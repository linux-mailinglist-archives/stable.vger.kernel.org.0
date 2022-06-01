Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D3F53A8C3
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355180AbiFAOL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354765AbiFAOJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:09:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8DCB4A8;
        Wed,  1 Jun 2022 07:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 966E1CE1C23;
        Wed,  1 Jun 2022 13:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48DBC385B8;
        Wed,  1 Jun 2022 13:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091742;
        bh=jePdNX0EfcO7Gm4KTYdBeSyuCnF+gYdC8iKD6gEPixU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgkyxWNmr8WQc5ABsxbYzeTaZgaBp/MbeCmzY2jBn/1anPBsPga4KODLgnDbnwAl0
         9k+59u3gppNbuhGgAHDAaX/u/BT5NGzBagExtcujS5JqNbleIo7gvqI/RXXy1ye8es
         t1ZaGhb7EpgUwdNhxDyCzP46JuqjmqLz07cHe33j3lRGiaVw1DG/5K0iLV78qlpGbR
         JhvOz7jcFMcQGBHG0LOp1WgvhQKKpnfBjjrfUZFNXFWMKA6KaG+LAgMBelLbUcFdn/
         Qwb8C8aANjCGsm4gM7rEwv2qKDwc4iwTJdEnzkSjP0aRCkDAtIH2NwhPMBJ7Q7LKxa
         gZa2xoiL3H76w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
        justin.he@arm.com, yuzhe@nfschina.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.17 34/48] KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
Date:   Wed,  1 Jun 2022 09:54:07 -0400
Message-Id: <20220601135421.2003328-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit a1ccfd6f6e06eceb632cc29c4f15a32860f05a7e ]

Restoring a corrupted collection entry (like an out of range ID) is
being ignored and treated as success. More specifically, a
vgic_its_restore_cte failure is treated as success by
vgic_its_restore_collection_table.  vgic_its_restore_cte uses positive
and negative numbers to return error, and +1 to return success.  The
caller then uses "ret > 0" to check for success.

Fix this by having vgic_its_restore_cte only return negative numbers on
error.  Do this by changing alloc_collection return codes to only return
negative numbers on error.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220510001633.552496-4-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 089fc2ffcb43..d4b849364d07 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -976,15 +976,16 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	return ret;
 }
 
+/*
+ * Add a new collection into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_alloc_collection(struct vgic_its *its,
 				     struct its_collection **colp,
 				     u32 coll_id)
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
-		return E_ITS_MAPC_COLLECTION_OOR;
-
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
 	if (!collection)
 		return -ENOMEM;
@@ -1078,7 +1079,12 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	collection = find_collection(its, coll_id);
 	if (!collection) {
-		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
+		int ret;
+
+		if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+			return E_ITS_MAPC_COLLECTION_OOR;
+
+		ret = vgic_its_alloc_collection(its, &collection, coll_id);
 		if (ret)
 			return ret;
 		new_coll = collection;
@@ -1233,6 +1239,10 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 		if (!collection) {
 			int ret;
 
+			if (!vgic_its_check_id(its, its->baser_coll_table,
+						coll_id, NULL))
+				return E_ITS_MAPC_COLLECTION_OOR;
+
 			ret = vgic_its_alloc_collection(its, &collection,
 							coll_id);
 			if (ret)
@@ -2461,6 +2471,11 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
+/*
+ * Restore a collection entry into the ITS collection table.
+ * Return +1 on success, 0 if the entry was invalid (which should be
+ * interpreted as end-of-table), and a negative error value for generic errors.
+ */
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 {
 	struct its_collection *collection;
@@ -2487,6 +2502,10 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	collection = find_collection(its, coll_id);
 	if (collection)
 		return -EEXIST;
+
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+		return -EINVAL;
+
 	ret = vgic_its_alloc_collection(its, &collection, coll_id);
 	if (ret)
 		return ret;
-- 
2.35.1

