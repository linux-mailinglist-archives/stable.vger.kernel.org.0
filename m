Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEEA37CA79
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbhELQa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236768AbhELQW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F0BF61C99;
        Wed, 12 May 2021 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834434;
        bh=2WEbULl4E6y4kgvGnmH5aRV4YDyBR8EYJfX2VktV0gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOC8/Y48qP+oY6E1PoGIKXLdRIr5bXmfx53xvrgs90Zn8+bajXk4nV+Occl755l8B
         GC09eoOE08qXrCOor+E2zG3S5vNJzHz4zioJ/kQamPi/AfrcWPqhB2La82cMM94XHk
         p1My4+Ow73UvqAHkgwNwN4bQCGqRgEcSkVY5nzdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 542/601] mt76: mt7615: fix memleak when mt7615_unregister_device()
Date:   Wed, 12 May 2021 16:50:19 +0200
Message-Id: <20210512144845.708652109@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 58a0ec1bf8d7..5dd1c6d501ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -168,10 +168,9 @@ void mt7615_unregister_device(struct mt7615_dev *dev)
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



