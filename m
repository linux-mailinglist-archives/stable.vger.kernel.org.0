Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91973612F
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbfFEQ0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbfFEQ0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 12:26:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28E37206C3;
        Wed,  5 Jun 2019 16:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559751989;
        bh=RRuTmiiCL4ohzUXB1ETCVXEBTEd5MWjinBA96qt0pQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g70kvZ4hhkO9JA7ZPvRvgVMal9GJL5Xzl89Bc4OOuz56PxzyGYFmwuNsefODsCtjX
         Za+YWKrYj4KvkKj9Hj92BxVEVwwwblgV7qR7NRrVAnJ8gj/yWUlplWQvU4wSj02WqD
         Qqer/L58HwWoxDc2SjM0ukfHKXRb/KUHBp6zkoLE=
Date:   Wed, 5 Jun 2019 18:26:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rolf Eike Beer <eb@emlix.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x
 (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
Message-ID: <20190605162626.GA31164@kroah.com>
References: <779905244.a0lJJiZRjM@devpool35>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <779905244.a0lJJiZRjM@devpool35>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 05:19:40PM +0200, Rolf Eike Beer wrote:
> I decided to dig out a toy project which uses a DragonBoard 410c. This has 
> been "running" with kernel 4.9, which I would keep this way for unrelated 
> reasons. The vanilla 4.9 kernel wasn't bootable back then, but it was 
> buildable, which was good enough.
> 
> Upgrading the kernel to 4.9.180 caused the boot to suddenly fail:
> 
> aarch64-unknown-linux-gnueabi-ld: ./drivers/firmware/efi/libstub/lib.a(arm64-
> stub.stub.o): in function `handle_kernel_image':
> /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.c:63: 
> undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_'
> aarch64-unknown-linux-gnueabi-ld: ./drivers/firmware/efi/libstub/lib.a(arm64-
> stub.stub.o): relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol 
> `__efistub__GLOBAL_OFFSET_TABLE_' which may bind externally can not be used 
> when making a shared object; recompile with -fPIC
> /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.c:63:
> (.init.text+0xc): dangerous relocation: unsupported relocation
> /tmp/e2/build/linux-4.9.139/Makefile:1001: recipe for target 'vmlinux' failed
> -make[1]: *** [vmlinux] Error 1
> 
> This is caused by commit 27b5ebf61818749b3568354c64a8ec2d9cd5ecca from 
> linux-4.9.y (which is 91ee5b21ee026c49e4e7483de69b55b8b47042be), reverting 
> this commit fixes the build.
> 
> This happens with vanilla binutils 2.32 and gcc 8.3.0 as well as 9.1.0. See 
> the attached .config for reference.
> 
> If you have questions or patches just ping me.

Does Linus's latest tree also fail for you (or 5.1)?

Nick, do we need to add another fix that is in mainline for this to work
properly?

thanks,

greg k-h
