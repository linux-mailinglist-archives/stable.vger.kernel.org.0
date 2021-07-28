Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5183D8D70
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 14:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhG1MF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 08:05:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50990 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234805AbhG1MFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 08:05:25 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SC2VdD101996;
        Wed, 28 Jul 2021 08:05:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IQu+wCH9h7nDTOSHQeUwEGhSI28OKU5cShZSQ8xx/uw=;
 b=jSy+XZOaPcxAhtNsegAIez5qIsGtjbahHYn5lu32mUuck3t76OQQoRH7mPLp/tczyaTF
 a0o1jDf4c5IiPcaMtv2e88Y0jQx8UKzAm4FJ3mvqk5TC9zvhum9QqEna1PZ3xcVmlus2
 7oqi2I9JJ7J3lX+qEK24RXE+3oX6JtFlyXdET60xfmoFugDrT4aobokYjVsBkyNLCeZR
 D8EHQXFQFks3bT7SFNljhYuK4YIWPJHZOLeQ875kY0BI9/atzuvD1vheginSf3pUpcnO
 ZEzrCcU0sRwrCaOofktxlokCVlG4Y3xQmt8JaVWGWQOI6X9YhTLIwPBL8j8ekZ9aK9k/ lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a36g897k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 08:05:14 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SC5D2m134022;
        Wed, 28 Jul 2021 08:05:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a36g897h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 08:05:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SC2pui009742;
        Wed, 28 Jul 2021 12:05:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3a235yh1fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 12:05:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SC58f731392066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 12:05:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9793111C050;
        Wed, 28 Jul 2021 12:05:08 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD98F11C058;
        Wed, 28 Jul 2021 12:05:05 +0000 (GMT)
Received: from pratiks-thinkpad.ibmuc.com (unknown [9.85.80.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 12:05:05 +0000 (GMT)
From:   "Pratik R. Sampat" <psampat@linux.ibm.com>
To:     mpe@ellerman.id.au, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: [PATCH v2 1/1] cpufreq:powernv: Fix init_chip_info initialization in numa=off
Date:   Wed, 28 Jul 2021 17:35:00 +0530
Message-Id: <20210728120500.87549-2-psampat@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728120500.87549-1-psampat@linux.ibm.com>
References: <20210728120500.87549-1-psampat@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yy9xZxCFGgnQXWxN30-uVWG8VmOn6ZmQ
X-Proofpoint-ORIG-GUID: 5nhJnAlooTf6GZS1GKBZpkDtRQGvr6iq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280068
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
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
---
 drivers/cpufreq/powernv-cpufreq.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 005600cef273..5f0e7c315e49 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -36,6 +36,7 @@
 #define MAX_PSTATE_SHIFT	32
 #define LPSTATE_SHIFT		48
 #define GPSTATE_SHIFT		56
+#define MAX_NR_CHIPS		32
 
 #define MAX_RAMP_DOWN_TIME				5120
 /*
@@ -1046,12 +1047,20 @@ static int init_chip_info(void)
 	unsigned int *chip;
 	unsigned int cpu, i;
 	unsigned int prev_chip_id = UINT_MAX;
+	cpumask_t *chip_cpu_mask;
 	int ret = 0;
 
 	chip = kcalloc(num_possible_cpus(), sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
+	/* Allocate a chip cpu mask large enough to fit mask for all chips */
+	chip_cpu_mask = kcalloc(MAX_NR_CHIPS, sizeof(cpumask_t), GFP_KERNEL);
+	if (!chip_cpu_mask) {
+		ret = -ENOMEM;
+		goto free_and_return;
+	}
+
 	for_each_possible_cpu(cpu) {
 		unsigned int id = cpu_to_chip_id(cpu);
 
@@ -1059,22 +1068,25 @@ static int init_chip_info(void)
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

