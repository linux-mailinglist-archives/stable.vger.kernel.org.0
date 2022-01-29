Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2A4A3100
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 18:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352632AbiA2R0N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 29 Jan 2022 12:26:13 -0500
Received: from mail-eopbgr120083.outbound.protection.outlook.com ([40.107.12.83]:31008
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244286AbiA2R0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Jan 2022 12:26:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2b9wjz4EbdFgcTzMDOBdypEW26g399hlSLf9eryemJsdGVGDPVBpkxLifW0enXo65SrMANE9CDkVrDpjeZYo+KadP/fRsZAaadhpQm0w5JKPw43lPk+Z9aaNEc+DHOS5ok46pgurQnNoi0iHZcxs/IsxQnzQkEBLpaLM062Bs6haL3H00n2g797LWkuzhk62Evh//z/UlCi9dunUIkC/17LH+vsKJtCPKTYhBaxKhvD7f++sNEnQ8OhtDUj+3A+kZH7dEqaCXcZ04JhYfwvUnsupVdPsJ2WmKFA6fGeX9lEt9AeRLH2buiBd9lBGUih4rANaCZSn3uU679HYvZYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/syTXPviOGvtjTBqpAT2QASuMj4CpK4s4Jc8XHVAk8=;
 b=I3u6Xx+HKMwfeaBTW4DNCpq5XPLWbOzTV6BbI0iD79Rci/Yskb00Q8EluRA7swM7U+g9mYFzutPsaeQVq2vEAwQEhR3UpcohkB7DWExnEWe79/ym2gnsPY+fbDojurY6z0aNzsXF9dQuOCJBeXKeg8167WELPouEnS8gNWyBZq+UcdxD1wRwCzrXf72hyj7BnoQvc65RLIn6OY7TuQMhsAP4oJB8b4rIktVZuNy9QqM4oEY4Q1CPVkt5JGhZsTxhVw1kXIJ4zcnadAjOW8SdOKGYJpMBTO3NeWd2/NYkI66wDnKFTFilAqusFZA2JORBUAKtvgxo0B7g4qOj0AjzXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB3760.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:184::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sat, 29 Jan
 2022 17:26:11 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%6]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 17:26:11 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] [Modified for 5.16 and 5.15] powerpc/32s: Fix
 kasan_init_region() for KASAN
Thread-Topic: [PATCH] [Modified for 5.16 and 5.15] powerpc/32s: Fix
 kasan_init_region() for KASAN
Thread-Index: AQHYFTVO3eIgTpYLEk24BDdS4dem3w==
Date:   Sat, 29 Jan 2022 17:26:10 +0000
Message-ID: <383707b74eac769f971ea72ea3db39aaf08e5111.1643476880.git.christophe.leroy@csgroup.eu>
References: <247bff242993dd6c8975a4f1248d822a448701ac.1643476812.git.christophe.leroy@csgroup.eu>
In-Reply-To: <247bff242993dd6c8975a4f1248d822a448701ac.1643476812.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 787b3a2b-7c2e-484b-c9c2-08d9e34c717a
x-ms-traffictypediagnostic: PR1P264MB3760:EE_
x-microsoft-antispam-prvs: <PR1P264MB3760380E4A8C6242DF9E8B38ED239@PR1P264MB3760.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 47nnk/HlLHkbKOOGIgokwiQ3j6eU/tLBKR3z+JC2PnYhh3yaNRJVVjMklICpcifbFYAcZ4Vowv1YXg5UuUMIcFwAC8svJwrfkdCnYgmkl//42V8M5I0FaVXKtZpGIrR2YKppSW94Mihks6FdZ0UZOnQ/33Q4PYl0xEI9KHJghWLtIuSXrI45KWl0uhJaoEHb4+wU5FGbWB3v2hStH0gC8KBDPu42W/5BMtvtcI1ytGyhKk82lgKvNj8oDfKhB6KMMMsxm6iZCss47cGcQKu4cPjJOpKEPBB9GU6BT11e4mKakzNA4leMftygRXoAmiE051DNgdaU5DALvJZNieQiefUziBxroaM60Y+XtRDfAZE5JjK+6uyuBLSRLZqnpNLEeW5aIjzejjAKUIii1R6CvCK30YAE/zCFLtt9Qi+knS+T/G0Ka3NkoWplJOx9ImnTGm++zG4uXVfr1LU+vUBjZ6Tv+nfxZCrciB8HpEvM/8aHOs0ALr8Rfl31gg/YpMeZ+McZLH7k7TpyB/abt73K2xAkgX7niH23MkseSVpy1zFrQ4mKO68Vte0rz1dEYyCaf8cMFbKukue4BSmXjLNAuHjyFcpUIjRtm52WJehK5Nw1mCkjUc/Fqky2BQ0mcpDUeS7k5x1lZ76VvFX9Pz9kTh931hszTQvNOmZGkPt30+Zm73/0T0a2IPs+42y6gQsMSv3eb+RVw8O0aT7n9yI8yi1ualPPiwEmloJPRkHzS1BpE/8auyy55pueIkc7hnjt4+6gocAG76MOmcFvibJtHVBoGbapoCb76x4Klwt8hjk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(44832011)(64756008)(8936002)(66946007)(66556008)(66446008)(71200400001)(66476007)(186003)(122000001)(5660300002)(316002)(8676002)(4326008)(91956017)(38100700002)(76116006)(2616005)(38070700005)(83380400001)(36756003)(6916009)(2906002)(54906003)(6506007)(6512007)(966005)(6486002)(86362001)(508600001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kyNVPK+IZ87czhLBlB1kyX7VsQ0qkt8bghJbKBpMojSunnIfac40YLadpG?=
 =?iso-8859-1?Q?zOqN3jDDf0qzdsjUeeh1gOxZWKakEnhO7Jbge+TDqNA5e7XqTVbI3JrSdm?=
 =?iso-8859-1?Q?WxG8BnIg2SwcxD2U6AW8xJy1XClG2QsZrTRBp1lkvMtj9FuLa4B+utlUMs?=
 =?iso-8859-1?Q?PrtBm1pUtXJtWFM/Uh45tAglBQzJPq7QrzSlig5XGsdM7/CSW+EwQK2GPL?=
 =?iso-8859-1?Q?VQ8lbZ4IvwGJrVoOeRXQt6tT8AnAQYSMZ4nrAaq2oqpiD+jNLtyuWjUf9g?=
 =?iso-8859-1?Q?vr6Agyq/YL0jNOZ8RG/ueDLIjXk5J08sS4GJAzrR3XCRVVErstk/Cb0BLC?=
 =?iso-8859-1?Q?ZV8H1IKhV/w3qh8g9cFlqGLvyofeAzyNpjODgKWBH2lzUPa3LgMdfSFEDE?=
 =?iso-8859-1?Q?L8xZGge1oj/Jln/TBupTF2OAB9fDor/M7RjOit1nd7CvMSp/s5Kg62UU3Y?=
 =?iso-8859-1?Q?TNVYSPVJ1Bu83eooG3t7BhZjPkQkNAuHCYTo2O4ghEHYSgM3oyqbuAVDem?=
 =?iso-8859-1?Q?kWHQJM5yE18EpfqFytk0S7LyPmMNLV7b3TWtl0DuR+Lx3XpShiMHqfyH4Q?=
 =?iso-8859-1?Q?K5r1y5GoVknkkAQQ+pj7AfgEsgNGHZlS7hlSzCjy1q7Z2XM3Rz86+y5Gl9?=
 =?iso-8859-1?Q?QxpCMN0I8nSf0JsJYudN/fkWXePWlgp+OvZjyVAyN+chES3gr/hsbw9mZy?=
 =?iso-8859-1?Q?FjsAfFfWoasBBf+yHGnVDhp8z2HFe0+gC3SpvS7YWhKGu5V07+/bnZoA/4?=
 =?iso-8859-1?Q?FGfIaCqy3TGYw6+hK+F52Z8bbCpAeoUAW8sn944QKvAt9SuW/cojNp21ld?=
 =?iso-8859-1?Q?6g4Ep8voma5GOcv/TGF0LGDn/uk5VwXFp0UXapc748UffhBpxNhaGFb+ep?=
 =?iso-8859-1?Q?0DL/afomKPQW8Rke013tmM3EaLNGXB8R/ZSFb2vv+BAGhUsa2aTao17ZZn?=
 =?iso-8859-1?Q?hC1px2aIv+2DYssrXid4T8hEIY/64Zhgcj/muibml+Y9NSeWymffm1m0DC?=
 =?iso-8859-1?Q?ceGwZ87rQTgeAXuuG1876iPS6hUvVkl97MTQJmF4Az4LaImkYlFfwv36YJ?=
 =?iso-8859-1?Q?eRgfZwiomcslxIzvWdzcT4aTD+jtEQK5bsX8pNfCmPOCU6TE3Z+kJVljdC?=
 =?iso-8859-1?Q?4tYjFrvTLimr1h2MH4qpKjwSMiWPeEsF+TAF9s/2KrdkiKryu+sDyyU0/j?=
 =?iso-8859-1?Q?DyD0L+watuPgSYXdUGwrmgA/dBWU8WmzBMy7U4+Uxi4przPESmITBcWGe9?=
 =?iso-8859-1?Q?oX9L10zEooO1kRN1mZk8cMx4u72cmqfKIcDI7kGxqdVNLyesYHG5njZldg?=
 =?iso-8859-1?Q?dhn0V/WGaHwMUZwz0dIDklxTtWfQDIoBRyl/2cBKwtAj8htJkiiAK/C3zX?=
 =?iso-8859-1?Q?+YFO2YyGwUr4hoxX1ZkQxaqxDt+Co87KFNIbPNixf567VX2g3D253SR9kQ?=
 =?iso-8859-1?Q?8L6hvbx7d7iZKT73x9NCRlAmSlZcg+EBhO2H8NvBPsCIYFNyFQvcwHdZJR?=
 =?iso-8859-1?Q?Yxig8LAWmw85g2x53l86W7r+9jNPhEPtGQXjlLMVGF1FxWLgttwla55HJG?=
 =?iso-8859-1?Q?H+b50yewjqUbUXd/Yke/GKKV53/ei6D6XXelAz9KGzicWC4MC0r03EZuCW?=
 =?iso-8859-1?Q?zGn2jXsFgbswpKiJqq+2HMOPeHBfb9mHH4ywVXdYcjHTvtNfX9is8+TLAp?=
 =?iso-8859-1?Q?k/XQZzGss1nH3vbDrZXB/SLtEvMnjEnjjgLeBzBwomw9uwEkNe30JenRqt?=
 =?iso-8859-1?Q?qTqpVqsYfggjIBNIWG6W4Rb9U=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 787b3a2b-7c2e-484b-c9c2-08d9e34c717a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2022 17:26:10.9746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sLgj7JBQHHginNwG4R3B3wORXMhM7AY8/BWrvRRPJeZ/XKO4h0Mm7FazL7AjZo8RlRNx8yenpC0aX0dMKB60fzNr0wbDKQ7LKif4qL2+Il0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB3760
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport for 5.16 and 5.15.

To apply, it also requires commit 37eb7ca91b69 ("powerpc/32s: Allocate
one 256k IBAT instead of two consecutives 128k IBATs")

(cherry picked from commit d37823c3528e5e0705fc7746bcbc2afffb619259)

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

Fixes: 7974c4732642 ("powerpc/32s: Implement dedicated kasan_init_region()")
Cc: stable@vger.kernel.org
Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/7a50ef902494d1325227d47d33dada01e52e5518.1641818726.git.christophe.leroy@csgroup.eu
---
 arch/powerpc/include/asm/book3s/32/mmu-hash.h |  2 +
 arch/powerpc/mm/book3s32/mmu.c                | 10 ++--
 arch/powerpc/mm/kasan/book3s_32.c             | 59 ++++++++++---------
 3 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index f5be185cbdf8..94ad7acfd056 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -143,6 +143,8 @@ static __always_inline void update_user_segments(u32 val)
 	update_user_segment(15, val);
 }
 
+int __init find_free_bat(void);
+unsigned int bat_block_size(unsigned long base, unsigned long top);
 #endif /* !__ASSEMBLY__ */
 
 /* We happily ignore the smaller BATs on 601, we don't actually use
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 33ab63d56435..203735caf691 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -76,7 +76,7 @@ unsigned long p_block_mapped(phys_addr_t pa)
 	return 0;
 }
 
-static int find_free_bat(void)
+int __init find_free_bat(void)
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
