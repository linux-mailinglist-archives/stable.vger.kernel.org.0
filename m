Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18E7450317
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbhKOLJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:09:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231327AbhKOLJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:09:00 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AF9i5x5000991;
        Mon, 15 Nov 2021 11:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=2ZsyXyDuLrtKribS0ra9yNA8eNqldjvWFyfr8z8/W2U=;
 b=deRQSkEyL43pj2mJchi+U1ZKtS7HEqsguWda5KKOnLTkG56EZopNrD4ALGvUGJ1CQ87e
 e7GcNFPxU0QwX5d/qwQ1JZR8NqGoQalhHqxuu44WXpea2hktZoWq5J88tW5Sa9Kfld6C
 8AfW6KVafnC6d8g2Fnz3o9KU8wspfQI0koGWkSQzd46n+tmIVVbyTRmwJculjOiml1lD
 XfB/UItarMuefcpQSRU5e5J2/N4rFEQ4YnHyoOdGdq+I5jhfkmm1cbLqGGO4++NXLJTi
 yA+4uFqz+rqzNkOTdLTYMaLNI86mNG0N12diXW65WNt13Ib+VJBei+ZzShFdejPsiyn2 aA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbn68hgk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:49 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB3dcI001921;
        Mon, 15 Nov 2021 11:05:46 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ca509kwvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB5ijJ64946648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:05:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4840A4081;
        Mon, 15 Nov 2021 11:05:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B30F2A406B;
        Mon, 15 Nov 2021 11:05:42 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:05:42 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 4/5] powerpc/security: Add a helper to query stf_barrier type
Date:   Mon, 15 Nov 2021 16:35:31 +0530
Message-Id: <962f76e4e51c5e97c26188195a9e8c2bde8f9ba9.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rH8dTtqajJch8K7Eho7ai42Ro6DsBweU
X-Proofpoint-GUID: rH8dTtqajJch8K7Eho7ai42Ro6DsBweU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit 030905920f32e91a52794937f67434ac0b3ea41a

Add a helper to return the stf_barrier type for the current processor.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/3bd5d7f96ea1547991ac2ce3137dc2b220bae285.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/security_features.h | 5 +++++
 arch/powerpc/kernel/security.c               | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/powerpc/include/asm/security_features.h b/arch/powerpc/include/asm/security_features.h
index 3b45a64e491e54..a673416da3889e 100644
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -39,6 +39,11 @@ static inline bool security_ftr_enabled(unsigned long feature)
 	return !!(powerpc_security_features & feature);
 }
 
+#ifdef CONFIG_PPC_BOOK3S_64
+enum stf_barrier_type stf_barrier_type_get(void);
+#else
+static inline enum stf_barrier_type stf_barrier_type_get(void) { return STF_BARRIER_NONE; }
+#endif
 
 // Features indicating support for Spectre/Meltdown mitigations
 
diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/security.c
index 6a3dde9587ccba..48985a1fd34dbc 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -248,6 +248,11 @@ static int __init handle_no_stf_barrier(char *p)
 
 early_param("no_stf_barrier", handle_no_stf_barrier);
 
+enum stf_barrier_type stf_barrier_type_get(void)
+{
+	return stf_enabled_flush_types;
+}
+
 /* This is the generic flag used by other architectures */
 static int __init handle_ssbd(char *p)
 {
-- 
2.33.1

