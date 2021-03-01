Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2088D328CE5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240792AbhCATBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240791AbhCASx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:53:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D16A764FBB;
        Mon,  1 Mar 2021 17:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620244;
        bh=iMH4t2kCJ6eeGc1rC6GCEGke9jt0PK3W41XzbwufATU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QkE5n3UOi7sG/Dcve9I8GiwUXyJrNvwlWLpZYpDAx4Sb2JQj9S4RCswU5xJUyOOZ
         FMa6P4XkLWCfdIxc2IKo2qvdiir0fS+7eR0g7TT6T7weRPnM3tUZjYfel6tpIttp3d
         5w1euvoP9dopJFHl1gRuI5c/TjAw5tK9gb3zvf9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 083/775] staging: wfx: fix possible panic with re-queued frames
Date:   Mon,  1 Mar 2021 17:04:11 +0100
Message-Id: <20210301161205.786784499@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 26df933d9b83ea668304dc4ec641d52ea1fc4091 ]

When the firmware rejects a frame (because station become asleep or
disconnected), the frame is re-queued in mac80211. However, the
re-queued frame was 8 bytes longer than the original one (the size of
the ICV for the encryption). So, when mac80211 try to send this frame
again, it is a little bigger than expected.
If the frame is re-queued secveral time it end with a skb_over_panic
because the skb buffer is not large enough.

Note it only happens when device acts as an AP and encryption is
enabled.

This patch more or less reverts the commit 049fde130419 ("staging: wfx:
drop useless field from struct wfx_tx_priv").

Fixes: 049fde130419 ("staging: wfx: drop useless field from struct wfx_tx_priv")
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20210208135254.399964-1-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/data_tx.c | 10 +++++++++-
 drivers/staging/wfx/data_tx.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_tx.c
index 36b36ef39d053..77fb104efdec1 100644
--- a/drivers/staging/wfx/data_tx.c
+++ b/drivers/staging/wfx/data_tx.c
@@ -331,6 +331,7 @@ static int wfx_tx_inner(struct wfx_vif *wvif, struct ieee80211_sta *sta,
 {
 	struct hif_msg *hif_msg;
 	struct hif_req_tx *req;
+	struct wfx_tx_priv *tx_priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -344,11 +345,14 @@ static int wfx_tx_inner(struct wfx_vif *wvif, struct ieee80211_sta *sta,
 
 	// From now tx_info->control is unusable
 	memset(tx_info->rate_driver_data, 0, sizeof(struct wfx_tx_priv));
+	// Fill tx_priv
+	tx_priv = (struct wfx_tx_priv *)tx_info->rate_driver_data;
+	tx_priv->icv_size = wfx_tx_get_icv_len(hw_key);
 
 	// Fill hif_msg
 	WARN(skb_headroom(skb) < wmsg_len, "not enough space in skb");
 	WARN(offset & 1, "attempt to transmit an unaligned frame");
-	skb_put(skb, wfx_tx_get_icv_len(hw_key));
+	skb_put(skb, tx_priv->icv_size);
 	skb_push(skb, wmsg_len);
 	memset(skb->data, 0, wmsg_len);
 	hif_msg = (struct hif_msg *)skb->data;
@@ -484,6 +488,7 @@ static void wfx_tx_fill_rates(struct wfx_dev *wdev,
 
 void wfx_tx_confirm_cb(struct wfx_dev *wdev, const struct hif_cnf_tx *arg)
 {
+	const struct wfx_tx_priv *tx_priv;
 	struct ieee80211_tx_info *tx_info;
 	struct wfx_vif *wvif;
 	struct sk_buff *skb;
@@ -495,6 +500,7 @@ void wfx_tx_confirm_cb(struct wfx_dev *wdev, const struct hif_cnf_tx *arg)
 		return;
 	}
 	tx_info = IEEE80211_SKB_CB(skb);
+	tx_priv = wfx_skb_tx_priv(skb);
 	wvif = wdev_to_wvif(wdev, ((struct hif_msg *)skb->data)->interface);
 	WARN_ON(!wvif);
 	if (!wvif)
@@ -503,6 +509,8 @@ void wfx_tx_confirm_cb(struct wfx_dev *wdev, const struct hif_cnf_tx *arg)
 	// Note that wfx_pending_get_pkt_us_delay() get data from tx_info
 	_trace_tx_stats(arg, skb, wfx_pending_get_pkt_us_delay(wdev, skb));
 	wfx_tx_fill_rates(wdev, tx_info, arg);
+	skb_trim(skb, skb->len - tx_priv->icv_size);
+
 	// From now, you can touch to tx_info->status, but do not touch to
 	// tx_priv anymore
 	// FIXME: use ieee80211_tx_info_clear_status()
diff --git a/drivers/staging/wfx/data_tx.h b/drivers/staging/wfx/data_tx.h
index 46c9fff7a870e..401363d6b563a 100644
--- a/drivers/staging/wfx/data_tx.h
+++ b/drivers/staging/wfx/data_tx.h
@@ -35,6 +35,7 @@ struct tx_policy_cache {
 
 struct wfx_tx_priv {
 	ktime_t xmit_timestamp;
+	unsigned char icv_size;
 };
 
 void wfx_tx_policy_init(struct wfx_vif *wvif);
-- 
2.27.0



