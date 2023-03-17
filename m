Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873836BEF8C
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 18:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCQRWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 13:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQRWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 13:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EB6E41D2
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 321CCB82640
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 17:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832FCC433D2;
        Fri, 17 Mar 2023 17:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679073720;
        bh=LcKL84YlERoqSdqkJ3NY6XZlF25LNyocYt0Ta6Gf170=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aWz6J0n0zFIZsGxgRM4JQJsCpWsqZ1gypuJyr/qaKl9586hvuuWUcnksQmHy+C9zO
         g0Pch2JrV2q5QhOn3vmXi6A6bnkwTpkZiN2SpN/TLQwq5qcjGc8et76twboRs19i47
         mKj3sejlatKa1KkqeUvxEcxJ/+ERkYyiNuhBcOkxo7I9B6fss8mNH4+ZwpqiRas5qx
         Ulcvr90uc1SJHm0nHrO10RrfSQhqSk/1k60hLqFH4xn9vOIyzmAA2jXWp1ob2yU48K
         IxVOll4b0z7WetbVHRyowSAxt2mQ63YtgUh5nHhWE+FUKLyT4Il58PKhkLYhFS0erB
         GhckRm54K0hsw==
Received: by pali.im (Postfix)
        id 56F2C648; Fri, 17 Mar 2023 18:21:57 +0100 (CET)
Date:   Fri, 17 Mar 2023 18:21:57 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/boot: Don't always pass
 -mcpu=powerpc when building" failed to apply to 6.1-stable tree
Message-ID: <20230317172157.ces5ikgyj3rt2vne@pali>
References: <1678953691202116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1678953691202116@kroah.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday 16 March 2023 09:01:31 gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> git checkout FETCH_HEAD
> git cherry-pick -x ff7c76f66d8bad4e694c264c789249e1d3a8205d

It applies cleanly for me with above steps.

> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678953691202116@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..
> 
> Possible dependencies:
> 
> ff7c76f66d8b ("powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage")

Probably you are missing fix for CONFIG_TARGET_CPU_BOOL as mentioned
previously. Commit is:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=45f7091aac3546ef8112bf62836650ca0bbf0b79

> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From ff7c76f66d8bad4e694c264c789249e1d3a8205d Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
> Date: Wed, 25 Jan 2023 08:39:00 +0100
> Subject: [PATCH] powerpc/boot: Don't always pass -mcpu=powerpc when building
>  32-bit uImage
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> When CONFIG_TARGET_CPU is specified then pass its value to the compiler
> -mcpu option. This fixes following build error when building kernel with
> powerpc e500 SPE capable cross compilers:
> 
>     BOOTAS  arch/powerpc/boot/crt0.o
>   powerpc-linux-gnuspe-gcc: error: unrecognized argument in option ‘-mcpu=powerpc’
>   powerpc-linux-gnuspe-gcc: note: valid arguments to ‘-mcpu=’ are: 8540 8548 native
>   make[1]: *** [arch/powerpc/boot/Makefile:231: arch/powerpc/boot/crt0.o] Error 1
> 
> Similar change was already introduced for the main powerpc Makefile in
> commit 446cda1b21d9 ("powerpc/32: Don't always pass -mcpu=powerpc to the
> compiler").
> 
> Fixes: 40a75584e526 ("powerpc/boot: Build wrapper for an appropriate CPU")
> Cc: stable@vger.kernel.org # v5.19+
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/2ae3ae5887babfdacc34435bff0944b3f336100a.1674632329.git.christophe.leroy@csgroup.eu
> 
> diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
> index d32d95aea5d6..295f76df13b5 100644
> --- a/arch/powerpc/boot/Makefile
> +++ b/arch/powerpc/boot/Makefile
> @@ -39,13 +39,19 @@ BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>  		 $(LINUXINCLUDE)
>  
>  ifdef CONFIG_PPC64_BOOT_WRAPPER
> -ifdef CONFIG_CPU_LITTLE_ENDIAN
> -BOOTCFLAGS	+= -m64 -mcpu=powerpc64le
> +BOOTCFLAGS	+= -m64
>  else
> -BOOTCFLAGS	+= -m64 -mcpu=powerpc64
> +BOOTCFLAGS	+= -m32
>  endif
> +
> +ifdef CONFIG_TARGET_CPU_BOOL
> +BOOTCFLAGS	+= -mcpu=$(CONFIG_TARGET_CPU)
> +else ifdef CONFIG_PPC64_BOOT_WRAPPER
> +ifdef CONFIG_CPU_LITTLE_ENDIAN
> +BOOTCFLAGS	+= -mcpu=powerpc64le
>  else
> -BOOTCFLAGS	+= -m32 -mcpu=powerpc
> +BOOTCFLAGS	+= -mcpu=powerpc64
> +endif
>  endif
>  
>  BOOTCFLAGS	+= -isystem $(shell $(BOOTCC) -print-file-name=include)
> 
