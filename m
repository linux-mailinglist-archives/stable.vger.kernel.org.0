Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58FA20DE77
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgF2U0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732528AbgF2TZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72C7425312;
        Mon, 29 Jun 2020 15:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445141;
        bh=LoVIHkXo/f1i0Yzxzmm7UVOq2WlhqMhxCMJ6m/utMNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIMbEV7xbpV4BTWBOEN7wDhjXwnmPMstnqSPvbpzNXOy5Ru2CNJEUOWsMmt7mHfHq
         wdiJ9W2sxabTUqCrmFr/JouEOGugJP+CHy62ybl1HOlh8SSy8TFED4z0w4xH6elLz6
         QB5bZHhRaYp6qZqQ4iN5lYmvjOtL77DUxp/knp/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 46/78] net: qed: fix left elements count calculation
Date:   Mon, 29 Jun 2020 11:37:34 -0400
Message-Id: <20200629153806.2494953-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit 97dd1abd026ae4e6a82fa68645928404ad483409 ]

qed_chain_get_element_left{,_u32} returned 0 when the difference
between producer and consumer page count was equal to the total
page count.
Fix this by conditional expanding of producer value (vs
unconditional). This allowed to eliminate normalizaton against
total page count, which was the cause of this bug.

Misc: replace open-coded constants with common defines.

Fixes: a91eb52abb50 ("qed: Revisit chain implementation")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/qed/qed_chain.h | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 733fad7dfbed9..6d15040c642cb 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -207,28 +207,34 @@ static inline u32 qed_chain_get_cons_idx_u32(struct qed_chain *p_chain)
 
 static inline u16 qed_chain_get_elem_left(struct qed_chain *p_chain)
 {
+	u16 elem_per_page = p_chain->elem_per_page;
+	u32 prod = p_chain->u.chain16.prod_idx;
+	u32 cons = p_chain->u.chain16.cons_idx;
 	u16 used;
 
-	used = (u16) (((u32)0x10000 +
-		       (u32)p_chain->u.chain16.prod_idx) -
-		      (u32)p_chain->u.chain16.cons_idx);
+	if (prod < cons)
+		prod += (u32)U16_MAX + 1;
+
+	used = (u16)(prod - cons);
 	if (p_chain->mode == QED_CHAIN_MODE_NEXT_PTR)
-		used -= p_chain->u.chain16.prod_idx / p_chain->elem_per_page -
-		    p_chain->u.chain16.cons_idx / p_chain->elem_per_page;
+		used -= prod / elem_per_page - cons / elem_per_page;
 
 	return (u16)(p_chain->capacity - used);
 }
 
 static inline u32 qed_chain_get_elem_left_u32(struct qed_chain *p_chain)
 {
+	u16 elem_per_page = p_chain->elem_per_page;
+	u64 prod = p_chain->u.chain32.prod_idx;
+	u64 cons = p_chain->u.chain32.cons_idx;
 	u32 used;
 
-	used = (u32) (((u64)0x100000000ULL +
-		       (u64)p_chain->u.chain32.prod_idx) -
-		      (u64)p_chain->u.chain32.cons_idx);
+	if (prod < cons)
+		prod += (u64)U32_MAX + 1;
+
+	used = (u32)(prod - cons);
 	if (p_chain->mode == QED_CHAIN_MODE_NEXT_PTR)
-		used -= p_chain->u.chain32.prod_idx / p_chain->elem_per_page -
-		    p_chain->u.chain32.cons_idx / p_chain->elem_per_page;
+		used -= (u32)(prod / elem_per_page - cons / elem_per_page);
 
 	return p_chain->capacity - used;
 }
-- 
2.25.1

