Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C6E4ABD97
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388795AbiBGLpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385407AbiBGLbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5DDC02B662;
        Mon,  7 Feb 2022 03:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73B8260AB0;
        Mon,  7 Feb 2022 11:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B18CC004E1;
        Mon,  7 Feb 2022 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233414;
        bh=i2PB0zojxD9sz4cxUGlG2ch2e9HLN9jntYt4Vcfu+iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIwY/NpH15AB/fa+yCdKHsDf1lY7JWeoIDEFkYBLxafQP0sXz0f2u225NXTYuOVM5
         sVKgX0PcKJCcpHYIOmfvGKIQIIBYrUHB5PgUVlxlLzuOJOxFF+KvAInkuUahhULiOH
         gyJzpvmQ43Lrxki4w7axv9WpNYOybj4PH+UVSx58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 090/110] e1000e: Separate ADP board type from TGP
Date:   Mon,  7 Feb 2022 12:07:03 +0100
Message-Id: <20220207103805.451603316@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Sasha Neftin <sasha.neftin@intel.com>

commit 68defd528f94ed1cf11f49a75cc1875dccd781fa upstream.

We have the same LAN controller on different PCH's. Separate ADP board
type from a TGP which will allow for specific fixes to be applied for
ADP platforms.

Suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/e1000.h   |    4 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c |   20 ++++++++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  |   33 ++++++++++++++--------------
 3 files changed, 40 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -114,7 +114,8 @@ enum e1000_boards {
 	board_pch_lpt,
 	board_pch_spt,
 	board_pch_cnp,
-	board_pch_tgp
+	board_pch_tgp,
+	board_pch_adp
 };
 
 struct e1000_ps_page {
@@ -501,6 +502,7 @@ extern const struct e1000_info e1000_pch
 extern const struct e1000_info e1000_pch_spt_info;
 extern const struct e1000_info e1000_pch_cnp_info;
 extern const struct e1000_info e1000_pch_tgp_info;
+extern const struct e1000_info e1000_pch_adp_info;
 extern const struct e1000_info e1000_es2_info;
 
 void e1000e_ptp_init(struct e1000_adapter *adapter);
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -6021,3 +6021,23 @@ const struct e1000_info e1000_pch_tgp_in
 	.phy_ops		= &ich8_phy_ops,
 	.nvm_ops		= &spt_nvm_ops,
 };
+
+const struct e1000_info e1000_pch_adp_info = {
+	.mac			= e1000_pch_adp,
+	.flags			= FLAG_IS_ICH
+				  | FLAG_HAS_WOL
+				  | FLAG_HAS_HW_TIMESTAMP
+				  | FLAG_HAS_CTRLEXT_ON_LOAD
+				  | FLAG_HAS_AMT
+				  | FLAG_HAS_FLASH
+				  | FLAG_HAS_JUMBO_FRAMES
+				  | FLAG_APME_IN_WUC,
+	.flags2			= FLAG2_HAS_PHY_STATS
+				  | FLAG2_HAS_EEE,
+	.pba			= 26,
+	.max_hw_frame_size	= 9022,
+	.get_variants		= e1000_get_variants_ich8lan,
+	.mac_ops		= &ich8_mac_ops,
+	.phy_ops		= &ich8_phy_ops,
+	.nvm_ops		= &spt_nvm_ops,
+};
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -52,6 +52,7 @@ static const struct e1000_info *e1000_in
 	[board_pch_spt]		= &e1000_pch_spt_info,
 	[board_pch_cnp]		= &e1000_pch_cnp_info,
 	[board_pch_tgp]		= &e1000_pch_tgp_info,
+	[board_pch_adp]		= &e1000_pch_adp_info,
 };
 
 struct e1000_reg_info {
@@ -7905,22 +7906,22 @@ static const struct pci_device_id e1000_
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_tgp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_tgp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM23), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V23), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM22), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V22), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM20), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V21), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM23), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V23), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM22), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V22), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM20), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V21), board_pch_adp },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };


