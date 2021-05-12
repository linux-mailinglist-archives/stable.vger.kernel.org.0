Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500E837C662
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbhELPtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233477AbhELPmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:42:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5ADA619A1;
        Wed, 12 May 2021 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832925;
        bh=LkWGr2rRHvEgmvScWiGg+bJIodcaQoaK49yILxuNnuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcGjpTqEuhwH5obC0Zcn/bhhnVD4lEPARGqmQ+rG9UE51wRjFBgdWRUVuPlEHW0jV
         rcnUIpighoE9aJOJVY/teuIDy7M3S9unGU4CV4rChrRkiYz2EZlvQBKUzJXj2wK8Mj
         p1ChKnDwW0dKV7yZ043mW8z+RTbdoP8+xqHcruSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 477/530] mt76: mt7615: fix memleak when mt7615_unregister_device()
Date:   Wed, 12 May 2021 16:49:47 +0200
Message-Id: <20210512144835.435825744@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 8ab31da7b89f71c4c2defcca989fab7b42f87d71 ]

mt7615_tx_token_put() should get call before mt76_free_pending_txwi().

Fixes: a6275e934605 ("mt76: mt7615: reset token when mac_reset happens")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index 7b81aef3684e..726e4781d9d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -161,10 +161,9 @@ void mt7615_unregister_device(struct mt7615_dev *dev)
 	mt76_unregister_device(&dev->mt76);
 	if (mcu_running)
 		mt7615_mcu_exit(dev);
-	mt7615_dma_cleanup(dev);
 
 	mt7615_tx_token_put(dev);
-
+	mt7615_dma_cleanup(dev);
 	tasklet_disable(&dev->irq_tasklet);
 
 	mt76_free_device(&dev->mt76);
-- 
2.30.2



