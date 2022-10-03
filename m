Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3205F2B04
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiJCHpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiJCHoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:44:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E28D57568;
        Mon,  3 Oct 2022 00:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F458B80E7A;
        Mon,  3 Oct 2022 07:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B767C433D6;
        Mon,  3 Oct 2022 07:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781440;
        bh=+K2M49aupPvctZ91T0D68iUEBcL7JYgj1FqGcf/KDjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRKJ7XTa1zbX//t8+sZ1gymSbI+E6LXrDuLYBz1wY1RUMvY3QzZP/99edgXGMu1LA
         ri9snwj9Rwvok0/ecOgpoorKdvvpcaCLurltTJbsTF8eLuJ8XLqJzCTO+SbO9vrtvU
         KyuEpIegTaXLyToLkTjemR/bpDEuypNaVC/IAamM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Couzens <lynxis@fe80.eu>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 20/83] net: mt7531: only do PLL once after the reset
Date:   Mon,  3 Oct 2022 09:10:45 +0200
Message-Id: <20221003070722.491312135@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Couzens <lynxis@fe80.eu>

commit 42bc4fafe359ed6b73602b7a2dba0dd99588f8ce upstream.

Move the PLL init of the switch out of the pad configuration of the port
6 (usally cpu port).

Fix a unidirectional 100 mbit limitation on 1 gbit or 2.5 gbit links for
outbound traffic on port 5 or port 6.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -501,14 +501,19 @@ static bool mt7531_dual_sgmii_supported(
 static int
 mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
 {
-	struct mt7530_priv *priv = ds->priv;
+	return 0;
+}
+
+static void
+mt7531_pll_setup(struct mt7530_priv *priv)
+{
 	u32 top_sig;
 	u32 hwstrap;
 	u32 xtal;
 	u32 val;
 
 	if (mt7531_dual_sgmii_supported(priv))
-		return 0;
+		return;
 
 	val = mt7530_read(priv, MT7531_CREV);
 	top_sig = mt7530_read(priv, MT7531_TOP_SIG_SR);
@@ -587,8 +592,6 @@ mt7531_pad_setup(struct dsa_switch *ds,
 	val |= EN_COREPLL;
 	mt7530_write(priv, MT7531_PLLGP_EN, val);
 	usleep_range(25, 35);
-
-	return 0;
 }
 
 static void
@@ -2292,6 +2295,8 @@ mt7531_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
+	mt7531_pll_setup(priv);
+
 	if (mt7531_dual_sgmii_supported(priv)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5_SGMII;
 
@@ -2867,8 +2872,6 @@ mt7531_cpu_port_config(struct dsa_switch
 	case 6:
 		interface = PHY_INTERFACE_MODE_2500BASEX;
 
-		mt7531_pad_setup(ds, interface);
-
 		priv->p6_interface = interface;
 		break;
 	default:


