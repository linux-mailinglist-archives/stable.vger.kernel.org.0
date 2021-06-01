Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC627397977
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 19:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhFARu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhFARu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 13:50:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B4DC061574;
        Tue,  1 Jun 2021 10:48:47 -0700 (PDT)
Received: from zn.tnic (p200300ec2f111d0082e984b2e91ac710.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:1d00:82e9:84b2:e91a:c710])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 38A301EC04DE;
        Tue,  1 Jun 2021 19:48:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622569726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=biQU14FYVVk4LB/gooVKcC5sTJb4CihHDJ0GsZwwdsI=;
        b=ljUMKrqnXANNG2IE6wOlTAr42/bzDsFV0OihCjRTU+kIPfJCb2tJcciteOpTeKOm4N83My
        qSP5K6wXXge4fWUtSwXeMnD51FZvwo2LDaVYGGAv46WxHdY9gmfF6mRU77oQ3a24o/1KpR
        Lf8wqwE1nu75LbGucD+vhJVSAERhg44=
Date:   Tue, 1 Jun 2021 19:48:40 +0200
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
Message-ID: <YLZy+JR7TNEeNA6C@zn.tnic>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com>
 <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de>
 <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
 <YLZGuTYXDin2K9wx@zn.tnic>
 <YLZc3sFKSjpd2yPS@google.com>
 <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
 <YLZneRWzoujEe+6b@zn.tnic>
 <YLZrXEQ8w5ntu7ov@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YLZrXEQ8w5ntu7ov@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 05:16:12PM +0000, Sean Christopherson wrote:
> The bug isn't limited to out-of-spec hardware.  At the point of #GP, sme_enable()
> has only verified the max leaf is greater than 0x8000001f, it has not verified
> that 0x8000001f is actually supported.  The APM itself declares several leafs
> between 0x80000000 and 0x8000001f as reserved/unsupported, so we can't argue that
> 0x8000001f must be supported if the max leaf is greater than 0x8000001f.

If a hypervisor says that 0x8000001f is supported but then we explode
when reading MSR_AMD64_SEV, then hypervisor gets to keep both pieces.

We're not going to workaround all possible insane hardware/hypervisor
configurations just because they dropped the ball.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
