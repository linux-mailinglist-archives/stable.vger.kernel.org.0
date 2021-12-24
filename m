Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6EF47EE70
	for <lists+stable@lfdr.de>; Fri, 24 Dec 2021 12:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbhLXLHn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 24 Dec 2021 06:07:43 -0500
Received: from mail-eopbgr90074.outbound.protection.outlook.com ([40.107.9.74]:8074
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344029AbhLXLHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Dec 2021 06:07:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5QPRqd95sXgtZAsXBxL/t/QhjC37VHeqDHanbqS4PjR3h2GNNIsv/Q/6wlRvhAujimnJPBmPoVgExQa8JOtsdCrgo3L0Xm0fKugw03cbW7u/jNtdavyObf2o5AaJMh4Itjn9YPN8JBWfrOFC7g+7b/zmkDH34fakd0Ae9+B6uk11N8Gx2sQUFq0rhxwZUAI5ERJT/sVrOpypExQTuddQGAjEH22ZiMMoKP4oL1kqhXbdBKoFyzN86ke/7/kq7bBbkHSIrhiOKPJIYX2Phi6wHMQVPSEBwIKhfKo4CCAq59IvFeCUiEhK3BAnFGoF+w+1K1aAOo7SHE6bX+Ns0UUng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cIMKLbEc1X7ojhyPl/Wd/bkJLWi83d+e8lOVZJrwAGY=;
 b=YRWS0pBp0zBQDEJscZqaD7eZlaxgpVhXP1JTe9H7hq/iKUyWWHCnY+y4AgL92wqpLZP2Yk9r1Wt5EBvQXatuGFfsqfFMoMaoSwUnWMxoyf0cVh5kGe0jv1gdFYRtHJSk8nXb7nN5l6UtgDSnnrRGF5mHvcUYPtQY1gAyOnpVeiYE0QFgfgDlimL8JZxepv5K8l8dUmV4qeJyXLGmpzaUbVHagqxKgQBLibfcoEBH5JMsqbHDJDY96RKrpX09HAK8dNE6FPfoYX78e5zfSHEzjkiEFsOJmZKlY8OtD2x7btX4+iEwBm0N6dEwjRzLwLYE9I7DM7m1x/reKLWbLi1KBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRXP264MB0005.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Fri, 24 Dec
 2021 11:07:41 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::f0ef:856d:b0de:e85d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::f0ef:856d:b0de:e85d%7]) with mapi id 15.20.4823.021; Fri, 24 Dec 2021
 11:07:41 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Russell Currey <ruscur@russell.cc>
Subject: [PATCH v3 2/2] powerpc: Add set_memory_{p/np}() and remove
 set_memory_attr()
Thread-Topic: [PATCH v3 2/2] powerpc: Add set_memory_{p/np}() and remove
 set_memory_attr()
Thread-Index: AQHX+LZ3pRpnIABVV0eAi8LQLOkMHw==
Date:   Fri, 24 Dec 2021 11:07:40 +0000
Message-ID: <cda2b44b55c96f9ac69fa92e68c01084ec9495c5.1640344012.git.christophe.leroy@csgroup.eu>
References: <43c3c76a1175ae6dc1a3d3b5c3f7ecb48f683eea.1640344012.git.christophe.leroy@csgroup.eu>
In-Reply-To: <43c3c76a1175ae6dc1a3d3b5c3f7ecb48f683eea.1640344012.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aba06c92-3e17-470b-c780-08d9c6cd9a5c
x-ms-traffictypediagnostic: MRXP264MB0005:EE_
x-microsoft-antispam-prvs: <MRXP264MB000571A0402F30C5C4948049ED7F9@MRXP264MB0005.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w3IMcNUJC4LHwXm6ZEWHflyt6AP8qzMGEDKQeo7RjtDwdqB4ZnTv+d+gpkFdduzPnFwhIB59ABOBhrUpGl6iTFZ7rGRfxzs27NtGRRHmY2Im7Qz44cvmfFl7oxjOrxVCm8GQ13JeY8BtnkNKI+qthsM3wKUHo1/syejB1uPDlvdUKV1PZ5lHTJqBCQpahy6apOjPS+M23zJDN8jRlYky6dOjJ11DjmTJDuehl/5ELvz2ud/RlpuQIyj8uJv3sdZn9HH1sMBC4C1EtNOy25wJehM/Ab3G5S9pT6KuUUM9YtNpIT8cLH7sbfT9xlpZU6+rlgvEWl0OQWeSq4DPTyGpLbVVllTu/6jc5NMZYMLcXZC84FetWuwQOWT5YA3N6ECJnjg1GlFIECSDBWurg8cc/uIVpQSobJRFIhFvZy/Kxy3UZWVdoTYum2p6myVDqeAv0FFD2lQ4vkRwCkSjenBrKYRUEFQdL3Dulm+5+NDGbMlRmx+cfKH+H/kuZnF19vo21qpwz9TaxLMaaY9nmeUsFOJII1yflS0QSamtEEgJlSKF9hZslL6OoWna+X27Kfe7UIcW5+gmk2UaMfuN6+iWX4hBRolLUPMEEqjXp3J72j3pe2QU2Nwl+z5qeNRoAr/nHVWQ9h1keM9qxweqygCfkoy4yQgwWrIrUClHUs4yjLB0w7SxHfsJ6Bw6Y9Pe7trai2BVzloiT1wAUVwnAi6J4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(110136005)(2906002)(4326008)(2616005)(44832011)(64756008)(508600001)(5660300002)(66556008)(66446008)(66476007)(6506007)(91956017)(76116006)(66946007)(8676002)(71200400001)(8936002)(26005)(38070700005)(316002)(186003)(36756003)(38100700002)(122000001)(83380400001)(6486002)(6512007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?akAsGyhJd1k1h0d6j5m7jAGwVmErJjHNh70pcKb2qQRy7/9XoUiRLT/2f9?=
 =?iso-8859-1?Q?O3wo9tNLZ5ruOFLO6iOh9DVwtPKfC950wd0dQZx0rhTgnzZSMxWIGk1uhs?=
 =?iso-8859-1?Q?z49JC+EoUUsD78V0J9Qs9ZYW+fAD3n1eeAov/xgK2yddBT6NWI9FUhSNVu?=
 =?iso-8859-1?Q?qFIHc+mF6VHkXqO4/h8sZQ05rfRiGsmlr2pVIRuUaFq9pEoqzaa6vpagPu?=
 =?iso-8859-1?Q?7/YNC5Q5iHXcAYHeWiSZV7v2JDxetijoefx0Y+V5rGaZWOaKdN8tEhc8RO?=
 =?iso-8859-1?Q?aLrLDC6wLN28faLfbvbr0Epw5UqLgwhgULcx/G294hoNaJgR5XeZpiVGeJ?=
 =?iso-8859-1?Q?RXVcG4T0WP+pRYBiw+bF4kdY7fwPoITJkjNh3XYJNKzUgbUDwSZutGCnrU?=
 =?iso-8859-1?Q?c66TN8fXIuRIH4u36BGbcO0WQYp2rQC+Ike51VfA3lh9Kc7CTMjgwTVvj2?=
 =?iso-8859-1?Q?M3Q3OYvUglxPDbyrs2iSZFMRB7XT1D7Yp+obhlMLMxNtntXJIDjR8cdirT?=
 =?iso-8859-1?Q?clBd0j74tnq/R9D65rCaUMElzrh+/qRcwsxHI/NkrFeRRAzl71CjpeB69G?=
 =?iso-8859-1?Q?C7VxtOX0Htssmvp4uehsBKdaweqshxJb9BtxEYJkNtxSVXjVpOJ+uqNKes?=
 =?iso-8859-1?Q?zrr/5Ce9xeNuDPBOzHka+fpGr7xMr+pA3jui+aMom5rBeaw8pfEFW1ydKw?=
 =?iso-8859-1?Q?pm/PLvejLR/IwqFxbJK2rCtHApLrAX8vstFqVXOdWrRMUw65nyx3HF5ahR?=
 =?iso-8859-1?Q?utNgwS8g9HTO+J6hoJGt1oosl8+gHn7MmW1zThQIM+tdboufTM4NsYjO8+?=
 =?iso-8859-1?Q?SjWu4L3Vovo3r/5a8/pS0/o4ttzUunmoZJuv1Bucuv22JiWTEv49xw7xMK?=
 =?iso-8859-1?Q?NWp+a0lugKQiWMfqBKD8OMPsiiMrrRPyxYWA/I/s9zVhT1wLGT/B4wI/Yw?=
 =?iso-8859-1?Q?Zra6xNdRwUQgaKej4YcxWM/0J2+f+gF7+iHupb47qpUMkFBN0Qd+w/JSKy?=
 =?iso-8859-1?Q?eTsupDt1viycxaSzhmEH6NhcPVybbv7vYFwx01h6UXPsIVmTeZJHZItESn?=
 =?iso-8859-1?Q?8vtyUpZWXI/8O54mW2R162RT+U5N2ejECYP45aMVg9Ib651snNiVeYeq/t?=
 =?iso-8859-1?Q?sZwtVCNyDtaUWeXtptF/92ttSsyoI9aWfxJUcVYmm0nvTNz6bc9n+DLgXF?=
 =?iso-8859-1?Q?3pn/PZmX+9rnBJhz1x6LSi5dUdXNrWrIfelruyzqQqHbCpCTbdyzG3Nbbn?=
 =?iso-8859-1?Q?5juM0kDeT7Qub8vuNAxzYWCNLtRiFAG6oXo+wG2qeUN1lyuVRZlLItq0Vi?=
 =?iso-8859-1?Q?qpK67IEVb1N4Mkrps+hKky4Em9amqbZA5rq2NURLkQAt3gawcuAFaH+Gme?=
 =?iso-8859-1?Q?kxM3bqdQrq2WNm+kuPsquZXtNBAKCyqdK00W63klLSmmrNHZI5inmxbwI8?=
 =?iso-8859-1?Q?e3go334OyTxwMMHPpPGAeBGTkp6AEaXXm2A/UFoJ9AJT+WaoW3JhTG8r4a?=
 =?iso-8859-1?Q?/fMTR9LMKopVSvi5gh1Je5z6a1iSgKg9ZGnLW8mF1dMcgFi0zyTSuBjSUK?=
 =?iso-8859-1?Q?kpZiX3axYEBF8L5lKqZLalP6I3W7FDhX28WO0rOh4aZVhxHw0e/EPfwfp6?=
 =?iso-8859-1?Q?zkAMaijVBoNt/DJkMBDyc34R9RlCfCqkD/+0XzMYV7FVsLjlE9aD1Mc7QZ?=
 =?iso-8859-1?Q?Icd8xYgRwbU6h85ntMXqSg/w2V/cwvDfX0GrVVsluUjU9FL2WJ04caPB7F?=
 =?iso-8859-1?Q?1MufVBEFG/uEw0Xe32yMxlSfg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: aba06c92-3e17-470b-c780-08d9c6cd9a5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2021 11:07:40.9221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UhFtoMtJwRZTfizeR9Qs9ErbLB6SNnaq3m2wagiu1tctGBdLXRkyB/A8tq3BlteSirjiKEYBMj7/PXuMQmowXRGLqC3rCozA2+9pK7VjZQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRXP264MB0005
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

set_memory_attr() was implemented by commit 4d1755b6a762 ("powerpc/mm:
implement set_memory_attr()") because the set_memory_xx() couldn't
be used at that time to modify memory "on the fly" as explained it
the commit.

But set_memory_attr() uses set_pte_at() which leads to warnings when
CONFIG_DEBUG_VM is selected, because set_pte_at() is unexpected for
updating existing page table entries.

The check could be bypassed by using __set_pte_at() instead,
as it was the case before commit c988cfd38e48 ("powerpc/32:
use set_memory_attr()") but since commit 9f7853d7609d ("powerpc/mm:
Fix set_memory_*() against concurrent accesses") it is now possible
to use set_memory_xx() functions to update page table entries
"on the fly" because the update is now atomic.

For DEBUG_PAGEALLOC we need to clear and set back _PAGE_PRESENT.
Add set_memory_np() and set_memory_p() for that.

Replace all uses of set_memory_attr() by the relevant set_memory_xx()
and remove set_memory_attr().

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Fixes: c988cfd38e48 ("powerpc/32: use set_memory_attr()")
Cc: stable@vger.kernel.org
Depends-on: 9f7853d7609d ("powerpc/mm: Fix set_memory_*() against concurrent accesses")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Russell Currey <ruscur@russell.cc>
Tested-by: Maxime Bizon <mbizon@freebox.fr>
---
v3: Use _PAGE_PRESENT directly as all platforms have the bit

v2: Add comment to SET_MEMORY_P and SET_MEMORY_NP
---
 arch/powerpc/include/asm/set_memory.h | 12 ++++++++-
 arch/powerpc/mm/pageattr.c            | 39 +++++----------------------
 arch/powerpc/mm/pgtable_32.c          | 24 ++++++++---------
 3 files changed, 28 insertions(+), 47 deletions(-)

diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
index b040094f7920..7ebc807aa8cc 100644
--- a/arch/powerpc/include/asm/set_memory.h
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -6,6 +6,8 @@
 #define SET_MEMORY_RW	1
 #define SET_MEMORY_NX	2
 #define SET_MEMORY_X	3
+#define SET_MEMORY_NP	4	/* Set memory non present */
+#define SET_MEMORY_P	5	/* Set memory present */
 
 int change_memory_attr(unsigned long addr, int numpages, long action);
 
@@ -29,6 +31,14 @@ static inline int set_memory_x(unsigned long addr, int numpages)
 	return change_memory_attr(addr, numpages, SET_MEMORY_X);
 }
 
-int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot);
+static inline int set_memory_np(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_NP);
+}
+
+static inline int set_memory_p(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_P);
+}
 
 #endif
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index 8812454e70ff..85753e32a4de 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -46,6 +46,12 @@ static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
 	case SET_MEMORY_X:
 		pte_update_delta(ptep, addr, _PAGE_KERNEL_RO, _PAGE_KERNEL_ROX);
 		break;
+	case SET_MEMORY_NP:
+		pte_update(&init_mm, addr, ptep, _PAGE_PRESENT, 0, 0);
+		break;
+	case SET_MEMORY_P:
+		pte_update(&init_mm, addr, ptep, 0, _PAGE_PRESENT, 0);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -90,36 +96,3 @@ int change_memory_attr(unsigned long addr, int numpages, long action)
 	return apply_to_existing_page_range(&init_mm, start, size,
 					    change_page_attr, (void *)action);
 }
-
-/*
- * Set the attributes of a page:
- *
- * This function is used by PPC32 at the end of init to set final kernel memory
- * protection. It includes changing the maping of the page it is executing from
- * and data pages it is using.
- */
-static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
-{
-	pgprot_t prot = __pgprot((unsigned long)data);
-
-	spin_lock(&init_mm.page_table_lock);
-
-	set_pte_at(&init_mm, addr, ptep, pte_modify(*ptep, prot));
-	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-
-	spin_unlock(&init_mm.page_table_lock);
-
-	return 0;
-}
-
-int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)
-{
-	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
-	unsigned long sz = numpages * PAGE_SIZE;
-
-	if (numpages <= 0)
-		return 0;
-
-	return apply_to_existing_page_range(&init_mm, start, sz, set_page_attr,
-					    (void *)pgprot_val(prot));
-}
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 906e4e4328b2..f71ededdc02a 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -135,10 +135,12 @@ void mark_initmem_nx(void)
 	unsigned long numpages = PFN_UP((unsigned long)_einittext) -
 				 PFN_DOWN((unsigned long)_sinittext);
 
-	if (v_block_mapped((unsigned long)_sinittext))
+	if (v_block_mapped((unsigned long)_sinittext)) {
 		mmu_mark_initmem_nx();
-	else
-		set_memory_attr((unsigned long)_sinittext, numpages, PAGE_KERNEL);
+	} else {
+		set_memory_nx((unsigned long)_sinittext, numpages);
+		set_memory_rw((unsigned long)_sinittext, numpages);
+	}
 }
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
@@ -152,18 +154,14 @@ void mark_rodata_ro(void)
 		return;
 	}
 
-	numpages = PFN_UP((unsigned long)_etext) -
-		   PFN_DOWN((unsigned long)_stext);
-
-	set_memory_attr((unsigned long)_stext, numpages, PAGE_KERNEL_ROX);
 	/*
-	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
-	 * to cover NOTES and EXCEPTION_TABLE.
+	 * mark .text and .rodata as read only. Use __init_begin rather than
+	 * __end_rodata to cover NOTES and EXCEPTION_TABLE.
 	 */
 	numpages = PFN_UP((unsigned long)__init_begin) -
-		   PFN_DOWN((unsigned long)__start_rodata);
+		   PFN_DOWN((unsigned long)_stext);
 
-	set_memory_attr((unsigned long)__start_rodata, numpages, PAGE_KERNEL_RO);
+	set_memory_ro((unsigned long)_stext, numpages);
 
 	// mark_initmem_nx() should have already run by now
 	ptdump_check_wx();
@@ -179,8 +177,8 @@ void __kernel_map_pages(struct page *page, int numpages, int enable)
 		return;
 
 	if (enable)
-		set_memory_attr(addr, numpages, PAGE_KERNEL);
+		set_memory_p(addr, numpages);
 	else
-		set_memory_attr(addr, numpages, __pgprot(0));
+		set_memory_np(addr, numpages);
 }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
-- 
2.33.1
