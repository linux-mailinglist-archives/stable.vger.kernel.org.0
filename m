Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAA64290A6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbhJKOK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57621 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242408AbhJKOI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A544610A4;
        Mon, 11 Oct 2021 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960897;
        bh=HhpJpmWrjCFG1UDrTsOVQChc5YErbrpiZFtouS3DQng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3SMeAAhZ1rQkBzuWJJdhqTMQslOoPpTrOZCYeJqvwV06u9zHSSg7REE4fFKjzDze
         3DtzZOyuP8L9ue25faqckCPqviFzTeqKCELn4K8UjcDFxau13DJ0ooGlwVCwiTyeto
         xKI9k8OlZe6kpgzZjMCK7Gt+jGMzD9GcLj5tbB7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 106/151] net: pcs: xpcs: fix incorrect steps on disable EEE
Date:   Mon, 11 Oct 2021 15:46:18 +0200
Message-Id: <20211011134521.243663376@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

[ Upstream commit 590df78bc7d1d0425196a8e11ce6676d7023fb26 ]

When Energy-Efficient Ethernet(EEE) is disable from the MAC side,
we need to clear the DW_VR_MII_EEE_TRN_LPI bit of DW_VR_MII_EEE_MCTRL1
register.

Fixes: 7617af3d1a5e ("net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet")
Cc: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 4a169545797b..d4ab03a92fb5 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -662,6 +662,10 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 {
 	int ret;
 
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL0);
+	if (ret < 0)
+		return ret;
+
 	if (enable) {
 	/* Enable EEE */
 		ret = DW_VR_MII_EEE_LTX_EN | DW_VR_MII_EEE_LRX_EN |
@@ -669,9 +673,6 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 		      DW_VR_MII_EEE_TX_EN_CTRL | DW_VR_MII_EEE_RX_EN_CTRL |
 		      mult_fact_100ns << DW_VR_MII_EEE_MULT_FACT_100NS_SHIFT;
 	} else {
-		ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL0);
-		if (ret < 0)
-			return ret;
 		ret &= ~(DW_VR_MII_EEE_LTX_EN | DW_VR_MII_EEE_LRX_EN |
 		       DW_VR_MII_EEE_TX_QUIET_EN | DW_VR_MII_EEE_RX_QUIET_EN |
 		       DW_VR_MII_EEE_TX_EN_CTRL | DW_VR_MII_EEE_RX_EN_CTRL |
@@ -686,7 +687,11 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 	if (ret < 0)
 		return ret;
 
-	ret |= DW_VR_MII_EEE_TRN_LPI;
+	if (enable)
+		ret |= DW_VR_MII_EEE_TRN_LPI;
+	else
+		ret &= ~DW_VR_MII_EEE_TRN_LPI;
+
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL1, ret);
 }
 EXPORT_SYMBOL_GPL(xpcs_config_eee);
-- 
2.33.0



