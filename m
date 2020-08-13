Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB637243C79
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 17:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgHMP33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 11:29:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17134 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726249AbgHMP32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 11:29:28 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DF5fWu062752;
        Thu, 13 Aug 2020 11:29:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=fEApjQ32ZlCsV+pRD9M5xHULiwiX0puoetNqBdtPEcE=;
 b=mD8zyB9gXYSZW4HuuN/u4nuYL9t7hhb/1OMkIIfaqbiRc76Tu0CWpmwnqVxMB/NFO9cj
 iGGIiHwUuIEszjyn3aRpo7fP9Cro4Ro74Xz7F1hNjAiwMqFDVUEYd32CoWcTU6b6gMVw
 du0Vbszs3be3yPBrgLuj7J1ySUvfwEt29aFAGh6NsxZvQoVgw8W0IUawNm1k9IQ0EcgR
 y5m7qkH0j6ARFnV9YVpu/SI0n73cSS37ULsiuc2uHPB/fHg8WVKb2QnyuigIQvpmQ0rf
 OgaqLbOetiPGPZkvooEsX/03TxEOqZLCWSObi/tpRBhOfxqN+U6Cuc7SEnlqbQcn6PNO Qg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w5mwdt78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 11:29:25 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DFOo4H024475;
        Thu, 13 Aug 2020 15:29:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 32skp8dpep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 15:29:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DFTKID27132204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 15:29:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C717AE05F;
        Thu, 13 Aug 2020 15:29:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D85C6AE057;
        Thu, 13 Aug 2020 15:29:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 15:29:19 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH] zfcp: fix use-after-free in request timeout handlers
Date:   Thu, 13 Aug 2020 17:28:56 +0200
Message-Id: <20200813152856.50088-1-maier@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_14:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=2 clxscore=1011 impostorscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008130114
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before v4.15 commit 75492a51568b ("s390/scsi: Convert timers to use
timer_setup()"), we intentionally only passed zfcp_adapter as context
argument to zfcp_fsf_request_timeout_handler(). Since we only trigger
adapter recovery, it was unnecessary to sync against races between timeout
and (late) completion.
Likewise, we only passed zfcp_erp_action as context argument to
zfcp_erp_timeout_handler(). Since we only wakeup an ERP action, it was
unnecessary to sync against races between timeout and (late) completion.

Meanwhile the timeout handlers get timer_list as context argument
and do a timer-specific container-of to zfcp_fsf_req which can have
been freed.

Fix it by making sure that any request timeout handlers, that might
just have started before del_timer(), are completed by using
del_timer_sync() instead. This ensures the request free happens
afterwards.

Space time diagram of potential use-after-free:

Basic idea is to have 2 or more pending requests whose timeouts run
out at almost the same time.

req 1 timeout     ERP thread        req 2 timeout
----------------  ----------------  ---------------------------------------
zfcp_fsf_request_timeout_handler
fsf_req = from_timer(fsf_req, t, timer)
adapter = fsf_req->adapter
zfcp_qdio_siosl(adapter)
zfcp_erp_adapter_reopen(adapter,...)
                  zfcp_erp_strategy
                  ...
                  zfcp_fsf_req_dismiss_all
                  list_for_each_entry_safe
                    zfcp_fsf_req_complete 1
                    del_timer 1
                    zfcp_fsf_req_free 1
                    zfcp_fsf_req_complete 2
                                    zfcp_fsf_request_timeout_handler
                    del_timer 2
                                    fsf_req = from_timer(fsf_req, t, timer)
                    zfcp_fsf_req_free 2
                                    adapter = fsf_req->adapter
                                              ^^^^^^^ already freed

Suggested-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Fixes: 75492a51568b ("s390/scsi: Convert timers to use timer_setup()")
Cc: <stable@vger.kernel.org> #4.15+
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c795f22249d8..140186fe1d1e 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -434,7 +434,7 @@ static void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
 		return;
 	}
 
-	del_timer(&req->timer);
+	del_timer_sync(&req->timer);
 	zfcp_fsf_protstatus_eval(req);
 	zfcp_fsf_fsfstatus_eval(req);
 	req->handler(req);
@@ -867,7 +867,7 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 	req->qdio_req.qdio_outb_usage = atomic_read(&qdio->req_q_free);
 	req->issued = get_tod_clock();
 	if (zfcp_qdio_send(qdio, &req->qdio_req)) {
-		del_timer(&req->timer);
+		del_timer_sync(&req->timer);
 		/* lookup request again, list might have changed */
 		zfcp_reqlist_find_rm(adapter->req_list, req_id);
 		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1");
-- 
2.17.1

