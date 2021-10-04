Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909E2420FDC
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbhJDNjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238148AbhJDNh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EDD36121F;
        Mon,  4 Oct 2021 13:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353415;
        bh=ZO6zA9c8Lzwvtuu4Dipo711ge+UklH1aYIsTPUIsBKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yILEQddT1Zq8HIn/fU9T8qzyJqkbNXzmam7uwU5BwuWFu0UzIZFUdvIOs4EbtfCyU
         zr6FNgL3YBvsBCaWXJX5YM3lmSOUu08PYX/s3Shm9gNBpOmuf2lC6Lv1cLqbRe/BDj
         gfie/25RqchV48pNr5QgJ6tVV1Oo9GJ8K+yxgsOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 119/172] net: ks8851: fix link error
Date:   Mon,  4 Oct 2021 14:52:49 +0200
Message-Id: <20211004125048.824493986@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 51bb08dd04a05035a64504faa47651d36b0f3125 ]

An object file cannot be built for both loadable module and built-in
use at the same time:

arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
ks8851_common.c:(.text+0xf80): undefined reference to `__this_module'

Change the ks8851_common code to be a standalone module instead,
and use Makefile logic to ensure this is built-in if at least one
of its two users is.

Fixes: 797047f875b5 ("net: ks8851: Implement Parallel bus operations")
Link: https://lore.kernel.org/netdev/20210125121937.3900988-1-arnd@kernel.org/
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/Makefile        | 6 ++----
 drivers/net/ethernet/micrel/ks8851_common.c | 8 ++++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/Makefile b/drivers/net/ethernet/micrel/Makefile
index 5cc00d22c708..6ecc4eb30e74 100644
--- a/drivers/net/ethernet/micrel/Makefile
+++ b/drivers/net/ethernet/micrel/Makefile
@@ -4,8 +4,6 @@
 #
 
 obj-$(CONFIG_KS8842) += ks8842.o
-obj-$(CONFIG_KS8851) += ks8851.o
-ks8851-objs = ks8851_common.o ks8851_spi.o
-obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
-ks8851_mll-objs = ks8851_common.o ks8851_par.o
+obj-$(CONFIG_KS8851) += ks8851_common.o ks8851_spi.o
+obj-$(CONFIG_KS8851_MLL) += ks8851_common.o ks8851_par.o
 obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 831518466de2..0f9c5457b93e 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -1057,6 +1057,7 @@ int ks8851_suspend(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_suspend);
 
 int ks8851_resume(struct device *dev)
 {
@@ -1070,6 +1071,7 @@ int ks8851_resume(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_resume);
 #endif
 
 static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
@@ -1243,6 +1245,7 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 err_reg_io:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ks8851_probe_common);
 
 int ks8851_remove_common(struct device *dev)
 {
@@ -1261,3 +1264,8 @@ int ks8851_remove_common(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_remove_common);
+
+MODULE_DESCRIPTION("KS8851 Network driver");
+MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
+MODULE_LICENSE("GPL");
-- 
2.33.0



