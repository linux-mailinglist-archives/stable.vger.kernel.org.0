Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE73C2F14F8
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbhAKNdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732160AbhAKNOm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CA3422ADF;
        Mon, 11 Jan 2021 13:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370841;
        bh=tzvl5sHdBtluz5D1Fyj4DNPYehSKsO9XCZc2JL+oR/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftsn7Bd5RApPqw3DiWGuehNqIEcEuXgZT6CsEARo1KNUkb0rRV49yJVh6EPN8wm+F
         8p8oheEwf3in5s2r0Ka7k2FaFDBZ1KgMJlIZJxFvs2wr3QpN2wdD28gFbyhbPLDDaC
         rS420wQdZMf2nnQhboK2f3Br5G33rsb0WGTb95AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Chulski <stefanc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 004/145] net: mvpp2: Add TCAM entry to drop flow control pause frames
Date:   Mon, 11 Jan 2021 14:00:28 +0100
Message-Id: <20210111130048.722039794@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit 3f48fab62bb81a7f9d01e9d43c40395fad011dd5 ]

Issue:
Flow control frame used to pause GoP(MAC) was delivered to the CPU
and created a load on the CPU. Since XOFF/XON frames are used only
by MAC, these frames should be dropped inside MAC.

Fix:
According to 802.3-2012 - IEEE Standard for Ethernet pause frame
has unique destination MAC address 01-80-C2-00-00-01.
Add TCAM parser entry to track and drop pause frames by destination MAC.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Link: https://lore.kernel.org/r/1608229817-21951-1-git-send-email-stefanc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c |   33 +++++++++++++++++++++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h |    2 -
 2 files changed, 34 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -405,6 +405,38 @@ static int mvpp2_prs_tcam_first_free(str
 	return -EINVAL;
 }
 
+/* Drop flow control pause frames */
+static void mvpp2_prs_drop_fc(struct mvpp2 *priv)
+{
+	unsigned char da[ETH_ALEN] = { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x01 };
+	struct mvpp2_prs_entry pe;
+	unsigned int len;
+
+	memset(&pe, 0, sizeof(pe));
+
+	/* For all ports - drop flow control frames */
+	pe.index = MVPP2_PE_FC_DROP;
+	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_MAC);
+
+	/* Set match on DA */
+	len = ETH_ALEN;
+	while (len--)
+		mvpp2_prs_tcam_data_byte_set(&pe, len, da[len], 0xff);
+
+	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_DROP_MASK,
+				 MVPP2_PRS_RI_DROP_MASK);
+
+	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
+	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
+
+	/* Mask all ports */
+	mvpp2_prs_tcam_port_map_set(&pe, MVPP2_PRS_PORT_MASK);
+
+	/* Update shadow table and hw entry */
+	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_MAC);
+	mvpp2_prs_hw_write(priv, &pe);
+}
+
 /* Enable/disable dropping all mac da's */
 static void mvpp2_prs_mac_drop_all_set(struct mvpp2 *priv, int port, bool add)
 {
@@ -1162,6 +1194,7 @@ static void mvpp2_prs_mac_init(struct mv
 	mvpp2_prs_hw_write(priv, &pe);
 
 	/* Create dummy entries for drop all and promiscuous modes */
+	mvpp2_prs_drop_fc(priv);
 	mvpp2_prs_mac_drop_all_set(priv, 0, false);
 	mvpp2_prs_mac_promisc_set(priv, 0, MVPP2_PRS_L2_UNI_CAST, false);
 	mvpp2_prs_mac_promisc_set(priv, 0, MVPP2_PRS_L2_MULTI_CAST, false);
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
@@ -129,7 +129,7 @@
 #define MVPP2_PE_VID_EDSA_FLTR_DEFAULT	(MVPP2_PRS_TCAM_SRAM_SIZE - 7)
 #define MVPP2_PE_VLAN_DBL		(MVPP2_PRS_TCAM_SRAM_SIZE - 6)
 #define MVPP2_PE_VLAN_NONE		(MVPP2_PRS_TCAM_SRAM_SIZE - 5)
-/* reserved */
+#define MVPP2_PE_FC_DROP		(MVPP2_PRS_TCAM_SRAM_SIZE - 4)
 #define MVPP2_PE_MAC_MC_PROMISCUOUS	(MVPP2_PRS_TCAM_SRAM_SIZE - 3)
 #define MVPP2_PE_MAC_UC_PROMISCUOUS	(MVPP2_PRS_TCAM_SRAM_SIZE - 2)
 #define MVPP2_PE_MAC_NON_PROMISCUOUS	(MVPP2_PRS_TCAM_SRAM_SIZE - 1)


