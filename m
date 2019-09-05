Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1EAA3C9
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 15:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389609AbfIENDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 09:03:45 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:54894 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388180AbfIENDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 09:03:36 -0400
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85D2PIW005575;
        Thu, 5 Sep 2019 13:02:55 GMT
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        by mx0a-002e3701.pphosted.com with ESMTP id 2utevt0pku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 13:02:54 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (unknown [128.162.236.70])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id 09FB67B;
        Thu,  5 Sep 2019 13:02:54 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id 86071201EAA4A; Thu,  5 Sep 2019 08:02:53 -0500 (CDT)
Message-Id: <20190905130253.440105979@stormcage.eag.rdlabs.hpecorp.net>
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Thu, 05 Sep 2019 08:02:59 -0500
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
Subject: [PATCH 7/8] x86/platform/uv: Check EFI Boot to set reboot type
Content-Disposition: inline; filename=check-efi-boot
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_04:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909050128
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Change to checking for EFI Boot type from previous check on if this
is a KDUMP kernel.  This allows for KDUMP kernels that can handle
EFI reboots.

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
 arch/x86/kernel/apic/x2apic_uv_x.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/pci.h>
 #include <linux/acpi.h>
+#include <linux/efi.h>
 
 #include <asm/e820/api.h>
 #include <asm/uv/uv_mmrs.h>
@@ -1483,6 +1484,14 @@ static void __init build_socket_tables(v
 	}
 }
 
+/* Check which reboot to use */
+static void check_efi_reboot(void)
+{
+	/* If EFI reboot not available, use ACPI reboot */
+	if (!efi_enabled(EFI_BOOT))
+		reboot_type = BOOT_ACPI;
+}
+
 /* Setup user proc fs files */
 static int proc_hubbed_show(struct seq_file *file, void *data)
 {
@@ -1571,6 +1580,8 @@ static __init int uv_system_init_hubless
 	if (rc >= 0)
 		uv_setup_proc_files(1);
 
+	check_efi_reboot();
+
 	return rc;
 }
 
@@ -1704,12 +1715,7 @@ static void __init uv_system_init_hub(vo
 	/* Register Legacy VGA I/O redirection handler: */
 	pci_register_set_vga_state(uv_set_vga_state);
 
-	/*
-	 * For a kdump kernel the reset must be BOOT_ACPI, not BOOT_EFI, as
-	 * EFI is not enabled in the kdump kernel:
-	 */
-	if (is_kdump_kernel())
-		reboot_type = BOOT_ACPI;
+	check_efi_reboot();
 }
 
 /*

-- 
