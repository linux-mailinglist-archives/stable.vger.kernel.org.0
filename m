Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9C658114
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiL1QYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbiL1QYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F58B165B4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9499B817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F08FC433F0;
        Wed, 28 Dec 2022 16:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244462;
        bh=3lwxasK5NkpFU4+l7wHqxiDULc6e1FGx/znr2yxZgU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI8WQ9C0hbc8TnkTVtIVQInh/FaDTmGUp0ku4zNBmiXz7CpyAUwCFE3P77Anweqtx
         RrPASc+mS2svATgBJP9L9TjQ9KfwsuYHZlYuNksmnRLg8MJaXKgjuVIRabsfyUPXd7
         1CAWwRWZIpcaTTfzCsGUJbYCtWlTo6rJsPeCwVfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0714/1073] staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()
Date:   Wed, 28 Dec 2022 15:38:22 +0100
Message-Id: <20221228144347.421807720@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index abe5c153f74e..b0ef9da43bc4 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1489,9 +1489,9 @@ static int rtllib_rx_Monitor(struct rtllib_device *ieee, struct sk_buff *skb,
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



