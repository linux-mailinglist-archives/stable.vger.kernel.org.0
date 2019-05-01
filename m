Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D806107B2
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 13:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfEAL7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 07:59:34 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:55325 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfEAL7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 07:59:33 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 31CB530000F2A;
        Wed,  1 May 2019 13:59:31 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id EE4CF233EA5; Wed,  1 May 2019 13:59:30 +0200 (CEST)
Date:   Wed, 1 May 2019 13:59:30 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?iso-8859-1?B?S3I/P23hPz8=?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kvm ML <kvm@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH 4.19 083/100] x86/fpu: Dont export
 __kernel_fpu_{begin,end}()
Message-ID: <20190501115930.wa7ubea67rmsoqo7@wunner.de>
References: <20190430113608.616903219@linuxfoundation.org>
 <20190430113612.682532449@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430113612.682532449@linuxfoundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 01:38:52PM +0200, Greg Kroah-Hartman wrote:
> commit 12209993e98c5fa1855c467f22a24e3d5b8be205 upstream.
> 
> There is one user of __kernel_fpu_begin() and before invoking it,
> it invokes preempt_disable(). So it could invoke kernel_fpu_begin()
> right away. The 32bit version of arch_efi_call_virt_setup() and
> arch_efi_call_virt_teardown() does this already.
> 
> The comment above *kernel_fpu*() claims that before invoking
> __kernel_fpu_begin() preemption should be disabled and that KVM is a
> good example of doing it. Well, KVM doesn't do that since commit
> 
>   f775b13eedee2 ("x86,kvm: move qemu/guest FPU switching out to vcpu_run")
> 
> so it is not an example anymore.
> 
> With EFI gone as the last user of __kernel_fpu_{begin|end}(), both can
> be made static and not exported anymore.

This is just a cleanup and therefore doesn't seem to satisfy the rules
for stable patches per Documentation/process/stable-kernel-rules.rst
("It must fix a real bug that bothers people / fix a problem that causes
a build error").

Why is it being queued up for stable and why are the rules disregarded here?

Thanks,

Lukas
