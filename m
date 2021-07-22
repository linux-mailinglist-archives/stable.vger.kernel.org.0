Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE6B3D2676
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhGVOaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232575AbhGVOav (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:30:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 764AA6109D;
        Thu, 22 Jul 2021 15:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626966686;
        bh=u1vGICj9VPnsUKwNNNRac1iguok/y+AWFTE4iWUNGRQ=;
        h=Subject:To:Cc:From:Date:From;
        b=vaMsxKLwo8damGHxnt7o6WmU4lxaSTI2OaQR7G27MAHOZ0v4LbNDZaobfOexCG6yB
         ff8Aa2dXHWkACRwE+UqtsUm+Tlh4DwhDIrrpr/4NbR9PlBUw3bVfKZRaUuiyYCSXY2
         /sfC1blR4rF4IptOsNOJuENAjnL18OpSgr2XtUJk=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz" failed to apply to 5.10-stable tree
To:     kabel@kernel.org, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:11:23 +0200
Message-ID: <162696668319468@kroah.com>
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

From a03b98d68367b18e5db6d6850e2cc18754fba94a Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Date: Thu, 1 Jul 2021 00:22:30 +0200
Subject: [PATCH] net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 0df952873636a ("mv88e6xxx: Add serdes Rx statistics") added
support for RX statistics on SerDes ports for Peridot.

This same implementation is also valid for Topaz, but was not enabled
at the time.

We need to use the generic .serdes_get_lane() method instead of the
Peridot specific one in the stats methods so that on Topaz the proper
one is used.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 0df952873636a ("mv88e6xxx: Add serdes Rx statistics")
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 354ff0b84b7f..1e95a0facbd4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3623,6 +3623,9 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4429,6 +4432,9 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index e4fbef81bc52..b1d46dd8eaab 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -722,7 +722,7 @@ static struct mv88e6390_serdes_hw_stat mv88e6390_serdes_hw_stats[] = {
 
 int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6390_serdes_get_lane(chip, port) < 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) < 0)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
@@ -734,7 +734,7 @@ int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
 	struct mv88e6390_serdes_hw_stat *stat;
 	int i;
 
-	if (mv88e6390_serdes_get_lane(chip, port) < 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) < 0)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -770,7 +770,7 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	int lane;
 	int i;
 
-	lane = mv88e6390_serdes_get_lane(chip, port);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane < 0)
 		return 0;
 

