Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF381FA481
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 01:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgFOXkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 19:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFOXks (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 19:40:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07B112080D;
        Mon, 15 Jun 2020 23:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592264448;
        bh=qQ0fVSbE13WUzr52al67Vyqbqkp9alSGQ7j+CaJzxzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zge7GdYpqd7TIJahU6E6qpjDfNF0v99oWMPtQDjcL4c8fyCEedLioqcqffQszmhOM
         HXAT2eCns3eBjJ+mcn2Bp6qZ1nWkhR9Ap5sFaPmBJCtEagw6+sps2Gmfk9O5EnxOFG
         zMEyqJy9XXYOscyP+ky/O6PVkSzKQQ5+8rbMn/pU=
Date:   Mon, 15 Jun 2020 19:40:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, linus.walleij@linaro.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: Fix controller unregister order"
 failed to apply to 4.19-stable tree
Message-ID: <20200615234046.GG1931@sasha-vm>
References: <159223444415976@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159223444415976@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:20:44PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 84855678add8aba927faf76bc2f130a40f94b6f7 Mon Sep 17 00:00:00 2001
>From: Lukas Wunner <lukas@wunner.de>
>Date: Fri, 15 May 2020 17:58:01 +0200
>Subject: [PATCH] spi: Fix controller unregister order
>
>When an SPI controller unregisters, it unbinds all its slave devices.
>For this, their drivers may need to access the SPI bus, e.g. to quiesce
>interrupts.
>
>However since commit ffbbdd21329f ("spi: create a message queueing
>infrastructure"), spi_destroy_queue() is executed before unbinding the
>slaves.  It sets ctlr->running = false, thereby preventing SPI bus
>access and causing unbinding of slave devices to fail.
>
>Fix by unbinding slaves before calling spi_destroy_queue().
>
>Fixes: ffbbdd21329f ("spi: create a message queueing infrastructure")
>Signed-off-by: Lukas Wunner <lukas@wunner.de>
>Cc: stable@vger.kernel.org # v3.4+
>Cc: Linus Walleij <linus.walleij@linaro.org>
>Link: https://lore.kernel.org/r/8aaf9d44c153fe233b17bc2dec4eb679898d7e7b.1589557526.git.lukas@wunner.de
>Signed-off-by: Mark Brown <broonie@kernel.org>

I've also grabbed:

ebc37af5e0a1 ("spi: No need to assign dummy value in spi_unregister_controller()")

And again worked around not having:

8caab75fd2c2 ("spi: Generalize SPI "master" to "controller"")

And queued these two patches for 4.19, 4.14, 4.9, and 4.4.

-- 
Thanks,
Sasha
