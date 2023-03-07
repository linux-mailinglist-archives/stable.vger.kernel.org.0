Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825AF6AE923
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCGRVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjCGRVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:21:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479D79AA36
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:16:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8CD0B81929
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AD6C433EF;
        Tue,  7 Mar 2023 17:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209377;
        bh=YJvzSjrF4kDl10elFRx9/GYSXjb1b9aiHDAE4N9u23Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PC5UkAuRzeeyi7l2eDII1dXOlVjEpviS4YzF8aiU7fJedoH9GBuJ7R/acpqa1ke+D
         9eORA6xAcr1laip6cMpNDRhY0mA3AYBOfXvOOCS2/982/g2ga9nmmh09BJ4y4iyJBw
         YzHbppAiKuBYdA02RNHZSHKTyGD9yxP87imr2ZDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0200/1001] wifi: rtw89: fix potential leak in rtw89_append_probe_req_ie()
Date:   Tue,  7 Mar 2023 17:49:32 +0100
Message-Id: <20230307170030.589762382@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 4a0e218cc9c42d1903ade8b5a371dcf48cf918c5 ]

Do `kfree_skb(new)` before `goto out` to prevent potential leak.

Fixes: 895907779752 ("rtw89: 8852a: add ieee80211_ops::hw_scan")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230103141054.17372-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index de1f23779fc62..3b7af8faca505 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2665,8 +2665,10 @@ static int rtw89_append_probe_req_ie(struct rtw89_dev *rtwdev,
 
 		list_add_tail(&info->list, &scan_info->pkt_list[band]);
 		ret = rtw89_fw_h2c_add_pkt_offload(rtwdev, &info->id, new);
-		if (ret)
+		if (ret) {
+			kfree_skb(new);
 			goto out;
+		}
 
 		kfree_skb(new);
 	}
-- 
2.39.2



