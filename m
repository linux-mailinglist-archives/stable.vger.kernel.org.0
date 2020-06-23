Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FD6205415
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 16:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgFWODT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 10:03:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732730AbgFWODT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 10:03:19 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDXsR3164073;
        Tue, 23 Jun 2020 10:03:12 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31ufgj7pbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 10:03:11 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05NE1Lj4006853;
        Tue, 23 Jun 2020 14:03:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 31uk330060-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 14:03:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05NE32Z035127636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 14:03:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BE34A405E;
        Tue, 23 Jun 2020 14:03:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39F16A4040;
        Tue, 23 Jun 2020 14:03:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Jun 2020 14:03:02 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] zfcp: fix panic on ERP timeout for previously dismissed ERP action
Date:   Tue, 23 Jun 2020 16:02:42 +0200
Message-Id: <20200623140242.98864-1-maier@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=2
 priorityscore=1501 mlxscore=0 mlxlogscore=993 impostorscore=0 spamscore=0
 adultscore=0 cotscore=-2147483648 clxscore=1011 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230108
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Suppose that, for unrelated reasons, FSF requests on behalf of recovery
are very slow and can run into the ERP timeout.

In the case at hand, we did adapter recovery to a large degree.
However due to the slowness a LUN open is pending
so the corresponding fc_rport remains blocked.
After fast_io_fail_tmo we trigger close physical port recovery
for the port under which the LUN should have been opened.
The new higher order port recovery
dismisses the pending LUN open ERP action and
dismisses the pending LUN open FSF request.
Such dismissal decouples the ERP action from the pending corresponding
FSF request by setting zfcp_fsf_req->erp_action to NULL
(among other things) [zfcp_erp_strategy_check_fsfreq()].

If now the ERP timeout for the pending open LUN request runs out, we
must not use zfcp_fsf_req->erp_action in the ERP timeout handler.
This is a problem since v4.15 commit 75492a51568b ("s390/scsi: Convert
timers to use timer_setup()"). Before that we intentionally only passed
zfcp_erp_action as context argument to zfcp_erp_timeout_handler().

Note: The lifetime of the corresponding zfcp_fsf_req object continues
until a (late) response or an (unrelated) adapter recovery.

Just like the regular response path ignores dismissed requests
[zfcp_fsf_req_complete() => zfcp_fsf_protstatus_eval() => return early]
the ERP timeout handler now needs to ignore dismissed requests.
So simply return early in the ERP timeout handler if the FSF request
is marked as dismissed in its status flags.
To protect against the race where zfcp_erp_strategy_check_fsfreq()
dismisses and sets zfcp_fsf_req->erp_action to NULL after our previous
status flag check, return early if zfcp_fsf_req->erp_action is NULL.
After all, the former ERP action does not need to be woken up as that was
already done as part of the dismissal above [zfcp_erp_action_dismiss()].

This fixes the following panic due to kernel page fault in IRQ context:

Unable to handle kernel pointer dereference in virtual kernel address space
Failing address: 0000000000000000 TEID: 0000000000000483
Fault in home space mode while using kernel ASCE.
AS:000009859238c00b R2:00000e3e7ffd000b R3:00000e3e7ffcc007 S:00000e3e7ffd7000 P:000000000000013d
Oops: 0004 ilc:2 [#1] SMP
Modules linked in: ...
CPU: 82 PID: 311273 Comm: stress Kdump: loaded Tainted: G            E  X   ...
Hardware name: IBM 8561 T01 701 (LPAR)
Krnl PSW : 0404c00180000000 001fffff80549be0 (zfcp_erp_notify+0x40/0xc0 [zfcp])
           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000000080 00000e3d00000000 00000000000000f0 0000000000030000
           000000010028e700 000000000400a39c 000000010028e700 00000e3e7cf87e02
           0000000010000000 0700098591cb67f0 0000000000000000 0000000000000000
           0000033840e9a000 0000000000000000 001fffe008d6bc18 001fffe008d6bbc8
Krnl Code: 001fffff80549bd4: a7180000            lhi     %r1,0
           001fffff80549bd8: 4120a0f0            la      %r2,240(%r10)
          #001fffff80549bdc: a53e0003            llilh   %r3,3
          >001fffff80549be0: ba132000            cs      %r1,%r3,0(%r2)
           001fffff80549be4: a7740037            brc     7,1fffff80549c52
           001fffff80549be8: e320b0180004        lg      %r2,24(%r11)
           001fffff80549bee: e31020e00004        lg      %r1,224(%r2)
           001fffff80549bf4: 412020e0            la      %r2,224(%r2)
Call Trace:
 [<001fffff80549be0>] zfcp_erp_notify+0x40/0xc0 [zfcp]
 [<00000985915e26f0>] call_timer_fn+0x38/0x190
 [<00000985915e2944>] expire_timers+0xfc/0x190
 [<00000985915e2ac4>] run_timer_softirq+0xec/0x218
 [<0000098591ca7c4c>] __do_softirq+0x144/0x398
 [<00000985915110aa>] do_softirq_own_stack+0x72/0x88
 [<0000098591551b58>] irq_exit+0xb0/0xb8
 [<0000098591510c6a>] do_IRQ+0x82/0xb0
 [<0000098591ca7140>] ext_int_handler+0x128/0x12c
 [<0000098591722d98>] clear_subpage.constprop.13+0x38/0x60
([<000009859172ae4c>] clear_huge_page+0xec/0x250)
 [<000009859177e7a2>] do_huge_pmd_anonymous_page+0x32a/0x768
 [<000009859172a712>] __handle_mm_fault+0x88a/0x900
 [<000009859172a860>] handle_mm_fault+0xd8/0x1b0
 [<0000098591529ef6>] do_dat_exception+0x136/0x3e8
 [<0000098591ca6d34>] pgm_check_handler+0x1c8/0x220
Last Breaking-Event-Address:
 [<001fffff80549c88>] zfcp_erp_timeout_handler+0x10/0x18 [zfcp]
Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: 75492a51568b ("s390/scsi: Convert timers to use timer_setup()")
Cc: <stable@vger.kernel.org> #4.15+
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
---


Martin, James, this zfcp fix for a seldom panic would be something for
v5.8-rcX and applies to 5.8/scsi-fixes.


 drivers/s390/scsi/zfcp_erp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index db320dab1fee..79f6e8fb03ca 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -577,7 +577,10 @@ static void zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *act)
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
 			req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
 			zfcp_dbf_rec_run("erscf_1", act);
-			req->erp_action = NULL;
+			/* lock-free concurrent access with
+			 * zfcp_erp_timeout_handler()
+			 */
+			WRITE_ONCE(req->erp_action, NULL);
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			zfcp_dbf_rec_run("erscf_2", act);
@@ -613,8 +616,14 @@ void zfcp_erp_notify(struct zfcp_erp_action *erp_action, unsigned long set_mask)
 void zfcp_erp_timeout_handler(struct timer_list *t)
 {
 	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
-	struct zfcp_erp_action *act = fsf_req->erp_action;
+	struct zfcp_erp_action *act;
 
+	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED)
+		return;
+	/* lock-free concurrent access with zfcp_erp_strategy_check_fsfreq() */
+	act = READ_ONCE(fsf_req->erp_action);
+	if (!act)
+		return;
 	zfcp_erp_notify(act, ZFCP_STATUS_ERP_TIMEDOUT);
 }
 
-- 
2.17.1

