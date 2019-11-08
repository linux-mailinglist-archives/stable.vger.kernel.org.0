Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A48F5645
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390525AbfKHTHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388499AbfKHTHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E1FF21D7F;
        Fri,  8 Nov 2019 19:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240066;
        bh=9nPEdpQYOCY2TlQxk6PBSh9IstcTcETRHvZjaXcvaF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5cNlrc19jYGv9CkoEHQsyGrLtgks3YKqP4jghKbrOo5UthIzh3RuGU7vUZPmeBzr
         ZPdeNWnCPmDR74U5qNoOh3PSuTTN0fMh4xP9M/vCUhfMxn8J5G61shjInBhF/7B77i
         aKlwf9Ad+ZYUqM+uAm4Um/gsVl/bimLdwmrt6Dj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 070/140] irqchip/gic-v3-its: Use the exact ITSList for VMOVP
Date:   Fri,  8 Nov 2019 19:49:58 +0100
Message-Id: <20191108174909.582979810@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c3a8d732805f5..868c356fbf496 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -175,6 +175,22 @@ static DEFINE_IDA(its_vpeid_ida);
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
@@ -976,17 +992,15 @@ static void its_send_vmapp(struct its_node *its,
 
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
@@ -1003,6 +1017,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
 	raw_spin_lock_irqsave(&vmovp_lock, flags);
 
 	desc.its_vmovp_cmd.seq_num = vmovp_seq_num++;
+	desc.its_vmovp_cmd.its_list = get_its_list(vpe->its_vm);
 
 	/* Emit VMOVPs */
 	list_for_each_entry(its, &its_nodes, entry) {
-- 
2.20.1



