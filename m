Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B79DA6E6
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 10:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392880AbfJQIFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 04:05:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727791AbfJQIFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 04:05:18 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9H82dWj033636
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 04:05:17 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vpjakvc3d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 04:05:17 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <sandipan@linux.ibm.com>;
        Thu, 17 Oct 2019 09:05:13 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 17 Oct 2019 09:05:11 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9H85AOE50069688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 08:05:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ADCBA4062;
        Thu, 17 Oct 2019 08:05:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A89ABA4054;
        Thu, 17 Oct 2019 08:05:08 +0000 (GMT)
Received: from tpad450.ibmuc.com (unknown [9.199.32.220])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Oct 2019 08:05:08 +0000 (GMT)
From:   Sandipan Das <sandipan@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH stable 4.14 2/6] powerpc/book3s64/mm: Don't do tlbie fixup for some hardware revisions
Date:   Thu, 17 Oct 2019 13:35:01 +0530
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191017080505.8348-1-sandipan@linux.ibm.com>
References: <20191017080505.8348-1-sandipan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101708-4275-0000-0000-00000372DF6C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101708-4276-0000-0000-00003885F71B
Message-Id: <20191017080505.8348-2-sandipan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-17_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910170071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 677733e296b5c7a37c47da391fc70a43dc40bd67 upstream.

The store ordering vs tlbie issue mentioned in commit
a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on
POWER9") is fixed for Nimbus 2.3 and Cumulus 1.3 revisions. We don't
need to apply the fixup if we are running on them

We can only do this on PowerNV. On pseries guest with kvm we still
don't support redoing the feature fixup after migration. So we should
be enabling all the workarounds needed, because whe can possibly
migrate between DD 2.3 and DD 2.2

Cc: stable@vger.kernel.org # v4.14
Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on POWER9")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190924035254.24612-1-aneesh.kumar@linux.ibm.com
[sandipan: Backported to v4.14]
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
---
 arch/powerpc/kernel/dt_cpu_ftrs.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 15059e2446de..753759a3c8e9 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -733,9 +733,35 @@ static bool __init cpufeatures_process_feature(struct dt_cpu_feature *f)
 	return true;
 }
 
+/*
+ * Handle POWER9 broadcast tlbie invalidation issue using
+ * cpu feature flag.
+ */
+static __init void update_tlbie_feature_flag(unsigned long pvr)
+{
+	if (PVR_VER(pvr) == PVR_POWER9) {
+		/*
+		 * Set the tlbie feature flag for anything below
+		 * Nimbus DD 2.3 and Cumulus DD 1.3
+		 */
+		if ((pvr & 0xe000) == 0) {
+			/* Nimbus */
+			if ((pvr & 0xfff) < 0x203)
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+		} else if ((pvr & 0xc000) == 0) {
+			/* Cumulus */
+			if ((pvr & 0xfff) < 0x103)
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+		} else {
+			WARN_ONCE(1, "Unknown PVR");
+			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+		}
+	}
+}
+
 static __init void cpufeatures_cpu_quirks(void)
 {
-	int version = mfspr(SPRN_PVR);
+	unsigned long version = mfspr(SPRN_PVR);
 
 	/*
 	 * Not all quirks can be derived from the cpufeatures device tree.
@@ -743,8 +769,7 @@ static __init void cpufeatures_cpu_quirks(void)
 	if ((version & 0xffffff00) == 0x004e0100)
 		cur_cpu_spec->cpu_features |= CPU_FTR_POWER9_DD1;
 
-	if ((version & 0xffff0000) == 0x004e0000)
-		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+	update_tlbie_feature_flag(version);
 }
 
 static void __init cpufeatures_setup_finished(void)
-- 
2.21.0

