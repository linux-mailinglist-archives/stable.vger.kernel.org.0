Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B052CD566
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 13:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbgLCMVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 07:21:43 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42258 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388034AbgLCMVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 07:21:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3CFPi9126840;
        Thu, 3 Dec 2020 12:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=5kE4tnaIOoWss+wgn2FM156GixL1Gar5ddM0M3j3rvU=;
 b=dJjfz5qs2JVgWiSsqHNpQOmb5inr2oiLjB9OgiG2hl3bGpcfjcI9tIx8TO2VCI2IWTjB
 n2ZAVo+fvSIDIzfhMN0CZb9i9lHPRzelf6RGgCdD23aPptKspTkmAPUGf0YjQinI+Vuu
 emKaLfkIVfvwm/KYyaQk8Wslv3EsXA/70rdkCJyn/GuiV8bbw4wfboj5ATPG+gRgmpCP
 OcrEtNpHzUn0092A3F0skPcMQ8rHemLsAWlOsx9I8kI2muYaJ9hMBf05/4QHK3o6O4a1
 nko0kdJ4vGKOtfAM5zuxRuHCzvRwVRPFXHVWRVMM9ZZDq9MWoWfbAD4jpMX1TpDhGBCd Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2b5nam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 12:18:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3CGF4W002649;
        Thu, 3 Dec 2020 12:18:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540f1rv3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 12:18:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3CIZ6C007548;
        Thu, 3 Dec 2020 12:18:35 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 04:18:34 -0800
Date:   Thu, 3 Dec 2020 15:18:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Cc:     James.Bottomley@suse.de,
        jayamohank@hdredirect-lb5-1afb6e2973825a56.elb.us-east-1.amazonaws.com,
        jejb@linux.ibm.com, jitendra.bhivare@broadcom.com,
        kernel-janitors@vger.kernel.org, ketan.mukadam@broadcom.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, subbu.seetharaman@broadcom.com,
        stable@vger.kernel.org
Subject: [PATCH] scsi: be2iscsi: revert "Fix a theoretical leak in
 beiscsi_create_eqs()"
Message-ID: <X8jXkt6eThjyVP1v@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54f36c62-10bf-8736-39ce-27ece097d9de@proxmox.com>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My patch caused kernel Oopses and delays in boot.  Revert it.

The problem was that I moved the "mem->dma = paddr;" before the call to
be_fill_queue().  But the first thing that the be_fill_queue() function
does is memset the whole struct to zero which overwrites the assignment.

Fixes: 38b2db564d9a ("scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()")
Reported-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
My original patch was basically a clean up patch and to try silence a
static checker warning.  I've already updated the static checker to not
warn about impossible leaks and in this case we know that be_fill_queue()
cannot fail.

I was tempted to delete the "mem->va = eq_vaddress;" assignment as a
clean up but I didn't.  :P

 drivers/scsi/be2iscsi/be_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 50e464224d47..90fcddb76f46 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3020,7 +3020,6 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			goto create_eq_error;
 		}
 
-		mem->dma = paddr;
 		mem->va = eq_vaddress;
 		ret = be_fill_queue(eq, phba->params.num_eq_entries,
 				    sizeof(struct be_eq_entry), eq_vaddress);
@@ -3030,6 +3029,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			goto create_eq_error;
 		}
 
+		mem->dma = paddr;
 		ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
 					    BEISCSI_EQ_DELAY_DEF);
 		if (ret) {
@@ -3086,7 +3086,6 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			goto create_cq_error;
 		}
 
-		mem->dma = paddr;
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
@@ -3096,6 +3095,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			goto create_cq_error;
 		}
 
+		mem->dma = paddr;
 		ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false,
 					    false, 0);
 		if (ret) {
-- 
2.29.2

