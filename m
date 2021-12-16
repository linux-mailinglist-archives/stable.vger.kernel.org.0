Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B17477AF0
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 18:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240457AbhLPRrp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 16 Dec 2021 12:47:45 -0500
Received: from mail-eopbgr90044.outbound.protection.outlook.com ([40.107.9.44]:45962
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240446AbhLPRrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 12:47:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRf8/K6KiLOyLizxc1M1wYYlUfqOuNKV4nkk8K1OO2B3T91+eOCDQdk8ekqGUCXTKp/J2uNAqIwXEFJldwFTb/Z4ZU1ib7sLPpuURiIuy1z1gb3N4TsSVUXf7b+vMMMIB+TllCdMorvsenS3dyLW4QNs593Q0fqOV3eLdxR/bBu0QJwsapwF2yLt5x5XSAdgrKVvu6H5KDhE2ipn6WYGeTYxGBGxME3wLt97rexAEPKMW/ip0maEb+qE+/A3KynKNI3MWhnB6W6Dh1tdHhcTqko7YaDAyWwrqxL+UTg5dNfqv6RksAZtCOyGuId/Qd+4FQtcd8n+OVgWehBP3znNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ghsb1Kt7s6t3IDnF5g3ohm2Vxm553AqFVa3NEmYnHrs=;
 b=B72vVpUZ6/j8zVbwneboDV8+EnkXZdyDavd2jou7Ajb5Ark4jXGdwn4BbKP/UIRrEyayWhL9oIm8IeCe8enwe4f99Zu55a+0PYRARnogiEaLZRR58CPVChxTBNsinDOXdfbY0EE59Jtz6GORscDrLLbJyvIXSqsLQr+TWA0qiAQXo2pBqj3oXtrHKCqVkfb7/3e9z7OEa8e1HGgVJS7v54QbMwuNkbSS2teIMLIF5eWRaRYmWbUcTO1PAZQqqsI7cj7usNyYxP0khD9saj1DG5a74nAU1qSe9KjOOqBgWvHm9mi8haafDE0IL1GncptA4cbUea/FIeG4U49tKCKz6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3d::7) by
 MRXP264MB0040.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:18::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.16; Thu, 16 Dec 2021 17:47:43 +0000
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::30e4:16d5:f514:b8f8]) by MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::30e4:16d5:f514:b8f8%2]) with mapi id 15.20.4801.015; Thu, 16 Dec 2021
 17:47:42 +0000
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
Subject: [PATCH v2 2/2] powerpc: Add set_memory_{p/np}() and remove
 set_memory_attr()
Thread-Topic: [PATCH v2 2/2] powerpc: Add set_memory_{p/np}() and remove
 set_memory_attr()
Thread-Index: AQHX8qUG8PKoUhzwdUWdJAEQIG9ETQ==
Date:   Thu, 16 Dec 2021 17:47:42 +0000
Message-ID: <0e45e5454cc8e53461e6bb057861ab3578afc4b1.1639676816.git.christophe.leroy@csgroup.eu>
References: <112b55c5fe019fefc284e3361772b00345fa0967.1639676816.git.christophe.leroy@csgroup.eu>
In-Reply-To: <112b55c5fe019fefc284e3361772b00345fa0967.1639676816.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fd53736-4687-4d3d-59e9-08d9c0bc2958
x-ms-traffictypediagnostic: MRXP264MB0040:EE_
x-microsoft-antispam-prvs: <MRXP264MB004031A62D93F3FAA12D0567ED779@MRXP264MB0040.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uk90cRpZkQB/Nrk2+JwZipVJmd4Fv07wXJbQ7/9lpiGeAH9HYqTZGw0wNaZS5st/+Uqh6uTZt8JDf2wCcy4Vagvr1f7004dKsdNSvAsKdoEWceDescgRRSSK6g9D4kAb9XnYICCDvDzbBGeprkBfaedXNMN8RRZy3iaoP5UJmDgz9ii0/gdVUi3s3qbtsm+cd1i+1kl1feUC0pbNKrPrKZkmCkTzcm1ghnOf5/ECK8DAhOZkiiictAWwu7207J6gEBUPI3QJDZHDS/d3RrhTrz5VZU226yX4Pikl7EXeiZrQLw08ZJ5/P8BYD6N2rf54sKiTbjjRJkq8vbI3Mq59Q4bArL9pmwB1ZhXaNOc70fi3vuFQxvOzVFyNhh1aJH2eidaNMIjrvlGD8AN3II4ntks5OPEyReU4oPbu0GVGGvxsmsFp9e+jX2Y2CtsX8NNG1CYrAldntpws5ED8tVPvaxop0hBlnidABDnowdBLhgdyYxz6AO+4ZeFzgyKosFiI1liVHKaHF901QF5DtYXl7wgsOsp4ET8+awZKG7uoVf3FNn+5UgdX6ek7JtGxPvv2avgMJB2th0DcyJ/1h+NO8a4DV3h0j+eUsQD1THVDAkEAMX1ytZNIGbfBAe0vnWhF49OtVe/q3QWDVCxuQLlCPuFzm8tCl5GWZdw6O7dvnKlLrQ4mv7tJtZ1GUpit1Gyv8JJOGYSc2BH+K/WwoYcR5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(66556008)(54906003)(26005)(508600001)(8936002)(36756003)(2616005)(316002)(66946007)(110136005)(5660300002)(8676002)(71200400001)(122000001)(6512007)(91956017)(83380400001)(2906002)(86362001)(66446008)(6506007)(64756008)(38070700005)(186003)(6486002)(76116006)(44832011)(66476007)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Ay/bgegcYCh0eKQlefDEWE2uHixU1q5pxBVxF//qzZU5fEpCdZnLIBtEnX?=
 =?iso-8859-1?Q?7fO0ArSSYDwKl2d0muPUE1RlqrMF4uQyyBnTdl8EPfsbWBEDJKZ03oII1c?=
 =?iso-8859-1?Q?mzSFpn09i+NR9jhsMzZ0nrNmp+FVM83d6QjjV/7KrbS85qDzuTWaNackoH?=
 =?iso-8859-1?Q?JDKvM5ZfdLljOMCdSRRY3O+abylvjpUZq6mgzQ/uQhirVyeCu5XVlUHPZ6?=
 =?iso-8859-1?Q?aqhi3qbq91Nr5ZJ4A9yXSdIKLpPOPolUCnMG00fGpK6u20+Hx6QSMd34BX?=
 =?iso-8859-1?Q?DLXUQtQ67DZsSnjnLq4ldHfuENfoeAmTgy3EfnCPxCTat/3xT71Si8YgCj?=
 =?iso-8859-1?Q?RWPCO4HEy7kmMn8EUKlRFNF02iEeaEVkw/XzfG9TThpyYqQFC64KdnyBWB?=
 =?iso-8859-1?Q?ZQ++q+vNdHmtvWvcCDrcT9Sv4xqNrboKfrNX5J528ZuNutupnZO8EcQFE9?=
 =?iso-8859-1?Q?E/fVA+A21ZIYGmKiVG4Gzk/WKNONwTYJBlP5z8AeNs3L8Vu7Scp4e8GkLA?=
 =?iso-8859-1?Q?OzAMvIVeSo04zIGez01UN8n68V2tx98r98iF6KiJEDF1ihIKiOKh8W02Xm?=
 =?iso-8859-1?Q?Pe6327h+oRfICBVfENVXNoO6BhlSajpOZ28sinG7PVKDQI0Omv0MqevdPQ?=
 =?iso-8859-1?Q?PLslzN52nQnwu/O1qgda0yFMz1ZO9IlXhvHmFeU0rTf1bPcYkVQlpIYHKy?=
 =?iso-8859-1?Q?PV7ImbHkGmymxAwZQLl9IjzaktZwEjDpWMm7zOAH82hH/1Sw+RArM2j7as?=
 =?iso-8859-1?Q?7LPulz4OROPjkh8D8fOmXpld8ogCNBFmWbHJEpy4wWMuDTcK8Tk0niLR42?=
 =?iso-8859-1?Q?jrHP1zwuaoWntct5pd+Wc99NLT/JqPrqDxqwhCOszcdG63luEU1OS9K4T4?=
 =?iso-8859-1?Q?7AEYo7c8MADJjkS/v4VhMUndQl8PzyEPRXr73FvB26KpyeraKJs/TTFS/1?=
 =?iso-8859-1?Q?Ag2U7SinYiCc2mmqMJbamFWTWX0UAvGFfoM4/5g2EvJMsNQz1M6amzORRN?=
 =?iso-8859-1?Q?Ag630ty0GFxmqvyMn6bohi3Xp7r03ZbgEVTnJfI6QTzQPQ6pUrzMOp3t9U?=
 =?iso-8859-1?Q?WYRrPh0bfIlqja4xRXVCZdiFj9aB6X9aEau1xZ9YHj1ygObMr9EZrUeCHN?=
 =?iso-8859-1?Q?uz3Ecqc0spatbIajny78alp80a+N9MYOxSziya49h+gxNXNIllTw9MuiZD?=
 =?iso-8859-1?Q?D7TfT6LfGJxOnl+3QY8Fml5prvoYLABOLP1fEh6+DvascRpPy6qrfT1fXK?=
 =?iso-8859-1?Q?PQtF+1wfZZdukgh8V+7w3kBVelm4hdZp541rQnN2EF6qaOdGs5TnWjSAv9?=
 =?iso-8859-1?Q?TGoGSGs1ZMGRIQ5tptHhjskV70w1lnBQu204VwVr6LxVJQvN50MpZRfzra?=
 =?iso-8859-1?Q?kwo75615Cx4pWQlnrYRU4Dpsj8dssgfP2zh/89SJ5hPNLAkU1SkGoXgrrr?=
 =?iso-8859-1?Q?18H/AREgh1KBKlFCaSzbqOSdl2yz5YwuTXJy7H04p9U5uTtm+NBAa+9w3k?=
 =?iso-8859-1?Q?UJfC04XZHXdGjejV7mO+OkYoKcfCLrdhpGE414ftP/TQmwrLptsXCLhO8p?=
 =?iso-8859-1?Q?QNTv7Z6wtiQkU7aioT5eTs+4O0PRb1/I769RQBI2GnanxpKe3fvBYTM6no?=
 =?iso-8859-1?Q?NRAaQzaMfI879sawNHUzZDeKHwkd6drm114qqvxErxyNIzSWq2b1/W7xNF?=
 =?iso-8859-1?Q?eqjNhQxFNDqy+YsQnqA4qs2cvSEySIFAELETePc0ZCvq4p2IadsuHXmnQ6?=
 =?iso-8859-1?Q?MsJyyeDv2vQYtLur9naTDxNoA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd53736-4687-4d3d-59e9-08d9c0bc2958
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 17:47:42.8860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GH9MenvELRTn2tnuc1joTlEif2Rkg07HwXFl+dG+g5EgYavQzr9kch+spAWN9q0Xy1ulKmr+S+fy33VpCLw2RqnaypiL/lF5HTK5gbVOSIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRXP264MB0040
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
v2: Add comment to SET_MEMORY_P and SET_MEMORY_NP
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
index 308adc51da9d..eb5405d410f1 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -46,6 +46,12 @@ static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
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
@@ -92,36 +98,3 @@ int change_memory_attr(unsigned long addr, int numpages, long action)
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
