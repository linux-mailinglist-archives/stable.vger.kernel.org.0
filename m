Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5306431B5B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhJRNcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232692AbhJRNa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2719D610C7;
        Mon, 18 Oct 2021 13:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563714;
        bh=o9RFfwI0sv4AmSk4/RdXvL+qifTo6Le6igbD1msL6pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNwWUCj0bYzfUZAG1nvVNLCxgo4Ax2Urgj1y2VUXBMjUvepLKtLajtV+pNQhkRfuP
         /yWaWyu95mrQBjmMDL/t8EGdyhL7zPmRGEBvJVsULcpmWRG1tuJMlxhO+c55Zq3Cz5
         giAfT9GGGEUf4A2nhQIvNUPTvHy4Pt6gemJgwqyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 36/50] net: encx24j600: check error in devm_regmap_init_encx24j600
Date:   Mon, 18 Oct 2021 15:24:43 +0200
Message-Id: <20211018132327.723489073@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

commit f03dca0c9e2297c84a018e306f8a9cd534ee4287 upstream.

devm_regmap_init may return error which caused by like out of memory,
this will results in null pointer dereference later when reading
or writing register:

general protection fault in encx24j600_spi_probe
KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
CPU: 0 PID: 286 Comm: spi-encx24j600- Not tainted 5.15.0-rc2-00142-g9978db750e31-dirty #11 9c53a778c1306b1b02359f3c2bbedc0222cba652
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:regcache_cache_bypass drivers/base/regmap/regcache.c:540
Code: 54 41 89 f4 55 53 48 89 fb 48 83 ec 08 e8 26 94 a8 fe 48 8d bb a0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 4a 03 00 00 4c 8d ab b0 00 00 00 48 8b ab a0 00
RSP: 0018:ffffc900010476b8 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
RDX: 0000000000000012 RSI: ffff888002de0000 RDI: 0000000000000094
RBP: ffff888013c9a000 R08: 0000000000000000 R09: fffffbfff3f9cc6a
R10: ffffc900010476e8 R11: fffffbfff3f9cc69 R12: 0000000000000001
R13: 000000000000000a R14: ffff888013c9af54 R15: ffff888013c9ad08
FS:  00007ffa984ab580(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a6384136c8 CR3: 000000003bbe6003 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 encx24j600_spi_probe drivers/net/ethernet/microchip/encx24j600.c:459
 spi_probe drivers/spi/spi.c:397
 really_probe drivers/base/dd.c:517
 __driver_probe_device drivers/base/dd.c:751
 driver_probe_device drivers/base/dd.c:782
 __device_attach_driver drivers/base/dd.c:899
 bus_for_each_drv drivers/base/bus.c:427
 __device_attach drivers/base/dd.c:971
 bus_probe_device drivers/base/bus.c:487
 device_add drivers/base/core.c:3364
 __spi_add_device drivers/spi/spi.c:599
 spi_add_device drivers/spi/spi.c:641
 spi_new_device drivers/spi/spi.c:717
 new_device_store+0x18c/0x1f1 [spi_stub 4e02719357f1ff33f5a43d00630982840568e85e]
 dev_attr_store drivers/base/core.c:2074
 sysfs_kf_write fs/sysfs/file.c:139
 kernfs_fop_write_iter fs/kernfs/file.c:300
 new_sync_write fs/read_write.c:508 (discriminator 4)
 vfs_write fs/read_write.c:594
 ksys_write fs/read_write.c:648
 do_syscall_64 arch/x86/entry/common.c:50
 entry_SYSCALL_64_after_hwframe arch/x86/entry/entry_64.S:113

Add error check in devm_regmap_init_encx24j600 to avoid this situation.

Fixes: 04fbfce7a222 ("net: Microchip encx24j600 driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Link: https://lore.kernel.org/r/20211012125901.3623144-1-sunnanyong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/encx24j600-regmap.c |   10 ++++++++--
 drivers/net/ethernet/microchip/encx24j600.c        |    5 ++++-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |    4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -505,13 +505,19 @@ static struct regmap_bus phymap_encx24j6
 	.reg_read = regmap_encx24j600_phy_reg_read,
 };
 
-void devm_regmap_init_encx24j600(struct device *dev,
-				 struct encx24j600_context *ctx)
+int devm_regmap_init_encx24j600(struct device *dev,
+				struct encx24j600_context *ctx)
 {
 	mutex_init(&ctx->mutex);
 	regcfg.lock_arg = ctx;
 	ctx->regmap = devm_regmap_init(dev, &regmap_encx24j600, ctx, &regcfg);
+	if (IS_ERR(ctx->regmap))
+		return PTR_ERR(ctx->regmap);
 	ctx->phymap = devm_regmap_init(dev, &phymap_encx24j600, ctx, &phycfg);
+	if (IS_ERR(ctx->phymap))
+		return PTR_ERR(ctx->phymap);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(devm_regmap_init_encx24j600);
 
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -1032,10 +1032,13 @@ static int encx24j600_spi_probe(struct s
 	priv->speed = SPEED_100;
 
 	priv->ctx.spi = spi;
-	devm_regmap_init_encx24j600(&spi->dev, &priv->ctx);
 	ndev->irq = spi->irq;
 	ndev->netdev_ops = &encx24j600_netdev_ops;
 
+	ret = devm_regmap_init_encx24j600(&spi->dev, &priv->ctx);
+	if (ret)
+		goto out_free;
+
 	mutex_init(&priv->lock);
 
 	/* Reset device and check if it is connected */
--- a/drivers/net/ethernet/microchip/encx24j600_hw.h
+++ b/drivers/net/ethernet/microchip/encx24j600_hw.h
@@ -15,8 +15,8 @@ struct encx24j600_context {
 	int bank;
 };
 
-void devm_regmap_init_encx24j600(struct device *dev,
-				 struct encx24j600_context *ctx);
+int devm_regmap_init_encx24j600(struct device *dev,
+				struct encx24j600_context *ctx);
 
 /* Single-byte instructions */
 #define BANK_SELECT(bank) (0xC0 | ((bank & (BANK_MASK >> BANK_SHIFT)) << 1))


