Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F83A5E6C
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 02:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfICASm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 20:18:42 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:1462 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727926AbfICASf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 20:18:35 -0400
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83073DZ000495;
        Tue, 3 Sep 2019 00:18:18 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0b-002e3701.pphosted.com with ESMTP id 2uqj6rfk2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 00:18:18 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (stormcage.eag.rdlabs.hpecorp.net [128.162.236.70])
        by g4t3426.houston.hpe.com (Postfix) with ESMTP id 611EC59;
        Tue,  3 Sep 2019 00:18:16 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id 2303D201EA07A; Mon,  2 Sep 2019 19:18:16 -0500 (CDT)
Message-Id: <20190903001816.026944979@stormcage.eag.rdlabs.hpecorp.net>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Mon, 02 Sep 2019 19:18:18 -0500
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
Subject: [PATCH 3/8] x86/platform/uv: Add return code to UV BIOS Init function
Content-Disposition: inline; filename=add-bios_init-rc
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_10:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a return code to the UV BIOS init function that indicates the 
successful initialization of the kernel/BIOS callback interface.

Signed-off-by: Mike Travis <mike.travis@hpe.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
---
 arch/x86/include/asm/uv/bios.h |    2 +-
 arch/x86/platform/uv/bios_uv.c |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- linux.orig/arch/x86/include/asm/uv/bios.h
+++ linux/arch/x86/include/asm/uv/bios.h
@@ -138,7 +138,7 @@ extern s64 uv_bios_change_memprotect(u64
 extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
 extern int uv_bios_set_legacy_vga_target(bool decode, int domain, int bus);
 
-extern void uv_bios_init(void);
+extern int uv_bios_init(void);
 
 extern unsigned long sn_rtc_cycles_per_second;
 extern int uv_type;
--- linux.orig/arch/x86/platform/uv/bios_uv.c
+++ linux/arch/x86/platform/uv/bios_uv.c
@@ -182,20 +182,20 @@ int uv_bios_set_legacy_vga_target(bool d
 }
 EXPORT_SYMBOL_GPL(uv_bios_set_legacy_vga_target);
 
-void uv_bios_init(void)
+int uv_bios_init(void)
 {
 	uv_systab = NULL;
 	if ((efi.uv_systab == EFI_INVALID_TABLE_ADDR) ||
 	    !efi.uv_systab || efi_runtime_disabled()) {
 		pr_crit("UV: UVsystab: missing\n");
-		return;
+		return -EEXIST;
 	}
 
 	uv_systab = ioremap(efi.uv_systab, sizeof(struct uv_systab));
 	if (!uv_systab || strncmp(uv_systab->signature, UV_SYSTAB_SIG, 4)) {
 		pr_err("UV: UVsystab: bad signature!\n");
 		iounmap(uv_systab);
-		return;
+		return -EINVAL;
 	}
 
 	/* Starting with UV4 the UV systab size is variable */
@@ -206,8 +206,9 @@ void uv_bios_init(void)
 		uv_systab = ioremap(efi.uv_systab, size);
 		if (!uv_systab) {
 			pr_err("UV: UVsystab: ioremap(%d) failed!\n", size);
-			return;
+			return -EFAULT;
 		}
 	}
 	pr_info("UV: UVsystab: Revision:%x\n", uv_systab->revision);
+	return 0;
 }

-- 
