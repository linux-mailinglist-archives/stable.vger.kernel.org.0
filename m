Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1053755D255
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiF0Lfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiF0LfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:35:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC6DD47;
        Mon, 27 Jun 2022 04:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 184DB60920;
        Mon, 27 Jun 2022 11:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0CEC341C7;
        Mon, 27 Jun 2022 11:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329491;
        bh=ofn2fEtn2NgumFR9kyJjtjl7CDqFCrg7S2Lfx1WBC2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWXG3GjJZi+IHb+cZhPKVg/geOXYzKLA6+PSATdVb0qYLCylcDFP3KEhW2am8YQ3S
         L3HhIDAZgRFuaMgVhFaw8rAFiYDbIIGQ1F5GlXBzzxXF7TPMnnXl63MzuVKKZpg3h+
         ANQ4JdkwqtUuo6vc0XaWUrE9Mgr9AZy7TZruiZK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 017/135] scsi: ibmvfc: Store vhost pointer during subcrq allocation
Date:   Mon, 27 Jun 2022 13:20:24 +0200
Message-Id: <20220627111938.660961360@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

commit aeaadcde1a60138bceb65de3cdaeec78170b4459 upstream.

Currently the back pointer from a queue to the vhost adapter isn't set
until after subcrq interrupt registration. The value is available when a
queue is first allocated and can/should be also set for primary and async
queues as well as subcrqs.

This fixes a crash observed during kexec/kdump on Power 9 with legacy XICS
interrupt controller where a pending subcrq interrupt from the previous
kernel can be replayed immediately upon IRQ registration resulting in
dereference of a garbage backpointer in ibmvfc_interrupt_scsi().

Kernel attempted to read user page (58) - exploit attempt? (uid: 0)
BUG: Kernel NULL pointer dereference on read at 0x00000058
Faulting instruction address: 0xc008000003216a08
Oops: Kernel access of bad area, sig: 11 [#1]
...
NIP [c008000003216a08] ibmvfc_interrupt_scsi+0x40/0xb0 [ibmvfc]
LR [c0000000082079e8] __handle_irq_event_percpu+0x98/0x270
Call Trace:
[c000000047fa3d80] [c0000000123e6180] 0xc0000000123e6180 (unreliable)
[c000000047fa3df0] [c0000000082079e8] __handle_irq_event_percpu+0x98/0x270
[c000000047fa3ea0] [c000000008207d18] handle_irq_event+0x98/0x188
[c000000047fa3ef0] [c00000000820f564] handle_fasteoi_irq+0xc4/0x310
[c000000047fa3f40] [c000000008205c60] generic_handle_irq+0x50/0x80
[c000000047fa3f60] [c000000008015c40] __do_irq+0x70/0x1a0
[c000000047fa3f90] [c000000008016d7c] __do_IRQ+0x9c/0x130
[c000000014622f60] [0000000020000000] 0x20000000
[c000000014622ff0] [c000000008016e50] do_IRQ+0x40/0xa0
[c000000014623020] [c000000008017044] replay_soft_interrupts+0x194/0x2f0
[c000000014623210] [c0000000080172a8] arch_local_irq_restore+0x108/0x170
[c000000014623240] [c000000008eb1008] _raw_spin_unlock_irqrestore+0x58/0xb0
[c000000014623270] [c00000000820b12c] __setup_irq+0x49c/0x9f0
[c000000014623310] [c00000000820b7c0] request_threaded_irq+0x140/0x230
[c000000014623380] [c008000003212a50] ibmvfc_register_scsi_channel+0x1e8/0x2f0 [ibmvfc]
[c000000014623450] [c008000003213d1c] ibmvfc_init_sub_crqs+0xc4/0x1f0 [ibmvfc]
[c0000000146234d0] [c0080000032145a8] ibmvfc_reset_crq+0x150/0x210 [ibmvfc]
[c000000014623550] [c0080000032147c8] ibmvfc_init_crq+0x160/0x280 [ibmvfc]
[c0000000146235f0] [c00800000321a9cc] ibmvfc_probe+0x2a4/0x530 [ibmvfc]

Link: https://lore.kernel.org/r/20220616191126.1281259-2-tyreld@linux.ibm.com
Fixes: 3034ebe26389 ("scsi: ibmvfc: Add alloc/dealloc routines for SCSI Sub-CRQ Channels")
Cc: stable@vger.kernel.org
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |    3 ++-
 drivers/scsi/ibmvscsi/ibmvfc.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5680,6 +5680,8 @@ static int ibmvfc_alloc_queue(struct ibm
 	queue->cur = 0;
 	queue->fmt = fmt;
 	queue->size = PAGE_SIZE / fmt_size;
+
+	queue->vhost = vhost;
 	return 0;
 }
 
@@ -5788,7 +5790,6 @@ static int ibmvfc_register_scsi_channel(
 	}
 
 	scrq->hwq_id = index;
-	scrq->vhost = vhost;
 
 	LEAVE;
 	return 0;
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -789,6 +789,7 @@ struct ibmvfc_queue {
 	spinlock_t _lock;
 	spinlock_t *q_lock;
 
+	struct ibmvfc_host *vhost;
 	struct ibmvfc_event_pool evt_pool;
 	struct list_head sent;
 	struct list_head free;
@@ -797,7 +798,6 @@ struct ibmvfc_queue {
 	union ibmvfc_iu cancel_rsp;
 
 	/* Sub-CRQ fields */
-	struct ibmvfc_host *vhost;
 	unsigned long cookie;
 	unsigned long vios_cookie;
 	unsigned long hw_irq;


