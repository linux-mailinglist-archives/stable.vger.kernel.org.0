Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C47B3D28D2
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhGVP7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232805AbhGVP6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC2826135B;
        Thu, 22 Jul 2021 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626971931;
        bh=7sYbbC2XbITf3UNyJFgMAm53kuo6x7j5wKAiZq6v8S8=;
        h=From:To:Cc:Subject:Date:From;
        b=o78ASWpL16RbJZYevDHzZV/3Bf9xygqpiyyMX5HZELcy1Ln5lBiSS3Bh1XNwhP4nd
         Gx2LlIwL0FBGZVhajvvoa6wBfTLizwUyMVImzdewEEf0CTgDhhLEDHV+ekkWyiX65Z
         44GWXYqrncv+PAjGJRdjscr2woce1G7K56G+LSTvxKIY7CWJecSISMyHekrdCKQ7Ww
         FKR7rqOeXlrz+0hWIBJk1RaiJvg6mXobj5a+1iiOwDroK9qtHIDJp1IZBDEuyjc7SZ
         ISQbht6DlxOfmS3GzZXR5bdVnEr2Q3jb86//D/nwcOBryh2ISLDsROoaZJgBPMzjAA
         IGydbjJcnPG3A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 1/2] net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz
Date:   Thu, 22 Jul 2021 18:38:47 +0200
Message-Id: <20210722163848.23080-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a03b98d68367b18e5db6d6850e2cc18754fba94a upstream.

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
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 6 ++++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 6 +++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 429ce8638c2b..8029e76b0745 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3433,6 +3433,9 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4205,6 +4208,9 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 9c07b4f3d345..6920e62c864d 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -590,7 +590,7 @@ static struct mv88e6390_serdes_hw_stat mv88e6390_serdes_hw_stats[] = {
 
 int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
@@ -602,7 +602,7 @@ int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
 	struct mv88e6390_serdes_hw_stat *stat;
 	int i;
 
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -638,7 +638,7 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	int lane;
 	int i;
 
-	lane = mv88e6390_serdes_get_lane(chip, port);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane == 0)
 		return 0;
 
-- 
2.31.1

