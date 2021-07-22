Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045AB3D28C6
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhGVP6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233200AbhGVP6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E03613AF;
        Thu, 22 Jul 2021 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626971925;
        bh=mAh6cD/YknUmJyKdRuWdAOYumr3npNxzaA6Ore7Uq6g=;
        h=From:To:Cc:Subject:Date:From;
        b=csLLGDa6tKTPfIZtk/p27OdokSKXUy2biYJTo4yjwnmx8eTu0J1WH/DwMEweTFZ5K
         WgYoKyp6YqS4BwBmE1knvHZRKy5CWZrCzBKX4wdkPp5OSaA2gwNvzcF1qUKMfUcnVs
         JP3k6xukmC99wqyata7TGOBP9ja4ixgEEA0dDJES857Nw8+aUqS0+F246luf8sjVgP
         2YhCx1dpAkAGGgPqN/qPvfw33ambLxNv9Z+ZQ0Iy5R545bA5oYwdIM91P49jW6F9wm
         GXYKEOhRzoQQqn6zWXpgUeMy8xui8Is5smYNxUaeUYB2IBEkZrTyBATQea+SnRPgJk
         CaGCnbPTVPPkA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.4] net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz
Date:   Thu, 22 Jul 2021 18:38:42 +0200
Message-Id: <20210722163842.23025-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 11527f3c4725640e6c40a2b7654e303f45e82a6c upstream.

Commit 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
introduced wrong .stats_set_histogram() method for Topaz family.

The Peridot method should be used instead.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8aa8825557a8..40b105daaf9e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3192,7 +3192,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
-	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
@@ -3907,7 +3907,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
-	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-- 
2.31.1

