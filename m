Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13DB54E9D1
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 21:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378075AbiFPTLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 15:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378122AbiFPTLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 15:11:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE965007D;
        Thu, 16 Jun 2022 12:11:44 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GHUPA9027445;
        Thu, 16 Jun 2022 19:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SCDQWuQGFRyu8y789mFEEyPz5l1gFSI3XacoMHNxtKE=;
 b=sSu77Yb8wqHDZWlUTwn42jYO09H5LVkJd4ku0PPIqPW+MXoczwlcEqurJ92jw9mVYTvy
 F/j3FQhfQ43gvzGXj77wNgQ2SLT78CvFiqWavErsWy5h07BuP2Dpik3o+BCCFVW5duMX
 Uv5jAcLZTwPNg0zdZcnUZJB2Ah05tmKJD+wTnCfygCnEtVcRnmGK11cb5aGL/qMNf512
 lJNjGo2tF8ML9mILEJ2NB19fuKq8dIxFpvRoTXdwLn/1K4Z9Y8E8n7rxcclG92g6Da0J
 sgqV24vE/Uy5VIIJ4cYRO8suJev0+nu7eUudTSj0edYWZWJ4qfTM9mEDZvCljAvj5EGv 3g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gr10jyndj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 19:11:37 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25GJ5ldX028766;
        Thu, 16 Jun 2022 19:11:37 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3gmjpamgy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 19:11:36 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25GJBZdt14877280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 19:11:35 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59CC0136051;
        Thu, 16 Jun 2022 19:11:35 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B997F13604F;
        Thu, 16 Jun 2022 19:11:33 +0000 (GMT)
Received: from li-37e927cc-2b02-11b2-a85c-931637a79255.ibm.com.com (unknown [9.160.59.133])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jun 2022 19:11:33 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        stable@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ibmvfc: store vhost pointer during subcrq allocation
Date:   Thu, 16 Jun 2022 12:11:25 -0700
Message-Id: <20220616191126.1281259-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220616191126.1281259-1-tyreld@linux.ibm.com>
References: <20220616191126.1281259-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CHq05a20bxoxtDxqkO8EOhB8BRqWlAb3
X-Proofpoint-GUID: CHq05a20bxoxtDxqkO8EOhB8BRqWlAb3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_16,2022-06-16_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=537 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently the back pointer from a queue to the vhost adapter isn't set
until after subcrq interrupt registration. The value is available when a queue
is first allocated and can/should be also set for primary and async queues as
well as subcrq's.

This fixes a crash observed during kexec/kdump on Power 9 with legacy XICS
interrupt controller where a pending subcrq interrupt from the previous kernel
can be replayed immediately upon IRQ registration resulting in dereference of a
garbage backpointer in ibmvfc_interrupt_scsi.

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

Fixes: 3034ebe263897 ("scsi: ibmvfc: Add alloc/dealloc routines for SCSI Sub-CRQ Channels")
Cc: stable@vger.kernel.org
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 ++-
 drivers/scsi/ibmvscsi/ibmvfc.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index d0eab5700dc5..9fc0ffda6ae8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5682,6 +5682,8 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	queue->cur = 0;
 	queue->fmt = fmt;
 	queue->size = PAGE_SIZE / fmt_size;
+
+	queue->vhost = vhost;
 	return 0;
 }
 
@@ -5790,7 +5792,6 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 	}
 
 	scrq->hwq_id = index;
-	scrq->vhost = vhost;
 
 	LEAVE;
 	return 0;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 3718406e0988..c39a245f43d0 100644
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
-- 
2.35.3

