Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004924F2697
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiDEIEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiDEICg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D85657147;
        Tue,  5 Apr 2022 01:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4B12B81B7F;
        Tue,  5 Apr 2022 08:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17753C340EE;
        Tue,  5 Apr 2022 08:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145634;
        bh=d23euG9LU9OnWY5HhMRv7JtsTGt01ceHoyR4XIaImbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYxJ7pCTZcbZInPKBCn7XNmRM0Yup2N/+ks/0y5swPSQwKBA/2xCS2q2MsEaOBDXF
         RvUyq4wmd385B/21JbTHkye2lmn5XkLIG3n02hndLpxUPk3gRrx1DOdTjvfm/pD7vG
         J/Vo+gqm0WOG7jDAT99NnerfWBfm/D95OGHoSIqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0475/1126] rtw88: check for validity before using a pointer
Date:   Tue,  5 Apr 2022 09:20:22 +0200
Message-Id: <20220405070421.569270123@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit a12f809968dbf46ce2a6bc94463db8d431bb75fc ]

ieee80211_probereq_get() can return NULL. Pointer skb should be checked
for validty before use. If it is not valid, list of skbs needs to be
freed.

Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220121070813.9656-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 2f7c036f9022..b56dc43229d2 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1866,11 +1866,19 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
 					     req->ssids[i].ssid,
 					     req->ssids[i].ssid_len,
 					     req->ie_len);
+		if (!skb)
+			goto out;
 		rtw_append_probe_req_ie(rtwdev, skb, &list, rtwvif);
 		kfree_skb(skb);
 	}
 
 	return _rtw_hw_scan_update_probe_req(rtwdev, num, &list);
+
+out:
+	skb_queue_walk(&list, skb)
+		kfree_skb(skb);
+
+	return -ENOMEM;
 }
 
 static int rtw_add_chan_info(struct rtw_dev *rtwdev, struct rtw_chan_info *info,
-- 
2.34.1



