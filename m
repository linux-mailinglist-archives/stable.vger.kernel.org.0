Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6068DAA3C5
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 15:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388195AbfIENDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 09:03:36 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:4662 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388059AbfIENDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 09:03:36 -0400
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85D2OCQ014703;
        Thu, 5 Sep 2019 13:02:54 GMT
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        by mx0b-002e3701.pphosted.com with ESMTP id 2utxxb236d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 13:02:54 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (stormcage.eag.rdlabs.hpecorp.net [128.162.236.70])
        by g2t2352.austin.hpe.com (Postfix) with ESMTP id 3C9479C;
        Thu,  5 Sep 2019 13:02:53 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id D0513201EA1B9; Thu,  5 Sep 2019 08:02:52 -0500 (CDT)
Message-Id: <20190905130252.746448087@stormcage.eag.rdlabs.hpecorp.net>
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Thu, 05 Sep 2019 08:02:53 -0500
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
Subject: [PATCH 1/8] x86/platform/uv: Save OEM_ID from ACPI MADT probe
Content-Disposition: inline; filename=save-oem_id
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_04:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=868
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909050128
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
 arch/x86/kernel/apic/x2apic_uv_x.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -14,6 +14,7 @@
 #include <linux/memory.h>
 #include <linux/export.h>
 #include <linux/pci.h>
+#include <linux/acpi.h>
 
 #include <asm/e820/api.h>
 #include <asm/uv/uv_mmrs.h>
@@ -31,6 +32,10 @@ static u64			gru_dist_base, gru_first_no
 static u64			gru_dist_lmask, gru_dist_umask;
 static union uvh_apicid		uvh_apicid;
 
+/* Unpack OEM/TABLE ID's to be NULL terminated strings */
+static u8 oem_id[ACPI_OEM_ID_SIZE + 1];
+static u8 oem_table_id[ACPI_OEM_TABLE_ID_SIZE + 1];
+
 /* Information derived from CPUID: */
 static struct {
 	unsigned int apicid_shift;
@@ -248,11 +253,20 @@ static void __init uv_set_apicid_hibit(v
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
