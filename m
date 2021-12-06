Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F3D46919F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 09:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239557AbhLFIl5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 6 Dec 2021 03:41:57 -0500
Received: from mail-eopbgr120044.outbound.protection.outlook.com ([40.107.12.44]:12598
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239563AbhLFIls (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Dec 2021 03:41:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRUrOHHWsuPFN6B4Xakh2kWJ/mgb92KESOS6CewUSHH+yNtc1+M1Dx4c8rcZT59xLBMDuKnIZTh9BZHd4RHnWFXBX9eymihParMELBViDILXhssWAgdw6H0x8R5o618Fi/l0dCxsTk1l0u+10behCNSf4EV5mwIJwYj7Wq0WoFCTpiFNeyCEIEiNzLEsCwGwGb6njYoj2e0r3Q1+SDoANOmlHSWBVd5nZqOdCsTUYcdlPi5PWicEsv+YfFrOyFktW4pbga0RBRLqL5MTq2IJJu77LG4cKzC87fat6jl2ohvl+foMkhrwIFOFlGMEwDkQS1yAN636tvMuov8hPG67AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ayGoKHnNNhpGxRsG8hwmPmYBuHlzrzeB6gQSQyFhRA=;
 b=LzbdYelxp6zT29EiIE/Spi/gszlJjPkaMMw5A8LRn2ZUHkx49AmUapFoU66fcMsAfIYjH0Ct5W+ASU+Eybysb+TZNSUFDc9pMlAx3hEghGmJyhKE7et3Ya8RfZnmcOzkYJXXy9+S23NSYDDXf7+4F7YcJ+TS6jX2798BeBq1OP7XTbK5hU+QqMdfndnEFYIMqoQcOja1BvuerNjjA6xCqvXSV3GuTqLOU1B7yZ0JR8TLBugHvy5jS/8Xe0I4RBneXwgsGG8uOuMQT6N8Mkn7ksUO5r7J+uNbTLxh+eSk3ubmKTvtPi2kyfPFQZ4lupyD2neaRjh9v2CL6FEtF9Nt0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRXP264MB0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 08:38:17 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::fc67:d895:7965:663f]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::fc67:d895:7965:663f%2]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 08:38:16 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] powerpc/32s: Fix BATs allocation for KASAN
Thread-Topic: [PATCH] powerpc/32s: Fix BATs allocation for KASAN
Thread-Index: AQHX6nyd3iR1lDpG8kKduC3Cv3Q/+A==
Date:   Mon, 6 Dec 2021 08:38:16 +0000
Message-ID: <91962818085df4f909b0d48925b6dce7c30b6467.1638779871.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f29805c-0f0f-4ac0-1bd8-08d9b893bff7
x-ms-traffictypediagnostic: MRXP264MB0006:EE_
x-microsoft-antispam-prvs: <MRXP264MB0006299E1C1B1B78C506D1C2ED6D9@MRXP264MB0006.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YmvuwbgTVM1hLVAOteUk7PUkj7jguFwvcZX9RMsKX7QOMfhfFQm2/HmOwcUZmUEgPPz6WZ4V/ZOKlOgYJeci/3gOrLPGDRO3YTC5a9Mkt+effVMCFRJa9NRd3hki2NNVnkQJPh/+V2jMwqV6uDcYzLp6pV2SmWtm7Dv9783F0Ou+AsrytS3/zMD+ssojLVhfpGQr+7rix9qvap0FqcMrxGGHCBXK4AITN6hqJGLhLvNjmmG2xKXD0lKmcPvdq2zCwcf859IIDfBp3qhxlXJscagUc7VTNT5YgKtWpa281RLZvR4Al9Noc8BFfbROPkXx0jKD/rCmh5NRB6QcAjyc6hZtKga+nE11Zu7sXIG9ijg1mz5HQ8J6Qy7Xx/qWzB5+J+XQtQpoAPn2wgqMwm7qF9p3I7C8paQeJL+/xx0kLSXlGbofMP2BwgjCGlgPkYC8KeaGkRBDVhubFkXLO10npqQuu5ZxcX+dRuCZpNOn+K8o8Som85POSc2IQma2dU1IzpPcBoJwoH0s46lMQFSubbGuMT9y2fMnBakZMm6y24zd61Br4t1rdoMs1Pqd7y0nPmGXKUNEE8tTIuvMyPviNEd32ymgsWEXn+ISb2g2yXmGp3UnFVl5I81/3hXvVbF1s+je0wWu77WsmDwMz7ck4iM+/OWGHMQ31n7xTDNIwKuejB35G7XY7JRs92yOxEKg7FD60vsjKAK7jgBmjfH9IA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(4326008)(71200400001)(2906002)(110136005)(83380400001)(38070700005)(6512007)(8936002)(316002)(54906003)(122000001)(44832011)(38100700002)(86362001)(64756008)(66446008)(36756003)(2616005)(508600001)(5660300002)(6506007)(8676002)(26005)(66556008)(91956017)(66946007)(66476007)(76116006)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?mps9YxO1xuIT0aw4NwiRU/LlrquLqGik4MmWyjZ3UrY+hLbOqkR+Sf6wYk?=
 =?iso-8859-1?Q?TKrkkJIQcMDUoFnFLGJLLov1M7DQ+gQSvpj/cRcgTkhZvMDiIvYqINuDTT?=
 =?iso-8859-1?Q?i8XHEKsqIlfa8Vcbkf1aX5RqwF2v3dbmZu+cR0M8J3ER7tFQV+lt/GU7QP?=
 =?iso-8859-1?Q?hvGNWcDPwK3wAPJ2eB0srCX3+/shvfsfsGLGDu7mdWzNph+fnLkhTS0LRi?=
 =?iso-8859-1?Q?/AzVAnVlcY/eClQ1+QfJar3vD8KJHfvoUHQ8xW9nV5GD2tVXQK/gW/LxFH?=
 =?iso-8859-1?Q?2qCNYHKDCLWIkK55Ksv9aknpbCiGaCRwJNN4tNIY4gQbqBnJ+csrqWY5fO?=
 =?iso-8859-1?Q?u/YVm+8vgzUtrkiXO3RQMin4VUQ9kONGOlUWIIq8aqgZKFAgxQFoUt4Vc0?=
 =?iso-8859-1?Q?xhah2a6Cd4m7na99o8hfghuhXqVKlV0YngCbNqIX/cTX7WFkROKhcAMn8O?=
 =?iso-8859-1?Q?66/fez0rBu096kQQZ5ZXfO314pvS8ZMuuymjOhxKtWRIg/diTnY5+M7FFU?=
 =?iso-8859-1?Q?+QsWikxar5d1Y/ySBJbqrpUeNX01QW1jFNLO1cwFq7Qug+FMj/cXfi2cBU?=
 =?iso-8859-1?Q?+DVyPsdhvKxvPoojAjyruWpWo/te2Kert34yf5piJ18AH5o+EF0Yk9EyXv?=
 =?iso-8859-1?Q?i04tvYYsydv1BaY7XKE67LMo87A9cWuYSJz9JtCQo6bQnxK9eKYsL2zSq5?=
 =?iso-8859-1?Q?O+Sl3uA6krQ6QqFgU4t0kvgI9bgixKmfoBp+bxwALGXnjxBqQwsndmud3M?=
 =?iso-8859-1?Q?II4wmwNmsqgjoI3Tz7x9ibEpsMEQkzFJbCXK7HsIaV3UpwDd8ewwdYTMD2?=
 =?iso-8859-1?Q?TMeNoTkRIx/DKQNLX1pzivqGdYLmMyBJ3VSBMtMUYt8hDPNLX8a8TGzXL+?=
 =?iso-8859-1?Q?82uQ/x8cdMnjVzwrYEBrZsxs9lz765j1ybPvU+MqvjZkyOFFwjUWMziPno?=
 =?iso-8859-1?Q?HnrBV4mBDa6wA87m2Pae+qMCubg5VL3YKw9xD+ZZvr7V8kGeYyDeONupUs?=
 =?iso-8859-1?Q?knvBC4UOlmiZ0Ia3FXFnqry0nIlflsrIdtZtFColAYgcH/FfUO8PBtTwcB?=
 =?iso-8859-1?Q?UejQc6D5loZuj0T3BKnzk3RLXwAnkjM34A1CtPMdmj4fgksPAyo4Kjtvwq?=
 =?iso-8859-1?Q?n1YQJf8Mg0cborSzNDXolzfgQX6rufK95IdXu8gxk+u8X2eO68u82ADLR8?=
 =?iso-8859-1?Q?hUyXSER5vnbd5VbjZ1MS6/FN4x/m7vt2aYTlhM/WS0PV8Nw9XAO9kLda5+?=
 =?iso-8859-1?Q?pf9sPXcArgOecBS7m9UrogSGmB4erGU+3RAJy12Ta3fe+YvIYzscfN/1i2?=
 =?iso-8859-1?Q?HzTX2DfCmjXfHtvikMspD2zRW7IfgLAjocHg7MqaYSxvRycGEvY6GTpPkG?=
 =?iso-8859-1?Q?XdNoEI3e8ZpWRJ78g+FHb3iVyqn0SGpkxQdTi5rMAztvHE9PnAssVNEwO+?=
 =?iso-8859-1?Q?0TCnk+SvuEVz2WiyhBAK/7SMwL0fcspo4D112NuYnSBAUCBjlYiXkgiEsW?=
 =?iso-8859-1?Q?dx+jOYmiFGseMhixhhhYzze7VbZR6yDTFo5kbv+DCiX/Z7AdvKVeXis9eD?=
 =?iso-8859-1?Q?l0Uv2gXb7fGsw8jIClLxJ59JlxKy2vxmwFqwVZDB0yeMq2BmeILUgoXUOK?=
 =?iso-8859-1?Q?VlKLk3FhZQ+/FefAt2/u3+SrjzDnTFVUtD+1M9Bcxq0s8FNUnuzBXBIP6M?=
 =?iso-8859-1?Q?gjnKAwbr/r/VEI9p5pyw8ZUVbzyAehjNuVmHTn8H95Nicyt/q2tM95A/WR?=
 =?iso-8859-1?Q?XOkV+MKvhvbX6Ypbc0YqSk87Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f29805c-0f0f-4ac0-1bd8-08d9b893bff7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 08:38:16.8717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xc3/4ASDzlfBw0RGF0S2LYBhrX8HXMg3IacLiiF4/VzUAAxKIKuOw8qy8kP24J7e0BxgbgZ/j7FR2NWe1cljkn/JxNEVRp+eW31KEE1BxRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRXP264MB0006
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

With this change we get correct alignment for BATs:

	---[ Data Block Address Translation ]---
	0: 0xc0000000-0xcfffffff 0x00000000       256M Kernel rw
	1: 0xd0000000-0xdfffffff 0x10000000       256M Kernel rw
	2: 0xe0000000-0xefffffff 0x20000000       256M Kernel rw
	3: 0xf8000000-0xfbffffff 0x2c000000        64M Kernel rw
	4: 0xfc000000-0xfdffffff 0x2a000000        32M Kernel rw

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Fixes: 7974c4732642 ("powerpc/32s: Implement dedicated kasan_init_region()")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/include/asm/book3s/32/mmu-hash.h |  2 +
 arch/powerpc/mm/book3s32/mmu.c                | 10 ++---
 arch/powerpc/mm/kasan/book3s_32.c             | 43 ++++++++++---------
 3 files changed, 29 insertions(+), 26 deletions(-)

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
index 202bd260a009..c2ff93c63dfa 100644
--- a/arch/powerpc/mm/kasan/book3s_32.c
+++ b/arch/powerpc/mm/kasan/book3s_32.c
@@ -11,32 +11,33 @@ int __init kasan_init_region(void *start, size_t size)
 	unsigned long k_start = (unsigned long)kasan_mem_to_shadow(start);
 	unsigned long k_end = (unsigned long)kasan_mem_to_shadow(start + size);
 	unsigned long k_cur = k_start;
-	int k_size = k_end - k_start;
-	int k_size_base = 1 << (ffs(k_size) - 1);
 	int ret;
 	void *block;
 
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
+	while (k_cur < k_end) {
+		unsigned int k_size = bat_block_size(k_cur, k_end);
+		phys_addr_t phys;
+		int idx = find_free_bat();
+
+		if (idx == -1)
+			break;
+		if (k_size < SZ_128K)
+			break;
+		phys = memblock_phys_alloc(k_size, k_size);
+		if (!phys)
+			break;
+
+		setbat(idx, k_cur, phys, k_size, PAGE_KERNEL);
+		k_cur += k_size;
 	}
+	if (k_cur != k_start)
+		update_bats();
 
-	if (!block)
-		block = memblock_alloc(k_size, PAGE_SIZE);
-	if (!block)
-		return -ENOMEM;
+	if (k_cur < k_end) {
+		block = memblock_alloc(k_end - k_cur, PAGE_SIZE);
+		if (!block)
+			return -ENOMEM;
+	}
 
 	ret = kasan_init_shadow_page_tables(k_start, k_end);
 	if (ret)
-- 
2.33.1
