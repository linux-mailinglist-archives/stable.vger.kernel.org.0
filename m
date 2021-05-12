Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EED37CDC2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245636AbhELQ6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244170AbhELQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AA0361D32;
        Wed, 12 May 2021 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835879;
        bh=nNRDHEZ3jyQprezm5AzHlTgdjfNCFB42Zi7TTYstpNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaKXADbg59QAisgW/LF9ICk6TeIcakeIRwQrrLr/sREqf0GKXFKGirBa436i21DBr
         cHXJec5mnfe6Px4bYf+FBpKTvZL/TMbk9MEMdXr59GWBnzfJ3vTOOnNrU6p5YlTI4V
         l+Sot/QEl+tnUpGVswt4q3azMaY1LHjAJfOgoLUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 520/677] mt76: mt7921: fix memory leak in mt7921_coredump_work
Date:   Wed, 12 May 2021 16:49:26 +0200
Message-Id: <20210512144854.663395334@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 782b3e86ea970e899f8e723db9f64708a15ca30e ]

Fix possible memory leak in mt7921_coredump_work.

Fixes: 1c099ab44727c ("mt76: mt7921: add MCU support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 3f9097481a5e..d51ec8a550d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1503,8 +1503,10 @@ void mt7921_coredump_work(struct work_struct *work)
 			break;
 
 		skb_pull(skb, sizeof(struct mt7921_mcu_rxd));
-		if (data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ)
-			break;
+		if (data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ) {
+			dev_kfree_skb(skb);
+			continue;
+		}
 
 		memcpy(data, skb->data, skb->len);
 		data += skb->len;
-- 
2.30.2



