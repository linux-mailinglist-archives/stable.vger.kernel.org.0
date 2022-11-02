Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA62061596B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiKBDKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiKBDKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:10:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7B02339B
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:10:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B36FFB82078
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B67EC433D7;
        Wed,  2 Nov 2022 03:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358637;
        bh=kYvn7guARQT/ilG8JAvUnESeWB4cclyl5mJ68AajVgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoWN+GWyQ5jvHVxgfWstbRSjLQkcU4vMGCYUEwhitUGdlZkmqYgvGTeuxfAPAzUGp
         O07d91rKC6UCK6H+vbE4pxJOFfMtgYJMDn6Jp628pIIy5+FDc3STOUTMfH9ZWuQzO1
         PgZckbzROjYKvlkk21pgzRmz0MhcZcOwz8hRHoOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Borleis <jbe@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/132] net: fec: limit register access on i.MX6UL
Date:   Wed,  2 Nov 2022 03:33:32 +0100
Message-Id: <20221102022102.445808801@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Borleis <jbe@pengutronix.de>

[ Upstream commit 0a8b43b12dd78daa77a7dc007b92770d262a2714 ]

Using 'ethtool -d […]' on an i.MX6UL leads to a kernel crash:

   Unhandled fault: external abort on non-linefetch (0x1008) at […]

due to this SoC has less registers in its FEC implementation compared to other
i.MX6 variants. Thus, a run-time decision is required to avoid access to
non-existing registers.

Fixes: a51d3ab50702 ("net: fec: use a more proper compatible string for i.MX6UL type device")
Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221024080552.21004-1-jbe@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 46 ++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 67eb9b671244..313ae8112067 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2336,6 +2336,31 @@ static u32 fec_enet_register_offset[] = {
 	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
 	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
 };
+/* for i.MX6ul */
+static u32 fec_enet_register_offset_6ul[] = {
+	FEC_IEVENT, FEC_IMASK, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
+	FEC_ECNTRL, FEC_MII_DATA, FEC_MII_SPEED, FEC_MIB_CTRLSTAT, FEC_R_CNTRL,
+	FEC_X_CNTRL, FEC_ADDR_LOW, FEC_ADDR_HIGH, FEC_OPD, FEC_TXIC0, FEC_RXIC0,
+	FEC_HASH_TABLE_HIGH, FEC_HASH_TABLE_LOW, FEC_GRP_HASH_TABLE_HIGH,
+	FEC_GRP_HASH_TABLE_LOW, FEC_X_WMRK, FEC_R_DES_START_0,
+	FEC_X_DES_START_0, FEC_R_BUFF_SIZE_0, FEC_R_FIFO_RSFL, FEC_R_FIFO_RSEM,
+	FEC_R_FIFO_RAEM, FEC_R_FIFO_RAFL, FEC_RACC,
+	RMON_T_DROP, RMON_T_PACKETS, RMON_T_BC_PKT, RMON_T_MC_PKT,
+	RMON_T_CRC_ALIGN, RMON_T_UNDERSIZE, RMON_T_OVERSIZE, RMON_T_FRAG,
+	RMON_T_JAB, RMON_T_COL, RMON_T_P64, RMON_T_P65TO127, RMON_T_P128TO255,
+	RMON_T_P256TO511, RMON_T_P512TO1023, RMON_T_P1024TO2047,
+	RMON_T_P_GTE2048, RMON_T_OCTETS,
+	IEEE_T_DROP, IEEE_T_FRAME_OK, IEEE_T_1COL, IEEE_T_MCOL, IEEE_T_DEF,
+	IEEE_T_LCOL, IEEE_T_EXCOL, IEEE_T_MACERR, IEEE_T_CSERR, IEEE_T_SQE,
+	IEEE_T_FDXFC, IEEE_T_OCTETS_OK,
+	RMON_R_PACKETS, RMON_R_BC_PKT, RMON_R_MC_PKT, RMON_R_CRC_ALIGN,
+	RMON_R_UNDERSIZE, RMON_R_OVERSIZE, RMON_R_FRAG, RMON_R_JAB,
+	RMON_R_RESVD_O, RMON_R_P64, RMON_R_P65TO127, RMON_R_P128TO255,
+	RMON_R_P256TO511, RMON_R_P512TO1023, RMON_R_P1024TO2047,
+	RMON_R_P_GTE2048, RMON_R_OCTETS,
+	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
+	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
+};
 #else
 static __u32 fec_enet_register_version = 1;
 static u32 fec_enet_register_offset[] = {
@@ -2360,7 +2385,24 @@ static void fec_enet_get_regs(struct net_device *ndev,
 	u32 *buf = (u32 *)regbuf;
 	u32 i, off;
 	int ret;
+#if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M528x) || \
+	defined(CONFIG_M520x) || defined(CONFIG_M532x) || defined(CONFIG_ARM) || \
+	defined(CONFIG_ARM64) || defined(CONFIG_COMPILE_TEST)
+	u32 *reg_list;
+	u32 reg_cnt;
 
+	if (!of_machine_is_compatible("fsl,imx6ul")) {
+		reg_list = fec_enet_register_offset;
+		reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
+	} else {
+		reg_list = fec_enet_register_offset_6ul;
+		reg_cnt = ARRAY_SIZE(fec_enet_register_offset_6ul);
+	}
+#else
+	/* coldfire */
+	static u32 *reg_list = fec_enet_register_offset;
+	static const u32 reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
+#endif
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return;
@@ -2369,8 +2411,8 @@ static void fec_enet_get_regs(struct net_device *ndev,
 
 	memset(buf, 0, regs->len);
 
-	for (i = 0; i < ARRAY_SIZE(fec_enet_register_offset); i++) {
-		off = fec_enet_register_offset[i];
+	for (i = 0; i < reg_cnt; i++) {
+		off = reg_list[i];
 
 		if ((off == FEC_R_BOUND || off == FEC_R_FSTART) &&
 		    !(fep->quirks & FEC_QUIRK_HAS_FRREG))
-- 
2.35.1



