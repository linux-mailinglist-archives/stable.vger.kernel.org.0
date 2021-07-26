Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1EB3D652E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 19:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhGZQ2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 12:28:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47774 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243335AbhGZQ1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 12:27:51 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QH3nxF161959;
        Mon, 26 Jul 2021 13:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=PPHIk19j2zkNcxZZlTJxjLDQCtLPXdvL9yQEAb3r99w=;
 b=DF5zbsEl2zweSYSxviPiIHu96bLgGCbx8EjHXo3RZj02fVHMvTFq1OqXDwZT3yg9a88d
 nLQkTvAmmQ1ke/f1pUNM9gwRpzmONnQBuJIJHRoBBN62LmEJcT5nT/E2o5N6yROhfuYB
 KdWHu/XHccHOgoe3xoTFcNktUo0slgO5zayHMguj9gXfTiyz29FbnZkwtPUdBfnNW/mT
 U4rdbDTW9KrC0X588SmQj4yVDOBwEA+8PG83HccoJBS5EZsVUm/CAJz/0DBShEb03Uni
 Z6xYioxWr4PmKzZJXdY42Z/DXYcwsyTFYdKZhRI5mxgB1z0awlprORCE2YeapvynWe7W fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a20e1sn97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 13:08:06 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16QH3slJ164567;
        Mon, 26 Jul 2021 13:08:06 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a20e1sn8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 13:08:06 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16QH5vEl004392;
        Mon, 26 Jul 2021 17:08:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3a0ag8rstx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 17:08:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16QH81SK28705262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 17:08:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC98A4C052;
        Mon, 26 Jul 2021 17:08:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F0D04C044;
        Mon, 26 Jul 2021 17:07:59 +0000 (GMT)
Received: from pratiks-thinkpad.ibmuc.com (unknown [9.199.55.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 26 Jul 2021 17:07:58 +0000 (GMT)
From:   "Pratik R. Sampat" <psampat@linux.ibm.com>
To:     mpe@ellerman.id.au, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: [PATCH] cpufreq:powernv: Fix init_chip_info initialization in numa=off
Date:   Mon, 26 Jul 2021 22:37:57 +0530
Message-Id: <20210726170758.61041-1-psampat@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DPbsWMXae3DWyGROJPGnTZNKQDsvKhsx
X-Proofpoint-GUID: 8RmMpLKmoHjvsq9AyLbV2F8ZZtX5rtie
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_10:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 clxscore=1011 mlxlogscore=999 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107260099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the numa=off kernel command-line configuration init_chip_info() loops
around the number of chips and attempts to copy the cpumask of that node
which is NULL for all iterations after the first chip.

Hence, store the cpu mask for each chip instead of derving cpumask from
node while populating the "chips" struct array and copy that to the
chips[i].mask

Cc: stable@vger.kernel.org
Fixes: 053819e0bf84 ("cpufreq: powernv: Handle throttling due to Pmax capping at chip level")
Signed-off-by: Pratik R. Sampat <psampat@linux.ibm.com>
Reported-by: Shirisha Ganta <shirisha.ganta1@ibm.com>
---
 drivers/cpufreq/powernv-cpufreq.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 005600cef273..8ec10d9aed8f 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -1046,12 +1046,20 @@ static int init_chip_info(void)
 	unsigned int *chip;
 	unsigned int cpu, i;
 	unsigned int prev_chip_id = UINT_MAX;
+	cpumask_t *chip_cpu_mask;
 	int ret = 0;
 
 	chip = kcalloc(num_possible_cpus(), sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
+	/* Allocate a chip cpu mask large enough to fit mask for all chips */
+	chip_cpu_mask = kcalloc(32, sizeof(cpumask_t), GFP_KERNEL);
+	if (!chip_cpu_mask) {
+		ret = -ENOMEM;
+		goto free_and_return;
+	}
+
 	for_each_possible_cpu(cpu) {
 		unsigned int id = cpu_to_chip_id(cpu);
 
@@ -1059,22 +1067,25 @@ static int init_chip_info(void)
 			prev_chip_id = id;
 			chip[nr_chips++] = id;
 		}
+		cpumask_set_cpu(cpu, &chip_cpu_mask[nr_chips-1]);
 	}
 
 	chips = kcalloc(nr_chips, sizeof(struct chip), GFP_KERNEL);
 	if (!chips) {
 		ret = -ENOMEM;
-		goto free_and_return;
+		goto out_chip_cpu_mask;
 	}
 
 	for (i = 0; i < nr_chips; i++) {
 		chips[i].id = chip[i];
-		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
+		cpumask_copy(&chips[i].mask, &chip_cpu_mask[i]);
 		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
 		for_each_cpu(cpu, &chips[i].mask)
 			per_cpu(chip_info, cpu) =  &chips[i];
 	}
 
+out_chip_cpu_mask:
+	kfree(chip_cpu_mask);
 free_and_return:
 	kfree(chip);
 	return ret;
-- 
2.31.1

