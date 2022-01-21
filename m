Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D90495C22
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 09:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiAUImY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 21 Jan 2022 03:42:24 -0500
Received: from mail-eopbgr90047.outbound.protection.outlook.com ([40.107.9.47]:53600
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234238AbiAUImV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jan 2022 03:42:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCdt/04nCTk0QZ1Lqfq+iOozSToEob5V7YYMyL2V2y00b6Z1xu/jkWuqaDIpxx+1xnQBJbmEgRATK4rwCuIXWSvSKXOLLRqgIexZJlxbIk6tIcdtTg0tOp2NUinoASr5RS7I+fvmlWQwWmfziafPFjWhRm6HQp2Su80qbo2Jwmg7a+0kFbIz9cqPX3ygYSs+C+sor2+FzUiR3oo534OCWYXPAw88bAD/jE7EiD/Ypacq39IfLo6x67JukFwnMvquzix761MxVKtymLG8Vsr9aTxRVu31X6VuXXXdvM86aB2OCNATWTscAQcbPMvmL1RcAPxgyfc3WHjNW8w9NABf9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lw5N86s3tqPtBgpRDVxozjxEFAMRNf6EE/hUhEFfU3c=;
 b=XwXn7IIXxNIPcB70SS8i0Biva04wLUKXOGc68QXVeQWE0rMTE6/bjn/B8LLPxUff+XJtXzAAFX13F+8cft4IwnQZY6Vp19QosMWH3bmxo6SEJlrSo9WBynlXPvmHvlSHT9EJ4RqSYfutljxITefsCjFWewS/nUqX2ORKrOgHusPFc+YQ9DLlX0rqRNVKP4cT33Ox7BYUO8VWzh7oJE4hr+lAaxChS//y2oS3Rf1DvIli3mCJH/OuYxxj0RDix7UyWP3sss+urCbW7C3mDbfIPcHYeL4TCm4SWu25kv1Vrs5Ds5eVu0VLBHMZ6GJVb3RJfrjtH7+C5xZoU0e2iw9yxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB2206.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:192::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 08:42:18 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5%5]) with mapi id 15.20.4909.008; Fri, 21 Jan 2022
 08:42:18 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "alex@ghiti.fr" <alex@ghiti.fr>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v7 04/14] mm, hugetlbfs: Allow for "high" userspace addresses
Thread-Topic: [PATCH v7 04/14] mm, hugetlbfs: Allow for "high" userspace
 addresses
Thread-Index: AQHYDqLM2DB5nXoCH0elbLgrlKVk/Q==
Date:   Fri, 21 Jan 2022 08:42:18 +0000
Message-ID: <6c95091eab9f58cee58da3762a4dc4c56ab700e7.1642752946.git.christophe.leroy@csgroup.eu>
References: <cover.1642752946.git.christophe.leroy@csgroup.eu>
In-Reply-To: <cover.1642752946.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c6216db-644c-4901-25c2-08d9dcb9eef0
x-ms-traffictypediagnostic: PR1P264MB2206:EE_
x-microsoft-antispam-prvs: <PR1P264MB220689C22DD49651721224FAED5B9@PR1P264MB2206.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +RO20GS1c4VhLu9s7YiE5j52zwIg2XymivZtg+nuq8HGC/YljKkKBq2yy/Q6yFHb5mEXah1d2Gzp/bvzpb9f8vq+ltr8gD6vPH63ONZgLwh1d+pjKz5FyOUy4/hpjQMYW3loLD+uxXvr+M0xYXHhzwIQvU3iLfRFBnmUtWEEE+erZ5aqtNaPvYGYkeEEwJkm8YWrISgpg+ZWNgohZ8KVW2sKEbTuIDfHarteUeGRlpIviRqpKFGyjZCCyWoPRiEs0btoAgC+6VS5eQW8jUlifsgKYVjPxh3PlF9tdMDfUKABr5BezXtkcA8W3v/Bwvy0Zlm4J9eIt4K9APbQNw6dZpgMb2fkoZ2EkPm36G3SQ7KV5xeaxoxB1VRyUw7ukLriguCvbm5weXyLqXdEogmQYYVMiw1qXB6igSAIAGB6CQZQ0iBIr9aeXTtpCgBDU8FT+zdvD81HAmAQgpZvDPXh0/yToKsr3p7unmAH1jPSIcAtLZwyoyE39r8RVkzzDFnGZVyh5oRePnBbkaZepRM3Aq3R617COIA+1STAdsJ8fv1qTWl1kXrXbJl0CDtBmfSjcWyQb0y7qCuf2B9LVSR8I2vtOOAp+LMkJY5tugr+cgpWyFsi5f17iE8dMvw0RM9MH1fbEQduTMHCHKVrDPqvGqM6Hf4XbA7V3L2Zz6iapqOtdWha6DjglWSOO3+X8SoZ7TWP7CYvawi6cyu1xhbt6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(316002)(54906003)(38070700005)(2906002)(6512007)(8936002)(6486002)(86362001)(186003)(2616005)(83380400001)(7416002)(110136005)(26005)(66476007)(66556008)(64756008)(91956017)(36756003)(66946007)(44832011)(76116006)(66446008)(38100700002)(508600001)(5660300002)(8676002)(4326008)(122000001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?W9vekwVZWTR+cbQo1SvzyZEL9gWBpvWRwupVXLAgzZtEfvgl8L0euDsY/j?=
 =?iso-8859-1?Q?pLlRyMzAYQX31AJNPP1bG63YAxSAnVZ6okRm92xg2tNlCLzSoxFmvrJnnD?=
 =?iso-8859-1?Q?MjWDodvc4VssOwLRgXIs/Wgpo0+46KnMKv2Ip2/jBuIr91LL/ZhIlvGOqN?=
 =?iso-8859-1?Q?9D1gPAuIsMS+oVO9AP+TJANJHdJyCujG7q+awv8J3cXAGbCK6r6I6CtXvQ?=
 =?iso-8859-1?Q?TP58GHzbjzUYNGG3b9UXPFIrppKCgecAGjGJ+C9fNcrbVByTOg7i0NL0z+?=
 =?iso-8859-1?Q?jQV/6gnNQONzpQoYlED6iFR0sJODRlFx/cAfWK/P6GNYp3JrR3LF4bJp+g?=
 =?iso-8859-1?Q?MbHBjrPX3Xzv1gSSwekcc06y9rwxFtxTCguwklnxEAcY0PEVDD/ZliPt21?=
 =?iso-8859-1?Q?hIC1dufodUElQje+fW1P98UI1+eya8Z9W0Y8qWzlXKTIG3/kdjQHS5pWmC?=
 =?iso-8859-1?Q?yiUSKxcXOQiWbTb7mvaIx2z/nbyktzhwZuTpXcmEVElcAX+Z2yH62CwVC1?=
 =?iso-8859-1?Q?Fquc5lg/GODztMMMeKoLy8np58synaMHZkkxvXhHAOQprsAFgY2HmveTkz?=
 =?iso-8859-1?Q?2KTge6I5q0TEOadLdRhJa2y9TX7jqcV2EgAPjlm4/y40bpyNk4l7k8dPQR?=
 =?iso-8859-1?Q?tJsSX9cQB8GbKhSfdz78XiRZnEEt5NhB5GWCLFd2CAiwweOoqFZ+sGmXaD?=
 =?iso-8859-1?Q?s2H4w8joViyFsdObP01IiktfhG07FkaWQaLJbM++8rOPE9dM9YuIZyrORz?=
 =?iso-8859-1?Q?7adCQKhcF+29A9u2NFr0s2HhL14SLJ/CDpcGTstTmJJ9NQjPwVN2HleGoC?=
 =?iso-8859-1?Q?aFIJNfX9Pueg2f/wDEKYKm439ruotYVJP0TLZw0Xyhmi+PBHB3xYhojIVH?=
 =?iso-8859-1?Q?wh51ebNzEcZIztutDMlAGz4MrnHpPTBMTmQbG3HXeMYesknfd5N4YEn7zg?=
 =?iso-8859-1?Q?pPqnA+pe7duDwAkcO5Imk5pot2O8HoeOjezC+sQR+Yojb8QVE5/tUgjL6h?=
 =?iso-8859-1?Q?yr33xSTx63XJ3S4vyy6CQcKcJEdMSuncKYJvSGGCdQxvXlemLgdyp9b4SR?=
 =?iso-8859-1?Q?um2PAebn89AQ88IxDCKsgcfVjStfHJqlhY2HrM7Swb2AWkpGlA/4vQzRr8?=
 =?iso-8859-1?Q?dZNcoW1lkuF4fyDhqLqeM7TXQbvGE5JcVpVd6opAitv8sUWzsG4mvxFDY2?=
 =?iso-8859-1?Q?Nm2g7xnZK+yOmCIUCpBEQlvO4HZLBnQJOfIeASUkGrdfwJPyh0wyUf/C1b?=
 =?iso-8859-1?Q?mej6pz3btcgRouKyG0RIxmXeOOFrAKGvndeNm5SHS/X1bCiyXOEOYzmzu6?=
 =?iso-8859-1?Q?UI/of2/+D7qe5oZm0GBf4S+Vk7Q4ZIsDqdLk9VG10sR3RDH2E9mm/AOtEJ?=
 =?iso-8859-1?Q?T1wtJs+jWiHvaq2G5q+EWiBdQ2CXs4E3fLTVKfUb/IrtC/Y1NU7UAhObj0?=
 =?iso-8859-1?Q?WImhT04hvqV6MmwLtubG8tsHMtA/nvoemNY7IZjNmzR/ee6nSMmJLFoftT?=
 =?iso-8859-1?Q?CjWAlLhGGN3XCilN6XbbVZENbLpgXWK0UB3i4+kFEz+8N7fuJ5JFmmkXgj?=
 =?iso-8859-1?Q?XHc6e03JNiEFzOHfF1cKqxwxRWIvMKTvClFJKN0EdvkcKbi+kb2IZbDH7+?=
 =?iso-8859-1?Q?sIE5xAPn0ifmQlxAcDtvE2gWx3/g6eAWdwoMPPJAke24ajeoZtpA1TCn83?=
 =?iso-8859-1?Q?1eSM9CFPuJsA2IcsvIB+k4XA/zaYDKsQH893zmtjDeQwYxrGKc9EuM0aNs?=
 =?iso-8859-1?Q?fsihvdw4wFmxFBvKS3A8k1suA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6216db-644c-4901-25c2-08d9dcb9eef0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2022 08:42:18.5099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gBfZW1GH8L4QWmsllaah1+kXn3I7doOZ3MCPALacgWkmJfhILrSfeXvs3hIbja3USmD7WOj/CtL0Cis8MsPmGItv4AS1nduNeqAbzocEfRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB2206
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a complement of f6795053dac8 ("mm: mmap: Allow for "high"
userspace addresses") for hugetlb.

This patch adds support for "high" userspace addresses that are
optionally supported on the system and have to be requested via a hint
mechanism ("high" addr parameter to mmap).

Architectures such as powerpc and x86 achieve this by making changes to
their architectural versions of hugetlb_get_unmapped_area() function.
However, arm64 uses the generic version of that function.

So take into account arch_get_mmap_base() and arch_get_mmap_end() in
hugetlb_get_unmapped_area(). To allow that, move those two macros
out of mm/mmap.c into include/linux/sched/mm.h

If these macros are not defined in architectural code then they default
to (TASK_SIZE) and (base) so should not introduce any behavioural
changes to architectures that do not define them.

For the time being, only ARM64 is affected by this change.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Fixes: f6795053dac8 ("mm: mmap: Allow for "high" userspace addresses")
Cc: <stable@vger.kernel.org> # 5.0.x
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 fs/hugetlbfs/inode.c     | 9 +++++----
 include/linux/sched/mm.h | 8 ++++++++
 mm/mmap.c                | 8 --------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c7cde4e5924d..a8d3b0899b60 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -205,7 +205,7 @@ hugetlb_get_unmapped_area_bottomup(struct file *file, unsigned long addr,
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = current->mm->mmap_base;
-	info.high_limit = TASK_SIZE;
+	info.high_limit = arch_get_mmap_end(addr, len, flags);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	return vm_unmapped_area(&info);
@@ -221,7 +221,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
 	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
-	info.high_limit = current->mm->mmap_base;
+	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
@@ -236,7 +236,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 		VM_BUG_ON(addr != -ENOMEM);
 		info.flags = 0;
 		info.low_limit = current->mm->mmap_base;
-		info.high_limit = TASK_SIZE;
+		info.high_limit = arch_get_mmap_end(addr, len, flags);
 		addr = vm_unmapped_area(&info);
 	}
 
@@ -251,6 +251,7 @@ generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct hstate *h = hstate_file(file);
+	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -266,7 +267,7 @@ generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	if (addr) {
 		addr = ALIGN(addr, huge_page_size(h));
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (mmap_end - len >= addr &&
 		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 2584f7c13f69..cc9d80bd36d5 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -135,6 +135,14 @@ static inline void mm_update_next_owner(struct mm_struct *mm)
 #endif /* CONFIG_MEMCG */
 
 #ifdef CONFIG_MMU
+#ifndef arch_get_mmap_end
+#define arch_get_mmap_end(addr, len, flags)	(TASK_SIZE)
+#endif
+
+#ifndef arch_get_mmap_base
+#define arch_get_mmap_base(addr, base) (base)
+#endif
+
 extern void arch_pick_mmap_layout(struct mm_struct *mm,
 				  struct rlimit *rlim_stack);
 extern unsigned long
diff --git a/mm/mmap.c b/mm/mmap.c
index ad48f7af7511..c773b5ad9a11 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2112,14 +2112,6 @@ unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info)
 	return addr;
 }
 
-#ifndef arch_get_mmap_end
-#define arch_get_mmap_end(addr, len, flags)	(TASK_SIZE)
-#endif
-
-#ifndef arch_get_mmap_base
-#define arch_get_mmap_base(addr, base) (base)
-#endif
-
 /* Get an address range which is currently unmapped.
  * For shmat() with addr=0.
  *
-- 
2.33.1
