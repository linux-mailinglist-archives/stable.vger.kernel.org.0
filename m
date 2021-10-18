Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBAF4327C5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 21:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhJRTjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 15:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhJRTjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 15:39:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A80BC06161C;
        Mon, 18 Oct 2021 12:37:05 -0700 (PDT)
Received: from zn.tnic (p200300ec2f085700af6a7a3215758573.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5700:af6a:7a32:1575:8573])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 98A2F1EC04A9;
        Mon, 18 Oct 2021 21:37:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634585823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=E/uKBTWke5UW0bUBb2EBl2Aml26+VGEAZuawTlCp+4Q=;
        b=aWzc8Jik5Gn0fKiVZtRMmEqBXF1zDeih6+2kRwwDVvBmf5zj75XXu9dsb9yZDZNFRzIvKa
        aR3cgh7pwxtPgSdTNfjG/cVj7v9Jx+/AQUQb3nY3/MnOBKaquplZg2Y+oUtOOinU+xs2Y4
        IN9pbxm60qqOWYhwlBg7c1ddlz8QJ9o=
Date:   Mon, 18 Oct 2021 21:37:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jane Malalane <jane.malalane@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <YW3M40tOILjI3DiD@zn.tnic>
References: <20211013142230.10129-1-jane.malalane@citrix.com>
 <YW25x7AYiM1f1HQA@zn.tnic>
 <YW3LJdztZom+xQHv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YW3LJdztZom+xQHv@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 07:29:41PM +0000, Sean Christopherson wrote:
> This isn't correct.  When running as a guest, the intended behavior is to fully
> trust the CPUID.0x80000021 bit.

Really? Because I'm coming from an SEV-SNP mail thread where we don't
trust the HV at all and we even hand in a CPUID page into the guest...

:-P

> If bit 6 is set, yay, the hypervisor has told the kernel that it
> will only ever run on hardware without the bug. If bit 6 is clear
> and HYPERVISOR is true, then the FMS crud can't be trusted because
> the kernel _may_ run on affected hardware in the future even if the
> current underlying hardware is not affected.

Ok, I see, then the CPUID check needs to go first, makes sense.

> I agree.  If the argument for this patch is that the kernel can be migrated to
> older hardware, then it stands to reason that the kernel could also be migrated
> to a different CPU vendor entirely.  E.g. start on Intel, migrate to Zen1, kaboom.

Migration across vendors? Really, that works?

I'll believe it only when I see it with my own eyes.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
