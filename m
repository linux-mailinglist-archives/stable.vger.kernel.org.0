Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBA01837E9
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 18:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgCLRpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 13:45:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726362AbgCLRpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 13:45:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHYUUU071818
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 13:45:21 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yqskk8hw5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 13:45:21 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:19 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:17 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHiFiP48890306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:44:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2E5A52052;
        Thu, 12 Mar 2020 17:45:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 59D7A5204F;
        Thu, 12 Mar 2020 17:45:15 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH 01/10] zfcp: fix missing erp_lock in port recovery trigger for point-to-point
Date:   Thu, 12 Mar 2020 18:44:56 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312174505.51294-1-maier@linux.ibm.com>
References: <20200312174505.51294-1-maier@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031217-4275-0000-0000-000003AB4651
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-4276-0000-0000-000038C065A8
Message-Id: <20200312174505.51294-2-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_11:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1011 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120089
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v2.6.27 commit cc8c282963bd ("[SCSI] zfcp: Automatically attach remote
ports") introduced zfcp automatic port scan.

Before that, the user had to use the sysfs attribute "port_add" of an
FCP device (adapter) to add and open remote (target) ports, even for
the remote peer port in point-to-point topology. That code path did a
proper port open recovery trigger taking the erp_lock.

Since above commit, a new helper function zfcp_erp_open_ptp_port()
performed an UNlocked port open recovery trigger. This can race with
other parallel recovery triggers. In zfcp_erp_action_enqueue() this could
corrupt e.g. adapter->erp_total_count or adapter->erp_ready_head.

As already found for fabric topology in v4.17 commit fa89adba1941
("scsi: zfcp: fix infinite iteration on ERP ready list"), there was
an endless loop during tracing of rport (un)block.
A subsequent v4.18 commit 9e156c54ace3 ("scsi: zfcp: assert that the
ERP lock is held when tracing a recovery trigger") introduced a lockdep
assertion for that case.

As a side effect, that lockdep assertion now uncovered the unlocked
code path for PtP. It is from within an adapter ERP action:

zfcp_erp_strategy[1479]  intentionally DROPs erp lock around
                         zfcp_erp_strategy_do_action()
zfcp_erp_strategy_do_action[1441]      NO erp lock
zfcp_erp_adapter_strategy[876]         NO erp lock
zfcp_erp_adapter_strategy_open[855]    NO erp lock
zfcp_erp_adapter_strategy_open_fsf[806]NO erp lock
zfcp_erp_adapter_strat_fsf_xconf[772]  erp lock only around
                                       zfcp_erp_action_to_running(),
                                       BUT *_not_* around
                                       zfcp_erp_enqueue_ptp_port()
zfcp_erp_enqueue_ptp_port[728]         BUG: *_not_* taking erp lock
_zfcp_erp_port_reopen[432]             assumes to be called with erp lock
zfcp_erp_action_enqueue[314]           assumes to be called with erp lock
zfcp_dbf_rec_trig[288]                 _checks_ to be called with erp lock:
	lockdep_assert_held(&adapter->erp_lock);

It causes the following lockdep warning:

WARNING: CPU: 2 PID: 775 at drivers/s390/scsi/zfcp_dbf.c:288
                            zfcp_dbf_rec_trig+0x16a/0x188
no locks held by zfcperp0.0.17c0/775.

Fix this by using the proper locked recovery trigger helper function.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: cc8c282963bd ("[SCSI] zfcp: Automatically attach remote ports")
Cc: <stable@vger.kernel.org> #v2.6.27+
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 93655b85b73f..18a6751299f9 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -725,7 +725,7 @@ static void zfcp_erp_enqueue_ptp_port(struct zfcp_adapter *adapter)
 				 adapter->peer_d_id);
 	if (IS_ERR(port)) /* error or port already attached */
 		return;
-	_zfcp_erp_port_reopen(port, 0, "ereptp1");
+	zfcp_erp_port_reopen(port, 0, "ereptp1");
 }
 
 static enum zfcp_erp_act_result zfcp_erp_adapter_strat_fsf_xconf(
-- 
2.17.1

