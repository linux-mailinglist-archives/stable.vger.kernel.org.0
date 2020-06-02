Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812821EC58E
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 01:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgFBXS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 19:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgFBXSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 19:18:55 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97BCC08C5C2
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 16:18:54 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id h188so102569lfd.7
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 16:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w339YpBFgV7tqQf8M7YphxkuH2MrbkG2i3IWInNVEFw=;
        b=YxsAHw4owitymwvHIwpqwWvn9/NXfSmSAaW4XnOP3SsDR0q/tu0Kjtftp1ifdfbfTc
         db7b0ZQb7XugZtiYeszap76BEZuj9SR7sEGdl+KzdbvXUErm382A/PEE9pQKqw2RCHW+
         fxt3fniEs00mZZGfE4SRefURbUpvaDWjfMSwtxss/P7Hu5hOCAebKrwvL198wVJLAScc
         4x1kUwZY1D43yHWgBhNeQakXS1vaWEODvIRwRn+skTC2lMBjsFPh6jtE5RpKnVCGheKI
         hxnCOSxuHeJWxmzn1wKje/9Ngwo+exug6CDE81AlefvydqUyh2OSPjhGhkcoCl5Hkqrs
         Ktbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w339YpBFgV7tqQf8M7YphxkuH2MrbkG2i3IWInNVEFw=;
        b=squ1K/SSpnEY6Eaf8Gic/qA1q8P6OoagAfpoFxJkCJ/V/5c+wdhYTdJ72VKyKl9Ky7
         zE9uTQ2WN68dr2JU+VbcXPzr0OITkm+a/nr2odmZL9b42WRDXw26hAbtQ0dqx08MOvTv
         rPsiYPsU+/6z6c6q4kA0Xrh2iNUwtkhR+Wc+1FK5UbcF4/YLuukv7kw7WHZr/ep8lIaI
         In/yYBCUkKEcYHmOL9jGJElg4L4u3vZ6xb1iJunNEx81EgQYrw4RbRnbah8MehCpp1hv
         fPYOtP6R56Y7dUp6PQe1slDns7/9+Cqku+Tu+xPUB56mo3mTp62/VX4KLFej9zGRhr1P
         u6/Q==
X-Gm-Message-State: AOAM533qqDmlMh80ujJ13lS1U70TIjSedT7PQeFwGOAdn9mEUcBzlVGJ
        cwPeizA2W6XjDm4JhNHutbcOqpbIbdg=
X-Google-Smtp-Source: ABdhPJxwAotMVS+UbqsYp+bbhka8nGqAjJAI+8M3Prj7QP/OP9DS5g/xQ3THv/MFg0EiknvWEapPfQ==
X-Received: by 2002:ac2:550a:: with SMTP id j10mr860697lfk.46.1591139933189;
        Tue, 02 Jun 2020 16:18:53 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id 15sm63048ljr.104.2020.06.02.16.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 16:18:51 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 87BFB102780; Wed,  3 Jun 2020 02:18:57 +0300 (+03)
Date:   Wed, 3 Jun 2020 02:18:57 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Fix boot with some memory above MAXMEM
Message-ID: <20200602231857.ousba2xiks7myxbt@box>
References: <20200511191721.1416-1-kirill.shutemov@linux.intel.com>
 <20200525044902.rsb46bxu5hdsqglt@box>
 <20200525145943.GA13247@kernel.org>
 <20200525150820.zljiamptpzi37ohx@box>
 <24b51944-bfba-a937-484a-5d9ec54fdf01@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b51944-bfba-a937-484a-5d9ec54fdf01@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 07:27:15AM -0700, Dave Hansen wrote:
> On 5/25/20 8:08 AM, Kirill A. Shutemov wrote:
> >>>> +	if (not_addressable) {
> >>>> +		pr_err("%lldGB of physical memory is not addressable in the paging mode\n",
> >>>> +		       not_addressable >> 30);
> >>>> +		if (!pgtable_l5_enabled())
> >>>> +			pr_err("Consider enabling 5-level paging\n");
> >> Could this happen at all when l5 is enabled?
> >> Does it mean we need kmap() for 64-bit?
> > It's future-profing. Who knows what paging modes we would have in the
> > future.
> 
> Future-proofing and firmware-proofing. :)
> 
> In any case, are we *really* limited to 52 bits of physical memory with
> 5-level paging?

Yes. It's architectural. SDM says "MAXPHYADDR is at most 52" (Vol 3A,
4.1.4).

I guess it can be extended with an opt-in feature and relevant changes to
page table structure. But as of today there's no such thing.

> Previously, we said we were limited to 46 bits, and now
> we're saying that the limit is 52 with 5-level paging:
> 
> #define MAX_PHYSMEM_BITS (pgtable_l5_enabled() ? 52 : 46)
> 
> The 46 was fine with the 48 bits of address space on 4-level paging
> systems since we need 1/2 of the address space for userspace, 1/4 for
> the direct map and 1/4 for the vmalloc-and-friends area.  At 46 bits of
> address space, we fill up the direct map.
> 
> The hardware designers know this and never enumerated a MAXPHYADDR from
> CPUID which was higher than what we could cover with 46 bits.  It was
> nice and convenient that these two separate things matched:
> 1. The amount of physical address space addressable in a direct map
>    consuming 1/4 of the virtual address space.
> 2. The CPU-enumerated MAXPHYADDR which among other things dictates how
>    much physical address space is addressable in a PTE.
> 
> But, with 5-level paging, things are a little different.  The limit in
> addressable memory because of running out of the direct map actually
> happens at 55 bits (57-2=55, analogous to the 4-level 48-2=46).
> 
> So shouldn't it technically be this:
> 
> #define MAX_PHYSMEM_BITS (pgtable_l5_enabled() ? 55 : 46)
> 
> ?

Bits above 52 are ignored in the page table entries and accessible to
software. Some of them got claimed by HW features (XD-bit, protection
keys), but such features require explicit opt-in on software side.

Kernel could claim bits 53-55 for the physical address, but it doesn't get
us anything: if future HW would provide such feature it would require
opt-in. On other hand claiming them now means we cannot use them for other
purposes as SW bit. I don't see a point.

-- 
 Kirill A. Shutemov
