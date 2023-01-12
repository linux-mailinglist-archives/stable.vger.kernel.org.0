Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858D4666810
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbjALAru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjALArt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:47:49 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92DC3FA3D
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 16:47:48 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BN2DBA013594
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 00:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=snnt2Ht2cNaqdg+C0ROeeqxd5H9CLxW5+2tVqFhB2J0=;
 b=yjqX2egGN1ctmbegTa9S1YxAaNt2x+QZyaxBhjWSc4v+N7r794AdGvWSGUvQB/k+GVMt
 IF/cFRKThQJxCmCDAcG4KunWr4kmCIjMMEUGdE3IWIK5ZKX3zWPLEcY1m1VKq9OGgl0E
 ZQANZ4RRZJmnlimlWmv3mwxFGn/t/9nYRCQxKqmcfs8tAi6v5QA0xodWbuF7q/udSa1T
 +bkH46LOWNc+x6bDQQ0MUOmdASZCl9j8SqZfsCvNWieCyzr2uDWejebg6tAbq1s+W7Na
 l5VU1RtMGP2au2YGqfdH8wSx5PY7bthI5uJParQqH5DACWLjHTdsYXJZvPM3lLIbYScS zw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n185tc2fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 00:47:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0Mceb021910
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 00:47:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4phhfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 00:47:46 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30C0lkh2014639
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 00:47:46 GMT
Received: from viboo.us.oracle.com (dhcp-10-132-95-99.usdhcp.oraclecorp.com [10.132.95.99])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4phhfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 12 Jan 2023 00:47:46 +0000
From:   Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
To:     linux_uek_grp@oracle.com
Cc:     stable@vger.kernel.org,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Subject: [PATCH UEK4-U7] scsi: qla2xxx: Fix use after free in eh_abort path
Date:   Wed, 11 Jan 2023 16:46:48 -0800
Message-Id: <1673484408-16510-1-git-send-email-rajan.shanmugavelu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120001
X-Proofpoint-ORIG-GUID: ueq7uB_qC_bVEvkUhkH1tB1fC7224k1b
X-Proofpoint-GUID: ueq7uB_qC_bVEvkUhkH1tB1fC7224k1b
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

In eh_abort path driver prematurely exits the call to upper layer. Check
whether command is aborted / completed by firmware before exiting the call.

9 [ffff8b1ebf803c00] page_fault at ffffffffb0389778
  [exception RIP: qla2x00_status_entry+0x48d]
  RIP: ffffffffc04fa62d  RSP: ffff8b1ebf803cb0  RFLAGS: 00010082
  RAX: 00000000ffffffff  RBX: 00000000000e0000  RCX: 0000000000000000
  RDX: 0000000000000000  RSI: 00000000000013d8  RDI: fffff3253db78440
  RBP: ffff8b1ebf803dd0   R8: ffff8b1ebcd9b0c0   R9: 0000000000000000
  R10: ffff8b1e38a30808  R11: 0000000000001000  R12: 00000000000003e9
  R13: 0000000000000000  R14: ffff8b1ebcd9d740  R15: 0000000000000028
  ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
10 [ffff8b1ebf803cb0] enqueue_entity at ffffffffafce708f
11 [ffff8b1ebf803d00] enqueue_task_fair at ffffffffafce7b88
12 [ffff8b1ebf803dd8] qla24xx_process_response_queue at ffffffffc04fc9a6
[qla2xxx]
13 [ffff8b1ebf803e78] qla24xx_msix_rsp_q at ffffffffc04ff01b [qla2xxx]
14 [ffff8b1ebf803eb0] __handle_irq_event_percpu at ffffffffafd50714

Link: https://lore.kernel.org/r/20210908164622.19240-10-njavali@marvell.com
Fixes: f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort path")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Co-developed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Co-developed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Orabug: 34970763

(cherry picked from commit 3d33b303d4f3b74a71bede5639ebba3cfd2a2b4d)
Signed-off-by: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 71d4e83..1973e53 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1210,6 +1210,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	uint32_t ratov_j;
 	struct qla_qpair *qpair;
 	unsigned long flags;
+	int fast_fail_status = SUCCESS;
 
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8042,
@@ -1217,15 +1218,16 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
+	/* Save any FAST_IO_FAIL value to return later if abort succeeds */
 	ret = fc_block_scsi_eh(cmd);
 	if (ret != 0)
-		return ret;
+		fast_fail_status = ret;
 
 	sp = scsi_cmd_priv(cmd);
 	qpair = sp->qpair;
 
 	if ((sp->fcport && sp->fcport->deleted) || !qpair)
-		return SUCCESS;
+		return fast_fail_status != SUCCESS ? fast_fail_status : FAILED;
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	if (sp->completed) {
@@ -1276,7 +1278,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 			    __func__, ha->r_a_tov/10);
 			ret = FAILED;
 		} else {
-			ret = SUCCESS;
+			ret = fast_fail_status;
 		}
 		break;
 	default:
-- 
1.8.3.1

