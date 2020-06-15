Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA9B1FA4CE
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 01:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgFOXye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 19:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFOXye (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 19:54:34 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 515DC206D8;
        Mon, 15 Jun 2020 23:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592265273;
        bh=RB+AkCmVwbAZkDQU+ee5kpC8G+NmtvJ+435y0TSlxj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLuOOozNE/kAdq5QFdodZKHmTKyc0agKMr4iQz6G5O+zjt8ad0GTBn8Cg84D3vy4m
         rz2IiMrNl+Y42mUjj5vqE4coeWDqaoUFlU8SkzNoW6DQ7EjWSalYhVU69v+MQEXdG/
         6/CbUnzcUTC4lpp7DED1FO3aNJwuMMQuIVjh9oYA=
Date:   Mon, 15 Jun 2020 19:54:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, andriy.shevchenko@linux.intel.com,
        broonie@kernel.org, kitakar@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: pxa2xx: Fix controller unregister
 order" failed to apply to 4.19-stable tree
Message-ID: <20200615235432.GH1931@sasha-vm>
References: <1592234478161121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592234478161121@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:21:18PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 32e5b57232c0411e7dea96625c415510430ac079 Mon Sep 17 00:00:00 2001
>From: Lukas Wunner <lukas@wunner.de>
>Date: Mon, 25 May 2020 14:25:02 +0200
>Subject: [PATCH] spi: pxa2xx: Fix controller unregister order
>
>The PXA2xx SPI driver uses devm_spi_register_controller() on bind.
>As a consequence, on unbind, __device_release_driver() first invokes
>pxa2xx_spi_remove() before unregistering the SPI controller via
>devres_release_all().
>
>This order is incorrect:  pxa2xx_spi_remove() disables the chip,
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
>steps in pxa2xx_spi_remove(), e.g. by calling devm_add_action_or_reset()
>on probe.  However that approach would add more LoC to the driver and
>it wouldn't lend itself as well to backporting to stable.
>
>The improper use of devm_spi_register_controller() was introduced in 2013
>by commit a807fcd090d6 ("spi: pxa2xx: use devm_spi_register_master()"),
>but all earlier versions of the driver going back to 2006 were likewise
>broken because they invoked spi_unregister_master() at the end of
>pxa2xx_spi_remove(), rather than at the beginning.
>
>Fixes: e0c9905e87ac ("[PATCH] SPI: add PXA2xx SSP SPI Driver")
>Signed-off-by: Lukas Wunner <lukas@wunner.de>
>Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Cc: stable@vger.kernel.org # v2.6.17+
>Cc: Tsuchiya Yuto <kitakar@gmail.com>
>Link: https://bugzilla.kernel.org/show_bug.cgi?id=206403#c1
>Link: https://lore.kernel.org/r/834c446b1cf3284d2660f1bee1ebe3e737cd02a9.1590408496.git.lukas@wunner.de
>Signed-off-by: Mark Brown <broonie@kernel.org>

more work around master -> controller rename. Queued for 4.19, 4.14,
4.9, and 4.4.

-- 
Thanks,
Sasha
