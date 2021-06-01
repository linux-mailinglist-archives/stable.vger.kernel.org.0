Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B1397893
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 18:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhFARBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhFARBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 13:01:30 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFD0C061574;
        Tue,  1 Jun 2021 09:59:49 -0700 (PDT)
Received: from zn.tnic (p200300ec2f111d00a3e97a9775243981.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:1d00:a3e9:7a97:7524:3981])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7E37E1EC0288;
        Tue,  1 Jun 2021 18:59:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622566784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5nsnQeki0sXWJtABZE7YGdEDhyEL/jgo3r8JFWG5AfU=;
        b=dFSpLZGU8LIIn6vzob4eDC/+rLlcNMy9tZl/FRSRpotWwlyvzyhLQ/usMlGWImznHUDKlf
        jUbZHKlQNymCF0P+6Ajl6NaQF0Nzb1qOdfJKPXrgxByTLgwynIubRIrSJA4hmKw8v3BDFu
        W7K87gj50j5VV6f4e39P8FSDJOf0050=
Date:   Tue, 1 Jun 2021 18:59:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>, Pu Wen <puwen@hygon.cn>,
        Joerg Roedel <jroedel@suse.de>, x86@kernel.org,
        joro@8bytes.org, dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Message-ID: <YLZneRWzoujEe+6b@zn.tnic>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com>
 <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de>
 <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
 <YLZGuTYXDin2K9wx@zn.tnic>
 <YLZc3sFKSjpd2yPS@google.com>
 <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 11:36:31AM -0500, Tom Lendacky wrote:
> That is the reason for checking the maximum supported leaf being at least
> 0x8000001f. If that leaf is supported, we expect the SEV status MSR to be
> valid. The problem is that the Hygon ucode does not support the MSR in
> question. I'm not sure what it would take for that to be added to their
> ucode and just always return 0.

Yap, that sounds good too.

> Because a hypervisor can put anything it wants in the CPUID 0x0 /
> 0x80000000 fields, I don't think we can just check for "AuthenticAMD".

By that logic you can forget even checking CPUID at all in that case.
The only reliable check you can do is MSR_AMD64_SEV which is guest-only.

> If we want the read of CPUID 0x8000001f done before reading the SEV status
> MSR, then the original patch is close, but slightly flawed, e.g. only SME
> can be indicated but then MSR_AMD64_SEV can say SEV active.
> 
> If we want to introduce support for handling/detecting #GP, this might
> become overly complicated because of the very early, identity mapped state
> the code is in - especially for backport to stable.

Yah, ain't gonna happen. I'm not taking some #GP handler to the early
code just because some hardware is operating out of spec.

If some hypervisor running on Hygon hardware is lying and says it is an
AMD which supports the 0x8000001f leaf, then that hypervisor gets to
keep both pieces.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
