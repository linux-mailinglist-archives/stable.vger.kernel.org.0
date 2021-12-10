Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F329946FC57
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 09:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhLJINU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 10 Dec 2021 03:13:20 -0500
Received: from mail-eopbgr90045.outbound.protection.outlook.com ([40.107.9.45]:36512
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230205AbhLJINT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 03:13:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gibEA6ez6fPwKWElkaEF18JU2iYsI98+0R2zZB2ekNxYV20xUD2H7AJIASeUteVVjfejcslZwFkVCt4i5EoZ+In1zPmaYswp/3ObQjOCeWjTLpeKrEAgaf4hGqrc54Y7mTC2nMnIxZBcZpHA9hH956MhWvV850yFhIDSHJtbXMT7sOKA+g0asd05vDGaCtY/pqQRm5QnzbyDNg00KKVNp7ETfkmOFHFLKaeQfOK6gBezgBgk5a/gPVjV6yJDnqGdDEPN/JG+mysum86Eu+3KPvMcz13KjWZbUdrDJtDHRU9AWdehofU0AZU9oUvBkafzl3tcEZ1xjDcRFu/XEl4fzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYvuCWHRt8lTGnlzeemjU77Vv6WSxjP5l+FuCpH/mTs=;
 b=hCUnd/mX+hSBhSXGQnKg0sblJWRGFtwe7kCoVSDbhudrViUT42olc4QGKnNa8zr7vQ2h3gMuuWT/uT+FfmCczbWc9p6cwMgPq17HK5wD3Te5BmkePsqf5Ww9W8speU1T8AEJUFjDAe2CKADfa/T4gGkfOYv0Gom/VJjmkw1tbJ+ZZJMeCmPv5J5tGtIYGhb06GFO4FYZI9a2ifvqe7HYVoxGy6MHtvjxuUeZnHWGhnvYQqZrtXTMdYhN2HWKEv8CFPRMgvVy88BTHAYmJ77g7CCs2ddWsmMqUTKFlsJe234gf8AIefIo70scdylKdBmtCcILh5enZPozPUdyxDbhfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRXP264MB0262.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 08:09:42 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::fc67:d895:7965:663f]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::fc67:d895:7965:663f%2]) with mapi id 15.20.4778.015; Fri, 10 Dec 2021
 08:09:42 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] powerpc: Add set_memory_{p/np}() and remove set_memory_attr()
Thread-Topic: [PATCH] powerpc: Add set_memory_{p/np}() and remove
 set_memory_attr()
Thread-Index: AQHX7Z1JD9WtX5NUS0iOvd1wzg71lg==
Date:   Fri, 10 Dec 2021 08:09:42 +0000
Message-ID: <715cc0c2f801ef3b39b91233be44d328a91c30bc.1639123757.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2768c1a0-0647-48c9-415e-08d9bbb46ba0
x-ms-traffictypediagnostic: MRXP264MB0262:EE_
x-microsoft-antispam-prvs: <MRXP264MB02628ED1C46317D5D9BAE73AED719@MRXP264MB0262.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mEEmYFVfzeW/oyS4r1RLrFskDjxEOR5AzAq976MxwW08s6p198F093C+3ybnGsV/XceKPs9lyQ8CVgaojUVhfTPQEDLIPHF1EzW1W40TsCkUnFH5F1erN2YpnpoYeG9qpB+DKWcG0eRS/6NR25g5dj7Nyfi03XvwZg22uXtp6Tpft6GEM/wA5DkllL+WaMBwWhJ80Z0urKd6cCvfdAiJ39aibuwidTtO8brFdCLES5X/ud046eDKauqXQ1fkeBhU2UZrihMiizqlVUjIIWeHt2miiMbN+/A1EPVc3zAOvAkZF0IJ+wVaUslJ/kk/W+gGODuF9fsRUZiCqGejV45hilXSH20naGGWJlZZNdDv0WAWt/mwQZ+gQm7jIfcgnlO6JP8stBoCCE3qONkfbn67/XM6245kmfb+BwQ4odGec4GlboMFqmy1d2/KCJztsV8VUOLvrPjewHwADOh03EjR1BYM9CNPs61SAfjXMc7WjqGqEaGD1KLmhJTEA75kO5g5n4BkxEfKvWH4Je3ZSzKbDI4cvD63UNp6nCeOVSHi/TkdH3Yx9uXTxIyh3G755alOJuBEUto9H+zFx+BAlE9QX3HDMkxgc+r9rNdtQXqWvVuUNbKNMGXEBLzfQ0H+cT/j6EmWiA+Am7SpUkTaeYIp9Q2fCyHvIrXbDj4/qQqX292wCtSvq0CYzhkomxmUhYPJ+hwc/ZENHamO6RhmvuIfXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(186003)(4326008)(44832011)(26005)(2616005)(38100700002)(122000001)(71200400001)(316002)(6512007)(110136005)(38070700005)(54906003)(86362001)(66946007)(91956017)(76116006)(36756003)(66476007)(66556008)(66446008)(64756008)(508600001)(6486002)(5660300002)(2906002)(8936002)(6506007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?xw/W5Qw9dsZdCnEqCJNrdzodKNEZ50Mm4/BajegGnZhDvRNXo+UHycFlnR?=
 =?iso-8859-1?Q?6gjprVsrbJ2Vfk7V0tWynYIl1sXyJCJ+crrBB4EaZdP4AwKrWEsbCm8Kgs?=
 =?iso-8859-1?Q?vl9JczlmjAgeWc9xBFswzatan1OJgEAjgP4Fjtbsc22af0JHOXQHwULGIO?=
 =?iso-8859-1?Q?rv9DF86kBpujGcqvSk7gXMRSElPg5SrCsPiEHQHlr9TqAcCSdOvmo4UiCB?=
 =?iso-8859-1?Q?VJuzHGS5YZp9ei42+NYWy8T9OuHc1E0UmksLkVxbAcyH/ZPukmr79eEjCY?=
 =?iso-8859-1?Q?sA9lWhIb0FB7edF/lUJ/DjAB3cn4GXcOeGgI3+7jMtuLQJGucsSRppmqDj?=
 =?iso-8859-1?Q?MU+Va/nmok0q33yzdunvtN6W9c/kuempCK5ebipYInBQTgF2n4UWSOMdEM?=
 =?iso-8859-1?Q?w90rxBAT1bKVSRkM86zkMWPT1BY2LLm0Mj9x50lxHh132FZXuAunlglboG?=
 =?iso-8859-1?Q?Y53EHYc09qYZctxVQx6ZqJSHakRixRyXOAndXj1Gxj/sXufwXrJU79xjc+?=
 =?iso-8859-1?Q?tuWLpf/uIVcd5U3rckT5FbNVsHdsiRfJqgqjSjJUW3Edx0xK7GSmV1XBFs?=
 =?iso-8859-1?Q?S8Y+i64J54jKVJQjs4I+V2hKaBEkFrqctjYzZKzRmK6kj3ZofsaNeQDdNp?=
 =?iso-8859-1?Q?s0VuUbE34C/O0VasjfDGx9rUWeh3n7RCS40pxL0EpbiBTU3Ux+SrUmZWaC?=
 =?iso-8859-1?Q?rXzrhEQIjppPtWYd7Pg+FR0go6livo5qnlvD36nJmv4Eir2PdTgStlXLne?=
 =?iso-8859-1?Q?qU6tOq6qm4WQlpkurjpmXfCNZEUExWdIzSrKltmt1ga0O5kpwkbd1f7DdX?=
 =?iso-8859-1?Q?EW9gtUrYQOyGioTQi5/cQcOJI5YFqjYv64RI9sa3zAKUui+A1Fb9vsCHJo?=
 =?iso-8859-1?Q?MkDVsZNBsk+pzkF/OYeXzUwijWgpChlKTUmkVIeVuvgVfp3aD+t2JmXEe8?=
 =?iso-8859-1?Q?sV1vmo2CnLaVZgIVY0saTR4Mo3brRYr/Er0xVNrTi+04eyn3LWaZk/iCxz?=
 =?iso-8859-1?Q?oBfYSqhNzs3p9MeerxbWdIVwC9uMjfA+M3cPKpw8xsx2SJeLNupWkrGzpc?=
 =?iso-8859-1?Q?LIkK63bzxubFh5CJ5NfzW1ZGqJ6d9H49YhknOYUnB/YKDRQ8yVMQ/ORBBQ?=
 =?iso-8859-1?Q?cvHbNYF/hSpeV6yZt4H6w03BFuVBnhp5O/I1cOFxdXJ/acsrKUr2DLki5W?=
 =?iso-8859-1?Q?/2m6pEe5qiEUyCzf2eua+txws30aP8LDoTNn8M797T8CjAmdwLIWYR6d79?=
 =?iso-8859-1?Q?vw69+r2RSRytQ2Pq8kLUcR6S+jPnXLKfw4lg3TqsXJOwn5H8jmuwxWtQ9A?=
 =?iso-8859-1?Q?cEmVNRxxVk2h3ca8ois+kMWLQFLHunh0SEOtViYmaTYL7cCLM4pwicytqD?=
 =?iso-8859-1?Q?jXpjT/3MGk6Vbi8bih1lG22aIw3AYY9r063ie9wA7+/TZZuCOmT71+8LPa?=
 =?iso-8859-1?Q?mB6Cx3zrYPXQTBqinDBm7Im0U0u4ZdaA2Y/bUt1o72fve3LUTMzekikjYt?=
 =?iso-8859-1?Q?Wrb3rSr4d0SYGkYCI0cWzzNmkZKAIzWpwyZOvf1l2OStTmCcQB3PCQhulN?=
 =?iso-8859-1?Q?+4IFBLH5a1oTsYxNgMXkJswRIr/BAaVqYCzVPtTh4ruvh6fz5MDv4T+m+O?=
 =?iso-8859-1?Q?nloc/Yr3rqPKt46xm0wxZPqA1ots+ZHHwopv8cb9ZAS4GZtlbm71IMw0js?=
 =?iso-8859-1?Q?2RIMpVoShq7Unv29Eg3zfMtcV63RjzvGO87PkcLb4ZQ82yWheVMcq6GunZ?=
 =?iso-8859-1?Q?gStVj1AdJtHHt/diQ3HfRlNN0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2768c1a0-0647-48c9-415e-08d9bbb46ba0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 08:09:42.2563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8216ee5q/GJ62SbiFJceEGKrttcjS2PDlb7lOAylBQr/3QvwGWnDPG7CYRoK7K+Vr5kOn8aNHF3NPOrjJl2Wqb9gmqzFwK8zzZBfoskW+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRXP264MB0262
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
---
 arch/powerpc/include/asm/book3s/32/pgtable.h | 10 +++++
 arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++
 arch/powerpc/include/asm/nohash/pgtable.h    | 10 +++++
 arch/powerpc/include/asm/set_memory.h        | 12 +++++-
 arch/powerpc/mm/pageattr.c                   | 39 +++-----------------
 arch/powerpc/mm/pgtable_32.c                 | 24 ++++++------
 6 files changed, 58 insertions(+), 47 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 609c80f67194..4ceebb291896 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -518,6 +518,16 @@ static inline pte_t pte_mkuser(pte_t pte)
 	return __pte(pte_val(pte) | _PAGE_USER);
 }
 
+static inline pte_t pte_mkpresent(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_PRESENT);
+}
+
+static inline pte_t pte_mkabsent(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~_PAGE_PRESENT);
+}
+
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot));
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 33e073d6b0c4..2bbc8b69b7f4 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -724,6 +724,16 @@ static inline pte_t pte_mkuser(pte_t pte)
 	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_PRIVILEGED));
 }
 
+static inline pte_t pte_mkpresent(pte_t pte)
+{
+	return __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_PRESENT));
+}
+
+static inline pte_t pte_mkabsent(pte_t pte)
+{
+	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_PRESENT));
+}
+
 /*
  * This is potentially called with a pmd as the argument, in which case it's not
  * safe to check _PAGE_DEVMAP unless we also confirm that _PAGE_PTE is set.
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index ac75f4ab0dba..3d4169969900 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -166,6 +166,16 @@ static inline pte_t pte_mkuser(pte_t pte)
 }
 #endif
 
+static inline pte_t pte_mkpresent(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_PRESENT);
+}
+
+static inline pte_t pte_mkabsent(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~_PAGE_PRESENT);
+}
+
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot));
diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
index b040094f7920..061f1766a8a4 100644
--- a/arch/powerpc/include/asm/set_memory.h
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -6,6 +6,8 @@
 #define SET_MEMORY_RW	1
 #define SET_MEMORY_NX	2
 #define SET_MEMORY_X	3
+#define SET_MEMORY_NP	4
+#define SET_MEMORY_P	5
 
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
index edea388e9d3f..cb36963644c9 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -48,6 +48,12 @@ static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
 	case SET_MEMORY_X:
 		pte = pte_mkexec(pte);
 		break;
+	case SET_MEMORY_NP:
+		pte = pte_mkabsent(pte);
+		break;
+	case SET_MEMORY_P:
+		pte = pte_mkpresent(pte);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -96,36 +102,3 @@ int change_memory_attr(unsigned long addr, int numpages, long action)
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
