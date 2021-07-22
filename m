Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30AB3D2678
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhGVObF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232317AbhGVObE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:31:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30AF461029;
        Thu, 22 Jul 2021 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626966699;
        bh=72zsyY+nCegKzCa1oWp6WySUITK+P8znaJfAVipR/ks=;
        h=Subject:To:Cc:From:Date:From;
        b=YMNVmb77N/0+cWxG0DOY797MN2BvsZb7dBwku7fF5vLpiIHdsloHdH5XWd907wjEZ
         gOGimRP/Zm4Wcv+fjkmQIW8ks8+Y+30IsEK4rtcpdIMDIX2ucSJYL6Cf/ae7CkOLfu
         zQRQSveGlA2kxSJ7h1pphLC9HfaR9/VVH8dZTx8g=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: enable SerDes PCS register dump via" failed to apply to 5.10-stable tree
To:     kabel@kernel.org, andrew@lunn.ch, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:11:37 +0200
Message-ID: <162696669723966@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 953b0dcbe2e3f7bee98cc3bca2ec82c8298e9c16 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Date: Thu, 1 Jul 2021 00:22:31 +0200
Subject: [PATCH] net: dsa: mv88e6xxx: enable SerDes PCS register dump via
 ethtool -d on Topaz
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit bf3504cea7d7e ("net: dsa: mv88e6xxx: Add 6390 family PCS
registers to ethtool -d") added support for dumping SerDes PCS registers
via ethtool -d for Peridot.

The same implementation is also valid for Topaz, but was not
enabled at the time.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: bf3504cea7d7e ("net: dsa: mv88e6xxx: Add 6390 family PCS registers to ethtool -d")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1e95a0facbd4..beb41572d04e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3626,6 +3626,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4435,6 +4437,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 

