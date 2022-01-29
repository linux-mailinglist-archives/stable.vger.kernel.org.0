Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5D74A30FE
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 18:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346075AbiA2R0L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 29 Jan 2022 12:26:11 -0500
Received: from mail-eopbgr120083.outbound.protection.outlook.com ([40.107.12.83]:31008
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241147AbiA2R0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Jan 2022 12:26:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TltKpYPJ1em+bjEvAzLjDkCqvTkuEfugWfu5Ihvpi6b1YyE5VNYDE4+T9jyZ9K+f8Iu09LJNyLXLgRXxUVtFyIjx0nXZlMBJFGLDcAxkDcq8VWlYLq2Qc5xSxc26Jcsg8pFD6/E4TgtXWXznOYqquK9H3QGeXjjfT5YQJP0XRJkT5zoUJv+vva3MRl3RdTZLGbw8EbRrTJmFbLqQnhDBpjDAts/BR333d2qFcAPxyHVOWTHpuKHI/gdzJLFCeAOvG8obJwwyezpBZezOGtrFDFXD5Nmjk23AFscgxD/dbzV9T+heKNjuiNQH2MbFn0mUYjNQkr+z0tAMiol78rGMNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcOpz9eajQJFeiRyzrmAw6ZfxgpsuhE+U14bbWOHbts=;
 b=TbAGWcwmoUNtwuRYbooDr1D3lT0AmVtKfkKIh2Bnnhpx6y7vh+HThN3rZ5iRqXMSp9o2RC3BZmr8NIGxfeOq+bweK1hqUofh/+S9nv0wS94NWunRDmolct6QrZD5MNO0QEOyN1obJlSBYaIigVAvWUfkgOUTYPmqTiAn+y4lJVuRW2f6cvuGM8pQeEx83NHi7RhSSdmsn5Pi5tug+3iFNkhYuqbnMgUnXfkUINmf3+w6wobujz4TeMzZT0+AtEQ/Vhw84gHOYem64DDvgR/gIgrnKHZ2sFqxAmjS8vhT/ljfATsM+QPoD+hPrWLmUIP4lWoyFt+F4GUrKErbQ5uYmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB3760.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:184::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sat, 29 Jan
 2022 17:26:08 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%6]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 17:26:08 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] [Modified for 5.10] powerpc/32s: Fix kasan_init_region() for
 KASAN
Thread-Topic: [PATCH] [Modified for 5.10] powerpc/32s: Fix kasan_init_region()
 for KASAN
Thread-Index: AQHYFTVN6EqEPIrrqUGSKWDgaBIRQQ==
Date:   Sat, 29 Jan 2022 17:26:08 +0000
Message-ID: <247bff242993dd6c8975a4f1248d822a448701ac.1643476812.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4311e9a6-e829-49e2-0023-08d9e34c700e
x-ms-traffictypediagnostic: PR1P264MB3760:EE_
x-microsoft-antispam-prvs: <PR1P264MB37604DB90E0F9CA8A1CA6E86ED239@PR1P264MB3760.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6NXXt1vuWbPlKgfrYDqGEbF47SKtyEV10JIdaQB6kZtUpNKTi1QgJ/iMfxj6Idc3CfTfooQ7LUkArILrZ6JXTXQfY/3K6NPBLYOsg8t/pOHFaOR/AcYs9X90Hq/HR3uF1Vy4np7eufKUTPCCYp2wN4trABYLME+CDaz9qQDd4ViFXuDMrSVUP7QU7KVEuFS8ejnHv3bDAq+R+M7Q153X8r6Z9dvwTQwKp4aCWGgk3CYl5gC/4hoN+yRf7fHe63SMAy2z6BrnKqTYBxaQZAjtXZwk2zQ1K2UI8ZiIy44jQz0pePvQdkqhF6Lp+VD9R86U3eTbE3//QeiqkCE7i8S0gMPKguyJhMxdh1rRWMHpRs12Up0MEuY9QGsxqrMBkMEL7/REzQSH71pfkxWTrG/IhfOJnFLa72OMGY14CqYgHM8zcH53YPCfWpCQm8OK2mTMDRoUteMy6xBhyRl1s9DnNQPTnBjdybTIoUY4SfAMD018FcJa93JuBtnb9NlX81PGNcI3p/HPYC3XaPsXShgA6xbuNGezcyyDb1u+cRA33ESD/j3tFfqS8kQ/QbiKzntVHdRIwF8/4p3u+7vVjiU9iFYSTCV+QQ03fpKHa/8SILNO+uYqqT1KWlRIdWyCwaUPmEMWnyWb7pyLehu+EcizyMXQFrKyHalK5n0kx4aBR1AMzCrM8691hvP/c7nlIAvD2Q2kqaWaXRUEqSE3oK9ycFZCWMSAYGHk66QxvaJj5+SDEOHUdQj0Bv+yX2i6JpgX/P9jBzV3VGp21DsyJN3L7l1/okNW12wYKB8LZlb2tJQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(44832011)(64756008)(8936002)(66946007)(66556008)(66446008)(71200400001)(66476007)(186003)(122000001)(5660300002)(316002)(8676002)(4326008)(91956017)(38100700002)(76116006)(2616005)(38070700005)(83380400001)(36756003)(6916009)(2906002)(54906003)(6506007)(6512007)(966005)(6486002)(86362001)(508600001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?zO9NySwInUL/WpzOqVjxdZtPmukO8kEfXIqij6vPo669wNMyBPqbmFaBb5?=
 =?iso-8859-1?Q?UN+h+VXVT1QuFbpHfdq91CnOCj+B3RJNiRs7WXSTP+pwN8UEI7SZwO3QBe?=
 =?iso-8859-1?Q?oWjreocglJXMytvwPL6sjq3VAXbq2GNIgQNJxRlhFLebhLDN6GGuJ0dd8O?=
 =?iso-8859-1?Q?nD29qTds4+EiLFYUBK74qbtDSLny+OMs/+kp8TkJPyO2lmTCKB0XVKbfej?=
 =?iso-8859-1?Q?6TcpPY8Ts7Yyuizshm4oFYNkheTRB5UebAj7pPuy+G5J8bT+9XarLZB/4y?=
 =?iso-8859-1?Q?e9hgo5JK7/m1Kur/xT0HD/4QkG8Io5oy8F951AoYWYSi16gUvmsVfq/1gW?=
 =?iso-8859-1?Q?n3TZWikT662I+NV1M7lsSAFFjsz52+BTZJNeRixUfOuOSe3/cQKnHwLp3x?=
 =?iso-8859-1?Q?s/5l4s6EutsToROK8Ap4YOhiR4FMq2eSnX6CniMMlTOr31OwBvqrBvoTDO?=
 =?iso-8859-1?Q?AG0iOTc5NfW8d8zZiHmk8iYn4F7TqWPqwhZkWtPTMUlQtRBbmkGU+5o51I?=
 =?iso-8859-1?Q?sfFNHoVbpAtJoTzwGtG8fnhupDg3YNjwB2o0V9BWWZwxlrZ/HRrIgexYIC?=
 =?iso-8859-1?Q?/mfN4OiQYWGgfkuurhnIhUnSttFMD2n3T9a+/eEnC8qNg7T1FRDj6orFKQ?=
 =?iso-8859-1?Q?ZIrv+2FZeQPlQvqE1tAllpw7HWg+TphQps48Gfqk9cpHrp1YhhUAuwIN1p?=
 =?iso-8859-1?Q?p39l2Ig9F3DnJWUvAsOV5jWSpjglv9LtCE521Xsufh30YGLhReu9LXmSuC?=
 =?iso-8859-1?Q?Sfmy6EjhRpbh6F0abYX1uFNyfTQnBAomvgCVrBvtF2rpc7SQBqdQgFcATT?=
 =?iso-8859-1?Q?lPsCl6ZgTDH2cYCAm8d389EPej+Wc0OmwrM8KF9+4+8zyPo3wMly6tLwK9?=
 =?iso-8859-1?Q?9jSz7YLNatuhzmjKVe6VQLgd7L1p5ESa7Fq+GIkTra00xwqDdmcFWbcZs8?=
 =?iso-8859-1?Q?7X16B6nTF4r8JeWdOdCD8kCYG9/fUc9W4JzTqNUUALhQ3cO0ouDXCSM8TE?=
 =?iso-8859-1?Q?iIOvicEvNIMJKHoSduHy8XUvA5jZoNcvvTZ/xSP8Wc9P6rEK8luc23M/sX?=
 =?iso-8859-1?Q?5SWV+WkbRrBAswqDsNQQG6s91/M+9gLELZ6UX0EgSxyFPmlgi+Ig97sG7D?=
 =?iso-8859-1?Q?0cbGERIuc5Ytk43RAMLsBcgPtQPvgApO1VsLAdOEglNinybKoC5P1HpWWa?=
 =?iso-8859-1?Q?6sUtGHWZ2RJG3ZDAkeY69Ishv9azQVDGBtWHjMi9ThOdic0JfHO8ToXKNx?=
 =?iso-8859-1?Q?OPo9DNWj8xrRqIjLNXZwtmi5SyT+1AnYVL+44PjCx03tMy5lXajecpwhqi?=
 =?iso-8859-1?Q?u7ScsEUVO9j8fV2LFwdR2TrZkjKTe15lnXQlO9u3Vd0jAqC+kKGPITyf/r?=
 =?iso-8859-1?Q?AmpOXtIp4v53Cgu1OaFnjrqDLQnozY5bbLHnDjDVJk0FweuTgjBnzNqxR4?=
 =?iso-8859-1?Q?AEY5N1M76vt6V3B9mkDHn2a8Ammu35B06oX7/gG7LlTl7rnOXNY4/8fYDM?=
 =?iso-8859-1?Q?Pg4nlkmPaaJQ43YM01ftPLmyKYCqIwi4R3LoycANOj9xRkp3Q9q6VfgMqK?=
 =?iso-8859-1?Q?Huqg/vxRmcfBTT99vSrrLTT+pYA24vGNV6G33xcTz73ECHvY3LKaWhXJxD?=
 =?iso-8859-1?Q?KWAKs52Zw1pALqEwnWTCPOSSzyDGvCaZN9N/Wm95RTtZaEVlKMNkogfIiG?=
 =?iso-8859-1?Q?So+Ju41wagHNe4w7YP1cSWzKy05wcTUUyfdg8eoQ+GG0cVkAn70QhcaBUr?=
 =?iso-8859-1?Q?lRlcebz2Se3x2Xy42mOHWGl6w=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4311e9a6-e829-49e2-0023-08d9e34c700e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2022 17:26:08.5840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HeIFErte1RS5xk8GFLlWrfJXjWNtgIk7awA88MYfILJEVeEiV3MXhxFA9XEvyYuHT01FdfOJc/9KCRSMtCvvirx+7oCEnaPF2HqI9fi08o0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB3760
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport for 5.10

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
index a8982d52f6b1..cbde06d0fb38 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -102,6 +102,8 @@ extern s32 patch__hash_page_B, patch__hash_page_C;
 extern s32 patch__flush_hash_A0, patch__flush_hash_A1, patch__flush_hash_A2;
 extern s32 patch__flush_hash_B;
 
+int __init find_free_bat(void);
+unsigned int bat_block_size(unsigned long base, unsigned long top);
 #endif /* !__ASSEMBLY__ */
 
 /* We happily ignore the smaller BATs on 601, we don't actually use
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index addecf77dae3..602ab13127b4 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -72,7 +72,7 @@ unsigned long p_block_mapped(phys_addr_t pa)
 	return 0;
 }
 
-static int find_free_bat(void)
+int __init find_free_bat(void)
 {
 	int b;
 	int n = mmu_has_feature(MMU_FTR_USE_HIGH_BATS) ? 8 : 4;
@@ -96,7 +96,7 @@ static int find_free_bat(void)
  * - block size has to be a power of two. This is calculated by finding the
  *   highest bit set to 1.
  */
-static unsigned int block_size(unsigned long base, unsigned long top)
+unsigned int bat_block_size(unsigned long base, unsigned long top)
 {
 	unsigned int max_size = SZ_256M;
 	unsigned int base_shift = (ffs(base) - 1) & 31;
@@ -141,7 +141,7 @@ static unsigned long __init __mmu_mapin_ram(unsigned long base, unsigned long to
 	int idx;
 
 	while ((idx = find_free_bat()) != -1 && base != top) {
-		unsigned int size = block_size(base, top);
+		unsigned int size = bat_block_size(base, top);
 
 		if (size < 128 << 10)
 			break;
@@ -206,12 +206,12 @@ void mmu_mark_initmem_nx(void)
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
