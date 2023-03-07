Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B96AEB80
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjCGRpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjCGRo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:44:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF60A1012
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:40:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E59FCB818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CA1C433D2;
        Tue,  7 Mar 2023 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210832;
        bh=8GXMsI33074mvs1DqZXOwtkzqHwP4h5cKFOuCVr6Yig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwmvLOiXKBcHuiSH9mS2QpxZT+pQYkWv0zAEAYv3uMVqJxInJxIDq6CiTCOU135b8
         riGwDBQxueaUZ9ke/ydTbb016p+gZlAS5bRe1ISiz1BSDziGnuQQVnxOAvanjGAweV
         2Sh64pZ6tvSnWfyL9aOsKvWOf7tGCe3/oueJJFeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0669/1001] wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup
Date:   Tue,  7 Mar 2023 17:57:21 +0100
Message-Id: <20230307170050.640140461@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 1b88b47e898edef0e56e3a2f4e49f052a136153d ]

Free rx_head skb in mt76_dma_rx_cleanup routine in order to avoid
possible memory leak at module unload.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index dee4449de9082..d147dc698c9db 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -737,6 +737,7 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 		return;
 
 	spin_lock_bh(&q->lock);
+
 	do {
 		buf = mt76_dma_dequeue(dev, q, true, NULL, NULL, &more, NULL);
 		if (!buf)
@@ -744,6 +745,12 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 
 		skb_free_frag(buf);
 	} while (1);
+
+	if (q->rx_head) {
+		dev_kfree_skb(q->rx_head);
+		q->rx_head = NULL;
+	}
+
 	spin_unlock_bh(&q->lock);
 
 	if (!q->rx_page.va)
@@ -769,12 +776,6 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
 	mt76_dma_rx_cleanup(dev, q);
 	mt76_dma_sync_idx(dev, q);
 	mt76_dma_rx_fill(dev, q);
-
-	if (!q->rx_head)
-		return;
-
-	dev_kfree_skb(q->rx_head);
-	q->rx_head = NULL;
 }
 
 static void
-- 
2.39.2



