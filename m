Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B98451085
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242662AbhKOStx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242839AbhKOSqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:46:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C8F963386;
        Mon, 15 Nov 2021 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999628;
        bh=Idgu4DDNcl1FXQN6NTh07ooap8DRVzi2XKmEZ04Oi8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mSig2Mmv/6E4RGDmQfIKeOl61AsvaxaCgFHhyhqfnaJYwrcaa4MK4VABxsRkSx1p
         tQik2VOeaSfcoUUY0VaxANQwLblJVmE0x01aUi5ywSD44xF4pxzASYM8s4wdhL1gKG
         hWd1IxjBVvm8v1QRyCq6HjThnHRzEWfAYnVQFhaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 367/849] ath11k: fix some sleeping in atomic bugs
Date:   Mon, 15 Nov 2021 17:57:30 +0100
Message-Id: <20211115165432.649906719@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit aadf7c81a0771b8f1c97dabca6a48bae1b387779 ]

The ath11k_dbring_bufs_replenish() and ath11k_dbring_fill_bufs()
take a "gfp" parameter but they since they take spinlocks, the
allocations they do have to be atomic.  This causes a bug because
ath11k_dbring_buf_setup passes GFP_KERNEL for the gfp flags.

The fix is to use GFP_ATOMIC and remove the unused parameters.

Fixes: bd6478559e27 ("ath11k: Add direct buffer ring support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210812070434.GE31863@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dbring.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dbring.c b/drivers/net/wireless/ath/ath11k/dbring.c
index 5e1f5437b4185..fd98ba5b1130b 100644
--- a/drivers/net/wireless/ath/ath11k/dbring.c
+++ b/drivers/net/wireless/ath/ath11k/dbring.c
@@ -8,8 +8,7 @@
 
 static int ath11k_dbring_bufs_replenish(struct ath11k *ar,
 					struct ath11k_dbring *ring,
-					struct ath11k_dbring_element *buff,
-					gfp_t gfp)
+					struct ath11k_dbring_element *buff)
 {
 	struct ath11k_base *ab = ar->ab;
 	struct hal_srng *srng;
@@ -35,7 +34,7 @@ static int ath11k_dbring_bufs_replenish(struct ath11k *ar,
 		goto err;
 
 	spin_lock_bh(&ring->idr_lock);
-	buf_id = idr_alloc(&ring->bufs_idr, buff, 0, ring->bufs_max, gfp);
+	buf_id = idr_alloc(&ring->bufs_idr, buff, 0, ring->bufs_max, GFP_ATOMIC);
 	spin_unlock_bh(&ring->idr_lock);
 	if (buf_id < 0) {
 		ret = -ENOBUFS;
@@ -72,8 +71,7 @@ err:
 }
 
 static int ath11k_dbring_fill_bufs(struct ath11k *ar,
-				   struct ath11k_dbring *ring,
-				   gfp_t gfp)
+				   struct ath11k_dbring *ring)
 {
 	struct ath11k_dbring_element *buff;
 	struct hal_srng *srng;
@@ -92,11 +90,11 @@ static int ath11k_dbring_fill_bufs(struct ath11k *ar,
 	size = sizeof(*buff) + ring->buf_sz + align - 1;
 
 	while (num_remain > 0) {
-		buff = kzalloc(size, gfp);
+		buff = kzalloc(size, GFP_ATOMIC);
 		if (!buff)
 			break;
 
-		ret = ath11k_dbring_bufs_replenish(ar, ring, buff, gfp);
+		ret = ath11k_dbring_bufs_replenish(ar, ring, buff);
 		if (ret) {
 			ath11k_warn(ar->ab, "failed to replenish db ring num_remain %d req_ent %d\n",
 				    num_remain, req_entries);
@@ -176,7 +174,7 @@ int ath11k_dbring_buf_setup(struct ath11k *ar,
 	ring->hp_addr = ath11k_hal_srng_get_hp_addr(ar->ab, srng);
 	ring->tp_addr = ath11k_hal_srng_get_tp_addr(ar->ab, srng);
 
-	ret = ath11k_dbring_fill_bufs(ar, ring, GFP_KERNEL);
+	ret = ath11k_dbring_fill_bufs(ar, ring);
 
 	return ret;
 }
@@ -322,7 +320,7 @@ int ath11k_dbring_buffer_release_event(struct ath11k_base *ab,
 		}
 
 		memset(buff, 0, size);
-		ath11k_dbring_bufs_replenish(ar, ring, buff, GFP_ATOMIC);
+		ath11k_dbring_bufs_replenish(ar, ring, buff);
 	}
 
 	spin_unlock_bh(&srng->lock);
-- 
2.33.0



