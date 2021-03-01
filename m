Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CFA328647
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbhCARHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:07:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236704AbhCARDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:03:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 179C564EC6;
        Mon,  1 Mar 2021 16:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616715;
        bh=OM5otCY188Tdzt1LZzQFuh8666Jfaz3kboPyyro1mVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8HXnER4bF/cD2vwlb5t4sq5+c+Pw0CdgZAaIFJXczfQg4pctOOBqr/vhMQ4hamfy
         csE41F9HtRMmn1v4vCh+Pbx6qCj/f2K6/paucDlLOGvNgThrc5JyMFOK+55dHjHQTu
         L4gbZGVD2IuNInu76QoXCMgBgKqF4fggfjFLKy+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/247] net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP
Date:   Mon,  1 Mar 2021 17:11:31 +0100
Message-Id: <20210301161035.161862212@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 9eab3fdb419916f66a72d1572f68d82cd9b3f963 ]

Frequent link up/down events can happen when a Bel Fuse SFP part is
connected to the amd-xgbe device. Try to avoid the frequent link
issues by resetting the PHY as documented in Bel Fuse SFP datasheets.

Fixes: e722ec82374b ("amd-xgbe: Update the BelFuse quirk to support SGMII")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 1a617d6d2bf86..54753c8a6a9d7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -912,6 +912,9 @@ static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
 	if ((phy_id & 0xfffffff0) != 0x03625d10)
 		return false;
 
+	/* Reset PHY - wait for self-clearing reset bit to clear */
+	genphy_soft_reset(phy_data->phydev);
+
 	/* Disable RGMII mode */
 	phy_write(phy_data->phydev, 0x18, 0x7007);
 	reg = phy_read(phy_data->phydev, 0x18);
-- 
2.27.0



