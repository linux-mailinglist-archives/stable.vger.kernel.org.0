Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC74106EBD
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfKVLBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730365AbfKVLBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:01:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C1D20706;
        Fri, 22 Nov 2019 11:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420463;
        bh=2KUh2tDx0koScgjBuyBrWUfhSOsfanBbT7qewGFoA70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yG/nVej9fuNzyhI/66KZ/mPYPLnax7TDhDGeqPYzfY8gmSstwMCudfoBTQAIXbeas
         F8RhmxGzb2fJ5AqdRuLfFVjTaLUWmsEGCJc70fozgRgWPkOtje1Pv1uDL+bj1L8Anf
         EI4vLYY21onNS6ZaArr6Dx//WE1v6vIM43upKzIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Igor mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/220] qtnfmac: request userspace to do OBSS scanning if FW can not
Date:   Fri, 22 Nov 2019 11:27:58 +0100
Message-Id: <20191122100920.879502762@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

[ Upstream commit 92246b126ebf66ab1fec9d631df78d7c675b66db ]

In case firmware reports that it can not do OBSS scanning for 40MHz
2.4GHz channels itself, tell userpsace to do that instead by setting
NL80211_FEATURE_NEED_OBSS_SCAN flag.

Signed-off-by: Igor mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 3 +++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 4aa332f4646b1..1519d986b74a4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1109,6 +1109,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR)
 		wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 
+	if (!(hw_info->hw_capab & QLINK_HW_CAPAB_OBSS_SCAN))
+		wiphy->features |= NL80211_FEATURE_NEED_OBSS_SCAN;
+
 #ifdef CONFIG_PM
 	if (macinfo->wowlan)
 		wiphy->wowlan = macinfo->wowlan;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 99d37e3efba63..c5ae4ea9a47a9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -71,6 +71,7 @@ struct qlink_msg_header {
  * @QLINK_HW_CAPAB_DFS_OFFLOAD: device implements DFS offload functionality
  * @QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR: device supports MAC Address
  *	Randomization in probe requests.
+ * @QLINK_HW_CAPAB_OBSS_SCAN: device can perform OBSS scanning.
  */
 enum qlink_hw_capab {
 	QLINK_HW_CAPAB_REG_UPDATE		= BIT(0),
@@ -78,6 +79,7 @@ enum qlink_hw_capab {
 	QLINK_HW_CAPAB_DFS_OFFLOAD		= BIT(2),
 	QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR	= BIT(3),
 	QLINK_HW_CAPAB_PWR_MGMT			= BIT(4),
+	QLINK_HW_CAPAB_OBSS_SCAN		= BIT(5),
 };
 
 enum qlink_iface_type {
-- 
2.20.1



