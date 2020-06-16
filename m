Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C941FBA03
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732442AbgFPQID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731789AbgFPPq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDCA620776;
        Tue, 16 Jun 2020 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322386;
        bh=ZBnV5sxUwynEG5lSAIADmzfkPNAJRl5QKE8Qtn7F+yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3DUOK7rGxbLDWGs6uiiMD+jPjtEGj05Dx++BE/awa961sjllfQ2g/gjtnPbmcoJk
         +BbE8s9neDPrcLdMCV8hTqlcn2CYbBo371dpe9iWPqPk5H1qBOOQafA9T59tnrUR48
         uFy2FOSCEAQHRi/5PoIZHiVvAo0FgoHpBJpN4hm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 111/163] net: ethernet: ti: ale: fix allmulti for nu type ale
Date:   Tue, 16 Jun 2020 17:34:45 +0200
Message-Id: <20200616153112.122979967@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit bc139119a1708ae3db1ebb379630f286e28d06e8 ]

On AM65xx MCU CPSW2G NUSS and 66AK2E/L NUSS allmulti setting does not allow
unregistered mcast packets to pass.

This happens, because ALE VLAN entries on these SoCs do not contain port
masks for reg/unreg mcast packets, but instead store indexes of
ALE_VLAN_MASK_MUXx_REG registers which intended for store port masks for
reg/unreg mcast packets.
This path was missed by commit 9d1f6447274f ("net: ethernet: ti: ale: fix
seeing unreg mcast packets with promisc and allmulti disabled").

Hence, fix it by taking into account ALE type in cpsw_ale_set_allmulti().

Fixes: 9d1f6447274f ("net: ethernet: ti: ale: fix seeing unreg mcast packets with promisc and allmulti disabled")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw_ale.c |   49 ++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -604,10 +604,44 @@ void cpsw_ale_set_unreg_mcast(struct cps
 	}
 }
 
+static void cpsw_ale_vlan_set_unreg_mcast(struct cpsw_ale *ale, u32 *ale_entry,
+					  int allmulti)
+{
+	int unreg_mcast;
+
+	unreg_mcast =
+		cpsw_ale_get_vlan_unreg_mcast(ale_entry,
+					      ale->vlan_field_bits);
+	if (allmulti)
+		unreg_mcast |= ALE_PORT_HOST;
+	else
+		unreg_mcast &= ~ALE_PORT_HOST;
+	cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
+				      ale->vlan_field_bits);
+}
+
+static void
+cpsw_ale_vlan_set_unreg_mcast_idx(struct cpsw_ale *ale, u32 *ale_entry,
+				  int allmulti)
+{
+	int unreg_mcast;
+	int idx;
+
+	idx = cpsw_ale_get_vlan_unreg_mcast_idx(ale_entry);
+
+	unreg_mcast = readl(ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
+
+	if (allmulti)
+		unreg_mcast |= ALE_PORT_HOST;
+	else
+		unreg_mcast &= ~ALE_PORT_HOST;
+
+	writel(unreg_mcast, ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
+}
+
 void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS];
-	int unreg_mcast = 0;
 	int type, idx;
 
 	for (idx = 0; idx < ale->params.ale_entries; idx++) {
@@ -624,15 +658,12 @@ void cpsw_ale_set_allmulti(struct cpsw_a
 		if (port != -1 && !(vlan_members & BIT(port)))
 			continue;
 
-		unreg_mcast =
-			cpsw_ale_get_vlan_unreg_mcast(ale_entry,
-						      ale->vlan_field_bits);
-		if (allmulti)
-			unreg_mcast |= ALE_PORT_HOST;
+		if (!ale->params.nu_switch_ale)
+			cpsw_ale_vlan_set_unreg_mcast(ale, ale_entry, allmulti);
 		else
-			unreg_mcast &= ~ALE_PORT_HOST;
-		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
-					      ale->vlan_field_bits);
+			cpsw_ale_vlan_set_unreg_mcast_idx(ale, ale_entry,
+							  allmulti);
+
 		cpsw_ale_write(ale, idx, ale_entry);
 	}
 }


