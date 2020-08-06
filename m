Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70A723DE1B
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgHFRWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:22:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730280AbgHFRWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 13:22:13 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 076G3MKd018954;
        Thu, 6 Aug 2020 12:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=+cTwhbygt9oXS8OQzrjWUKCZsveWYmpge80Pn1UtJ58=;
 b=IjNACWBq5n1KZw4C8l24loFhuHrTZFYYtZqmw/GpWuHZnTTunMOTWcWKVPfk8asR2rjH
 XfUORZW+udDy/cqiIebfK4iUFBeo7ReyxT3Ti6ozbTSpTOCaKA93D5HJmYZYxwENdmSG
 +mQbuF7AIqbK3+R+TCQVAgmHpe/rZdwMgbJRVEQ+zF+AHj2tuBX8DkkF4CwGi4EncsV/
 1afd3l/ChDhcCYt/uvD0X8qNTpO02EBCNF6Re8Lw5UShZP1eDMI6b2J7JSV44I8lxRAV
 iUZC5ywRiQnUA0VhPyTEZKqqRhsgve4y5Lx8l8Pc5qfKr9reqNadVNoKzecshf5D0gKO 9g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32ra0rus1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 12:23:49 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 076GKjjn023371;
        Thu, 6 Aug 2020 16:23:49 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 32n019nm9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 16:23:49 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 076GNjkQ51511762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Aug 2020 16:23:45 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61C0878063;
        Thu,  6 Aug 2020 16:23:47 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7247A7805C;
        Thu,  6 Aug 2020 16:23:45 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.37.237])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  6 Aug 2020 16:23:45 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/4] powerpc/drmem: Make lmb_size 64 bit
Date:   Thu,  6 Aug 2020 21:53:26 +0530
Message-Id: <20200806162329.276534-1-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-06_13:2020-08-06,2020-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 bulkscore=0
 clxscore=1011 spamscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to commit 89c140bbaeee ("pseries: Fix 64 bit logical memory block panic")
make sure different variables tracking lmb_size are updated to be 64 bit.

This was found by code audit.

Cc: stable@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/include/asm/drmem.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/drmem.h b/arch/powerpc/include/asm/drmem.h
index 17ccc6474ab6..d719cbac34b2 100644
--- a/arch/powerpc/include/asm/drmem.h
+++ b/arch/powerpc/include/asm/drmem.h
@@ -21,7 +21,7 @@ struct drmem_lmb {
 struct drmem_lmb_info {
 	struct drmem_lmb        *lmbs;
 	int                     n_lmbs;
-	u32                     lmb_size;
+	u64                     lmb_size;
 };
 
 extern struct drmem_lmb_info *drmem_info;
@@ -67,7 +67,7 @@ struct of_drconf_cell_v2 {
 #define DRCONF_MEM_RESERVED	0x00000080
 #define DRCONF_MEM_HOTREMOVABLE	0x00000100
 
-static inline u32 drmem_lmb_size(void)
+static inline u64 drmem_lmb_size(void)
 {
 	return drmem_info->lmb_size;
 }
-- 
2.26.2

