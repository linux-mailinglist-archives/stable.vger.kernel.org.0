Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3B74F2797
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiDEIHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiDEICk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445CF55772;
        Tue,  5 Apr 2022 01:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DA286177F;
        Tue,  5 Apr 2022 08:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971A9C340EE;
        Tue,  5 Apr 2022 08:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145640;
        bh=ruRyJucv70xZ0kihqI7ZSSwyvEYZ2kk+P4V1D6DsGY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEnUcyO+wfXKnNjp2O0Hie2az61yemGSbj8kbkompdZ8SCx8WXBKt5XYckBhVdV1x
         gyx9mRIuQYpOtKgxvYNdrdrFzN0R/+3iZPiUGbAWFhBxyDH0KAR30DrYG/23VyhvIN
         tj8WRSF6tdwQV86kqHHzDAQ4zYF/PewggU0d3kyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0477/1126] rtw88: fix memory overrun and memory leak during hw_scan
Date:   Tue,  5 Apr 2022 09:20:24 +0200
Message-Id: <20220405070421.628095471@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit d95984b5580dcb8b1c0036577c52b609990a1dab ]

Previously we allocated less memory than actual required, overwrite
to the buffer causes the mm module to complaint and raise access
violation faults. Along with potential memory leaks when returned
early. Fix these by passing the correct size and proper deinit flow.

Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220121070813.9656-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 34 +++++++++++++++++--------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index a631042753ea..ce9535cce723 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1784,9 +1784,9 @@ void rtw_fw_scan_notify(struct rtw_dev *rtwdev, bool start)
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
 
-static void rtw_append_probe_req_ie(struct rtw_dev *rtwdev, struct sk_buff *skb,
-				    struct sk_buff_head *list,
-				    struct rtw_vif *rtwvif)
+static int rtw_append_probe_req_ie(struct rtw_dev *rtwdev, struct sk_buff *skb,
+				   struct sk_buff_head *list, u8 *bands,
+				   struct rtw_vif *rtwvif)
 {
 	struct ieee80211_scan_ies *ies = rtwvif->scan_ies;
 	struct rtw_chip_info *chip = rtwdev->chip;
@@ -1797,19 +1797,24 @@ static void rtw_append_probe_req_ie(struct rtw_dev *rtwdev, struct sk_buff *skb,
 		if (!(BIT(idx) & chip->band))
 			continue;
 		new = skb_copy(skb, GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
 		skb_put_data(new, ies->ies[idx], ies->len[idx]);
 		skb_put_data(new, ies->common_ies, ies->common_ie_len);
 		skb_queue_tail(list, new);
+		(*bands)++;
 	}
+
+	return 0;
 }
 
-static int _rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev, u8 num_ssids,
+static int _rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev, u8 num_probes,
 					 struct sk_buff_head *probe_req_list)
 {
 	struct rtw_chip_info *chip = rtwdev->chip;
 	struct sk_buff *skb, *tmp;
 	u8 page_offset = 1, *buf, page_size = chip->page_size;
-	u8 pages = page_offset + num_ssids * RTW_PROBE_PG_CNT;
+	u8 pages = page_offset + num_probes * RTW_PROBE_PG_CNT;
 	u16 pg_addr = rtwdev->fifo.rsvd_h2c_info_addr, loc;
 	u16 buf_offset = page_size * page_offset;
 	u8 tx_desc_sz = chip->tx_pkt_desc_sz;
@@ -1848,6 +1853,8 @@ static int _rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev, u8 num_ssids,
 	rtwdev->scan_info.probe_pg_size = page_offset;
 out:
 	kfree(buf);
+	skb_queue_walk(probe_req_list, skb)
+		kfree_skb(skb);
 
 	return ret;
 }
@@ -1858,7 +1865,8 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
 	struct cfg80211_scan_request *req = rtwvif->scan_req;
 	struct sk_buff_head list;
 	struct sk_buff *skb;
-	u8 num = req->n_ssids, i;
+	u8 num = req->n_ssids, i, bands = 0;
+	int ret;
 
 	skb_queue_head_init(&list);
 	for (i = 0; i < num; i++) {
@@ -1866,19 +1874,25 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
 					     req->ssids[i].ssid,
 					     req->ssids[i].ssid_len,
 					     req->ie_len);
-		if (!skb)
+		if (!skb) {
+			ret = -ENOMEM;
 			goto out;
-		rtw_append_probe_req_ie(rtwdev, skb, &list, rtwvif);
+		}
+		ret = rtw_append_probe_req_ie(rtwdev, skb, &list, &bands,
+					      rtwvif);
+		if (ret)
+			goto out;
+
 		kfree_skb(skb);
 	}
 
-	return _rtw_hw_scan_update_probe_req(rtwdev, num, &list);
+	return _rtw_hw_scan_update_probe_req(rtwdev, num * bands, &list);
 
 out:
 	skb_queue_walk(&list, skb)
 		kfree_skb(skb);
 
-	return -ENOMEM;
+	return ret;
 }
 
 static int rtw_add_chan_info(struct rtw_dev *rtwdev, struct rtw_chan_info *info,
-- 
2.34.1



