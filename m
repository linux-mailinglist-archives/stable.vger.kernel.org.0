Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E934A3566
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 10:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354503AbiA3JpW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 30 Jan 2022 04:45:22 -0500
Received: from mail-eopbgr120087.outbound.protection.outlook.com ([40.107.12.87]:29216
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354495AbiA3JpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Jan 2022 04:45:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRR5ajx9i/xk1wzg7Ka8KSZZagEJXKHdZd330+mcm9rIxsH78jAt2ouplLOXdDZ2wIJZIe/xFVtjQiMBjxNFLjbuO8L+Jc6ughKt9BHaRFW8yDnNUAfwKVAktoqrINCbihAR5kh59BI9c1t2CbPs+MJF4YnVdBDOgdLS0nAzmTlBHPa6vj5pO5p1ch87b9VUBpzSfMFffM1U2bYHh+tyVE/2HC6r4PNUqbxyh3OjscdnwMf0vkYxGW2f7HtFPC49MNDUEdI1FiHJenmoa5EoulmhxJdsP2fPjcCU+I2QtB65BB3VY7AYGzIamoUcbPRIvwIwjIKLB+aLT3R5Jhvz1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSPWCh7HwRjB+YO1UEOyP263D6uzTU2jJUA96JCe04g=;
 b=XXkg7nLh320HCshIWIAj0/yN2BQS5hOPXhrbDKY1+J1neA4KBn74SN2jCxKvvGU6OKsPah/NT78OXPutt2H2XTiLuNCkfzgEV0dYAi9uru4Amif41wV5aNpJXKhS4N8YEDzFW+rf8XSOkh4rPCz3BSlqKiih8CsrHLw1j5bRdPRpv6Dg39RT32d7GhdowD3WtohQa6DkJxP8pji/XoG+NA3ZNFkxOXnY9FM6FUXKb4sXF39fFRyPcK4gwclSCiVFXbeqmhMAvTbYnqrjmoKPRPxDN4GD2BlMTzfG5RhL2vkoflR7QgS+6FyWDRWgFRaQec3/ZsHq9QvlGWGvKhGJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR2P264MB0084.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sun, 30 Jan
 2022 09:45:12 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%6]) with mapi id 15.20.4930.020; Sun, 30 Jan 2022
 09:45:11 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Erhard Furtner <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] [Rebased for 5.10] powerpc/32: Fix boot failure with GCC
 latent entropy plugin
Thread-Topic: [PATCH] [Rebased for 5.10] powerpc/32: Fix boot failure with GCC
 latent entropy plugin
Thread-Index: AQHYFb4TnbSYKVIRwUOnBDw9DkSrTQ==
Date:   Sun, 30 Jan 2022 09:45:11 +0000
Message-ID: <aadb01c36a3f325c6eb3fe08ef5fd3cf4e50515d.1643535371.git.christophe.leroy@csgroup.eu>
References: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
In-Reply-To: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e278c98f-5c4c-472d-c508-08d9e3d535d0
x-ms-traffictypediagnostic: MR2P264MB0084:EE_
x-microsoft-antispam-prvs: <MR2P264MB0084CF7DD1BC546FC5F253D6ED249@MR2P264MB0084.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jO76cOOtu0VmHHfa2xQTKmVzsRLxuTzwA8rs/aJLRhpsdLK63VDVR8HbD7SP/6QA5PPMHlEJtUQrmp9qYHmP3GOavYCZz3DBvGNrh24+02fU4WA6FapaMj8gJxb8NzAGAEQzRVB2Go894mp5B0hVjV0TsFWoB6qLSaupou7dUtWkvz17v6h31lP/QGnavMgDZDE3Xmsw9nMgJ4niUuT1yZUBFkhRELfPY8B92EjQSxEbW1reFNTcEDVWetX42SOvNFOaJ0LQulR9fNpF8YDVmzVKYZm3QhLmq99/6m2OSP5XpV2gOCpEZptU94X8bcKyjD8I1Iy5epEE4x6hFLlDQNMZ+4MnHTwo/G3t3B8LSnuNvaHyySOr6r2ydcjDxq+1j7RTenjF2Nfl4DtdgBEDXEaB+3Z6UVSmtOiI/CgS+FyP/qIN+vfpIQ6i3uWrHngUE+JsqsGQ4FdFGviFK4uTgJuSAJtLI9DtOv7oZ03d365Jtn5iwRksn1eG+IHGcUP7rlxZ9QGru/v1Tsev2EKw2JJhKZhQNJ/wms8hQLnDjBvo4TuhT+Sr+wgVWZ/TdpTB5VTYCNvcZWXOxhJyiZjheIQVrEq/ICh7NiaNXq8fqeuFraXX7ccEkdJDFe511+mkVMUJy9se8GpoHYFwY05HGAyvP0O1TB5mnUY86nMTgs57oDJR5a7bwNGlvJq3c0X/erq3DerL2PBtpD4hMquGHXYfuXkbjGIbVs4rj3d5rIFJyWt6Vs0GDp2GY6Q+JK/Bp0ajXOHc+NFWX+YVzKJdk/OltGeDtrdeJBYL9bKO+Og=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(44832011)(26005)(83380400001)(186003)(2906002)(38100700002)(86362001)(122000001)(38070700005)(6506007)(76116006)(966005)(508600001)(8676002)(8936002)(6512007)(36756003)(64756008)(6486002)(4326008)(71200400001)(5660300002)(66446008)(54906003)(110136005)(66946007)(316002)(66556008)(91956017)(66476007)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?EGYmBRPoe63MyQYUbqW+gew214h8/FuiIY+yZ2P+KltMdr7Gj+6J0gIsa5?=
 =?iso-8859-1?Q?zrPqPgMJ1esAiFFRpEOXK94kIpUVRMTAXj+RMbqHrGTF21MRDw02Txqnle?=
 =?iso-8859-1?Q?+I5AihY+YnFVMu//7YaSUufuOY9JJGpsAFXhvxkTkPRN3OSLo+SbGZHbDh?=
 =?iso-8859-1?Q?Uzct9stw72TIv9YSxocvko1VknxKiEU8ZKjiQjLe79mWMODe/ccJiTVRc+?=
 =?iso-8859-1?Q?wuI4WDmoPITq2AJom+bZ+bDlksvJu1JlDDYW3AYtY5DE72paM2UqUIT6mA?=
 =?iso-8859-1?Q?SAHUGUUGcj60qfEWYV4pYbHgfTjPGP6HIR/Cq67gxDXZ2YVOBjSrwfoz0r?=
 =?iso-8859-1?Q?6BGnPiYHc8Dol25mRoUIhgb3ZNE3fKvLoeorGZyfVQSbnQs12RIl21Qphu?=
 =?iso-8859-1?Q?LKJYGF0Y76bkey0oRWsb4nJzMaW6jkLVk32D6XCvu5qOk11Z1HKXzRoIkT?=
 =?iso-8859-1?Q?s0fiZRvZpYoXFdQUP5BoAWCa1xwbnUwcbVSWQKHcq/1ZvOcAT6zO07cq3M?=
 =?iso-8859-1?Q?V8/Aaqslnt9eaSPPr3RPfpuxRH0s6zNjvnCt0X5YOY5lHpn15bfG+NkVkw?=
 =?iso-8859-1?Q?OZdDFSyyFD/uGHdEgmFnVZFu/OpCHaMMTsVFVH4g/nXSHPEji4FLoE+n8Y?=
 =?iso-8859-1?Q?0q/AXfuP2jg64qMhsuEO1nqk/7Wc1KkLgClTRhGuFduy5jkJfmVf4bGPx2?=
 =?iso-8859-1?Q?kZEDKamlgbMh4ScHtKFZIYd2P9aG8q+7nFKaw0EqugUyljaZx02pUIcpL6?=
 =?iso-8859-1?Q?CUiWAJ4eAJ2pLd5CsN5kQnDvoh4C2/EmJ1GzfQXP4MhkZ1jsW04vv7dGsG?=
 =?iso-8859-1?Q?2KBP9BQ7XTUIBYm6k1KsKOlZPb0xeUP0Y8nLxCNvwPXLJ3bItOvF41o3gH?=
 =?iso-8859-1?Q?PBeEOzfM/K2UI9Fmu+DuOTSwoGctzCwTWbrx4ExxADQ3nI4jLsQe4/je5z?=
 =?iso-8859-1?Q?JlCmfTjQDyQIaPGjnCOuJ+Tg8RPqqd3+F4Dg4RYpFRIPyPjNoOHVRO7iTq?=
 =?iso-8859-1?Q?BnHUwiskfaWpYrKzh8HD65CKRnwUkd7OPIJYe7Rjc00DeEPW34ewaYG2gN?=
 =?iso-8859-1?Q?N769cpxnF/zBTvlalyIri3W3PNLv34fMxjJV1OIcJe98NRjozOC/5NVQ91?=
 =?iso-8859-1?Q?Xj5IhYM+rhE4MtsJfuOe4B+3wJBxjUilfhanUSciCjMOTi3rKUcLTDs/X/?=
 =?iso-8859-1?Q?krqL5x6bZnP4R/WcTa34bAknpIr2BGhSdT1ZIEkuGwPRIg5JAUyKiCNlBc?=
 =?iso-8859-1?Q?5Rnpr23d78ZoJRRa+1OzgJZRlp/j4mrPW4P9wPzbpP9UEkEK0JI2vJUrtW?=
 =?iso-8859-1?Q?Vw4x+N0yrucuU5GszXgpp5TAODFgtxEsjCOdIiBxZGEM9q5Q44ICJoIx9V?=
 =?iso-8859-1?Q?JzssAAIhGS9VEEgrxHkKehNt9YPdxp1w7/goy/nitzWuDRhULlzQgonpXB?=
 =?iso-8859-1?Q?nWkbCvvI2B5nOe/IvzSshiK44VtOn/qQKBrHwNr3aFF7QmCDHYGR9g56w3?=
 =?iso-8859-1?Q?LE2/RDj0TlUwtULooFohZe2L6t5tfGz0lwQV+7DXQgSTKGD46QxkCULDAo?=
 =?iso-8859-1?Q?E/SMzG86J4LZih2IW7tr53FNgpSzYTXl/Wmxxt93BUfJYdMYs/LCaqcdd0?=
 =?iso-8859-1?Q?GzfkWKijjKp8s11+XKbnL+yjDUpDrSPjPmjnTiCaUbxBtXddoxmLnDN28/?=
 =?iso-8859-1?Q?jJDZHkZivAPSejop/K7XmnWrDVStjT789wwV77Q0KIAmagQQMUfRwag6oU?=
 =?iso-8859-1?Q?0loKLxIGX9zcJlAojYtvaaCCA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e278c98f-5c4c-472d-c508-08d9e3d535d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2022 09:45:11.6132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IGbuL+wRGmwfHRdT/1+7wXe1mNV+xmZBrWSiauYQxzlVNHCTmIeMYmU0cEunQg4saw7wJScmVtnpIBjdm8mZOJW2wIS1iCoryamWkD9hBe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0084
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport for 5.10

(cherry picked from commit bba496656a73fc1d1330b49c7f82843836e9feb1)

Boot fails with GCC latent entropy plugin enabled.

This is due to early boot functions trying to access 'latent_entropy'
global data while the kernel is not relocated at its final
destination yet.

As there is no way to tell GCC to use PTRRELOC() to access it,
disable latent entropy plugin in early_32.o and feature-fixups.o and
code-patching.o

Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Cc: stable@vger.kernel.org # v4.9+
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215217
Link: https://lore.kernel.org/r/2bac55483b8daf5b1caa163a45fa5f9cdbe18be4.1640178426.git.christophe.leroy@csgroup.eu
---
 arch/powerpc/kernel/Makefile | 1 +
 arch/powerpc/lib/Makefile    | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index fe2ef598e2ea..376104c166fc 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -11,6 +11,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+CFLAGS_early_32.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 58991233381e..0697a0e014ae 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -19,6 +19,9 @@ CFLAGS_code-patching.o += -DDISABLE_BRANCH_PROFILING
 CFLAGS_feature-fixups.o += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += alloc.o code-patching.o feature-fixups.o pmem.o inst.o test_code-patching.o
 
 ifndef CONFIG_KASAN
-- 
2.33.1
