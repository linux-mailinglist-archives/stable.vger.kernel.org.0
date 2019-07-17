Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D76D6BA59
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbfGQKfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 06:35:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbfGQKfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 06:35:55 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6HAWDGa063111
        for <stable@vger.kernel.org>; Wed, 17 Jul 2019 06:35:53 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tt0pmv15h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 17 Jul 2019 06:35:53 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ego@linux.vnet.ibm.com>;
        Wed, 17 Jul 2019 11:35:52 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 17 Jul 2019 11:35:48 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6HAZls328967204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 10:35:48 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4B8BAE063;
        Wed, 17 Jul 2019 10:35:47 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37B25AE05F;
        Wed, 17 Jul 2019 10:35:47 +0000 (GMT)
Received: from sofia.ibm.com (unknown [9.199.56.245])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jul 2019 10:35:47 +0000 (GMT)
Received: by sofia.ibm.com (Postfix, from userid 1000)
        id 8E42F2E2F43; Wed, 17 Jul 2019 16:05:43 +0530 (IST)
From:   "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Breno Leitao <leitao@debian.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] powerpc/xive: Fix loop exit-condition in xive_find_target_in_mask()
Date:   Wed, 17 Jul 2019 16:05:24 +0530
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19071710-0060-0000-0000-0000036236CF
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011444; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01233404; UDB=6.00649903; IPR=6.01014728;
 MB=3.00027758; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-17 10:35:51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071710-0061-0000-0000-00004A2F7E98
Message-Id: <1563359724-13931-1-git-send-email-ego@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-17_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907170128
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>

xive_find_target_in_mask() has the following for(;;) loop which has a
bug when @first == cpumask_first(@mask) and condition 1 fails to hold
for every CPU in @mask. In this case we loop forever in the for-loop.

  first = cpu;
  for (;;) {
  	  if (cpu_online(cpu) && xive_try_pick_target(cpu)) // condition 1
		  return cpu;
	  cpu = cpumask_next(cpu, mask);
	  if (cpu == first) // condition 2
		  break;

	  if (cpu >= nr_cpu_ids) // condition 3
		  cpu = cpumask_first(mask);
  }

This is because, when @first == cpumask_first(@mask), we never hit the
condition 2 (cpu == first) since prior to this check, we would have
executed "cpu = cpumask_next(cpu, mask)" which will set the value of
@cpu to a value greater than @first or to nr_cpus_ids. When this is
coupled with the fact that condition 1 is not met, we will never exit
this loop.

This was discovered by the hard-lockup detector while running LTP test
concurrently with SMT switch tests.

 watchdog: CPU 12 detected hard LOCKUP on other CPUs 68
 watchdog: CPU 12 TB:85587019220796, last SMP heartbeat TB:85578827223399 (15999ms ago)
 watchdog: CPU 68 Hard LOCKUP
 watchdog: CPU 68 TB:85587019361273, last heartbeat TB:85576815065016 (19930ms ago)
 CPU: 68 PID: 45050 Comm: hxediag Kdump: loaded Not tainted 4.18.0-100.el8.ppc64le #1
 NIP:  c0000000006f5578 LR: c000000000cba9ec CTR: 0000000000000000
 REGS: c000201fff3c7d80 TRAP: 0100   Not tainted  (4.18.0-100.el8.ppc64le)
 MSR:  9000000002883033 <SF,HV,VEC,VSX,FP,ME,IR,DR,RI,LE>  CR: 24028424  XER: 00000000
 CFAR: c0000000006f558c IRQMASK: 1
 GPR00: c0000000000afc58 c000201c01c43400 c0000000015ce500 c000201cae26ec18
 GPR04: 0000000000000800 0000000000000540 0000000000000800 00000000000000f8
 GPR08: 0000000000000020 00000000000000a8 0000000080000000 c00800001a1beed8
 GPR12: c0000000000b1410 c000201fff7f4c00 0000000000000000 0000000000000000
 GPR16: 0000000000000000 0000000000000000 0000000000000540 0000000000000001
 GPR20: 0000000000000048 0000000010110000 c00800001a1e3780 c000201cae26ed18
 GPR24: 0000000000000000 c000201cae26ed8c 0000000000000001 c000000001116bc0
 GPR28: c000000001601ee8 c000000001602494 c000201cae26ec18 000000000000001f
 NIP [c0000000006f5578] find_next_bit+0x38/0x90
 LR [c000000000cba9ec] cpumask_next+0x2c/0x50
 Call Trace:
 [c000201c01c43400] [c000201cae26ec18] 0xc000201cae26ec18 (unreliable)
 [c000201c01c43420] [c0000000000afc58] xive_find_target_in_mask+0x1b8/0x240
 [c000201c01c43470] [c0000000000b0228] xive_pick_irq_target.isra.3+0x168/0x1f0
 [c000201c01c435c0] [c0000000000b1470] xive_irq_startup+0x60/0x260
 [c000201c01c43640] [c0000000001d8328] __irq_startup+0x58/0xf0
 [c000201c01c43670] [c0000000001d844c] irq_startup+0x8c/0x1a0
 [c000201c01c436b0] [c0000000001d57b0] __setup_irq+0x9f0/0xa90
 [c000201c01c43760] [c0000000001d5aa0] request_threaded_irq+0x140/0x220
 [c000201c01c437d0] [c00800001a17b3d4] bnx2x_nic_load+0x188c/0x3040 [bnx2x]
 [c000201c01c43950] [c00800001a187c44] bnx2x_self_test+0x1fc/0x1f70 [bnx2x]
 [c000201c01c43a90] [c000000000adc748] dev_ethtool+0x11d8/0x2cb0
 [c000201c01c43b60] [c000000000b0b61c] dev_ioctl+0x5ac/0xa50
 [c000201c01c43bf0] [c000000000a8d4ec] sock_do_ioctl+0xbc/0x1b0
 [c000201c01c43c60] [c000000000a8dfb8] sock_ioctl+0x258/0x4f0
 [c000201c01c43d20] [c0000000004c9704] do_vfs_ioctl+0xd4/0xa70
 [c000201c01c43de0] [c0000000004ca274] sys_ioctl+0xc4/0x160
 [c000201c01c43e30] [c00000000000b388] system_call+0x5c/0x70
 Instruction dump:
 78aad182 54a806be 3920ffff 78a50664 794a1f24 7d294036 7d43502a 7d295039
 4182001c 48000034 78a9d182 79291f24 <7d23482a> 2fa90000 409e0020 38a50040

To fix this, move the check for condition 2 after the check for
condition 3, so that we are able to break out of the loop soon after
iterating through all the CPUs in the @mask in the problem case. Use
do..while() to achieve this.

Fixes: 243e25112d06 ("powerpc/xive: Native exploitation of the XIVE
interrupt controller")
Cc: <stable@vger.kernel.org> # 4.12+
Reported-by: Indira P. Joga <indira.priya@in.ibm.com>
Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
---
 arch/powerpc/sysdev/xive/common.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 082c7e1..1cdb395 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -479,7 +479,7 @@ static int xive_find_target_in_mask(const struct cpumask *mask,
 	 * Now go through the entire mask until we find a valid
 	 * target.
 	 */
-	for (;;) {
+	do {
 		/*
 		 * We re-check online as the fallback case passes us
 		 * an untested affinity mask
@@ -487,12 +487,11 @@ static int xive_find_target_in_mask(const struct cpumask *mask,
 		if (cpu_online(cpu) && xive_try_pick_target(cpu))
 			return cpu;
 		cpu = cpumask_next(cpu, mask);
-		if (cpu == first)
-			break;
 		/* Wrap around */
 		if (cpu >= nr_cpu_ids)
 			cpu = cpumask_first(mask);
-	}
+	} while (cpu != first);
+
 	return -1;
 }
 
-- 
1.9.4

