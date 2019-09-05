Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C37AA3BE
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 15:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733205AbfIENDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 09:03:32 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:26370 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbfIENDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 09:03:32 -0400
Received: from pps.filterd (m0134420.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85D2Rvj018926;
        Thu, 5 Sep 2019 13:02:57 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0b-002e3701.pphosted.com with ESMTP id 2utm9jwuuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 13:02:57 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (stormcage.eag.rdlabs.hpecorp.net [128.162.236.70])
        by g4t3426.houston.hpe.com (Postfix) with ESMTP id F1E6059;
        Thu,  5 Sep 2019 13:02:53 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id 69866201EA984; Thu,  5 Sep 2019 08:02:53 -0500 (CDT)
Message-Id: <20190905130253.325911213@stormcage.eag.rdlabs.hpecorp.net>
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Thu, 05 Sep 2019 08:02:58 -0500
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
Subject: [PATCH 6/8] x86/platform/uv: Decode UVsystab Info
Content-Disposition: inline; filename=decode-hubless-uvst
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_04:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909050128
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Decode the hubless UVsystab passed from BIOS to the kernel saving
pertinent info in a similar manner that hubbed UVsystabs are decoded.

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
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -1303,7 +1303,8 @@ static int __init decode_uv_systab(void)
 	struct uv_systab *st;
 	int i;
 
-	if (uv_hub_info->hub_revision < UV4_HUB_REVISION_BASE)
+	/* Select only UV4 (hubbed or hubless) and higher */
+	if (is_uv_hubbed(-2) < uv(4) && is_uv_hubless(-2) < uv(4))
 		return 0;	/* No extended UVsystab required */
 
 	st = uv_systab;
@@ -1554,8 +1555,19 @@ static __init int uv_system_init_hubless
 
 	/* Init kernel/BIOS interface */
 	rc = uv_bios_init();
+	if (rc < 0) {
+		pr_err("UV: BIOS init error:%d\n", rc);
+		return rc;
+	}
+
+	/* Process UVsystab */
+	rc = decode_uv_systab();
+	if (rc < 0) {
+		pr_err("UV: UVsystab decode error:%d\n", rc);
+		return rc;
+	}
 
-	/* Create user access node if UVsystab available */
+	/* Create user access node */
 	if (rc >= 0)
 		uv_setup_proc_files(1);
 

-- 
