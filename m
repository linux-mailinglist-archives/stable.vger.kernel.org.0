Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7471380CE
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbgAKKeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:34:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731664AbgAKKeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:34:11 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D03D820882;
        Sat, 11 Jan 2020 10:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738850;
        bh=OGdi3cRaoNqr0Vcs1iz9PDm0wsGbqlSnYfM4JsxQ1Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtDcRQhTAjBmX/V/OBBxCd6Q/4DJ2KpU2oLSuxXEU2vL8yQ0MHwI9Eu0qK1FdV1mA
         FA/BGc9cq+GpDubJKRniK6dmkTCPwcXXXdxhsR9ywWPuTJHVAlA/hMgazDN2DhblXe
         6yZEcu74dD2pbBv7cAAXY8pdXrIaCG7q2c35LUfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 159/165] net/mlx5: DR, No need for atomic refcount for internal SW steering resources
Date:   Sat, 11 Jan 2020 10:51:18 +0100
Message-Id: <20200111094942.499776527@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@mellanox.com>

[ Upstream commit 4ce380ca477507e2f413584cdd99e1698d6682d6 ]

No need for an atomic refcounter for the STE and hashtables.
These are internal SW steering resources and they are always
under domain mutex.

This also fixes the following refcount error:
  refcount_t: addition on 0; use-after-free.
  WARNING: CPU: 9 PID: 3527 at lib/refcount.c:25 refcount_warn_saturate+0x81/0xe0
  Call Trace:
   dr_table_init_nic+0x10d/0x110 [mlx5_core]
   mlx5dr_table_create+0xb4/0x230 [mlx5_core]
   mlx5_cmd_dr_create_flow_table+0x39/0x120 [mlx5_core]
   __mlx5_create_flow_table+0x221/0x5f0 [mlx5_core]
   esw_create_offloads_fdb_tables+0x180/0x5a0 [mlx5_core]
   ...

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c  |    2 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c   |   10 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h |   14 ++++++------
 3 files changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -209,7 +209,7 @@ static void dr_rule_rehash_copy_ste_ctrl
 	/* We need to copy the refcount since this ste
 	 * may have been traversed several times
 	 */
-	refcount_set(&new_ste->refcount, refcount_read(&cur_ste->refcount));
+	new_ste->refcount = cur_ste->refcount;
 
 	/* Link old STEs rule_mem list to the new ste */
 	mlx5dr_rule_update_rule_member(cur_ste, new_ste);
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -340,7 +340,7 @@ static void dr_ste_replace(struct mlx5dr
 	if (dst->next_htbl)
 		dst->next_htbl->pointing_ste = dst;
 
-	refcount_set(&dst->refcount, refcount_read(&src->refcount));
+	dst->refcount = src->refcount;
 
 	INIT_LIST_HEAD(&dst->rule_list);
 	list_splice_tail_init(&src->rule_list, &dst->rule_list);
@@ -557,7 +557,7 @@ bool mlx5dr_ste_is_not_valid_entry(u8 *p
 
 bool mlx5dr_ste_not_used_ste(struct mlx5dr_ste *ste)
 {
-	return !refcount_read(&ste->refcount);
+	return !ste->refcount;
 }
 
 /* Init one ste as a pattern for ste data array */
@@ -681,14 +681,14 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_
 	htbl->ste_arr = chunk->ste_arr;
 	htbl->hw_ste_arr = chunk->hw_ste_arr;
 	htbl->miss_list = chunk->miss_list;
-	refcount_set(&htbl->refcount, 0);
+	htbl->refcount = 0;
 
 	for (i = 0; i < chunk->num_of_entries; i++) {
 		struct mlx5dr_ste *ste = &htbl->ste_arr[i];
 
 		ste->hw_ste = htbl->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
 		ste->htbl = htbl;
-		refcount_set(&ste->refcount, 0);
+		ste->refcount = 0;
 		INIT_LIST_HEAD(&ste->miss_list_node);
 		INIT_LIST_HEAD(&htbl->miss_list[i]);
 		INIT_LIST_HEAD(&ste->rule_list);
@@ -705,7 +705,7 @@ out_free_htbl:
 
 int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl)
 {
-	if (refcount_read(&htbl->refcount))
+	if (htbl->refcount)
 		return -EBUSY;
 
 	mlx5dr_icm_free_chunk(htbl->chunk);
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -117,7 +117,7 @@ struct mlx5dr_matcher_rx_tx;
 struct mlx5dr_ste {
 	u8 *hw_ste;
 	/* refcount: indicates the num of rules that using this ste */
-	refcount_t refcount;
+	u32 refcount;
 
 	/* attached to the miss_list head at each htbl entry */
 	struct list_head miss_list_node;
@@ -149,7 +149,7 @@ struct mlx5dr_ste_htbl_ctrl {
 struct mlx5dr_ste_htbl {
 	u8 lu_type;
 	u16 byte_mask;
-	refcount_t refcount;
+	u32 refcount;
 	struct mlx5dr_icm_chunk *chunk;
 	struct mlx5dr_ste *ste_arr;
 	u8 *hw_ste_arr;
@@ -200,13 +200,14 @@ int mlx5dr_ste_htbl_free(struct mlx5dr_s
 
 static inline void mlx5dr_htbl_put(struct mlx5dr_ste_htbl *htbl)
 {
-	if (refcount_dec_and_test(&htbl->refcount))
+	htbl->refcount--;
+	if (!htbl->refcount)
 		mlx5dr_ste_htbl_free(htbl);
 }
 
 static inline void mlx5dr_htbl_get(struct mlx5dr_ste_htbl *htbl)
 {
-	refcount_inc(&htbl->refcount);
+	htbl->refcount++;
 }
 
 /* STE utils */
@@ -248,14 +249,15 @@ static inline void mlx5dr_ste_put(struct
 				  struct mlx5dr_matcher *matcher,
 				  struct mlx5dr_matcher_rx_tx *nic_matcher)
 {
-	if (refcount_dec_and_test(&ste->refcount))
+	ste->refcount--;
+	if (!ste->refcount)
 		mlx5dr_ste_free(ste, matcher, nic_matcher);
 }
 
 /* initial as 0, increased only when ste appears in a new rule */
 static inline void mlx5dr_ste_get(struct mlx5dr_ste *ste)
 {
-	refcount_inc(&ste->refcount);
+	ste->refcount++;
 }
 
 void mlx5dr_ste_set_hit_addr_by_next_htbl(u8 *hw_ste,


