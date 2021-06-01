Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E05397A06
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhFASZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 14:25:50 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53694 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhFASZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 14:25:49 -0400
Received: from zn.tnic (p200300ec2f111d0082e984b2e91ac710.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:1d00:82e9:84b2:e91a:c710])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 75E241EC01B7;
        Tue,  1 Jun 2021 20:24:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622571846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=tJXA6HXVxWBrx0FMpdafT6CUV8iMBF5xHQeDny+jk8w=;
        b=Sp9xEdkP1iBv9cZbO0Mn4+CaJvstno+vSwzYVQTaFWWB5MSoaE/igdzH8AE5b5t56A3ZGd
        Vq4zQGdd2fgpuAvhZKV1tUGF0HfKpcBc3MyfSqQHIbiZdJJLILjzLxEao6a8ipfddoX808
        bk+WtVkH6cvTgz27zsb1iklH1JszDUs=
Date:   Tue, 1 Jun 2021 20:24:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, Pu Wen <puwen@hygon.cn>,
        Joerg Roedel <jroedel@suse.de>, x86@kernel.org,
        joro@8bytes.org, dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Message-ID: <YLZ7Qu2fY6gmzTTN@zn.tnic>
References: <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de>
 <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
 <YLZGuTYXDin2K9wx@zn.tnic>
 <YLZc3sFKSjpd2yPS@google.com>
 <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
 <YLZneRWzoujEe+6b@zn.tnic>
 <YLZrXEQ8w5ntu7ov@google.com>
 <YLZy+JR7TNEeNA6C@zn.tnic>
 <YLZ3k77CK+F9v8fF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YLZ3k77CK+F9v8fF@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 06:08:19PM +0000, Sean Christopherson wrote:
> But we have not yet verified that 0x8000001f is supported, only that the result
> of CPUID.0x8000001f can be trusted (to handle Intel CPUs which return data from
> the highest supported leaf if the provided leaf function is greater than the max
> supported leaf).  Verifying that 0x8000001f is supported doesn't happen until
> 0x8000001f is actually read, which is currently done after the RDMSR that #GPs
> and explodes.

Yeah yeah, Tom just convinced me on IRC that the patch is ok after
all... so let's do that. And again, we cannot stop hypervisors from
doing shady things here so I don't even wanna try to. People should run
SNP/TDX guests only anyway if they care about this stuff.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
