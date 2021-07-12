Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144E33C53ED
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348195AbhGLH40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350803AbhGLHvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E233161154;
        Mon, 12 Jul 2021 07:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076109;
        bh=aznMyr3mS6X4yI+zpXfb8ZngxkF9p7QTKDxJQVfmA38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYD/m6hEQl3LS4zVov9+2Uqf8DZJ0OzPbq4fUyJxkA2d2lE8B/9vRLgybs2mqXO1u
         cy+4EaB9YiNZUh9bzhjhLowaURY7ds3Gw3ANnmPSKHnUvSzSfea2bsNhhuBSUHrIlZ
         +yCciSjpm1eIjxexbhkLEjHZeRNbjv94xS0cMfKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 501/800] mt76: testmode: fix memory leak in mt76_testmode_alloc_skb
Date:   Mon, 12 Jul 2021 08:08:44 +0200
Message-Id: <20210712061020.495407973@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fe2c3b1fc64ea0c7a5b2ca2f671b4572ff99baf8 ]

Free all pending frames in case of failure in mt76_testmode_alloc_skb
routine

Fixes: 2601dda8faa76 ("mt76: testmode: add support to send larger packet")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/testmode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/testmode.c b/drivers/net/wireless/mediatek/mt76/testmode.c
index 001d0ba5f73e..f40387a866ee 100644
--- a/drivers/net/wireless/mediatek/mt76/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/testmode.c
@@ -158,8 +158,11 @@ int mt76_testmode_alloc_skb(struct mt76_phy *phy, u32 len)
 			frag_len = MT_TXP_MAX_LEN;
 
 		frag = alloc_skb(frag_len, GFP_KERNEL);
-		if (!frag)
+		if (!frag) {
+			mt76_testmode_free_skb(phy);
+			dev_kfree_skb(head);
 			return -ENOMEM;
+		}
 
 		__skb_put_zero(frag, frag_len);
 		head->len += frag->len;
-- 
2.30.2



