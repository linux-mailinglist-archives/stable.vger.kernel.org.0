Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD0137CF12
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbhELRIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244456AbhELQqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A59461E74;
        Wed, 12 May 2021 16:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836103;
        bh=64Lb0QUVUNPoqsp59AbaL7FVwP2JzbpGg3xAnR4o3yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVzhi1JBgxI1Mea6v7AuRdDY4AClUAKPv7KnhaDSgDwsZeO0umhNNKwg8FPhlUd9p
         1UnavzXy4UETtDDWLEiOz7ZlwYt/9srFXsnTMbXeSHBnXggyfz9L8PXCi2j8mmdCCA
         DsrjKbuzbow3mZosfx3d49wO/Vgju+AG02VAkJXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 612/677] mt76: mt7915: fix memleak when mt7915_unregister_device()
Date:   Wed, 12 May 2021 16:50:58 +0200
Message-Id: <20210512144857.700878940@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit e9d32af478cfc3744a45245c0b126738af4b3ac4 ]

mt7915_tx_token_put() should get call before mt76_free_pending_txwi().

Fixes: f285dfb98562 ("mt76: mt7915: reset token when mac_reset happens")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ad4e5b95158b..894016fdcf07 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -675,9 +675,8 @@ void mt7915_unregister_device(struct mt7915_dev *dev)
 	mt7915_unregister_ext_phy(dev);
 	mt76_unregister_device(&dev->mt76);
 	mt7915_mcu_exit(dev);
-	mt7915_dma_cleanup(dev);
-
 	mt7915_tx_token_put(dev);
+	mt7915_dma_cleanup(dev);
 
 	mt76_free_device(&dev->mt76);
 }
-- 
2.30.2



