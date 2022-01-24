Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E49E499AB1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573264AbiAXVoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455566AbiAXVfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1319C05A184;
        Mon, 24 Jan 2022 12:22:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99AC7B81229;
        Mon, 24 Jan 2022 20:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D099DC340EB;
        Mon, 24 Jan 2022 20:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055743;
        bh=cGgoof5YZQNjDLD4VVh3KObatYUecWRFuj1h/IvavaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGD+t2ekRJDx67fvkh7cEPhyhGBO/fHk12S3nRIe2Zsowelp4dKe+HRIYisYvexr1
         K3tmR4eHgdeln7HBUVXXeRnqdwiD/AsC4/XcIKvLyT1n13qWB2BlHg94MAAbtmjykj
         ldQRCXt0UmimdgTrC74ssbDEEqktyzEEDbKRZv2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/846] net: dsa: hellcreek: Add missing PTP via UDP rules
Date:   Mon, 24 Jan 2022 19:36:07 +0100
Message-Id: <20220124184109.573560127@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 6cf01e451599da630ff1af529d61c5e4db4550ab ]

The switch supports PTP for UDP transport too. Therefore, add the missing static
FDB entries to ensure correct forwarding of these packets.

Fixes: ddd56dfe52c9 ("net: dsa: hellcreek: Add PTP clock support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 64 ++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 2dd1227e0c357..950a54ec4b59b 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1052,7 +1052,7 @@ static void hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
 
 static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 {
-	static struct hellcreek_fdb_entry ptp = {
+	static struct hellcreek_fdb_entry l2_ptp = {
 		/* MAC: 01-1B-19-00-00-00 */
 		.mac	      = { 0x01, 0x1b, 0x19, 0x00, 0x00, 0x00 },
 		.portmask     = 0x03,	/* Management ports */
@@ -1063,7 +1063,29 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
 	};
-	static struct hellcreek_fdb_entry p2p = {
+	static struct hellcreek_fdb_entry udp4_ptp = {
+		/* MAC: 01-00-5E-00-01-81 */
+		.mac	      = { 0x01, 0x00, 0x5e, 0x00, 0x01, 0x81 },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 0,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
+	static struct hellcreek_fdb_entry udp6_ptp = {
+		/* MAC: 33-33-00-00-01-81 */
+		.mac	      = { 0x33, 0x33, 0x00, 0x00, 0x01, 0x81 },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 0,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
+	static struct hellcreek_fdb_entry l2_p2p = {
 		/* MAC: 01-80-C2-00-00-0E */
 		.mac	      = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e },
 		.portmask     = 0x03,	/* Management ports */
@@ -1074,6 +1096,28 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
 	};
+	static struct hellcreek_fdb_entry udp4_p2p = {
+		/* MAC: 01-00-5E-00-00-6B */
+		.mac	      = { 0x01, 0x00, 0x5e, 0x00, 0x00, 0x6b },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 1,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
+	static struct hellcreek_fdb_entry udp6_p2p = {
+		/* MAC: 33-33-00-00-00-6B */
+		.mac	      = { 0x33, 0x33, 0x00, 0x00, 0x00, 0x6b },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 1,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
 	static struct hellcreek_fdb_entry stp = {
 		/* MAC: 01-80-C2-00-00-00 */
 		.mac	      = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x00 },
@@ -1088,10 +1132,22 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 	int ret;
 
 	mutex_lock(&hellcreek->reg_lock);
-	ret = __hellcreek_fdb_add(hellcreek, &ptp);
+	ret = __hellcreek_fdb_add(hellcreek, &l2_ptp);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &udp4_ptp);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &udp6_ptp);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &l2_p2p);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &udp4_p2p);
 	if (ret)
 		goto out;
-	ret = __hellcreek_fdb_add(hellcreek, &p2p);
+	ret = __hellcreek_fdb_add(hellcreek, &udp6_p2p);
 	if (ret)
 		goto out;
 	ret = __hellcreek_fdb_add(hellcreek, &stp);
-- 
2.34.1



