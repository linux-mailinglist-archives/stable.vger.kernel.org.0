Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF275489C2F
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 16:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiAJP3a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 Jan 2022 10:29:30 -0500
Received: from mail-eopbgr120070.outbound.protection.outlook.com ([40.107.12.70]:5888
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236125AbiAJP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 10:29:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPylSFp/byxGytF3kf7+7skDc8yv5a7EZ3nYo/JBdkfWXOqnamYDA4QvdlTqt4MzPvzWAMel4oFYta1lusOofG6z5BkF0NcsriXmWKJAxfOyPG036PVtSlaOe1G7V7sT0/EnxS//H8OqvrJxJPf77MuTEIcjxZJQfZXb2L2QRI6pkot9TJ8GCbJ++h/ZbgjVFVjrKhbp/YYS3iua7xUr2pehpmqGpOxtDK0x/G8/2OsrNxde+zUtNa2v7krLfaKKcLKWbXgfSoL0QHAuXcvMkdU+MLFv+lTVvy86N0d81TOpG3vIv115r++2y8BEFjNtxtd7hdsXZRkzoOiuqMQ2ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rYDB1mz3ieMRWl9cxzGPx0rwPUX5LYNLgwAdikMmA0=;
 b=cwLCVK6xAqQ6NlFXz8X/aI/jdpVtxtITFK5asP0+ilLm5KmAX1IPLmV/AQIUu9QaWvVRZ78UqXP0gwwuVSxswvzR0onARiyokG225XiuYED/qZOWI8MlbWLMkj48Eqye2PBBCE4uopNqQzSjXPezazHKa/B30RdlLNDHBW97FKyxXLlzFQJ0JVS6aHeIkQG8xygXlIsJe81TKnmq/nNpDtMbUCWpcpYuFIF3iqLNfi9pjhpR4SjuGltFNCKRtKXDkP4TcXezPJ7465/jZw3fEx/8cG+J2NsfdEbrwHaKk22P0kximH9fcRXsYyf8pnVdV4IVUcaSdqx+j98HPfSpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2708.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:39::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 15:29:25 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5%4]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 15:29:25 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v3] powerpc/32s: Fix kasan_init_region() for KASAN
Thread-Topic: [PATCH v3] powerpc/32s: Fix kasan_init_region() for KASAN
Thread-Index: AQHYBjbZDO9GgDNaoUKJ+yhwCC1pTQ==
Date:   Mon, 10 Jan 2022 15:29:25 +0000
Message-ID: <7a50ef902494d1325227d47d33dada01e52e5518.1641818726.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00796edd-49be-4b24-e0ec-08d9d44dfbc1
x-ms-traffictypediagnostic: MR1P264MB2708:EE_
x-microsoft-antispam-prvs: <MR1P264MB2708E2C0DB652311FB253F05ED509@MR1P264MB2708.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aY0L1d5IJ+rI+PB2Dk3MeyvfvMM6wrNZO36Jq5eb3pc8twucTe5Pq7rhrs752gCprBILVJvjYiFuCNj03YlzjSAegzRdZuqz1NBJSpSxTPVrlNg+jwK+868kJ8wMQMxtbhOwqv+ZgpzsDjP8VdWp8wwzbvfqJsAjg4NsqCghQ9N/3EeyDq2CoTSqDKiMm/PfHwSj2YHLFg94pshq456ctROrfbAV2dHE5+qyEjETsboHFDQumrQtPV8H43vh2v3zqTDXOvRwSx9AGnFcxCDC5GaPbqh/jb9hIl0NvuDUgE9SbKubMu+I8u37uVUM2Tz+oz5/Iy7M+5aDajmkmoLWAvBMzPoVnDeUxd7c1YFNC9Q2SgCZhqc7mGfbsTTMfyQQ4d41rjshOToB7KCmoR2wG8NHaq/Ooxj/HqbCqWvTwLj0C4d0aR0Nv8VGUVeG3DH8ZIbeTzD69ltiyqQGE3XAcjskLOppUT4CMrj2bkGpaqxcdUaehH6PHdMA8U6jU1+ekP0Y88t653a901WRf3MqGdaVsGQSBaRVUlS3hXPCH8XGtIzOnFlT/6hqvCsOCZeIQ7/+J1ozXvbQxsDz2e65l06HJFkU7UwEhAvSUdnPhxJSKZKKUKquA1NBzpSPxkEF4IEqNYt74rROBX5HWYysiD6ZA5kozSfMXrHHNJ1iAEwQvqzZwTW8fqjjYth/9LARO4awNE0P6sOuKihOKPDMEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(91956017)(76116006)(38100700002)(66946007)(316002)(122000001)(2906002)(66556008)(64756008)(66446008)(66476007)(6506007)(44832011)(2616005)(26005)(71200400001)(54906003)(4326008)(86362001)(110136005)(508600001)(8936002)(83380400001)(5660300002)(8676002)(36756003)(6486002)(6512007)(38070700005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?mMf9gkWbb3ydsRLHHMEHW98FEIcDgOnzZHC+ehrcWIhAf63fYnfKjAVhye?=
 =?iso-8859-1?Q?Fp1nURk3nLnHqyLI+b9QN3vNo+prR568ypzCatF1E6AZ18OZsaClbqIsnc?=
 =?iso-8859-1?Q?nbyZRVJtZsVLMcoMwdf7+eoBrV0S6/A/vIBFM501Sp4pbAg6b/kNDgVsju?=
 =?iso-8859-1?Q?3Q6epuOv9uqPqZg+xhmJGpjmjXzAG1VzQDofL4wMXaz+FlZD/fyQsDvo98?=
 =?iso-8859-1?Q?QwoLOOu91KXSHPj2pWd6L+GllSJo/5CUGZW6+mWgNLM/gSH97SC9Sv8xxS?=
 =?iso-8859-1?Q?/zh3DBVTk+G+1Utz+a73zLF63KBV6td/yKGOaO09kdG07EpsDITKy8d3Ys?=
 =?iso-8859-1?Q?HJoBdX5fpCFonvTlmBe/1aoWWl8T4J9xb9SoVg+aCtmvcnmmFfnepgNA+m?=
 =?iso-8859-1?Q?r3jPcNjjFm/a8BrxNpUF4yzl7QDCXg+lYFDV1s2RlpSbINetYqcbSzvMm0?=
 =?iso-8859-1?Q?HH0NPnWaryDxMPRMcJHx1f5OdbbNYbCZrtWSvEtU+4szJSLHxMMkBFFOhT?=
 =?iso-8859-1?Q?dbPnMWMBdYSk9iEUQikXB+3wOUtIOjL6aaupzicwzSNAknwZgLrlYBeuA0?=
 =?iso-8859-1?Q?+mKDWYJu9Etf0PgFdcrayp3ev12Cu+4hohn4MX/cBoLETVhVL9M/9bHvz5?=
 =?iso-8859-1?Q?qEMhhQWPmT2aDbGSGCUruN2+YKjbtuSIy/no+FgoOIS+9OWx2/wy3ZSMor?=
 =?iso-8859-1?Q?mhlIJwYuqbwg+534O0rzjMwKijIhWwYjcHoC7weifuWiMUEAyy+Z3rfx6S?=
 =?iso-8859-1?Q?WVOWI0zpEnMAs2hPz2pJub1KHrv7od7TwfWhCB5hVRmsqISkVCrrees19T?=
 =?iso-8859-1?Q?FhyfylnxcHksLl2froubdAjEeFCJVSq0Nq5U2bnYhIvy/svTSB2P/At9Ky?=
 =?iso-8859-1?Q?2nPyjOVOrnjP1aWwqvnC0L9+bj1cantyYDwSwGvvu7mKhHTa9UODMXMWTE?=
 =?iso-8859-1?Q?P04205jfsT7RsQR18ugf73uksw2xy6/Dd5HOeeSbTnxUpCf+InD7TRhr/k?=
 =?iso-8859-1?Q?IUD91m1VjfyWt5YzC1Max4AK8EF/gBoB1dvnYvNDCXqi7axOVC+b18wyvI?=
 =?iso-8859-1?Q?a4d2+i13Ke8dluLMFwxRN+YwvG+qyNEiD2JSHIJbljXebwRGy4dUM5Zy4a?=
 =?iso-8859-1?Q?myqjuTrCSZOFmR2mHoEFxMSOhKu8ZH3f9fQYEvX/jRvUf5v8IsNRk2QGSM?=
 =?iso-8859-1?Q?7hlAILpvvO8ehlWtU+l215wTcDdMSrdeSrEQ6kv/B1GePCe0JTpQXvwRmv?=
 =?iso-8859-1?Q?LO2eq3OYRXqHrOULliYSiflEWQd1F2DAwSc6rb7hvwbwNFoy8wBaFVBJpt?=
 =?iso-8859-1?Q?jHv32kG46QvjPK33wY9l+BDcEXFWv/OlCYGkJ9kKghVn0wC3aKh0ejEGrg?=
 =?iso-8859-1?Q?rV2nCxL4LUP0i3mkrmhRqdlxKJZxfxXkrjhwgR5326EZy68TQOvhNZaKlx?=
 =?iso-8859-1?Q?8gddazg0vWPxlexIk04mg+UckgjD/uR1lmXaESSjm2CVhQdPt4ynDYDFDt?=
 =?iso-8859-1?Q?7qBYUKkx6/91aetYVrdDUeaZ5FUzd6D4SQ+pnuMQoonPNxVb1ivdzD09+P?=
 =?iso-8859-1?Q?xLYASkI57zyTdu+WLcs4QUfSS29UrQkFs7XvX2pLoX5IQLG1Fl5D7ARhKa?=
 =?iso-8859-1?Q?tYVguQMNnydCKY4eJXwxVSevD1zMSMYieyoAVTp2xlgEodD5pId1eHwQwO?=
 =?iso-8859-1?Q?lpElk1U8YA++hlrf7ivEpr5ar7kJ2g0DGFnL/drne1DhuJowH0TVyV7Ysj?=
 =?iso-8859-1?Q?+Aqj6qYSGnN2mqQY4PAAsFxQ4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 00796edd-49be-4b24-e0ec-08d9d44dfbc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 15:29:25.0212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mOWSYD47inj4BBFr651VTz/9J9xfd5whszDUxKs4GWHa9D8p/fWQYGkeMkydDET4bgpDtuhrrhnLDPwQZMHDGNzfqzyFCE2qv/XjDPyMdhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2708
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has been reported some configuration where the kernel doesn't
boot with KASAN enabled.

This is due to wrong BAT allocation for the KASAN area:

	---[ Data Block Address Translation ]---
	0: 0xc0000000-0xcfffffff 0x00000000       256M Kernel rw      m
	1: 0xd0000000-0xdfffffff 0x10000000       256M Kernel rw      m
	2: 0xe0000000-0xefffffff 0x20000000       256M Kernel rw      m
	3: 0xf8000000-0xf9ffffff 0x2a000000        32M Kernel rw      m
	4: 0xfa000000-0xfdffffff 0x2c000000        64M Kernel rw      m

A BAT must have both virtual and physical addresses alignment matching
the size of the BAT. This is not the case for BAT 4 above.

Fix kasan_init_region() by using block_size() function that is in
book3s32/mmu.c. To be able to reuse it here, make it non static and
change its name to bat_block_size() in order to avoid name conflict
with block_size() defined in <linux/blkdev.h>

Also reuse find_free_bat() to avoid an error message from setbat()
when no BAT is available.

And allocate memory outside of linear memory mapping to avoid
wasting that precious space.

With this change we get correct alignment for BATs and KASAN shadow
memory is allocated outside the linear memory space.

	---[ Data Block Address Translation ]---
	0: 0xc0000000-0xcfffffff 0x00000000       256M Kernel rw
	1: 0xd0000000-0xdfffffff 0x10000000       256M Kernel rw
	2: 0xe0000000-0xefffffff 0x20000000       256M Kernel rw
	3: 0xf8000000-0xfbffffff 0x7c000000        64M Kernel rw
	4: 0xfc000000-0xfdffffff 0x7a000000        32M Kernel rw

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Fixes: 7974c4732642 ("powerpc/32s: Implement dedicated kasan_init_region()")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Maxime Bizon <mbizon@freebox.fr>
---
v3: Rebased

v2:
- Allocate kasan shadow memory outside precious kernel linear memory
- Properly zeroise kasan shadow memory
---
 arch/powerpc/include/asm/book3s/32/mmu-hash.h |  2 +
 arch/powerpc/mm/book3s32/mmu.c                | 10 ++--
 arch/powerpc/mm/kasan/book3s_32.c             | 59 ++++++++++---------
 3 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index 7be27862329f..78c6a5fde1d6 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -223,6 +223,8 @@ static __always_inline void update_user_segments(u32 val)
 	update_user_segment(15, val);
 }
 
+int __init find_free_bat(void);
+unsigned int bat_block_size(unsigned long base, unsigned long top);
 #endif /* !__ASSEMBLY__ */
 
 /* We happily ignore the smaller BATs on 601, we don't actually use
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 94045b265b6b..203735caf691 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -76,7 +76,7 @@ unsigned long p_block_mapped(phys_addr_t pa)
 	return 0;
 }
 
-static int __init find_free_bat(void)
+int __init find_free_bat(void)
 {
 	int b;
 	int n = mmu_has_feature(MMU_FTR_USE_HIGH_BATS) ? 8 : 4;
@@ -100,7 +100,7 @@ static int __init find_free_bat(void)
  * - block size has to be a power of two. This is calculated by finding the
  *   highest bit set to 1.
  */
-static unsigned int block_size(unsigned long base, unsigned long top)
+unsigned int bat_block_size(unsigned long base, unsigned long top)
 {
 	unsigned int max_size = SZ_256M;
 	unsigned int base_shift = (ffs(base) - 1) & 31;
@@ -145,7 +145,7 @@ static unsigned long __init __mmu_mapin_ram(unsigned long base, unsigned long to
 	int idx;
 
 	while ((idx = find_free_bat()) != -1 && base != top) {
-		unsigned int size = block_size(base, top);
+		unsigned int size = bat_block_size(base, top);
 
 		if (size < 128 << 10)
 			break;
@@ -201,12 +201,12 @@ void mmu_mark_initmem_nx(void)
 	unsigned long size;
 
 	for (i = 0; i < nb - 1 && base < top;) {
-		size = block_size(base, top);
+		size = bat_block_size(base, top);
 		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
 		base += size;
 	}
 	if (base < top) {
-		size = block_size(base, top);
+		size = bat_block_size(base, top);
 		if ((top - base) > size) {
 			size <<= 1;
 			if (strict_kernel_rwx_enabled() && base + size > border)
diff --git a/arch/powerpc/mm/kasan/book3s_32.c b/arch/powerpc/mm/kasan/book3s_32.c
index 35b287b0a8da..450a67ef0bbe 100644
--- a/arch/powerpc/mm/kasan/book3s_32.c
+++ b/arch/powerpc/mm/kasan/book3s_32.c
@@ -10,48 +10,51 @@ int __init kasan_init_region(void *start, size_t size)
 {
 	unsigned long k_start = (unsigned long)kasan_mem_to_shadow(start);
 	unsigned long k_end = (unsigned long)kasan_mem_to_shadow(start + size);
-	unsigned long k_cur = k_start;
-	int k_size = k_end - k_start;
-	int k_size_base = 1 << (ffs(k_size) - 1);
+	unsigned long k_nobat = k_start;
+	unsigned long k_cur;
+	phys_addr_t phys;
 	int ret;
-	void *block;
 
-	block = memblock_alloc(k_size, k_size_base);
-
-	if (block && k_size_base >= SZ_128K && k_start == ALIGN(k_start, k_size_base)) {
-		int shift = ffs(k_size - k_size_base);
-		int k_size_more = shift ? 1 << (shift - 1) : 0;
-
-		setbat(-1, k_start, __pa(block), k_size_base, PAGE_KERNEL);
-		if (k_size_more >= SZ_128K)
-			setbat(-1, k_start + k_size_base, __pa(block) + k_size_base,
-			       k_size_more, PAGE_KERNEL);
-		if (v_block_mapped(k_start))
-			k_cur = k_start + k_size_base;
-		if (v_block_mapped(k_start + k_size_base))
-			k_cur = k_start + k_size_base + k_size_more;
-
-		update_bats();
+	while (k_nobat < k_end) {
+		unsigned int k_size = bat_block_size(k_nobat, k_end);
+		int idx = find_free_bat();
+
+		if (idx == -1)
+			break;
+		if (k_size < SZ_128K)
+			break;
+		phys = memblock_phys_alloc_range(k_size, k_size, 0,
+						 MEMBLOCK_ALLOC_ANYWHERE);
+		if (!phys)
+			break;
+
+		setbat(idx, k_nobat, phys, k_size, PAGE_KERNEL);
+		k_nobat += k_size;
 	}
+	if (k_nobat != k_start)
+		update_bats();
 
-	if (!block)
-		block = memblock_alloc(k_size, PAGE_SIZE);
-	if (!block)
-		return -ENOMEM;
+	if (k_nobat < k_end) {
+		phys = memblock_phys_alloc_range(k_end - k_nobat, PAGE_SIZE, 0,
+						 MEMBLOCK_ALLOC_ANYWHERE);
+		if (!phys)
+			return -ENOMEM;
+	}
 
 	ret = kasan_init_shadow_page_tables(k_start, k_end);
 	if (ret)
 		return ret;
 
-	kasan_update_early_region(k_start, k_cur, __pte(0));
+	kasan_update_early_region(k_start, k_nobat, __pte(0));
 
-	for (; k_cur < k_end; k_cur += PAGE_SIZE) {
+	for (k_cur = k_nobat; k_cur < k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_off_k(k_cur);
-		void *va = block + k_cur - k_start;
-		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
+		pte_t pte = pfn_pte(PHYS_PFN(phys + k_cur - k_nobat), PAGE_KERNEL);
 
 		__set_pte_at(&init_mm, k_cur, pte_offset_kernel(pmd, k_cur), pte, 0);
 	}
 	flush_tlb_kernel_range(k_start, k_end);
+	memset(kasan_mem_to_shadow(start), 0, k_end - k_start);
+
 	return 0;
 }
-- 
2.33.1
