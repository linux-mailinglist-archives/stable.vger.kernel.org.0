Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DFC34C970
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbhC2I3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234129AbhC2I1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A379619C9;
        Mon, 29 Mar 2021 08:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006410;
        bh=eA7/9pe2sz93Lf4T19BPa+kc4xC7T19g9c4E0cRbi8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uz25CEv5kLKwnaJDQ/GnGdlneyQ3FmyeJ3UirfOXm3UvclCC1DmCcDPgw1cqWiLdF
         vVyDJmvU2tRFPQKsb9e0rNuI+wbJs7G9ald/sg0GCYf7cXHud/k9EU1OJzte6LtbrS
         fCvm0SJ+X8TN4V3OXfG7C4Gjj6tD0RGJiDpOxUUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 002/254] mt76: mt7915: only modify tx buffer list after allocating tx token id
Date:   Mon, 29 Mar 2021 09:55:18 +0200
Message-Id: <20210329075633.218510146@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 94f0e6256c2ab6803c935634aa1f653174c94879 ]

Modifying the tx buffer list too early can leak DMA mappings

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210216135119.23809-2-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 1b4d65310b88..c9dd6867e125 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -957,11 +957,6 @@ int mt7915_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	}
 	txp->nbuf = nbuf;
 
-	/* pass partial skb header to fw */
-	tx_info->buf[1].len = MT_CT_PARSE_LEN;
-	tx_info->buf[1].skip_unmap = true;
-	tx_info->nbuf = MT_CT_DMA_BUF_NUM;
-
 	txp->flags = cpu_to_le16(MT_CT_INFO_APPLY_TXD | MT_CT_INFO_FROM_HOST);
 
 	if (!key)
@@ -999,6 +994,11 @@ int mt7915_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		txp->rept_wds_wcid = cpu_to_le16(0x3ff);
 	tx_info->skb = DMA_DUMMY_DATA;
 
+	/* pass partial skb header to fw */
+	tx_info->buf[1].len = MT_CT_PARSE_LEN;
+	tx_info->buf[1].skip_unmap = true;
+	tx_info->nbuf = MT_CT_DMA_BUF_NUM;
+
 	return 0;
 }
 
-- 
2.30.1



