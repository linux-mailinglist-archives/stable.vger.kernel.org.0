Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B31E4F31CC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242790AbiDEJiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbiDEJE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:04:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8C8186F7;
        Tue,  5 Apr 2022 01:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B065B61572;
        Tue,  5 Apr 2022 08:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD87EC385A3;
        Tue,  5 Apr 2022 08:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148952;
        bh=YQ4rwbpQD1XCbXEEgniQsFh5ilejlivXkbnSqRLRICg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIAsETPeBqgbaqk9I2JYAM7FvjD92+sBBnYHBTJjJ9Z1LnFR9ekc0pcNvaUGe2Rju
         0EOZv9RGrzpASEEZRjYksH7HoCiisWpa4ezYlsdk3szSS6aQ+BmqFaGdFvSz6mdekF
         B/sMQhyWiGZVAP8fVrBf8Bx89pjyFton6ASSEDkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0539/1017] scsi: pm8001: Fix abort all task initialization
Date:   Tue,  5 Apr 2022 09:24:12 +0200
Message-Id: <20220405070410.289087854@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 7f12845c8389855dbcc67baa068b6832dc4a396e ]

In pm80xx_send_abort_all(), the n_elem field of the ccb used is not
initialized to 0. This missing initialization sometimes lead to the task
completion path seeing the ccb with a non-zero n_elem resulting in the
execution of invalid dma_unmap_sg() calls in pm8001_ccb_task_free(),
causing a crash such as:

[  197.676341] RIP: 0010:iommu_dma_unmap_sg+0x6d/0x280
[  197.700204] RSP: 0018:ffff889bbcf89c88 EFLAGS: 00010012
[  197.705485] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83d0bda0
[  197.712687] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88810dffc0d0
[  197.719887] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8881c790098b
[  197.727089] R10: ffffed1038f20131 R11: 0000000000000001 R12: 0000000000000000
[  197.734296] R13: ffff88810dffc0d0 R14: 0000000000000010 R15: 0000000000000000
[  197.741493] FS:  0000000000000000(0000) GS:ffff889bbcf80000(0000) knlGS:0000000000000000
[  197.749659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  197.755459] CR2: 00007f16c1b42734 CR3: 0000000004814000 CR4: 0000000000350ee0
[  197.762656] Call Trace:
[  197.765127]  <IRQ>
[  197.767162]  pm8001_ccb_task_free+0x5f1/0x820 [pm80xx]
[  197.772364]  ? do_raw_spin_unlock+0x54/0x220
[  197.776680]  pm8001_mpi_task_abort_resp+0x2ce/0x4f0 [pm80xx]
[  197.782406]  process_oq+0xe85/0x7890 [pm80xx]
[  197.786817]  ? lock_acquire+0x194/0x490
[  197.790697]  ? handle_irq_event+0x10e/0x1b0
[  197.794920]  ? mpi_sata_completion+0x2d70/0x2d70 [pm80xx]
[  197.800378]  ? __wake_up_bit+0x100/0x100
[  197.804340]  ? lock_is_held_type+0x98/0x110
[  197.808565]  pm80xx_chip_isr+0x94/0x130 [pm80xx]
[  197.813243]  tasklet_action_common.constprop.0+0x24b/0x2f0
[  197.818785]  __do_softirq+0x1b5/0x82d
[  197.822485]  ? do_raw_spin_unlock+0x54/0x220
[  197.826799]  __irq_exit_rcu+0x17e/0x1e0
[  197.830678]  irq_exit_rcu+0xa/0x20
[  197.834114]  common_interrupt+0x78/0x90
[  197.840051]  </IRQ>
[  197.844236]  <TASK>
[  197.848397]  asm_common_interrupt+0x1e/0x40

Avoid this issue by always initializing the ccb n_elem field to 0 in
pm8001_send_abort_all(), pm8001_send_read_log() and
pm80xx_send_abort_all().

Link: https://lore.kernel.org/r/20220220031810.738362-17-damien.lemoal@opensource.wdc.com
Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 97c08afd2dcf..6332cf23bf6b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1783,6 +1783,7 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	ccb->device = pm8001_ha_dev;
 	ccb->ccb_tag = ccb_tag;
 	ccb->task = task;
+	ccb->n_elem = 0;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
@@ -1844,6 +1845,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	ccb->device = pm8001_ha_dev;
 	ccb->ccb_tag = ccb_tag;
 	ccb->task = task;
+	ccb->n_elem = 0;
 	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
 	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 414cd4b67c90..48b0154211c7 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1801,6 +1801,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	ccb->device = pm8001_ha_dev;
 	ccb->ccb_tag = ccb_tag;
 	ccb->task = task;
+	ccb->n_elem = 0;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
-- 
2.34.1



