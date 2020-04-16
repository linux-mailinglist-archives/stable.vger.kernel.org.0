Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932D81ABFCE
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505925AbgDPLkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 07:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505944AbgDPLjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 07:39:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E284B21D95;
        Thu, 16 Apr 2020 11:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587037162;
        bh=qcp3Kk6bi7SjnZbnz8tvc9/xDE7T0f554GkHSi26Ygs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jDbwc/XvtbD/uCbHs5vOxwV7XSBoVeKqQIJ4ZJssPOZPrx9oHCKfGZEF46QFrq5le
         96XFHzVlVkoTcOPAZvrioHd1PM1rIrrmQPcruKPCh+H7qpHfQZ1/tPx21v54NZCKVT
         WNBY7WQ5ZwBGhIzYFdaDZ+64X/9o1TEPI0tco/No=
Date:   Thu, 16 Apr 2020 13:39:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5.6] arm64: Always force a branch protection mode when
 the compiler has one
Message-ID: <20200416113920.GB882109@kroah.com>
References: <20200416112430.1256-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416112430.1256-1-broonie@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 12:24:30PM +0100, Mark Brown wrote:
> Compilers with branch protection support can be configured to enable it by
> default, it is likely that distributions will do this as part of deploying
> branch protection system wide. As well as the slight overhead from having
> some extra NOPs for unused branch protection features this can cause more
> serious problems when the kernel is providing pointer authentication to
> userspace but not built for pointer authentication itself. In that case our
> switching of keys for userspace can affect the kernel unexpectedly, causing
> pointer authentication instructions in the kernel to corrupt addresses.
> 
> To ensure that we get consistent and reliable behaviour always explicitly
> initialise the branch protection mode, ensuring that the kernel is built
> the same way regardless of the compiler defaults.
> 
> [This is a reworked version of b8fdef311a0bd9223f1075 ("arm64: Always
> force a branch protection mode when the compiler has one") for backport.
> Kernels prior to 74afda4016a7 ("arm64: compile the kernel with ptrauth
> return address signing") don't have any Makefile machinery for forcing
> on pointer auth but still have issues if the compiler defaults it on so
> need this reworked version. -- broonie]
> 
> Fixes: 7503197562567 (arm64: add basic pointer authentication support)
> Reported-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Cc: stable@vger.kernel.org
> [catalin.marinas@arm.com: remove Kconfig option in favour of Makefile check]
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)

Now queued up, thanks!

greg k-h
