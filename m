Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E5E3B96CD
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 21:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhGAT7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 15:59:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229894AbhGAT7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 15:59:38 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161JjFNK090404;
        Thu, 1 Jul 2021 15:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8hv9RB4/CWmpqenUMWja7sLMqtPGJePkzN6+KnRTTBQ=;
 b=VICRWYGlJOvcuvABbl3xVm/7/Sk3AREgzMxZ4Yapo2DEuVbL8lvG2h6KBvYsJDqrENER
 DWBag0p85Yp3ckvMylv8srmrXvHv3+3BnFIsfVMoSJ/zYt7ZNIfs/c8r2wq5ATrDNHMj
 yTHc+IDZ2/H1uoVZiWLV9UOqMqEOSdWVZiqqpWheTsQq4N/x8ITSDsX7chs+1i0Tycm2
 3y2sskI4D8RQ9hBSFZU+cYH9tnE2Lqsx5sYYoHqnbrKXm2Cyv+NmZcaK+hZQym64Vp+G
 kiY5sMu26APpwZHG5IR5/JfqkFX7fO1VdfXdCMRXxehYmEMw3DlltmM4eLDJcIEAIzCb rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39hm4wg8p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jul 2021 15:57:04 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 161JtTCM143263;
        Thu, 1 Jul 2021 15:57:04 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39hm4wg8nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jul 2021 15:57:04 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 161JrNoX032577;
        Thu, 1 Jul 2021 19:57:03 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 39duvfj1fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jul 2021 19:57:03 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 161Jv1FA47448352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jul 2021 19:57:01 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C03EC6E050;
        Thu,  1 Jul 2021 19:57:01 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78CA36E053;
        Thu,  1 Jul 2021 19:57:01 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jul 2021 19:57:01 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        ming.lei@redhat.com
Cc:     james.bottomley@hansenpartnership.com, brking@linux.ibm.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH] scsi: core: fix bad pointer dereference when ehandler kthread is invalid
Date:   Thu,  1 Jul 2021 13:56:59 -0600
Message-Id: <20210701195659.3185475-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c0eJlrrgD9Iisd4cuWTNeHhbIefHBC50
X-Proofpoint-GUID: ycmWGsdOMl3o37JtDzz01rEZNoXq0rsT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_12:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 clxscore=1011 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010114
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 66a834d ("scsi: core: Fix error handling of scsi_host_alloc()")
changed the allocation logic to call put_device() to perform host
cleanup with the assumption that IDA removal and stopping the kthread
would properly be peformed in scsi_host_dev_release(). However, in the
unlikely case that the error handler thread fails to spawn
shost->ehandler is set to ERR_PTR(-ENOMEM). The error handler cleanup
code in scsi_host_dev_release() will call kthread_stop() if
shost->ehandler != NULL which will always be the case whether the
kthread was succesfully spawned or not. In the case that it failed to
spawn this has the nasty side effect of trying to dereference an
invalid pointer when kthread_stop() is called. The follwing splat
provides an example of this behavior in the wild:

scsi host11: error handler thread failed to spawn, error = -4
Kernel attempted to read user page (10c) - exploit attempt? (uid: 0)
BUG: Kernel NULL pointer dereference on read at 0x0000010c
Faulting instruction address: 0xc00000000818e9a8
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: ibmvscsi(+) scsi_transport_srp dm_multipath dm_mirror dm_region
 hash dm_log dm_mod fuse overlay squashfs loop
CPU: 12 PID: 274 Comm: systemd-udevd Not tainted 5.13.0-rc7 #1
NIP:  c00000000818e9a8 LR: c0000000089846e8 CTR: 0000000000007ee8
REGS: c000000037d12ea0 TRAP: 0300   Not tainted  (5.13.0-rc7)
MSR:  800000000280b033 &lt;SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE&gt;  CR: 28228228
XER: 20040001
CFAR: c0000000089846e4 DAR: 000000000000010c DSISR: 40000000 IRQMASK: 0
GPR00: c0000000089846e8 c000000037d13140 c000000009cc1100 fffffffffffffffc
GPR04: 0000000000000001 0000000000000000 0000000000000000 c000000037dc0000
GPR08: 0000000000000000 c000000037dc0000 0000000000000001 00000000fffff7ff
GPR12: 0000000000008000 c00000000a049000 c000000037d13d00 000000011134d5a0
GPR16: 0000000000001740 c0080000190d0000 c0080000190d1740 c000000009129288
GPR20: c000000037d13bc0 0000000000000001 c000000037d13bc0 c0080000190b7898
GPR24: c0080000190b7708 0000000000000000 c000000033bb2c48 0000000000000000
GPR28: c000000046b28280 0000000000000000 000000000000010c fffffffffffffffc
NIP [c00000000818e9a8] kthread_stop+0x38/0x230
LR [c0000000089846e8] scsi_host_dev_release+0x98/0x160
Call Trace:
[c000000033bb2c48] 0xc000000033bb2c48 (unreliable)
[c0000000089846e8] scsi_host_dev_release+0x98/0x160
[c00000000891e960] device_release+0x60/0x100
[c0000000087e55c4] kobject_release+0x84/0x210
[c00000000891ec78] put_device+0x28/0x40
[c000000008984ea4] scsi_host_alloc+0x314/0x430
[c0080000190b38bc] ibmvscsi_probe+0x54/0xad0 [ibmvscsi]
[c000000008110104] vio_bus_probe+0xa4/0x4b0
[c00000000892a860] really_probe+0x140/0x680
[c00000000892aefc] driver_probe_device+0x15c/0x200
[c00000000892b63c] device_driver_attach+0xcc/0xe0
[c00000000892b740] __driver_attach+0xf0/0x200
[c000000008926f28] bus_for_each_dev+0xa8/0x130
[c000000008929ce4] driver_attach+0x34/0x50
[c000000008928fc0] bus_add_driver+0x1b0/0x300
[c00000000892c798] driver_register+0x98/0x1a0
[c00000000810eb60] __vio_register_driver+0x80/0xe0
[c0080000190b4a30] ibmvscsi_module_init+0x9c/0xdc [ibmvscsi]
[c0000000080121d0] do_one_initcall+0x60/0x2d0
[c000000008261abc] do_init_module+0x7c/0x320
[c000000008265700] load_module+0x2350/0x25b0
[c000000008265cb4] __do_sys_finit_module+0xd4/0x160
[c000000008031110] system_call_exception+0x150/0x2d0
[c00000000800d35c] system_call_common+0xec/0x278

Fix this be nulling shost->ehandler when the kthread fails to spawn.

Cc: stable@vger.kernel.org
Fixes: 66a834d ("scsi: core: Fix error handling of scsi_host_alloc()")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/hosts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index cd52664920e1..00ec0b9e9dbb 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -485,6 +485,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
+		shost->ehandler = NULL;
 		goto fail;
 	}
 
-- 
2.27.0

