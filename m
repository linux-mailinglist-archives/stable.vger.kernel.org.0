Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3C06AF4D9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbjCGTUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbjCGTUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:20:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60039D00AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:04:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A9F9B819D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F29C433EF;
        Tue,  7 Mar 2023 19:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215843;
        bh=PyGC1cuoWSvAioDzXEqzM6DO4xbDDSPgQEBTXPCNAtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhKNFZafCaw5SwVstZxSdQL4UFNZzN+ZsMeCn+2SsiDTyfkvIAuNIriEyAvR6VzQk
         /gAQ4aTFxkG6PGFdfCwg6QeEv/NsQTNeQ/0VXVPDpS6AUICVhYDw/PI2JRhH6dcXfI
         iJ0BXCm7tQ0vEWLomb8Vq06YzDkLrf7fGa3tivw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/567] wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup
Date:   Tue,  7 Mar 2023 18:02:07 +0100
Message-Id: <20230307165922.775268521@linuxfoundation.org>
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
index 7aecde35cb9a3..1aa0479c5fa4e 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -486,6 +486,7 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 	bool more;
 
 	spin_lock_bh(&q->lock);
+
 	do {
 		buf = mt76_dma_dequeue(dev, q, true, NULL, NULL, &more);
 		if (!buf)
@@ -493,6 +494,12 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 
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
@@ -515,12 +522,6 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
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



