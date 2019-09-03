Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC1EA5E6A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 02:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfICASh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 20:18:37 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:1550 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727904AbfICASf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 20:18:35 -0400
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83074Dt014672;
        Tue, 3 Sep 2019 00:18:18 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 2us282kqr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 00:18:17 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (unknown [128.162.236.70])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id 226706A;
        Tue,  3 Sep 2019 00:18:17 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id CA0D1201EA185; Mon,  2 Sep 2019 19:18:16 -0500 (CDT)
Message-Id: <20190903001816.705097213@stormcage.eag.rdlabs.hpecorp.net>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Mon, 02 Sep 2019 19:18:23 -0500
From:   Mike Travis <mike.travis@hpe.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 8/8] x86/platform/uv: Account for UV Hubless in is_uvX_hub Ops
Content-Disposition: inline; filename=mod-is_uvX_hub
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_10:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 adultscore=0 mlxlogscore=588 suspectscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030000
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
---
 arch/x86/include/asm/uv/.uv_hub.h.swp |binary
 arch/x86/include/asm/uv/uv_hub.h |   60 ++++++++++++---------------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

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
@@ -243,83 +244,60 @@ static inline int uv_hub_info_check(int
 #define UV4_HUB_REVISION_BASE		7
 #define UV4A_HUB_REVISION_BASE		8	/* UV4 (fixed) rev 2 */
 
-#ifdef	UV1_HUB_IS_SUPPORTED
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
