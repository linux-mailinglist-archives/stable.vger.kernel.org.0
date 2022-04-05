Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166444F3497
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiDEJbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbiDEIQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AAFB62;
        Tue,  5 Apr 2022 01:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25BF561748;
        Tue,  5 Apr 2022 08:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D24C385A0;
        Tue,  5 Apr 2022 08:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145808;
        bh=DIdp1vSjSwVJv7qS7zn+yQYfahWFNcAaLdLqOMQ+MGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIZi5CI2mfsa8v6uZZIP6qwsOM7NX/qBlB2bK15EUBRUaOcsIdkQINQZ+Awyg7E/Y
         J3BJrmnzijPZltgrid/kJ1PlHyNhigtGHO8UaAP5KbQf3uFhKJJVW7sBbh36+y/Uc6
         uOU1jnLeAB9Eje3jz4U+VM8aJdv3CmUioM5Dra6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0536/1126] rtw88: fix use after free in rtw_hw_scan_update_probe_req()
Date:   Tue,  5 Apr 2022 09:21:23 +0200
Message-Id: <20220405070423.364503407@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a954f29aea5d2cf58feedf83235edf3367229a37 ]

This code needs to use skb_queue_walk_safe() instead of skb_queue_walk()
because it frees the list iterator.

Fixes: d95984b5580d ("rtw88: fix memory overrun and memory leak during hw_scan")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220203082532.GA25151@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index ce9535cce723..4c8e5ea5d069 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1853,7 +1853,7 @@ static int _rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev, u8 num_probes,
 	rtwdev->scan_info.probe_pg_size = page_offset;
 out:
 	kfree(buf);
-	skb_queue_walk(probe_req_list, skb)
+	skb_queue_walk_safe(probe_req_list, skb, tmp)
 		kfree_skb(skb);
 
 	return ret;
@@ -1864,7 +1864,7 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
 {
 	struct cfg80211_scan_request *req = rtwvif->scan_req;
 	struct sk_buff_head list;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *tmp;
 	u8 num = req->n_ssids, i, bands = 0;
 	int ret;
 
@@ -1889,7 +1889,7 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
 	return _rtw_hw_scan_update_probe_req(rtwdev, num * bands, &list);
 
 out:
-	skb_queue_walk(&list, skb)
+	skb_queue_walk_safe(&list, skb, tmp)
 		kfree_skb(skb);
 
 	return ret;
-- 
2.34.1



