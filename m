Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59649970C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446657AbiAXVI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56946 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445538AbiAXVEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:04:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 315EFB81188;
        Mon, 24 Jan 2022 21:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D7BC340E5;
        Mon, 24 Jan 2022 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058241;
        bh=ory3SVYeIybujCMEfusN/VnvpGC5oI84n45u5L7CtDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSWDneQCLNIgrd4NGaBoFqvSRHaW+HprUszwCa5b6UOvbl93etNjsvHdTDoSR5wig
         k0e0SHNITXu9l12XkqY5ZnHwJgoyyuyurL/5F1T3CAjnzESY02xbJv32GSXQ3xAiUa
         1vCq6tLAxQS6RFkVWg0IDgPlCsupYj6Cnn2NoHAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0224/1039] mtd: core: provide unique name for nvmem device
Date:   Mon, 24 Jan 2022 19:33:33 +0100
Message-Id: <20220124184132.862206603@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit c048b60d39e109c201d31ed5ad3a4f939064d6c4 ]

If there is more than one mtd device which supports OTP, there will
be a kernel warning about duplicated sysfs entries and the probing will
fail. This is because the nvmem device name is not unique. Make it
unique by prepending the name of the mtd. E.g. before the name was
"user-otp", now it will be "mtd0-user-otp".

For reference the kernel splash is:
[    4.665531] sysfs: cannot create duplicate filename '/bus/nvmem/devices/user-otp'
[    4.673056] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-next-20211101+ #1296
[    4.680565] Hardware name: Kontron SMARC-sAL28 (Single PHY) on SMARC Eval 2.0 carrier (DT)
[    4.688856] Call trace:
[    4.691303]  dump_backtrace+0x0/0x1bc
[    4.694984]  show_stack+0x24/0x30
[    4.698306]  dump_stack_lvl+0x68/0x84
[    4.701980]  dump_stack+0x18/0x34
[    4.705302]  sysfs_warn_dup+0x70/0x90
[    4.708973]  sysfs_do_create_link_sd+0x144/0x150
[    4.713603]  sysfs_create_link+0x2c/0x50
[    4.717535]  bus_add_device+0x74/0x120
[    4.721293]  device_add+0x330/0x890
[    4.724791]  device_register+0x2c/0x40
[    4.728550]  nvmem_register+0x240/0x9f0
[    4.732398]  mtd_otp_nvmem_register+0xb0/0x10c
[    4.736854]  mtd_device_parse_register+0x28c/0x2b4
[    4.741659]  spi_nor_probe+0x20c/0x2e0
[    4.745418]  spi_mem_probe+0x78/0xbc
[    4.749001]  spi_probe+0x90/0xf0
[    4.752237]  really_probe.part.0+0xa4/0x320
..
[    4.873936] mtd mtd1: Failed to register OTP NVMEM device
[    4.894468] spi-nor: probe of spi0.0 failed with error -17

Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211104134843.2642800-1-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 9186268d361b4..fc0bed14bfb10 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -825,8 +825,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 
 	/* OTP nvmem will be registered on the physical device */
 	config.dev = mtd->dev.parent;
-	/* just reuse the compatible as name */
-	config.name = compatible;
+	config.name = kasprintf(GFP_KERNEL, "%s-%s", dev_name(&mtd->dev), compatible);
 	config.id = NVMEM_DEVID_NONE;
 	config.owner = THIS_MODULE;
 	config.type = NVMEM_TYPE_OTP;
@@ -842,6 +841,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 		nvmem = NULL;
 
 	of_node_put(np);
+	kfree(config.name);
 
 	return nvmem;
 }
-- 
2.34.1



