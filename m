Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD5E1AB5A8
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388249AbgDPBvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387838AbgDPBvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:51:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F92D206D6;
        Thu, 16 Apr 2020 01:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587001882;
        bh=1OvG/pgsppQg4mHcQatDJ8Z/DQl1Fo9OwaPgmdrhpJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iVT7QzFms73IYN/64KnVv9TDXQoSU/i52EC2XiHMpM0Vu/DboIigt/o3weB3kmhks
         bgIaPOojBtWKm6gfJ/CIVhNIaDVlHDrd3t6kuQfpflm1wwQbI7+u7cEJHdSdrKLlAP
         Rf+oPvsetywgMjY8TtFh0xfSpGfcucxVHjFHK/oM=
Date:   Wed, 15 Apr 2020 21:51:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     broonie@kernel.org, catalin.marinas@arm.com, szabolcs.nagy@arm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: Always force a branch protection
 mode when the" failed to apply to 5.6-stable tree
Message-ID: <20200416015121.GV1068@sasha-vm>
References: <158694980415630@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158694980415630@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:23:24PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From b8fdef311a0bd9223f10754f94fdcf1a594a3457 Mon Sep 17 00:00:00 2001
>From: Mark Brown <broonie@kernel.org>
>Date: Tue, 31 Mar 2020 20:44:59 +0100
>Subject: [PATCH] arm64: Always force a branch protection mode when the
> compiler has one
>
>Compilers with branch protection support can be configured to enable it by
>default, it is likely that distributions will do this as part of deploying
>branch protection system wide. As well as the slight overhead from having
>some extra NOPs for unused branch protection features this can cause more
>serious problems when the kernel is providing pointer authentication to
>userspace but not built for pointer authentication itself. In that case our
>switching of keys for userspace can affect the kernel unexpectedly, causing
>pointer authentication instructions in the kernel to corrupt addresses.
>
>To ensure that we get consistent and reliable behaviour always explicitly
>initialise the branch protection mode, ensuring that the kernel is built
>the same way regardless of the compiler defaults.
>
>Fixes: 7503197562567 (arm64: add basic pointer authentication support)
>Reported-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
>Signed-off-by: Mark Brown <broonie@kernel.org>
>Cc: stable@vger.kernel.org
>[catalin.marinas@arm.com: remove Kconfig option in favour of Makefile check]
>Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

I don't think that this is needed anywhere without 74afda4016a7 ("arm64:
compile the kernel with ptrauth return address signing")?

-- 
Thanks,
Sasha
