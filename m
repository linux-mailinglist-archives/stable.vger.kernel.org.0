Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94543D2A3E
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhGVQKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235284AbhGVQJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B55061DD2;
        Thu, 22 Jul 2021 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972538;
        bh=tLTbp2wQX4NklGSuRsACp62/NbPWgqYc852I8m2h6QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frlMuEAtV0HYz6nUCDuA3ryeHT8yorS2XmGQJjw1sNqsXbuOiUgePb3ac1r7AsPtf
         h/h1YiqIdLkVRQH/XxQcgx9HSbS7jImgHImdEphz+9lPlJ6hZvZFtj/2qlE6mgrixh
         HorcaoiTDWlEEgTMit+fN0wz2tofUm3qa/m8Tr/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 113/156] net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz
Date:   Thu, 22 Jul 2021 18:31:28 +0200
Message-Id: <20210722155632.028064148@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |    6 ++++++
 drivers/net/dsa/mv88e6xxx/serdes.c |    6 +++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3623,6 +3623,9 @@ static const struct mv88e6xxx_ops mv88e6
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4429,6 +4432,9 @@ static const struct mv88e6xxx_ops mv88e6
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -722,7 +722,7 @@ static struct mv88e6390_serdes_hw_stat m
 
 int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6390_serdes_get_lane(chip, port) < 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) < 0)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
@@ -734,7 +734,7 @@ int mv88e6390_serdes_get_strings(struct
 	struct mv88e6390_serdes_hw_stat *stat;
 	int i;
 
-	if (mv88e6390_serdes_get_lane(chip, port) < 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) < 0)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -770,7 +770,7 @@ int mv88e6390_serdes_get_stats(struct mv
 	int lane;
 	int i;
 
-	lane = mv88e6390_serdes_get_lane(chip, port);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane < 0)
 		return 0;
 


