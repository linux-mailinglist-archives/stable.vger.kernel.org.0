Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FEB65EBE8
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbjAENEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbjAENDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:03:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133245833E
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:03:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A228C619FF
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B76C433F1;
        Thu,  5 Jan 2023 13:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923821;
        bh=cKxFVoRDndxq+75mI7m+XCgtCF96VQrQCnULyj/q0lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pq5FGNKp3Gb6SXrLHXwCnTM6L6YliCwBVPDx2sCb1nlnRavNADfWiKedRhd5O9KHs
         GK9k1DrmHXAHF5LLFBOF5ZylyMLcY9Avx/tQqNhHhd1oqo+Nb3GHv1QuWaVDJdFZwn
         k+XH6spg6eo4o7+FEmMHexQ0SMnzsh5DpXhzOIAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 144/251] staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()
Date:   Thu,  5 Jan 2023 13:54:41 +0100
Message-Id: <20230105125341.431045015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit d30f4436f364b4ad915ca2c09be07cd0f93ceb44 ]

The skb is delivered to netif_rx() in rtllib_monitor_rx(), which may free it,
after calling this, dereferencing skb may trigger use-after-free.
Found by Smatch.

Fixes: 94a799425eee ("From: wlanfae <wlanfae@realtek.com> [PATCH 1/8] rtl8192e: Import new version of driver from realtek")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20221123081253.22296-1-yuehaibing@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192e/rtllib_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 247475aa522e..23c917342943 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1508,9 +1508,9 @@ static int rtllib_rx_Monitor(struct rtllib_device *ieee, struct sk_buff *skb,
 		hdrlen += 4;
 	}
 
-	rtllib_monitor_rx(ieee, skb, rx_stats, hdrlen);
 	ieee->stats.rx_packets++;
 	ieee->stats.rx_bytes += skb->len;
+	rtllib_monitor_rx(ieee, skb, rx_stats, hdrlen);
 
 	return 1;
 }
-- 
2.35.1



