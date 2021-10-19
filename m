Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BAB433A2B
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 17:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhJSPYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 11:24:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13692 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233392AbhJSPYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 11:24:08 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JFDOou009389;
        Tue, 19 Oct 2021 11:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=KiaJYieEGdQ6NHlp4wTHC7+rXDJJiD2T5W7PsIzVa6U=;
 b=YAMAgfx9+R7tp5SEHDfZ0/OJnKbVJjNZa0pk77UD+u4u1RlSFvFvWPii4SOsBgpEy+GP
 qVbDsp3mQQ5cYdEroTl8+v1fQfaukXeBKGy86vPQbiEDWD+dKRsmgd6FoPPrSspnLxxK
 RSdeeQ+1bTroTmgmkrUpIMvuPlSTKuBzqVLRBUMdofQc/v727pp2g6MdPFp04d3XpkoX
 0Ec3rqfZNnXTd5pf27WX2yv8er/fT410YFl2jiFUezB3kv/n061PaMm323BKukaUxqGe
 jZfU2xBXWE7BBeOCr+mz1B3yExYLFDGFU446l2djcFaDLxZZPsB837nZaAvT3HevpoTn iQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsyr11fq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 11:21:47 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JFJvke005082;
        Tue, 19 Oct 2021 15:21:46 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 3bqpcb03ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 15:21:46 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JFLj5n54264084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 15:21:45 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCE4728059;
        Tue, 19 Oct 2021 15:21:45 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D57FC28060;
        Tue, 19 Oct 2021 15:21:44 +0000 (GMT)
Received: from li-8b42f0cc-24d8-11b2-a85c-df7e17c2bac6.ibm.com.com (unknown [9.163.9.214])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 15:21:44 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     tyreld@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH] ibmvfc: Fixup duplicate response detection
Date:   Tue, 19 Oct 2021 10:21:29 -0500
Message-Id: <20211019152129.16558-1-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RhsRGyEjjalsgAoUmkGmk-538aDJux4B
X-Proofpoint-GUID: RhsRGyEjjalsgAoUmkGmk-538aDJux4B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_01,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 clxscore=1011 suspectscore=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190090
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a264cf5e81c7 ("scsi: ibmvfc: Fix command state accounting and stale response detection")
introduced a regression in detecting duplicate responses. This was observed
in test where a command was sent to the VIOS and completed before
ibmvfc_send_event set the active flag to 1, which resulted in the
atomic_dec_if_positive call in ibmvfc_handle_crq thinking this was a
duplicate response, which resulted in scsi_done not getting called, so we
then hit a scsi command timeout for this command once the timeout expires.
This simply ensures the active flag gets set prior to making the hcall to
send the command to the VIOS, in order to close this window.

Fixes: a264cf5e81c7 ("scsi: ibmvfc: Fix command state accounting and stale response detection")
Cc: stable@vger.kernel.org
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a4b0a12f8a97..d0eab5700dc5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1696,6 +1696,7 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 
 	spin_lock_irqsave(&evt->queue->l_lock, flags);
 	list_add_tail(&evt->queue_list, &evt->queue->sent);
+	atomic_set(&evt->active, 1);
 
 	mb();
 
@@ -1710,6 +1711,7 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 				     be64_to_cpu(crq_as_u64[1]));
 
 	if (rc) {
+		atomic_set(&evt->active, 0);
 		list_del(&evt->queue_list);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		del_timer(&evt->timer);
@@ -1737,7 +1739,6 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 
 		evt->done(evt);
 	} else {
-		atomic_set(&evt->active, 1);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		ibmvfc_trc_start(evt);
 	}
-- 
2.27.0

