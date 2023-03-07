Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B986AF354
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjCGTDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjCGTDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:03:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFC7C5AE3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:49:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06BEA61535
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C78C433D2;
        Tue,  7 Mar 2023 18:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214950;
        bh=nADxeuLPCDtJhbJRp33DCoMaHcxQpG3WqP6vsyX6Wqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXrGWdT1Or68zGCv5z8LuqGMjUrpgXsIWtFxZ52IF6DYT1lhI8GhTsqIstkneW4yC
         KNHNQu6Xrn8C+4Wop4123JFQln5Q8jvTRY0HNRJ1sLrBiGJOUb83kRe/HE2D+m5qwU
         b2+qMbOj3xuECR9kIdRL8sqvCi0T8lUUWEu9Srmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Johnson <quic_jjohnson@quicinc.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/567] ath9k: htc: clean up statistics macros
Date:   Tue,  7 Mar 2023 17:57:19 +0100
Message-Id: <20230307165910.334346259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit d7fc76039b74ad37b7056d5607b05d7cb31a5404 ]

I've changed *STAT_* macros a bit in previous patch and I seems like
they become really unreadable. Align these macros definitions to make
code cleaner and fix folllowing checkpatch warning

ERROR: Macros with complex values should be enclosed in parentheses

Also, statistics macros now accept an hif_dev as argument, since
macros that depend on having a local variable with a magic name
don't abide by the coding style.

No functional change

Suggested-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/ebb2306d06a496cd1b032155ae52fdc5fa8cc2c5.1655145743.git.paskripkin@gmail.com
Stable-dep-of: 0af54343a762 ("wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      | 26 +++++++--------
 drivers/net/wireless/ath/ath9k/htc.h          | 32 +++++++++++--------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 +++---
 3 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f54380fb6c9e5..1a2e0c7eeb023 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -244,11 +244,11 @@ static inline void ath9k_skb_queue_complete(struct hif_device_usb *hif_dev,
 		ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
 					  skb, txok);
 		if (txok) {
-			TX_STAT_INC(skb_success);
-			TX_STAT_ADD(skb_success_bytes, ln);
+			TX_STAT_INC(hif_dev, skb_success);
+			TX_STAT_ADD(hif_dev, skb_success_bytes, ln);
 		}
 		else
-			TX_STAT_INC(skb_failed);
+			TX_STAT_INC(hif_dev, skb_failed);
 	}
 }
 
@@ -302,7 +302,7 @@ static void hif_usb_tx_cb(struct urb *urb)
 	hif_dev->tx.tx_buf_cnt++;
 	if (!(hif_dev->tx.flags & HIF_USB_TX_STOP))
 		__hif_usb_tx(hif_dev); /* Check for pending SKBs */
-	TX_STAT_INC(buf_completed);
+	TX_STAT_INC(hif_dev, buf_completed);
 	spin_unlock(&hif_dev->tx.tx_lock);
 }
 
@@ -353,7 +353,7 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 			tx_buf->len += tx_buf->offset;
 
 		__skb_queue_tail(&tx_buf->skb_queue, nskb);
-		TX_STAT_INC(skb_queued);
+		TX_STAT_INC(hif_dev, skb_queued);
 	}
 
 	usb_fill_bulk_urb(tx_buf->urb, hif_dev->udev,
@@ -369,7 +369,7 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
 	} else {
-		TX_STAT_INC(buf_queued);
+		TX_STAT_INC(hif_dev, buf_queued);
 	}
 
 	return ret;
@@ -514,7 +514,7 @@ static void hif_usb_sta_drain(void *hif_handle, u8 idx)
 			ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
 						  skb, false);
 			hif_dev->tx.tx_skb_cnt--;
-			TX_STAT_INC(skb_failed);
+			TX_STAT_INC(hif_dev, skb_failed);
 		}
 	}
 
@@ -585,14 +585,14 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 		pkt_tag = get_unaligned_le16(ptr + index + 2);
 
 		if (pkt_tag != ATH_USB_RX_STREAM_MODE_TAG) {
-			RX_STAT_INC(skb_dropped);
+			RX_STAT_INC(hif_dev, skb_dropped);
 			return;
 		}
 
 		if (pkt_len > 2 * MAX_RX_BUF_SIZE) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: invalid pkt_len (%x)\n", pkt_len);
-			RX_STAT_INC(skb_dropped);
+			RX_STAT_INC(hif_dev, skb_dropped);
 			return;
 		}
 
@@ -618,7 +618,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				goto err;
 			}
 			skb_reserve(nskb, 32);
-			RX_STAT_INC(skb_allocated);
+			RX_STAT_INC(hif_dev, skb_allocated);
 
 			memcpy(nskb->data, &(skb->data[chk_idx+4]),
 			       hif_dev->rx_transfer_len);
@@ -639,7 +639,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				goto err;
 			}
 			skb_reserve(nskb, 32);
-			RX_STAT_INC(skb_allocated);
+			RX_STAT_INC(hif_dev, skb_allocated);
 
 			memcpy(nskb->data, &(skb->data[chk_idx+4]), pkt_len);
 			skb_put(nskb, pkt_len);
@@ -649,10 +649,10 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 err:
 	for (i = 0; i < pool_index; i++) {
-		RX_STAT_ADD(skb_completed_bytes, skb_pool[i]->len);
+		RX_STAT_ADD(hif_dev, skb_completed_bytes, skb_pool[i]->len);
 		ath9k_htc_rx_msg(hif_dev->htc_handle, skb_pool[i],
 				 skb_pool[i]->len, USB_WLAN_RX_PIPE);
-		RX_STAT_INC(skb_completed);
+		RX_STAT_INC(hif_dev, skb_completed);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index e3d546ef71ddc..30f0765fb9fd8 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -327,14 +327,18 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-#define __STAT_SAFE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
-#define TX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
-#define TX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
-#define RX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
-#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
-
-#define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
+#define __STAT_SAFE(hif_dev, expr)	((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
+#define CAB_STAT_INC(priv)		((priv)->debug.tx_stats.cab_queued++)
+#define TX_QSTAT_INC(priv, q)		((priv)->debug.tx_stats.queue_stats[q]++)
+
+#define TX_STAT_INC(hif_dev, c) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(hif_dev, c, a) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c += a)
+#define RX_STAT_INC(hif_dev, c) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(hif_dev, c, a) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.skbrx_stats.c += a)
 
 void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 			   struct ath_rx_status *rs);
@@ -374,13 +378,13 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 			    struct ethtool_stats *stats, u64 *data);
 #else
 
-#define TX_STAT_INC(c) do { } while (0)
-#define TX_STAT_ADD(c, a) do { } while (0)
-#define RX_STAT_INC(c) do { } while (0)
-#define RX_STAT_ADD(c, a) do { } while (0)
-#define CAB_STAT_INC   do { } while (0)
+#define TX_STAT_INC(hif_dev, c)
+#define TX_STAT_ADD(hif_dev, c, a)
+#define RX_STAT_INC(hif_dev, c)
+#define RX_STAT_ADD(hif_dev, c, a)
 
-#define TX_QSTAT_INC(c) do { } while (0)
+#define CAB_STAT_INC(priv)
+#define TX_QSTAT_INC(priv, c)
 
 static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 					 struct ath_rx_status *rs)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index a23eaca0326d1..672789e3c55d0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -106,20 +106,20 @@ static inline enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
 
 	switch (qnum) {
 	case 0:
-		TX_QSTAT_INC(IEEE80211_AC_VO);
+		TX_QSTAT_INC(priv, IEEE80211_AC_VO);
 		epid = priv->data_vo_ep;
 		break;
 	case 1:
-		TX_QSTAT_INC(IEEE80211_AC_VI);
+		TX_QSTAT_INC(priv, IEEE80211_AC_VI);
 		epid = priv->data_vi_ep;
 		break;
 	case 2:
-		TX_QSTAT_INC(IEEE80211_AC_BE);
+		TX_QSTAT_INC(priv, IEEE80211_AC_BE);
 		epid = priv->data_be_ep;
 		break;
 	case 3:
 	default:
-		TX_QSTAT_INC(IEEE80211_AC_BK);
+		TX_QSTAT_INC(priv, IEEE80211_AC_BK);
 		epid = priv->data_bk_ep;
 		break;
 	}
@@ -328,7 +328,7 @@ static void ath9k_htc_tx_data(struct ath9k_htc_priv *priv,
 	memcpy(tx_fhdr, (u8 *) &tx_hdr, sizeof(tx_hdr));
 
 	if (is_cab) {
-		CAB_STAT_INC;
+		CAB_STAT_INC(priv);
 		tx_ctl->epid = priv->cab_ep;
 		return;
 	}
-- 
2.39.2



