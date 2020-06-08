Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12D01F1988
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 15:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgFHNAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 09:00:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:24601 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgFHNAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 09:00:10 -0400
IronPort-SDR: L9yHiPSY6L9003JD8yJ4tCbt4+dStbQHDGniGEIJvvuNSXqRBjVBXc6PZHD4NyM5f+9y93iRNg
 HQYVDNftdOCA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 06:00:08 -0700
IronPort-SDR: PE7HufXDg7f9+jqjyOSDQxo3+G5SfFBHCYIwahilTfZJSDu5i1xv5XRhvFNk0pOmcejo6UVxmT
 YgYUB1xC1Ltw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="274212404"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga006.jf.intel.com with ESMTP; 08 Jun 2020 06:00:04 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1jiHNm-00BgOT-Bj; Mon, 08 Jun 2020 16:00:06 +0300
Date:   Mon, 8 Jun 2020 16:00:06 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH RESEND2] lib: fix bitmap_parse() on 64-bit big endian
 archs
Message-ID: <20200608130006.GN2428291@smile.fi.intel.com>
References: <1591611829-23071-1-git-send-email-agordeev@linux.ibm.com>
 <CAHp75VcFdrvNMj0TL8ZHxShqqGDM31Hy8vitmn9HOPjZ6f9uYw@mail.gmail.com>
 <20200608124433.GA28369@oc3871087118.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608124433.GA28369@oc3871087118.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 02:44:34PM +0200, Alexander Gordeev wrote:
> On Mon, Jun 08, 2020 at 03:03:05PM +0300, Andy Shevchenko wrote:
> > On Mon, Jun 8, 2020 at 1:26 PM Alexander Gordeev <agordeev@linux.ibm.com> wrote:
> > >
> > > Commit 2d6261583be0 ("lib: rework bitmap_parse()") does not
> > > take into account order of halfwords on 64-bit big endian
> > > architectures. As result (at least) Receive Packet Steering,
> > > IRQ affinity masks and runtime kernel test "test_bitmap" get
> > > broken on s390.
> > 
> > ...
> > 
> > > +#if defined(__BIG_ENDIAN) && defined(CONFIG_64BIT)
> > 
> > I think it's better to re-use existing patterns.
> > 
> > ipc/sem.c:1682:#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
> > 
> > > +static void save_x32_chunk(unsigned long *maskp, u32 chunk, int chunk_idx)
> > > +{
> > > +       maskp += (chunk_idx / 2);
> > > +       ((u32 *)maskp)[(chunk_idx & 1) ^ 1] = chunk;
> > > +}
> > > +#else
> > > +static void save_x32_chunk(unsigned long *maskp, u32 chunk, int chunk_idx)
> > > +{
> > > +       ((u32 *)maskp)[chunk_idx] = chunk;
> > > +}
> > > +#endif
> > 
> > See below.
> > 
> > ...
> > 
> > > -               end = bitmap_get_x32_reverse(start, end, bitmap++);
> > > +               end = bitmap_get_x32_reverse(start, end, &chunk);
> > >                 if (IS_ERR(end))
> > >                         return PTR_ERR(end);
> > > +
> > > +               save_x32_chunk(maskp, chunk, chunk_idx++);
> > 
> > Can't we simple do
> > 
> >         int chunk_index = 0;
> >         ...
> >         do {
> > #if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
> >                end = bitmap_get_x32_reverse(start, end,
> > bitmap[chunk_index ^ 1]);
> > #else
> >                end = bitmap_get_x32_reverse(start, end, bitmap[chunk_index]);
> > #endif
> >         ...
> >         } while (++chunk_index);
> > 
> > ?
> 
> Well, unless we ignore coding style 21) Conditional Compilation
> we could. Do you still insist it would be better?

I think it's okay to do here
 - it's not a big function
 - it has no stub versions (you always do something)
 - the result pretty much readable (5 lines any editor can keep on screen)
 - and it's not ignoring, see "Wherever possible...", compare readability of
   two versions, for yours reader needs to go somewhere to read, calculate and
   return, when everything already being forgotten
 - last but not least, I bet it makes code shorter (at least in C)

-- 
With Best Regards,
Andy Shevchenko


