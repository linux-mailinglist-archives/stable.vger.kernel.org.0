Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DFE4037F0
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 12:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhIHKgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 06:36:39 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59040 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhIHKgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 06:36:39 -0400
Received: from zn.tnic (p200300ec2f0efc002d1ac0b1b41b9169.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:fc00:2d1a:c0b1:b41b:9169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5B73C1EC036B;
        Wed,  8 Sep 2021 12:35:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1631097330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vNZo46xtdLfPCSghubjAQ0AbiTd/3e4sJ5wQ5kYrsZk=;
        b=aRJSgvRLCoKkTWzIqFJm5RepVqZxbasjqfKuU8UvRw9DGDOAjYyqQXl+jgGN/P0Y/4qyYf
        qAH2j4creMyuTF+DO2WKIckrrNg72u000ui50+YNIeysEGcVatNjDcL5w3Cn9Mn6Lk34qF
        VS3GawEjtGqtDyAYGL8tP62fy0OfuDI=
Date:   Wed, 8 Sep 2021 12:35:21 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
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
Message-ID: <YTiR6aK6XKJ4z0wH@zn.tnic>
References: <20210819132717.19358-1-rppt@kernel.org>
 <35f4a263-1001-5ba5-7b6c-3fcc5f93cc30@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <35f4a263-1001-5ba5-7b6c-3fcc5f93cc30@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 11:47:10AM -0700, Dave Hansen wrote:
> On 8/19/21 6:27 AM, Mike Rapoport wrote:
> > Such PMDs are created when free_kernel_image_pages() frees regions larger
> > than 2Mb. In this case a part of the freed memory is mapped with PMDs and
> > the set_memory_np_noalias() -> ... -> __change_page_attr() sequence will
> > mark the PMD as not present rather than wipe it completely.
> > 
> > Make kern_addr_valid() to check whether higher level page table entries are
> > present before trying to dereference them to fix this issue and to avoid
> > similar issues in the future.
> > 
> > Reported-by: Jiri Olsa <jolsa@redhat.com>
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > Cc: <stable@vger.kernel.org>	# 4.4...
> >  	pmd = pmd_offset(pud, addr);
> > -	if (pmd_none(*pmd))
> > +	if (!pmd_present(*pmd))
> >  		return 0;
> 
> Yeah, that seems like the right fix.  The one kern_addr_valid() user is
> going to touch the memory so it *better* be present.  p*d_none() was
> definitely the wrong check.
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>

So I did stare at this for a while, trying to make sense of it and David
Hildenbrand asked for a Fixes: tag in v1 review and from doing a bit of
git archeology I think it should be:

c40a56a7818c ("x86/mm/init: Remove freed kernel image areas from alias mapping")

because that thing added the clearing of the Present bit for the high
kernel image mapping of those areas.

Right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
