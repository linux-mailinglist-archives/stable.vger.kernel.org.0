Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE54038D0
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 13:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348769AbhIHLfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 07:35:34 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39450 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348557AbhIHLfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 07:35:34 -0400
Received: from zn.tnic (p200300ec2f0efc002d1ac0b1b41b9169.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:fc00:2d1a:c0b1:b41b:9169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 69E191EC036B;
        Wed,  8 Sep 2021 13:34:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1631100865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=m/Frv4i98ljsymrvV0/yhoTmQ0S/VberekuyvlZ3qEw=;
        b=NfKUxhqk7CQNY9baqIi2HJw9km0ov3Vhu96MRbZd7TFmRoLJn/9d8b11Xk17XDIwl6B1Wg
        ubT9iwlULRlwmbhdS1woU5AIwJtXvDZL2VpfRLDE9rroVJfb1kI8NRVVH/gFIGNGu7QkLI
        7I/ZsdGgnHAzL2v1JqKR3QArzp0xr0w=
Date:   Wed, 8 Sep 2021 13:34:18 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Mike Rapoport <rppt@kernel.org>
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
Message-ID: <YTifujf+Qez2hE82@zn.tnic>
References: <20210819132717.19358-1-rppt@kernel.org>
 <35f4a263-1001-5ba5-7b6c-3fcc5f93cc30@intel.com>
 <YTiR6aK6XKJ4z0wH@zn.tnic>
 <YTiV/Sdm/T/jnsHC@zn.tnic>
 <YTic90lqv0HbuYOI@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YTic90lqv0HbuYOI@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 08, 2021 at 02:22:31PM +0300, Mike Rapoport wrote:
> kern_addr_valid() wrongly uses pxy_none() rather than pxy_present() because
> according to 9a14aefc1d28 ("x86: cpa, fix lookup_address") there could be
> cases when page table entries exist but they are not valid.
> So a call to kern_addr_valid() for an address in the direct map would oops.
> 
> I've stopped digging at 9a14aefc1d28 (which is in v2.6.26) and added the
> oldest stable we still support (4.4).
> 
> I agree that before 4.19 it's more of a theoretical bug, but you know,
> things happen...

Hmmkay, I guess I should add the gist of that to the commit message so
that it is explained why 4.4.

I'm assuming the pxy_present() check is more strict than pxy_none() so
that backporting to all stable kernels should not introduce any risks...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
