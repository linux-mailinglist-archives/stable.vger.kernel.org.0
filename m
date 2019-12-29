Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB4A12C839
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732253AbfL2RwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732247AbfL2RwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43DA206A4;
        Sun, 29 Dec 2019 17:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641940;
        bh=tIEprq/X8LCOfj6Dzv/fgrd/+pnK3pCK2ScBJt+MR4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydCx1ugm/dOYkf1nGI/LkXS7v1/u+MwTXlNZSwKLf/wmoqbG4OQwuXVb/QhhpxHnJ
         ht9EqLmX/4asXTbxLp5jDqwrJDeA5lMSWNOqmeK1+TtluLpGkTVfWOfxHnSGjV+zbg
         9H9/NhhvA4pESmLdFmUrut2GUSPTFK+25RiXVLsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Bao Hou <houbao@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 273/434] ath10k: fix get invalid tx rate for Mesh metric
Date:   Sun, 29 Dec 2019 18:25:26 +0100
Message-Id: <20191229172720.074538410@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 05a11003a56507023f18d3249a4d4d119c0a3e9c ]

ath10k does not provide transmit rate info per MSDU
in tx completion, mark that as -1 so mac80211
will ignore the rates. This fixes mac80211 update Mesh
link metric with invalid transmit rate info.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00035

Signed-off-by: Hou Bao Hou <houbao@codeaurora.org>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 4102df016931..39abf8b12903 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -95,6 +95,8 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	info = IEEE80211_SKB_CB(msdu);
 	memset(&info->status, 0, sizeof(info->status));
+	info->status.rates[0].idx = -1;
+
 	trace_ath10k_txrx_tx_unref(ar, tx_done->msdu_id);
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
-- 
2.20.1



