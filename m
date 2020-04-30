Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDCF1C07D2
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 22:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgD3UZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 16:25:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:36651 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgD3UZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 16:25:19 -0400
IronPort-SDR: AFzbOPrBUfbhDy0EtLj34UrI6N6CP093fGaed6PxL8ElYcOAvm9cbWv0cT33fwRQm5Qjs7rEJ5
 rwj4EsW3Nwaw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 13:25:18 -0700
IronPort-SDR: cdfVVzrh6ngjaDBZLFBICWr5KRRav1Et0SERCoAbGfCgIsOaX0I4vgmIe0LtMc4Ae0ffdyOSxM
 B/T8PSwMcZVQ==
X-IronPort-AV: E=Sophos;i="5.73,337,1583222400"; 
   d="scan'208";a="249848943"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 13:25:17 -0700
Date:   Thu, 30 Apr 2020 13:25:16 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Message-ID: <20200430202516.GA26147@agluck-desk2.amr.corp.intel.com>
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
 <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com>
 <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 12:50:40PM -0700, Linus Torvalds wrote:

I see your point about the namimg being important.  I think Dan's
case is indeed "copy from pmem to user" where only options for faulting
are #MC on the source addresses, and #PF on the destination.

> The only *fundamental* access would likely be a single read/write
> operation, not a copy operation. Think "get_user()" instead of
> "copy_from_user()".  Even there you get combinatorial explosions with
> access sizes, but you can often generate those automatically or with
> simple patterns, and then you can build up the copy functions from
> that if you really need to.

That's maybe very clean. But it looks like it would be hard to build
a high performance interface on top of that primitive. Remember that
for Dan's copy 99.999999999367673%[1] of copies will not hit a machine
check on the read from pmem.

Dan wants (whatever the function name) to get to a "REP MOVS" with an
exception table entry to handle the cases where there is a fault.

-Tony

[1] Likely several more '9's in there
