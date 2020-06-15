Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574BB1FA2D1
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 23:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgFOVcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 17:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgFOVcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 17:32:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB47620707;
        Mon, 15 Jun 2020 21:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592256772;
        bh=0MyJgletJ8hYzh6YngJ6WSyQ17x8eEN7XswnVrUBpzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gnul/6Fl2ES++QLBmVTG/cvLDZAlkbaQkQtT/YrvfKqa4euxPJpSzhXB20X5kBzHI
         vW7Nwj10FG0XM3omiGcrQ5cI61u2RnmN+zRwcxR7BuQVbph6Ni+aOMy8Wqi3TcKyAF
         muSLwclfZzrz85T+O9bzCC79t4ipLYTcz6FIp7vc=
Date:   Mon, 15 Jun 2020 17:32:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, andriy.shevchenko@linux.intel.com,
        baruch@tkos.co.il, broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: dw: Fix controller unregister order"
 failed to apply to 4.14-stable tree
Message-ID: <20200615213250.GD1931@sasha-vm>
References: <159223441416477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159223441416477@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:20:14PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From ca8b19d61e3fce5d2d7790cde27a0b57bcb3f341 Mon Sep 17 00:00:00 2001
>From: Lukas Wunner <lukas@wunner.de>
>Date: Mon, 25 May 2020 14:25:01 +0200
>Subject: [PATCH] spi: dw: Fix controller unregister order
>
>The Designware SPI driver uses devm_spi_register_controller() on bind.
>As a consequence, on unbind, __device_release_driver() first invokes
>dw_spi_remove_host() before unregistering the SPI controller via
>devres_release_all().
>
>This order is incorrect:  dw_spi_remove_host() shuts down the chip,
>rendering the SPI bus inaccessible even though the SPI controller is
>still registered.  When the SPI controller is subsequently unregistered,
>it unbinds all its slave devices.  Because their drivers cannot access
>the SPI bus, e.g. to quiesce interrupts, the slave devices may be left
>in an improper state.
>
>As a rule, devm_spi_register_controller() must not be used if the
>->remove() hook performs teardown steps which shall be performed after
>unregistering the controller and specifically after unbinding of slaves.
>
>Fix by reverting to the non-devm variant of spi_register_controller().
>
>An alternative approach would be to use device-managed functions for all
>steps in dw_spi_remove_host(), e.g. by calling devm_add_action_or_reset()
>on probe.  However that approach would add more LoC to the driver and
>it wouldn't lend itself as well to backporting to stable.
>
>Fixes: 04f421e7b0b1 ("spi: dw: use managed resources")
>Signed-off-by: Lukas Wunner <lukas@wunner.de>
>Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Cc: stable@vger.kernel.org # v3.14+
>Cc: Baruch Siach <baruch@tkos.co.il>
>Link: https://lore.kernel.org/r/3fff8cb8ae44a9893840d0688be15bb88c090a14.1590408496.git.lukas@wunner.de
>Signed-off-by: Mark Brown <broonie@kernel.org>

I took this additional patch:

66b19d762378 ("spi: dw: fix possible race condition")

And worked around the renames in :

721483e28889 ("spi: dw: Convert to generalized SPI controller API")

And queued these two patches for 4.14, 4.9, and 4.4.

-- 
Thanks,
Sasha
