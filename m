Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88293382E55
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbhEQOG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237767AbhEQOGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB836128A;
        Mon, 17 May 2021 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260284;
        bh=GC0JSQP6TWY1b0lfwONIKL+869Qk61wRxyZRS4vVIz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hYXjB9ikDNtdNbPvKrQv3gAQs+ysQNFO2xk3Ras9D4iYWPfcFMJn0POQz/aN1QQU
         4iYHeAXHFJ6ZpNrJyTJBBEJb7oAywEFXSb1SucSjJ/KnEEa0Xh59X4NQKQAlp/+gIg
         tjcwS7rkknHghQaMbPZUrLeRNNzw2kGLiAVgZLiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 012/363] ath11k: fix thermal temperature read
Date:   Mon, 17 May 2021 15:57:58 +0200
Message-Id: <20210517140302.976041347@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

[ Upstream commit e3de5bb7ac1a4cb262f8768924fd3ef6182b10bb ]

Fix dangling pointer in thermal temperature event which causes
incorrect temperature read.

Tested-on: IPQ8074 AHB WLAN.HK.2.4.0.1-00041-QCAHKSWPL_SILICONZ-1

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210218182708.8844-1-pradeepc@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 53 +++++++++++----------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index cccfd3bd4d27..ca5cda890d58 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5417,31 +5417,6 @@ int ath11k_wmi_pull_fw_stats(struct ath11k_base *ab, struct sk_buff *skb,
 	return 0;
 }
 
-static int
-ath11k_pull_pdev_temp_ev(struct ath11k_base *ab, u8 *evt_buf,
-			 u32 len, const struct wmi_pdev_temperature_event *ev)
-{
-	const void **tb;
-	int ret;
-
-	tb = ath11k_wmi_tlv_parse_alloc(ab, evt_buf, len, GFP_ATOMIC);
-	if (IS_ERR(tb)) {
-		ret = PTR_ERR(tb);
-		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
-		return ret;
-	}
-
-	ev = tb[WMI_TAG_PDEV_TEMPERATURE_EVENT];
-	if (!ev) {
-		ath11k_warn(ab, "failed to fetch pdev temp ev");
-		kfree(tb);
-		return -EPROTO;
-	}
-
-	kfree(tb);
-	return 0;
-}
-
 size_t ath11k_wmi_fw_stats_num_vdevs(struct list_head *head)
 {
 	struct ath11k_fw_stats_vdev *i;
@@ -6849,23 +6824,37 @@ ath11k_wmi_pdev_temperature_event(struct ath11k_base *ab,
 				  struct sk_buff *skb)
 {
 	struct ath11k *ar;
-	struct wmi_pdev_temperature_event ev = {0};
+	const void **tb;
+	const struct wmi_pdev_temperature_event *ev;
+	int ret;
+
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
+		return;
+	}
 
-	if (ath11k_pull_pdev_temp_ev(ab, skb->data, skb->len, &ev) != 0) {
-		ath11k_warn(ab, "failed to extract pdev temperature event");
+	ev = tb[WMI_TAG_PDEV_TEMPERATURE_EVENT];
+	if (!ev) {
+		ath11k_warn(ab, "failed to fetch pdev temp ev");
+		kfree(tb);
 		return;
 	}
 
 	ath11k_dbg(ab, ATH11K_DBG_WMI,
-		   "pdev temperature ev temp %d pdev_id %d\n", ev.temp, ev.pdev_id);
+		   "pdev temperature ev temp %d pdev_id %d\n", ev->temp, ev->pdev_id);
 
-	ar = ath11k_mac_get_ar_by_pdev_id(ab, ev.pdev_id);
+	ar = ath11k_mac_get_ar_by_pdev_id(ab, ev->pdev_id);
 	if (!ar) {
-		ath11k_warn(ab, "invalid pdev id in pdev temperature ev %d", ev.pdev_id);
+		ath11k_warn(ab, "invalid pdev id in pdev temperature ev %d", ev->pdev_id);
+		kfree(tb);
 		return;
 	}
 
-	ath11k_thermal_event_temperature(ar, ev.temp);
+	ath11k_thermal_event_temperature(ar, ev->temp);
+
+	kfree(tb);
 }
 
 static void ath11k_fils_discovery_event(struct ath11k_base *ab,
-- 
2.30.2



