Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AFE1FA4DE
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 02:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgFPAFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 20:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFPAFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 20:05:51 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 737AF20739;
        Tue, 16 Jun 2020 00:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592265950;
        bh=+UiisGvSamnV8qvpoHjLI1mtg5AHMxnzlc/N7NILwZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FAJ6/sIaPBUGMRmQa1AZ43Kph7TVgqY5oZPgU5CGrYXevIjAj4PRHL2R1j0k/QAWR
         9exTdSaARJAHsfKLMFGYKK6feAESCh8rLolBZzZ0N8rzN3QlwX+D5uh22Scp5ElZHx
         piJTeMKBk0oag0UWDHcEpBA1JHV5DTfRgJViFG+E=
Date:   Mon, 15 Jun 2020 20:05:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix controller unregister
 order" failed to apply to 4.19-stable tree
Message-ID: <20200616000549.GI1931@sasha-vm>
References: <1592234520147134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592234520147134@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:22:00PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 9dd277ff92d06f6aa95b39936ad83981d781f49b Mon Sep 17 00:00:00 2001
>From: Lukas Wunner <lukas@wunner.de>
>Date: Fri, 15 May 2020 17:58:02 +0200
>Subject: [PATCH] spi: bcm2835: Fix controller unregister order
>
>The BCM2835 SPI driver uses devm_spi_register_controller() on bind.
>As a consequence, on unbind, __device_release_driver() first invokes
>bcm2835_spi_remove() before unregistering the SPI controller via
>devres_release_all().
>
>This order is incorrect:  bcm2835_spi_remove() tears down the DMA
>channels and turns off the SPI controller, including its interrupts
>and clock.  The SPI controller is thus no longer usable.
>
>When the SPI controller is subsequently unregistered, it unbinds all
>its slave devices.  If their drivers need to access the SPI bus,
>e.g. to quiesce their interrupts, unbinding will fail.
>
>As a rule, devm_spi_register_controller() must not be used if the
>->remove() hook performs teardown steps which shall be performed
>after unbinding of slaves.
>
>Fix by using the non-devm variant spi_register_controller().  Note that
>the struct spi_controller as well as the driver-private data are not
>freed until after bcm2835_spi_remove() has finished, so accessing them
>is safe.
>
>Fixes: 247263dba208 ("spi: bcm2835: use devm_spi_register_master()")
>Signed-off-by: Lukas Wunner <lukas@wunner.de>
>Cc: stable@vger.kernel.org # v3.13+
>Link: https://lore.kernel.org/r/2397dd70cdbe95e0bc4da2b9fca0f31cb94e5aed.1589557526.git.lukas@wunner.de
>Signed-off-by: Mark Brown <broonie@kernel.org>

more work around master -> controller rename. Queued for 4.19, 4.14,
4.9, and 4.4.

-- 
Thanks,
Sasha
