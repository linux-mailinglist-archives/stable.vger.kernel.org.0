Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08313A5E6F
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 02:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfICASv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 20:18:51 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:3238 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727933AbfICASf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 20:18:35 -0400
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x830755P023714;
        Tue, 3 Sep 2019 00:18:18 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0a-002e3701.pphosted.com with ESMTP id 2us2nfbjrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 00:18:18 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (stormcage.eag.rdlabs.hpecorp.net [128.162.236.70])
        by g4t3426.houston.hpe.com (Postfix) with ESMTP id 828285A;
        Tue,  3 Sep 2019 00:18:16 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id 4460B201EA097; Mon,  2 Sep 2019 19:18:16 -0500 (CDT)
Message-Id: <20190903001816.151524458@stormcage.eag.rdlabs.hpecorp.net>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Mon, 02 Sep 2019 19:18:19 -0500
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
Subject: [PATCH 4/8] x86/platform/uv: Setup UV functions for Hubless UV Systems
Content-Disposition: inline; filename=setup-hubless-init
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_10:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=751 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add more support for UV systems that do not contain a UV Hub (AKA
"hubless").  This update adds support for additional functions required:

    Use PCH NMI handler instead of a UV Hub NMI handler.

    Initialize the UV BIOS callback interface used to support specific
    UV functions.

Signed-off-by: Mike Travis <mike.travis@hpe.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -1477,6 +1477,20 @@ static void __init build_socket_tables(v
 	}
 }
 
+/* Initialize UV hubless systems */
+static __init int uv_system_init_hubless(void)
+{
+	int rc;
+
+	/* Setup PCH NMI handler */
+	uv_nmi_setup_hubless();
+
+	/* Init kernel/BIOS interface */
+	rc = uv_bios_init();
+
+	return rc;
+}
+
 static void __init uv_system_init_hub(void)
 {
 	struct uv_hub_info_s hub_info = {0};
@@ -1616,8 +1630,8 @@ static void __init uv_system_init_hub(vo
 }
 
 /*
- * There is a small amount of UV specific code needed to initialize a
- * UV system that does not have a "UV HUB" (referred to as "hubless").
+ * There is a different code path needed to initialize a UV system that does
+ * not have a "UV HUB" (referred to as "hubless").
  */
 void __init uv_system_init(void)
 {
@@ -1627,7 +1641,7 @@ void __init uv_system_init(void)
 	if (is_uv_system())
 		uv_system_init_hub();
 	else
-		uv_nmi_setup_hubless();
+		uv_system_init_hubless();
 }
 
 apic_driver(apic_x2apic_uv_x);

-- 
