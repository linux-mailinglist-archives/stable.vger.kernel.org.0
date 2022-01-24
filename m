Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F58499756
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448523AbiAXVNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59932 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353511AbiAXVHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75076131F;
        Mon, 24 Jan 2022 21:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9D9C340E5;
        Mon, 24 Jan 2022 21:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058451;
        bh=bb8964e8msFvAo7Z/rouyLUH8l08cyHY8RTjbv7K7vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UPNqKPZe5uTB/aW9IqEosd4EGQdVwrDxWkKLDgS6hrD9A00iRTlqmMUdGD268VRy
         KoKZBsBj4zuBeT0ctYoQfX3TTqg7QZEr4SBbn39Xnuvuncm16Mma5/3PW/jjsJb7ZP
         vwdeqCh46cJYvYHmirXk8vP8bA40yR5e+fo1AYh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0292/1039] net: dsa: hellcreek: Add missing PTP via UDP rules
Date:   Mon, 24 Jan 2022 19:34:41 +0100
Message-Id: <20220124184135.091770773@linuxfoundation.org>
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
index 40ce8c0c9167a..b2bab460d2e98 100644
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



