Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD0332A2A
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 09:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFCH6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 03:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfFCH6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 03:58:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 191DF27D02;
        Mon,  3 Jun 2019 07:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559548717;
        bh=B+3QOAxzyhGeUhy50rc2ee+EAF0kA5fNYeJbxtDg74U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iFf5KHVL1400dPwfqA6Rx5YJ8RU2OVn/wedaLqVkMKbLE8QZnBs6iREg4TOAXOCvb
         bZhGW9Qdu7hTmn2pf/he+tval8A0EN1rIAHOEM/vsmiOX6R/wtXY+iOTVVOA2JyC+y
         iSvetq5Yj3tfI3+xTN9/R8AQuSd5r8bE9MrVNiB0=
Date:   Mon, 3 Jun 2019 09:58:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH 4.19] jump_label: move 'asm goto' support test to Kconfig
Message-ID: <20190603075835.GE7814@kroah.com>
References: <20190531065159.6490-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531065159.6490-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 11:52:00PM -0700, Nathan Chancellor wrote:
> From: Masahiro Yamada <yamada.masahiro@socionext.com>
> 
> commit e9666d10a5677a494260d60d1fa0b73cc7646eb3 upstream.
> 
> Currently, CONFIG_JUMP_LABEL just means "I _want_ to use jump label".
> 
> The jump label is controlled by HAVE_JUMP_LABEL, which is defined
> like this:
> 
>   #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
>   # define HAVE_JUMP_LABEL
>   #endif
> 
> We can improve this by testing 'asm goto' support in Kconfig, then
> make JUMP_LABEL depend on CC_HAS_ASM_GOTO.
> 
> Ugly #ifdef HAVE_JUMP_LABEL will go away, and CONFIG_JUMP_LABEL will
> match to the real kernel capability.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> [nc: Fix trivial conflicts in 4.19
>      arch/xtensa/kernel/jump_label.c doesn't exist yet
>      Ensured CC_HAVE_ASM_GOTO and HAVE_JUMP_LABEL were sufficiently
>      eliminated]
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
> 
> Hi Greg and Sasha,
> 
> Please pick up this patch for 4.19. It fixes some warnings in the boot
> code for x86 when using clang because that Makefile steamrolls
> KBUILD_CFLAGS so CC_HAVE_ASM_GOTO is not defined, which triggers the
> warnings in arch/x86/include/asm/cpufeature.h on line 143.
> 
> I've tested this with GCC 9.1.0 and a clang 9.0.0 build with asm goto
> support on arm, arm64, and x86_64 and CONFIG_CC_HAS_ASM_GOTO and
> CONFIG_JUMP_LABEL get enabled properly.

Now applied, thanks.

greg k-h
