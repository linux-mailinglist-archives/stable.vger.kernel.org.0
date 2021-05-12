Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA237CDCF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhELQ6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244197AbhELQmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5373461C71;
        Wed, 12 May 2021 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835887;
        bh=mDMXlIFEngb3Uj/DykP8JSnHilYmwXjGmg3Kup2eyPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEKFf2ihB5bkXPB8JypphdwLDU8K8PKpyDd2gXHy4Uz9/TtiDJsDTHSL6kBnf/FG/
         lOb1r6fhrnmkdzKwzzQ/UBI99LNrMYTFbqYb5H+R/LSnXxYsjLrOQwt+lX8KNo1AGY
         RHfYnO0Xh/dO8o/4DX5/WIOmy+Ar7BEa0NAnEKA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 523/677] mt76: mt7615: fix memory leak in mt7615_coredump_work
Date:   Wed, 12 May 2021 16:49:29 +0200
Message-Id: <20210512144854.762647775@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 49cc85059a2cb656f96ff3693f891e8fe8f669a9 ]

Similar to the issue fixed in mt7921_coredump_work, fix a possible memory
leak in mt7615_coredump_work routine.

Fixes: d2bf7959d9c0f ("mt76: mt7663: introduce coredump support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 1abfd58e8f49..b313442b2d9e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2308,8 +2308,10 @@ void mt7615_coredump_work(struct work_struct *work)
 			break;
 
 		skb_pull(skb, sizeof(struct mt7615_mcu_rxd));
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



