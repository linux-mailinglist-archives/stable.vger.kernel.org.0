Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30598EA0E4
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfJ3Pzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbfJ3Pzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:55:37 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E60821734;
        Wed, 30 Oct 2019 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450936;
        bh=tF0E1giTSXxJHmVP2hupSm5VRPNu7THTyO2tRFdVq+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfxvRBEbU5Kififr1prFTJSgG6zX8ZaTRaUKk47GoKb6RlwiDhCh9fL/F7tUioFwd
         UoT/Y/qGNbsDQy7LhxwPbbNzCaq7izyx6GZrTCbQUEO0/Q6SpFSOxJnWuvKB06Y7tG
         G1wOm4NkSFog3f+wymmjR85YjmqYkBRPQoQhsVc8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 31/38] irqchip/gic-v3-its: Use the exact ITSList for VMOVP
Date:   Wed, 30 Oct 2019 11:53:59 -0400
Message-Id: <20191030155406.10109-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit 8424312516e5d9baeeb0a95d0e4523579b7aa395 ]

On a system without Single VMOVP support (say GITS_TYPER.VMOVP == 0),
we will map vPEs only on ITSs that will actually control interrupts
for the given VM.  And when moving a vPE, the VMOVP command will be
issued only for those ITSs.

But when issuing VMOVPs we seemed fail to present the exact ITSList
to ITSs who are actually included in the synchronization operation.
The its_list_map we're currently using includes all ITSs in the system,
even though some of them don't have the corresponding vPE mapping at all.

Introduce get_its_list() to get the per-VM its_list_map, to indicate
which ITSs have vPE mappings for the given VM, and use this map as
the expected ITSList when building VMOVP. This is hopefully a performance
gain not to do some synchronization with those unsuspecting ITSs.
And initialize the whole command descriptor to zero at beginning, since
the seq_num and its_list should be RES0 when GITS_TYPER.VMOVP == 1.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1571802386-2680-1-git-send-email-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e7549a2b1482b..050d6e040128d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -182,6 +182,22 @@ static DEFINE_IDA(its_vpeid_ida);
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
 
+static u16 get_its_list(struct its_vm *vm)
+{
+	struct its_node *its;
+	unsigned long its_list = 0;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (!its->is_v4)
+			continue;
+
+		if (vm->vlpi_count[its->list_nr])
+			__set_bit(its->list_nr, &its_list);
+	}
+
+	return (u16)its_list;
+}
+
 static struct its_collection *dev_event_to_col(struct its_device *its_dev,
 					       u32 event)
 {
@@ -983,17 +999,15 @@ static void its_send_vmapp(struct its_node *its,
 
 static void its_send_vmovp(struct its_vpe *vpe)
 {
-	struct its_cmd_desc desc;
+	struct its_cmd_desc desc = {};
 	struct its_node *its;
 	unsigned long flags;
 	int col_id = vpe->col_idx;
 
 	desc.its_vmovp_cmd.vpe = vpe;
-	desc.its_vmovp_cmd.its_list = (u16)its_list_map;
 
 	if (!its_list_map) {
 		its = list_first_entry(&its_nodes, struct its_node, entry);
-		desc.its_vmovp_cmd.seq_num = 0;
 		desc.its_vmovp_cmd.col = &its->collections[col_id];
 		its_send_single_vcommand(its, its_build_vmovp_cmd, &desc);
 		return;
@@ -1010,6 +1024,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
 	raw_spin_lock_irqsave(&vmovp_lock, flags);
 
 	desc.its_vmovp_cmd.seq_num = vmovp_seq_num++;
+	desc.its_vmovp_cmd.its_list = get_its_list(vpe->its_vm);
 
 	/* Emit VMOVPs */
 	list_for_each_entry(its, &its_nodes, entry) {
-- 
2.20.1

