Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640974A356A
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 10:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354526AbiA3Jpc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 30 Jan 2022 04:45:32 -0500
Received: from mail-eopbgr120087.outbound.protection.outlook.com ([40.107.12.87]:29216
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354510AbiA3Jp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Jan 2022 04:45:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUeXFxrmHq9nE4bEyfY6JxM3xd33HxwJmQLkaejhsXWejEoKheC/LGdz8GYnhm0fiJ5crYxOmJfcz1NolyW87P+9YEPWGJkPHn20sW6qzz/2NKqIEsby38HUKArTCM2g2DmUQuURG1MyRH287IskQ4L3IghBplPgJd4uVQmUMXrm5YDwm/yXUXDQC34d4Io2MA2r5sd7Iu8CE5n/K8BvuQQpK+KQfTHjWkkE/G2KcOXLOjvSQ9zcqI2thxK96SYFaDV7LgDHriqSYlOFgmyXk3YcTRKIqeiXg45270MN444jtvezirqXnVEmM4u7ebZZKdIYyUF6UC8XpMB71PPpSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHxF4peXwsvgpdfVOc2MOb3MX3VpWCURlsgx5RAABYs=;
 b=FFzbxahQN4uPQS0VyZfQYA3AHD50ZIIeGPi3nyWCZJD0eCEz+E1lcxw2wdcYNiC8gTzUizatV21UkhB2xIgfQrIXpufKS/iAQ5nKsOoOpZbjffGZBirsENG27ZVIsNSYACFJsN6mzX8rXafse9J7utRRdsNHyYGnBV8ECijnPvn9sYCZ8tGC/PmzK161DNPQ/GD8Ho8Riez8WajZNuIx0uaKsPYp2wqwWOz0XU4/Pyrh6qjcNPdghZ1kPEwPnOQ4URCkQlmG+xEuop2xbxe8MeOIvBvpXEW6waEqyR8X/2P9A9wIdhTwIzK2rEfJAZx4lfdgYS09Ha90BvJetQb0lA==
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
 09:45:12 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Erhard Furtner <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] [Rebased for 5.4] powerpc/32: Fix boot failure with GCC
 latent entropy plugin
Thread-Topic: [PATCH] [Rebased for 5.4] powerpc/32: Fix boot failure with GCC
 latent entropy plugin
Thread-Index: AQHYFb4T+yOsvhjVoUOfadQsYca3gg==
Date:   Sun, 30 Jan 2022 09:45:12 +0000
Message-ID: <2e04e534ae03013524fec4ca341d7e8c9aa9e8b2.1643535437.git.christophe.leroy@csgroup.eu>
References: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
In-Reply-To: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 071f0f6a-089d-4494-0107-08d9e3d5364f
x-ms-traffictypediagnostic: MR2P264MB0084:EE_
x-microsoft-antispam-prvs: <MR2P264MB0084B1B929862B6108A3EBD3ED249@MR2P264MB0084.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P9ixT8nqoqGZwtCMh4tVeRTUVXBj6CWkbqx9rCey64vvuobFTBBn9K/3OsOwPdcs45JFP5wycgL4QbiJv8ae/KcYzWWJ7/4L6RZ7HzA/M4NDKnY4SJ7u5drSDPY8PrrJnMYKyo0c3jPPYLDbo1b/xFildhhMHMmh7Jmfq/+3czNTcuUK+Ssu8xc3/+ePoi0lUNR/MbCHSmwhRDwusgaeyMZ0pL4WE8ZQ0Hu8sF2DqRANDOAwtPJr9F7oQ96d/v4Pkpeo3Ge7avz1MmC0C4uBOSiHuZZk9dW/ZEhRcM/O0BUsujmsaoqRwo/1ABtlyk+FafMpQZpig9fExl4/xKJUQyx2xl+TJkW9MlLXP/5ayXtbrI++rPOUSDfPofaULrzGrHDeXAuipsQvdqhW+T1DNBS6MOA0mVWSS430U0D3Ymz9StaMm552bxVc6Cm3e0ZBUrU7AFQbDLqwPE2lbR/2BXzveeAOZaaIyb5DwJHg1wZLWzm7ErqsObPDvrNEEa+KEC4+Vh+bxGaRaLr3HmHILFVEOHeC6bo+N08IDRuoWF80N3UXLkt7BIiAqNcKmyptU8aanFbEObXl5Qo+lkzjv/j8EpO2zeOUs+oXIMFdjg6zV+0Mnek1GNXhVZtJd+vJV5GZD8UKF5R3x4vvbANEpMyMoxKOLcRq0R5AchhYA8iidtyQax9GCGms0HTQ9wqsrpmDBLVJ+RBNtZggU2Xlvn82/qREPMuvv0LW2z1XGWuGQhKHilZyjezOeGQHrBFD55FGCnciR0U4eHTefVJBvBXGIh+ArcCZzDIhobXjAHo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(44832011)(26005)(83380400001)(186003)(2906002)(38100700002)(86362001)(122000001)(38070700005)(6506007)(76116006)(966005)(508600001)(8676002)(8936002)(6512007)(36756003)(64756008)(6486002)(4326008)(71200400001)(5660300002)(66446008)(54906003)(110136005)(66946007)(316002)(66556008)(91956017)(66476007)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+HZrIlbvzqgLKrX/v5ZsQH0s/AlsUexc7xKcnGRgU8ijeZX4enE1TPDXMF?=
 =?iso-8859-1?Q?B6OVl4SpS2OK5BHqtg6VH4/FeNavHtKbXS6Qtapk/XJw79MdVsiWEGpCCh?=
 =?iso-8859-1?Q?5VxqxsJybSUMKbmCmgpXvS8uQoxIwX2U9Kt2rO9jmrHhYnwmzT+DUQraF7?=
 =?iso-8859-1?Q?qqEqoJTZev1GiLkG56OgsATMnNPKlRHtUScW8YyV6CEP670E1ITR0ON7Fb?=
 =?iso-8859-1?Q?pJsvJMvwldq/gY36TdTNJmNRP4F23qxHoCFzdr8iMaIy5c6GoZTllU2NX+?=
 =?iso-8859-1?Q?K8iqVCXeZvkOE1nO/5aqE6Uvo+BAoJIFhijAcajmWJxhxRuejrvyHxZu6z?=
 =?iso-8859-1?Q?Y9Uk394kN19jrL+LnPWRaP+MNXDc5fZaa+ZLisdAo0vHcK+IwIrwm/xoze?=
 =?iso-8859-1?Q?VcC0Z2A5MoO1ZVW2R9yYi+XSvFQUuQCjgCih5vV+U1bXbIsVTsk+lmvvai?=
 =?iso-8859-1?Q?quftr9HlcKx3/Ef8EVZoXITzsQzEBVLSESzfiejp5cBfepVi/d/OX5jj2X?=
 =?iso-8859-1?Q?5gKxienNK5w8yXfDdJUv290MAk7YthogBtqT+iaVo7woTQJ1z+tkwXSRAx?=
 =?iso-8859-1?Q?WqUQ1oHavMNeRGSewoY3e2FSRVqylkhuCBEx1dnEREnt0OMHHunZiw1fSE?=
 =?iso-8859-1?Q?QxUs0wHeoFZDHoPfTBDa38ylaNcxAyZhxIROgvVuDhhYmJDfoUGuJe4YbY?=
 =?iso-8859-1?Q?KnoLMJsu1bWowjv2QFyOooyp5GwCLiIUH8aGxCMzhILb59VCK/OHIvbN4r?=
 =?iso-8859-1?Q?onmx8FsJtr+wGBvGpD9fq3wBi1RBAZLVPbPSrKTM1N+johqoFe6ZwMBW+O?=
 =?iso-8859-1?Q?Ffmhl5aD/Rq7rtirSQHodQ406XPDoHOolbh43qmo8qMSxXQlF3bRZnoSRu?=
 =?iso-8859-1?Q?eAlKyg9aDySwpRCvmuoe9wRAQ33i5HW2l4LUon3J7r9UKmFqhSaGF7p7bg?=
 =?iso-8859-1?Q?tFWjKmyZu55G839YaYvMB3aqrrtJWaq7dquEZkItonMRxLt9Ou4dvvRS07?=
 =?iso-8859-1?Q?KqbZWkaMM3fAI8fjUJw8163aSZgImZgo4BfwRoycAV1qESbdXLesF2JMI0?=
 =?iso-8859-1?Q?UbrAH8lMsK/w9nw9UBfiUWFskb1NBq360HGBc6dejGakotk/1Ql33uUtHk?=
 =?iso-8859-1?Q?iCPee4v6UfC4nLa0rxdyUqRZ3tqextsa7247Yuvt2ERnqWIZBK1I2rmX5I?=
 =?iso-8859-1?Q?x82yr4WXTRZ5Me8VyUuwpfOTS2Q3xOxrvy2sSuPeHx9z+jV86g1tDjFGK7?=
 =?iso-8859-1?Q?cYBj742f8NMb/pZbgWBU7GI8ULVMt/VNDx3lHQ48k5elWfXMmTmLt+KFBd?=
 =?iso-8859-1?Q?JmV4+EKMgd0zyVdb6HwCx5Nm8VU1DxZ9R/sM9UR7UltYMaIGWF2JFdMout?=
 =?iso-8859-1?Q?DPoK7jJPnD/Iia9bBWPYy02oqO9FFNQz2F2k7RPdCu2o48Z/xanl7ZazdQ?=
 =?iso-8859-1?Q?vvXQHRBktJNk+xersECKrtrCh4KJi2rye+ssl+OKkinan63qW/UAVVIqxn?=
 =?iso-8859-1?Q?sEsqALnxcWzJXxBxDBWpKbvOajmDdc76t4TUyL9El59HSrn1SNhVo1m2uq?=
 =?iso-8859-1?Q?6CCfK0skX2wzKJafKuyRcbLks04bw0Op7Y0pDC2UAdmNm8onhpIliKvN3T?=
 =?iso-8859-1?Q?x36bEjcpHo1morONPaq1cpw3s3zRe8PKR1sOjdmfI0Xgq7jVsV1k6mZ7me?=
 =?iso-8859-1?Q?YZoxJDQdNB4g0DQsQjcoHmdguO2rgXqPuqRds44dD33P2/+wqNFAisA6RC?=
 =?iso-8859-1?Q?2jXtH+8ODPIPHFvIYotmT2pVg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 071f0f6a-089d-4494-0107-08d9e3d5364f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2022 09:45:12.6923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JjhEi5cbqrsKFqhxRm248ceQc7wHLJdZnyTtwZJhOBCOwYZiXuknOeoJzwEpi/JjkbrdyEKmFpKV2b13EGqAktIAz8lhcKg/svqfaMhKqoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0084
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport for 5.4

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
index afbd47b0a75c..5819a577d267 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -13,6 +13,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+CFLAGS_early_32.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index b8de3be10eb4..8656b8d2ce55 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -16,6 +16,9 @@ CFLAGS_code-patching.o += -DDISABLE_BRANCH_PROFILING
 CFLAGS_feature-fixups.o += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += alloc.o code-patching.o feature-fixups.o pmem.o
 
 ifndef CONFIG_KASAN
-- 
2.33.1
