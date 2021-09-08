Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3344B4038B0
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 13:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351433AbhIHLXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 07:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232430AbhIHLXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 07:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F82861078;
        Wed,  8 Sep 2021 11:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631100161;
        bh=ALxiOwLgszVWrVBZDyapBhC1fA/x/vzP431jfN69HAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jsf2Mw/GVuU9UpcmP2PG0O/Rb4JUi0D7Fovo2UU666jqECJkmEdX9z5av8kdNFKxV
         thg6JhYxJv8cyhAhdDa2ni3dZ8emj1aT75E6yIF258hGoXVEDb6ipwx/O7QRcbDRwh
         bn8QspmdbJORahKy4eqxZz43QQHxjBHb2TK24Hytbx6FayPLfKZv57v8I/93lYoXmV
         mf2Iz1Fc0T5vU//gCwDfaFIlT93OPcQ9Y/EwmLUP4pI6Q3TuCYxYo5tfoP5rLSsbBA
         cBHY5yrXtZhxb+Npu/Em6Y4P3tf/8y2prV1qIIAdqxFihUjAtsUq/UU2PmAIPo3BeV
         sj3f0PBq4RCIg==
Date:   Wed, 8 Sep 2021 14:22:31 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm: fix kern_addr_valid to cope with existing but
 not present entries
Message-ID: <YTic90lqv0HbuYOI@kernel.org>
References: <20210819132717.19358-1-rppt@kernel.org>
 <35f4a263-1001-5ba5-7b6c-3fcc5f93cc30@intel.com>
 <YTiR6aK6XKJ4z0wH@zn.tnic>
 <YTiV/Sdm/T/jnsHC@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTiV/Sdm/T/jnsHC@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 08, 2021 at 12:52:45PM +0200, Borislav Petkov wrote:
> On Wed, Sep 08, 2021 at 12:35:21PM +0200, Borislav Petkov wrote:
> > So I did stare at this for a while, trying to make sense of it and David
> > Hildenbrand asked for a Fixes: tag in v1 review and from doing a bit of
> > git archeology I think it should be:
> > 
> > c40a56a7818c ("x86/mm/init: Remove freed kernel image areas from alias mapping")
> > 
> > because that thing added the clearing of the Present bit for the high
> > kernel image mapping of those areas.
> > 
> > Right?

Yes, in a sense. 
As the only user of kern_addr_valid() is kcore and it only uses this check
for high kernel mappings, there should be no problem before 4.19.

But...


> Hmm, but that commit is in v4.19. Mike has added
> 
> Cc: <stable@vger.kernel.org>    # 4.4+
> 
> Mike, why 4.4 and newer?

kern_addr_valid() wrongly uses pxy_none() rather than pxy_present() because
according to 9a14aefc1d28 ("x86: cpa, fix lookup_address") there could be
cases when page table entries exist but they are not valid.
So a call to kern_addr_valid() for an address in the direct map would oops.

I've stopped digging at 9a14aefc1d28 (which is in v2.6.26) and added the
oldest stable we still support (4.4).

I agree that before 4.19 it's more of a theoretical bug, but you know,
things happen...
 
> Hmmm.

-- 
Sincerely yours,
Mike.
