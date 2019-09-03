Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DFDA5E65
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 02:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfICASf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 20:18:35 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:56194 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727667AbfICASe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 20:18:34 -0400
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x830759v019173;
        Tue, 3 Sep 2019 00:18:18 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0a-002e3701.pphosted.com with ESMTP id 2uqfejg65k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 00:18:18 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (stormcage.eag.rdlabs.hpecorp.net [128.162.236.70])
        by g4t3426.houston.hpe.com (Postfix) with ESMTP id 58F184F;
        Tue,  3 Sep 2019 00:18:16 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id D8125201EA073; Mon,  2 Sep 2019 19:18:15 -0500 (CDT)
Message-Id: <20190903001815.756100423@stormcage.eag.rdlabs.hpecorp.net>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Mon, 02 Sep 2019 19:18:16 -0500
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
Subject: [PATCH 1/8] x86/platform/uv: Save OEM_ID from ACPI MADT probe
Content-Disposition: inline; filename=save-oem_id
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_10:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=916 malwarescore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Save the OEM_ID and OEM_TABLE_ID passed to the apic driver probe function
for later use.  Also, convert the char list arg passed from the kernel
to a true null-terminated string.

Signed-off-by: Mike Travis <mike.travis@hpe.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -28,6 +28,7 @@
 #include <linux/reboot.h>
 #include <linux/memory.h>
 #include <linux/numa.h>
+#include <linux/acpi.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -51,6 +52,10 @@ static u64			gru_dist_base, gru_first_no
 static u64			gru_dist_lmask, gru_dist_umask;
 static union uvh_apicid		uvh_apicid;
 
+/* Unpack OEM/TABLE ID's to be NULL terminated strings */
+static u8 oem_id[ACPI_OEM_ID_SIZE + 1];
+static u8 oem_table_id[ACPI_OEM_TABLE_ID_SIZE + 1];
+
 /* Information derived from CPUID: */
 static struct {
 	unsigned int apicid_shift;
@@ -268,11 +273,20 @@ static void __init uv_set_apicid_hibit(v
 	}
 }
 
-static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static void __init uv_stringify(int len, char *to, char *from)
+{
+	/* Relies on 'to' being NULL chars so result will be NULL terminated */
+	strncpy(to, from, len-1);
+}
+
+static int __init uv_acpi_madt_oem_check(char *_oem_id, char *_oem_table_id)
 {
 	int pnodeid;
 	int uv_apic;
 
+	uv_stringify(sizeof(oem_id), oem_id, _oem_id);
+	uv_stringify(sizeof(oem_table_id), oem_table_id, _oem_table_id);
+
 	if (strncmp(oem_id, "SGI", 3) != 0) {
 		if (strncmp(oem_id, "NSGI", 4) == 0) {
 			uv_hubless_system = true;

-- 
