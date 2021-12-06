Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA16469850
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 15:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245733AbhLFOQX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 6 Dec 2021 09:16:23 -0500
Received: from mail-eopbgr120075.outbound.protection.outlook.com ([40.107.12.75]:35228
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242325AbhLFOQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Dec 2021 09:16:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqVxumo9o0NdXUOT60vFiCrpQUtvv0wG95SB7I9SP6cqrFo5FeCKeeclaOY4JZnaG2X+blxy8gMlXki7hB1QEOq+/qSMhHWQAAJp4j7p3ECM/az2PnhTOqJ9iThxWiPwKqK9TnkZ/vzTi6vVvMa5JwkVgXDr187FY148qrPyZG3Xf3VusH4o5pgZki2SiTA/UjeVWKY6MuCWLh9zVDsaBcYM+wlu/JQXA4ibhDq+4WNVQY6fG5PrXI8ygxebNgyym2rYMDallGdefYsYUBcsj/f5xy50T+ZyJbaAoLT0c0dyEsQ3CkauivYdbU0g8DNJAqtnJ7S3fKJuBGrgouAlDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=984RHHzw+YmTqJKX09uurr+BUVyONmjYuoecdJMjK0Y=;
 b=m1f9K0ZX2KvTjKheb/gDb02CmwPuImhXyNmqhSPEen+3FZHxw/FDd/+SNfKy+EYbNDcHSXizCJAk//qWcxXuKcp2fvzMTMQ6LT4+FDc3x0oqNAuJH1Airiu7pK/M51VLK2NexkAt1nrhmaGQiJcjEAVGmRXf1nHPehoXuzGKyiksddEOjniI0jpwz4TURXll1fJ7FNgat0XzV0mjSAtwC8A/D7pa7nFH5qROBStfFKXZKPuqjBWg6BLYwtzY0DDHPGz0TBzg99ntt1WxwMho4b+iclvmxqOLW1zct6zh+sSrVmwPhYOq9Gi2hjELLyFsbC/s3uILUn435IRquIC4vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR2P264MB0275.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 14:12:51 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::fc67:d895:7965:663f]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::fc67:d895:7965:663f%2]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 14:12:51 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] powerpc/32s: Fix kasan_init_region() for KASAN
Thread-Topic: [PATCH v2] powerpc/32s: Fix kasan_init_region() for KASAN
Thread-Index: AQHX6qtaVhn+nTorakewpI8P3ssyQg==
Date:   Mon, 6 Dec 2021 14:12:51 +0000
Message-ID: <90826d123e3e28b840f284412b150a1e13ed62fb.1638799954.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e3aa2ae-e669-439c-9a4e-08d9b8c27d4b
x-ms-traffictypediagnostic: MR2P264MB0275:EE_
x-microsoft-antispam-prvs: <MR2P264MB0275EFBBFFB8C99B7D9C13FEED6D9@MR2P264MB0275.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8WheWHxNLPYFcjVlDzzW/kzBY4LvOoOS6UepPv29uI44yghe/VFf3FQz48zCEB7GMx+inc3fOq86F6lBO3PR6nvIE1MPH5U6rknxRLyr32taFNvz3NoT43AppEou7wZR+Q0Bf875la5d6gl7Ele89Kfrs+zp/g4O1eJYvawXF+qam02NHWPQXqvD6ex7LlCCo8pena42I5rxQa5erukdhhRvL5O90iVbn82x0inn2ijiKXBbJWCcBTxcDcCiSEPAIOcB/DV+tK8wd1KIKa0OwKz7mY8RWP2FDt0psTW6Ho9k9CGBwxYj1qWXrgEXWvmiWhOlhp1nGuPzYFMN+tUjp6WcR1RQi2Ug5M/MdHQoTjWIsC2XNPclDsDcMc/vJs4j8JCzIOjs2XEKXNL35sOlDa/MYW7SIwfNdMya81gM5SzhnuLT1JWYUrlYYQI2WDJWOMkGS7pQlTZp0jiaJXNT6qrFj81GYET4z1KetmkJAywLm8RpF5bNBnmGvN2I/A91felxH59dcJfwTOAJQycPZdJuAhi9HkqZ3oLqnJMg9+l491nQ/GUDh86turlm1yZ0l0MUEt9T2LKCLNUTCO2ufDGTa2ybqnod03oLdKM5UZBrqIDZCU0tkCrptn9XhPczTumno7NZ4w5Wmxr9vSrEbVuph0Eo9reXFMgiuJiP45Zooyb7WnIllZgg+AYdYhDBVy9GzZrl2RWZCQrs/8q35Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(6486002)(36756003)(26005)(508600001)(54906003)(6506007)(64756008)(5660300002)(86362001)(66946007)(66556008)(66476007)(66446008)(6512007)(91956017)(76116006)(71200400001)(38100700002)(8676002)(316002)(4326008)(83380400001)(2616005)(8936002)(122000001)(44832011)(186003)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?WEVLTaqEOAc1Kk58n/K8dzJ/MlCAlVunLOUyBdgqK4Y7nplvmC4s4byDta?=
 =?iso-8859-1?Q?H61dX8L642AUVcY278+C7O3AjVrzjZ0xEof1r/aa0qLeLGjmpTt5dwwyoo?=
 =?iso-8859-1?Q?9Oul6P7bFRfQiNOwoaUzMgM4D/CilhRnT2rG8xyNqbDCMwRci7GPjLX4fh?=
 =?iso-8859-1?Q?PANaxdcMShIUE/mD4COGmEgEFiU65ee1VWeYixYzZMosbcTO/NSqf71Z4M?=
 =?iso-8859-1?Q?gGld+YKoRRIL8ixKK/3s0g1Y45DdSAfSkLR5GCzetV4TWnxnv87x9YVY/D?=
 =?iso-8859-1?Q?f4D4PG7NV8HMhA6FkBMrSLDxUvq+VLKORHFBUHvLaj7QTTshavxvSGnPFi?=
 =?iso-8859-1?Q?ELP9PYV+nEHkaek0iWRvC5NjFj5eQJQVV3bWKPhv5aLAIRwe7SCNsEj3Bu?=
 =?iso-8859-1?Q?8+8VgIXUL2kzrl3/vfRsCFufOkuhkyTNRR4mp9OL4RTjWHs2lq5AlVlJWm?=
 =?iso-8859-1?Q?ryxYDqS60EuHhS37yT6VrHdV6NuKBf6hp+kKAxyeggZwetpnarKMtji3bM?=
 =?iso-8859-1?Q?MhGDe/9ZwVZ94sKuntKnPM8xXTiwRnSh1hYmtggff4AhlY764WFNG+CdVP?=
 =?iso-8859-1?Q?CA0fyH6v6nDPSOXuFiFdPJCTdEgZcoLnP8exSDrYTHn4JJjRUy570utVMK?=
 =?iso-8859-1?Q?vJAGUayYiu3S0y7ohKWEJ27L2M8G/jR3T1EePW+dT0aOkfhDcO5RXNC0pD?=
 =?iso-8859-1?Q?oJ7zbixdZ6Hjqly1RMv/Wkr4F5uyrJrXbcNoYSP+N9wuGl4ZTd8qGXXRya?=
 =?iso-8859-1?Q?vLwN7yHxdU5tckhvp89lO7a0PQ8+ixeNxKujZTIr1OMsVboEkJER2FCBcb?=
 =?iso-8859-1?Q?8qMOoJyCFgWYXeMJzm5NBs0wzai3EImygEjrm2P89x6FwKd8OEuLgOO48L?=
 =?iso-8859-1?Q?jq01/cBlmpLV40D1vmd95vOg33Xo/1Go2nlLsb7+qsUTAHLeYfY54Wr6Hm?=
 =?iso-8859-1?Q?V47t8Dz64QSiUxiDvUxUS+4Qr3bpVWa9FjxPphtXjwpNSCCErDzrre7qyE?=
 =?iso-8859-1?Q?NrEkR01WdlJq7R6ra7Cvz5mW2Q9M7zW9tT3/qrta5SU1RCZSyzbBj5Rsd1?=
 =?iso-8859-1?Q?SlpVYP3AvAORarJFN82yHAtXmD51G3dmDNN9k4MvX/y881Q1KoVGwQHg7Z?=
 =?iso-8859-1?Q?URzPnsIjMPJe/C8C1EI3dOm1doWWGSuapO7b4ya9RHNimfwKl1gmifu3Cy?=
 =?iso-8859-1?Q?sY8O2QZFWuDCkLOvLgKLzeloXg1BO04cyv2vIK748ClPT80B0IenRITSQU?=
 =?iso-8859-1?Q?MkuIy3UGuATvSpyio3d0518BkDXfelbfjMeYmt8lmEPT7CtbKXl3gP9c5c?=
 =?iso-8859-1?Q?1VbcQnqz2NzfrEwim0plQLYLgNbd1bbRv/QBN5tw3C5MHcFXXa0Mvsjkra?=
 =?iso-8859-1?Q?RgueOOw+EhT2e7MN3cC8AjnM2Ol+x/qs2dM647Cs9c/iSnI8u7/xD/lgtK?=
 =?iso-8859-1?Q?YbawJIvtAjiZ/jncu5TtlDhPS0pm6ECnR73e75ls9CQM9xqnTVivAqI99P?=
 =?iso-8859-1?Q?+M+H4z/0qLtif3jxexUzL2zjT3F5/vQWsPvcs3AN1mNBcIIiPJytMSm3nN?=
 =?iso-8859-1?Q?Bx5y5maHfWkGmBP+4OvFdhDZtbPnaM8AQHVcFO++p+BWoVQ6+ExxnFWzTb?=
 =?iso-8859-1?Q?WdwTnLbNQFNqCKpiRyIy0Kiv40kujwGnKDyyhWrl3hhQ/7hcqzPVem4qzK?=
 =?iso-8859-1?Q?YP2Pj/T2o3hKTnnTM02XM3yj9Dan1hQkHKC4s0ZMw2aKdWCXeo/ZmE0V9u?=
 =?iso-8859-1?Q?EHASmydczi0nWNTUgeqe1K+y8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3aa2ae-e669-439c-9a4e-08d9b8c27d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 14:12:51.3972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h7yIkHF6xLBTc3tYHVp09xzOAlwJLtFBM9Ixs7NqcO35PXPmgwQpjIduXIo0Mw49ETC4IkzTggxd3VBQZRXkzJGmWot8dUk0eKtBOXXv4Y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0275
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
---
v2:
- Allocate kasan shadow memory outside precious kernel linear memory
- Properly zeroise kasan shadow memory
---
 arch/powerpc/include/asm/book3s/32/mmu-hash.h |  2 +
 arch/powerpc/mm/book3s32/mmu.c                | 10 ++--
 arch/powerpc/mm/kasan/book3s_32.c             | 58 ++++++++++---------
 3 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index f5be185cbdf8..5b45c648a8d9 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -143,6 +143,8 @@ static __always_inline void update_user_segments(u32 val)
 	update_user_segment(15, val);
 }
 
+int find_free_bat(void);
+unsigned int bat_block_size(unsigned long base, unsigned long top);
 #endif /* !__ASSEMBLY__ */
 
 /* We happily ignore the smaller BATs on 601, we don't actually use
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index cb48e4a5106d..9e7714a861bf 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -76,7 +76,7 @@ unsigned long p_block_mapped(phys_addr_t pa)
 	return 0;
 }
 
-static int find_free_bat(void)
+int find_free_bat(void)
 {
 	int b;
 	int n = mmu_has_feature(MMU_FTR_USE_HIGH_BATS) ? 8 : 4;
@@ -100,7 +100,7 @@ static int find_free_bat(void)
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
@@ -204,12 +204,12 @@ void mmu_mark_initmem_nx(void)
 	unsigned long size;
 
 	for (i = 0; i < nb - 1 && base < top && top - base > (128 << 10);) {
-		size = block_size(base, top);
+		size = bat_block_size(base, top);
 		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
 		base += size;
 	}
 	if (base < top) {
-		size = block_size(base, top);
+		size = bat_block_size(base, top);
 		size = max(size, 128UL << 10);
 		if ((top - base) > size) {
 			size <<= 1;
diff --git a/arch/powerpc/mm/kasan/book3s_32.c b/arch/powerpc/mm/kasan/book3s_32.c
index 202bd260a009..450a67ef0bbe 100644
--- a/arch/powerpc/mm/kasan/book3s_32.c
+++ b/arch/powerpc/mm/kasan/book3s_32.c
@@ -10,47 +10,51 @@ int __init kasan_init_region(void *start, size_t size)
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
-		int k_size_more = 1 << (ffs(k_size - k_size_base) - 1);
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
