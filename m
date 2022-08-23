Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDBD59D5AC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347591AbiHWJFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347708AbiHWJEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:04:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B766C832DB;
        Tue, 23 Aug 2022 01:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2CE7B81C4B;
        Tue, 23 Aug 2022 08:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25914C433C1;
        Tue, 23 Aug 2022 08:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243246;
        bh=VxIzgje0bAkA5nU6x14VUAf4lFgpCDT5esVGWY5nUig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHeqy3MwGbcAkSXnFbie1A82BTAIKYeIOOZ7bylkYRYGg5asoHxVg28hLJ7+V/EG/
         eZtXsjxSXe23T/1BVbcCsNpwTEexn/QjQexSf63/pVnEgraBYBF7lPsCyxEMumCZD6
         r7Y8Ov7eicMd4RMMHcXqPY6cBHfKFUZcdc6pNU70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 216/365] net: mscc: ocelot: fix incorrect ndo_get_stats64 packet counters
Date:   Tue, 23 Aug 2022 10:01:57 +0200
Message-Id: <20220823080127.233437508@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 5152de7b79ab0be150f5966481b0c8f996192531 upstream.

Reading stats using the SYS_COUNT_* register definitions is only used by
ocelot_get_stats64() from the ocelot switchdev driver, however,
currently the bucket definitions are incorrect.

Separately, on both RX and TX, we have the following problems:
- a 256-1023 bucket which actually tracks the 256-511 packets
- the 1024-1526 bucket actually tracks the 512-1023 packets
- the 1527-max bucket actually tracks the 1024-1526 packets

=> nobody tracks the packets from the real 1527-max bucket

Additionally, the RX_PAUSE, RX_CONTROL, RX_LONGS and RX_CLASSIFIED_DROPS
all track the wrong thing. However this doesn't seem to have any
consequence, since ocelot_get_stats64() doesn't use these.

Even though this problem only manifests itself for the switchdev driver,
we cannot split the fix for ocelot and for DSA, since it requires fixing
the bucket definitions from enum ocelot_reg, which makes us necessarily
adapt the structures from felix and seville as well.

Fixes: 84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953 switch")
Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c   |   20 ++++++++++++--------
 drivers/net/dsa/ocelot/seville_vsc9953.c |   16 +++++++++-------
 drivers/net/ethernet/mscc/ocelot_net.c   |    6 ++++--
 drivers/net/ethernet/mscc/vsc7514_regs.c |   24 +++++++++++++-----------
 include/soc/mscc/ocelot.h                |    6 ++++--
 5 files changed, 42 insertions(+), 30 deletions(-)

--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -280,19 +280,23 @@ static const u32 vsc9959_sys_regmap[] =
 	REG(SYS_COUNT_RX_64,			0x000024),
 	REG(SYS_COUNT_RX_65_127,		0x000028),
 	REG(SYS_COUNT_RX_128_255,		0x00002c),
-	REG(SYS_COUNT_RX_256_1023,		0x000030),
-	REG(SYS_COUNT_RX_1024_1526,		0x000034),
-	REG(SYS_COUNT_RX_1527_MAX,		0x000038),
-	REG(SYS_COUNT_RX_LONGS,			0x000044),
+	REG(SYS_COUNT_RX_256_511,		0x000030),
+	REG(SYS_COUNT_RX_512_1023,		0x000034),
+	REG(SYS_COUNT_RX_1024_1526,		0x000038),
+	REG(SYS_COUNT_RX_1527_MAX,		0x00003c),
+	REG(SYS_COUNT_RX_PAUSE,			0x000040),
+	REG(SYS_COUNT_RX_CONTROL,		0x000044),
+	REG(SYS_COUNT_RX_LONGS,			0x000048),
 	REG(SYS_COUNT_TX_OCTETS,		0x000200),
 	REG(SYS_COUNT_TX_COLLISION,		0x000210),
 	REG(SYS_COUNT_TX_DROPS,			0x000214),
 	REG(SYS_COUNT_TX_64,			0x00021c),
 	REG(SYS_COUNT_TX_65_127,		0x000220),
-	REG(SYS_COUNT_TX_128_511,		0x000224),
-	REG(SYS_COUNT_TX_512_1023,		0x000228),
-	REG(SYS_COUNT_TX_1024_1526,		0x00022c),
-	REG(SYS_COUNT_TX_1527_MAX,		0x000230),
+	REG(SYS_COUNT_TX_128_255,		0x000224),
+	REG(SYS_COUNT_TX_256_511,		0x000228),
+	REG(SYS_COUNT_TX_512_1023,		0x00022c),
+	REG(SYS_COUNT_TX_1024_1526,		0x000230),
+	REG(SYS_COUNT_TX_1527_MAX,		0x000234),
 	REG(SYS_COUNT_TX_AGING,			0x000278),
 	REG(SYS_RESET_CFG,			0x000e00),
 	REG(SYS_SR_ETYPE_CFG,			0x000e04),
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -277,19 +277,21 @@ static const u32 vsc9953_sys_regmap[] =
 	REG(SYS_COUNT_RX_64,			0x000024),
 	REG(SYS_COUNT_RX_65_127,		0x000028),
 	REG(SYS_COUNT_RX_128_255,		0x00002c),
-	REG(SYS_COUNT_RX_256_1023,		0x000030),
-	REG(SYS_COUNT_RX_1024_1526,		0x000034),
-	REG(SYS_COUNT_RX_1527_MAX,		0x000038),
+	REG(SYS_COUNT_RX_256_511,		0x000030),
+	REG(SYS_COUNT_RX_512_1023,		0x000034),
+	REG(SYS_COUNT_RX_1024_1526,		0x000038),
+	REG(SYS_COUNT_RX_1527_MAX,		0x00003c),
 	REG(SYS_COUNT_RX_LONGS,			0x000048),
 	REG(SYS_COUNT_TX_OCTETS,		0x000100),
 	REG(SYS_COUNT_TX_COLLISION,		0x000110),
 	REG(SYS_COUNT_TX_DROPS,			0x000114),
 	REG(SYS_COUNT_TX_64,			0x00011c),
 	REG(SYS_COUNT_TX_65_127,		0x000120),
-	REG(SYS_COUNT_TX_128_511,		0x000124),
-	REG(SYS_COUNT_TX_512_1023,		0x000128),
-	REG(SYS_COUNT_TX_1024_1526,		0x00012c),
-	REG(SYS_COUNT_TX_1527_MAX,		0x000130),
+	REG(SYS_COUNT_TX_128_255,		0x000124),
+	REG(SYS_COUNT_TX_256_511,		0x000128),
+	REG(SYS_COUNT_TX_512_1023,		0x00012c),
+	REG(SYS_COUNT_TX_1024_1526,		0x000130),
+	REG(SYS_COUNT_TX_1527_MAX,		0x000134),
 	REG(SYS_COUNT_TX_AGING,			0x000178),
 	REG(SYS_RESET_CFG,			0x000318),
 	REG_RESERVED(SYS_SR_ETYPE_CFG),
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -739,7 +739,8 @@ static void ocelot_get_stats64(struct ne
 			    ocelot_read(ocelot, SYS_COUNT_RX_64) +
 			    ocelot_read(ocelot, SYS_COUNT_RX_65_127) +
 			    ocelot_read(ocelot, SYS_COUNT_RX_128_255) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_256_1023) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_256_511) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_512_1023) +
 			    ocelot_read(ocelot, SYS_COUNT_RX_1024_1526) +
 			    ocelot_read(ocelot, SYS_COUNT_RX_1527_MAX);
 	stats->multicast = ocelot_read(ocelot, SYS_COUNT_RX_MULTICAST);
@@ -749,7 +750,8 @@ static void ocelot_get_stats64(struct ne
 	stats->tx_bytes = ocelot_read(ocelot, SYS_COUNT_TX_OCTETS);
 	stats->tx_packets = ocelot_read(ocelot, SYS_COUNT_TX_64) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_65_127) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_128_511) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_128_255) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_256_511) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_512_1023) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_1024_1526) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_1527_MAX);
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -180,13 +180,14 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_RX_64,				0x000024),
 	REG(SYS_COUNT_RX_65_127,			0x000028),
 	REG(SYS_COUNT_RX_128_255,			0x00002c),
-	REG(SYS_COUNT_RX_256_1023,			0x000030),
-	REG(SYS_COUNT_RX_1024_1526,			0x000034),
-	REG(SYS_COUNT_RX_1527_MAX,			0x000038),
-	REG(SYS_COUNT_RX_PAUSE,				0x00003c),
-	REG(SYS_COUNT_RX_CONTROL,			0x000040),
-	REG(SYS_COUNT_RX_LONGS,				0x000044),
-	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x000048),
+	REG(SYS_COUNT_RX_256_511,			0x000030),
+	REG(SYS_COUNT_RX_512_1023,			0x000034),
+	REG(SYS_COUNT_RX_1024_1526,			0x000038),
+	REG(SYS_COUNT_RX_1527_MAX,			0x00003c),
+	REG(SYS_COUNT_RX_PAUSE,				0x000040),
+	REG(SYS_COUNT_RX_CONTROL,			0x000044),
+	REG(SYS_COUNT_RX_LONGS,				0x000048),
+	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x00004c),
 	REG(SYS_COUNT_TX_OCTETS,			0x000100),
 	REG(SYS_COUNT_TX_UNICAST,			0x000104),
 	REG(SYS_COUNT_TX_MULTICAST,			0x000108),
@@ -196,10 +197,11 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_TX_PAUSE,				0x000118),
 	REG(SYS_COUNT_TX_64,				0x00011c),
 	REG(SYS_COUNT_TX_65_127,			0x000120),
-	REG(SYS_COUNT_TX_128_511,			0x000124),
-	REG(SYS_COUNT_TX_512_1023,			0x000128),
-	REG(SYS_COUNT_TX_1024_1526,			0x00012c),
-	REG(SYS_COUNT_TX_1527_MAX,			0x000130),
+	REG(SYS_COUNT_TX_128_255,			0x000124),
+	REG(SYS_COUNT_TX_256_511,			0x000128),
+	REG(SYS_COUNT_TX_512_1023,			0x00012c),
+	REG(SYS_COUNT_TX_1024_1526,			0x000130),
+	REG(SYS_COUNT_TX_1527_MAX,			0x000134),
 	REG(SYS_COUNT_TX_AGING,				0x000170),
 	REG(SYS_RESET_CFG,				0x000508),
 	REG(SYS_CMID,					0x00050c),
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -335,7 +335,8 @@ enum ocelot_reg {
 	SYS_COUNT_RX_64,
 	SYS_COUNT_RX_65_127,
 	SYS_COUNT_RX_128_255,
-	SYS_COUNT_RX_256_1023,
+	SYS_COUNT_RX_256_511,
+	SYS_COUNT_RX_512_1023,
 	SYS_COUNT_RX_1024_1526,
 	SYS_COUNT_RX_1527_MAX,
 	SYS_COUNT_RX_PAUSE,
@@ -351,7 +352,8 @@ enum ocelot_reg {
 	SYS_COUNT_TX_PAUSE,
 	SYS_COUNT_TX_64,
 	SYS_COUNT_TX_65_127,
-	SYS_COUNT_TX_128_511,
+	SYS_COUNT_TX_128_255,
+	SYS_COUNT_TX_256_511,
 	SYS_COUNT_TX_512_1023,
 	SYS_COUNT_TX_1024_1526,
 	SYS_COUNT_TX_1527_MAX,


