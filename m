Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B39AAB6C
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 20:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731401AbfIESsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 14:48:23 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:2604 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391351AbfIESsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 14:48:12 -0400
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85IkkEK009547;
        Thu, 5 Sep 2019 18:47:43 GMT
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        by mx0b-002e3701.pphosted.com with ESMTP id 2utnxkg4hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 18:47:43 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (stormcage.eag.rdlabs.hpecorp.net [128.162.236.70])
        by g2t2352.austin.hpe.com (Postfix) with ESMTP id 9A7E1A1;
        Thu,  5 Sep 2019 18:47:42 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id 76BA6201EAAA8; Thu,  5 Sep 2019 13:47:42 -0500 (CDT)
Message-Id: <20190905184742.326657295@stormcage.eag.rdlabs.hpecorp.net>
References: <20190905184741.256857552@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Thu, 05 Sep 2019 13:47:49 -0500
From:   Mike Travis <mike.travis@hpe.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 8/8] x86/platform/uv: Account for UV Hubless in is_uvX_hub Ops
Content-Disposition: inline; filename=mod-is_uvX_hub
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_06:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 mlxlogscore=517 suspectscore=0 phishscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909050176
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The references in the is_uvX_hub() function uses the hub_info pointer
which will be NULL when the system is hubless.  This change avoids
that NULL dereference.  It is also an optimization in performance.

Signed-off-by: Mike Travis <mike.travis@hpe.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: H. Peter Anvin <hpa@zytor.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Russ Anderson <russ.anderson@hpe.com>
Cc: Hedi Berriche <hedi.berriche@hpe.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
v2: Add WARNING that the is UVx supported defines will be removed.
---
 arch/x86/include/asm/uv/.uv_hub.h.swp |binary
 arch/x86/include/asm/uv/uv_hub.h |   61 ++++++++++++---------------------------
 1 file changed, 20 insertions(+), 41 deletions(-)

Binary files linux.orig/arch/x86/include/asm/uv/.uv_hub.h.swp and linux/arch/x86/include/asm/uv/.uv_hub.h.swp differ
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux/arch/x86/include/asm/uv/uv_hub.h
@@ -19,6 +19,7 @@
 #include <linux/topology.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
+#include <asm/uv/uv.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/bios.h>
 #include <asm/irq_vectors.h>
@@ -243,83 +244,61 @@ static inline int uv_hub_info_check(int
 #define UV4_HUB_REVISION_BASE		7
 #define UV4A_HUB_REVISION_BASE		8	/* UV4 (fixed) rev 2 */
 
-#ifdef	UV1_HUB_IS_SUPPORTED
+/* WARNING: UVx_HUB_IS_SUPPORTED defines are deprecated and will be removed */
 static inline int is_uv1_hub(void)
 {
-	return uv_hub_info->hub_revision < UV2_HUB_REVISION_BASE;
-}
+#ifdef	UV1_HUB_IS_SUPPORTED
+	return is_uv_hubbed(uv(1));
 #else
-static inline int is_uv1_hub(void)
-{
 	return 0;
-}
 #endif
+}
 
-#ifdef	UV2_HUB_IS_SUPPORTED
 static inline int is_uv2_hub(void)
 {
-	return ((uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE) &&
-		(uv_hub_info->hub_revision < UV3_HUB_REVISION_BASE));
-}
+#ifdef	UV2_HUB_IS_SUPPORTED
+	return is_uv_hubbed(uv(2));
 #else
-static inline int is_uv2_hub(void)
-{
 	return 0;
-}
 #endif
+}
 
-#ifdef	UV3_HUB_IS_SUPPORTED
 static inline int is_uv3_hub(void)
 {
-	return ((uv_hub_info->hub_revision >= UV3_HUB_REVISION_BASE) &&
-		(uv_hub_info->hub_revision < UV4_HUB_REVISION_BASE));
-}
+#ifdef	UV3_HUB_IS_SUPPORTED
+	return is_uv_hubbed(uv(3));
 #else
-static inline int is_uv3_hub(void)
-{
 	return 0;
-}
 #endif
+}
 
 /* First test "is UV4A", then "is UV4" */
-#ifdef	UV4A_HUB_IS_SUPPORTED
-static inline int is_uv4a_hub(void)
-{
-	return (uv_hub_info->hub_revision >= UV4A_HUB_REVISION_BASE);
-}
-#else
 static inline int is_uv4a_hub(void)
 {
+#ifdef	UV4A_HUB_IS_SUPPORTED
+	if (is_uv_hubbed(uv(4)))
+		return (uv_hub_info->hub_revision == UV4A_HUB_REVISION_BASE);
+#endif
 	return 0;
 }
-#endif
 
-#ifdef	UV4_HUB_IS_SUPPORTED
 static inline int is_uv4_hub(void)
 {
-	return uv_hub_info->hub_revision >= UV4_HUB_REVISION_BASE;
-}
+#ifdef	UV4_HUB_IS_SUPPORTED
+	return is_uv_hubbed(uv(4));
 #else
-static inline int is_uv4_hub(void)
-{
 	return 0;
-}
 #endif
+}
 
 static inline int is_uvx_hub(void)
 {
-	if (uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE)
-		return uv_hub_info->hub_revision;
-
-	return 0;
+	return (is_uv_hubbed(-2) >= uv(2));
 }
 
 static inline int is_uv_hub(void)
 {
-#ifdef	UV1_HUB_IS_SUPPORTED
-	return uv_hub_info->hub_revision;
-#endif
-	return is_uvx_hub();
+	return is_uv1_hub() || is_uvx_hub();
 }
 
 union uvh_apicid {

-- 
