Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383F947D2A2
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 14:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245227AbhLVNHg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 22 Dec 2021 08:07:36 -0500
Received: from mail-eopbgr120072.outbound.protection.outlook.com ([40.107.12.72]:23017
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236364AbhLVNHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 08:07:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htk6iZ9/q6+NZrwlCNbAOBh619G5whyLaQ/NWBoBGR/hhmJG72S9sHv3dgMFf0/hD8+S8mdhtsFn3ReWeSQZ995ZCeBI+Axz1N8l8GM08mLTAeI0atEpo6FItBv+mXkSE2fM0QmnukhOplGQI2ueI5Qi3Lz4jOoLo4URTCZfvL6zqVfIgTgpYXHKCRbmhbAd5zHtKBnf1RlyXuHB9LhtiLa6qgU8rrK8hLQWom63asH44tmL7BkF5gitELt5InF2BxWrO/t6i1PlCrEZGZFNFSnciWC5QbGFrCrYf/PMlNdxojBvUnQA9XM9urajBjDtK4n6nbkWmloouOq0tLwS3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJxvT4w3APTENeCkeumempsVVsuseo8lKJJm8KOv2HA=;
 b=GYTY5yNXHqzFZF3BPoU6cWElx10ASwjnE3Vbx6uMXJC6PP+OCjfq2WfrvKhyfHEMN26kY3ze2XCLFmujw6l1ILx6AZlBpmFCuONLE2KFOb+6kUNSRlNFCR261RTMRUNsAUrc7/71jgU+0h73eEYtmY3dc4nuLszV3SAXMMk7qf77nR5EEQWZzvJq10SVMAZQyI5ZIopqI/CqHB0StzDNiAAF2Ut0jgVLIzlDocFkllFJqIzPtQCQeeuaObR/HHDQsf+cAg6P6GmPgyu9e2uYXX0eNfjNL3mQVnZkU+v4SCUijYFOszbCT8wabTF7Bt+c78EX8TPSurpZ+9f/u813rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2691.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 22 Dec
 2021 13:07:31 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::f0ef:856d:b0de:e85d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::f0ef:856d:b0de:e85d%7]) with mapi id 15.20.4823.018; Wed, 22 Dec 2021
 13:07:31 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Erhard Furtner <erhard_f@mailbox.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Emese Revfy <re.emese@gmail.com>
Subject: [PATCH] powerpc/32: Fix boot failure with GCC latent entropy plugin
Thread-Topic: [PATCH] powerpc/32: Fix boot failure with GCC latent entropy
 plugin
Thread-Index: AQHX9zTg0ZucU0S3NkiOSQU+B0LkiQ==
Date:   Wed, 22 Dec 2021 13:07:31 +0000
Message-ID: <2bac55483b8daf5b1caa163a45fa5f9cdbe18be4.1640178426.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cff732f-717c-40ce-b0e7-08d9c54c0343
x-ms-traffictypediagnostic: MR1P264MB2691:EE_
x-microsoft-antispam-prvs: <MR1P264MB2691CBE7C80C270D23BB7E19ED7D9@MR1P264MB2691.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0TqfSMN9WmKjdQ53kYLE14pOOVUsS6dZDSX8Ey5CsYF2r7Ri+m1tTcW9Nuul3adHof69IErBruQoZu8i2No5V6jJ/nfMwI4A/gHZxhj1k1zk+71RA7Z7UnYFWpk6tAXOUNzqg16XEQB0vbEFW5sIAxzxemCvxbLs2xti96/Sc5mVFCjv8uDfPqjPzt9lE70RdGEOraqXVOs1NdLb8gcw2xp0o7s9qks5Ji3KWZan3UwUBRIHGFHxJNTkZjC1Es/cCy0w69KCUuKIAHaw9JqPZ/m12/SAQ4IO62NmjB6aPe8WWaqjPFelyLTqsNLT4/WoTNhBej/nPX1vpomIr/IINFSo3l9jIpcXWAPdIHxajcuOg6rFTdTKEYaIaF4HD9ATEF/YIzED32qTqAUFL/9K+mF2VBNhdLu8TfqWQZhfn/xr7fSSJl9PwmyCy8mld+bFRY1BYhEXCukgA6RJqvYl967xW2z19E3be/pPXgDI4XGZfBvy1FxHa5LJ730+BY5cQlsNc8aqPI5leIMnaBV9+4Kju+d5tpPnlR2i/jnAJwRG3F7xzFHIPkYFNNnZBGOcroR0LcVftV34O6OBwgJEixOO3G4fYmgizZVRcKxOQJfqcdZIe6jE8N4NhJOWPOCiwhl4SVp3U2weY9vrp3ctAtZUqk/1jk6fHiUx3FiGFM91E6vzNTlopLGYtZLX+UX3TFK/nbwA9SzDvoqzdN/hzY6KSYh9rfSxKlbB9nXEoChrGnXtB3S49UPQU4bJAlxf/H6BQ88useUWIx9002VyxSVj5WfO530b5Bt79fj7o4s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(4326008)(71200400001)(54906003)(86362001)(6486002)(8676002)(2906002)(8936002)(122000001)(316002)(966005)(508600001)(76116006)(186003)(36756003)(6512007)(44832011)(38070700005)(5660300002)(110136005)(66946007)(91956017)(26005)(6506007)(66556008)(66476007)(66446008)(2616005)(83380400001)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bXMEWbhxwDyJBrB05hDwBytmyhnB+fEgHpHGSp9MKD8en4QSkKfmOQ0LtV?=
 =?iso-8859-1?Q?oHi5Y1o3Sx5vuyjr7qK0eV4CyU0wy3iyAdJsMrZkabae4L+PzZY3sxW+rz?=
 =?iso-8859-1?Q?+zESjwRLsFF9v7LTKKRHsiqoHU02VwtmpFZkdDPzf/RLiH5rSXAFe3hcg1?=
 =?iso-8859-1?Q?YJ9xSvaRoGUSAPOVsinvSkCXd0J/rkQ3cJuzja/RRyVtjfmdb9Sn6D4ror?=
 =?iso-8859-1?Q?zA0ANuVl1lYoJfKTEsdgBsMjgtq9aNaMqxkuO13dUMVpWfa94eNLduEV25?=
 =?iso-8859-1?Q?QMHvBxLBIgZoN9NhU5mswZfH/5s0V5KQFlpaRN6Y/vNhv9QryXTZyd37eI?=
 =?iso-8859-1?Q?SFtL4ho46vyr6EzzRGzEtszBUwNFgDnt8H5CPr74RjBa5DO8si7C3BKq0b?=
 =?iso-8859-1?Q?9O6HfdGjjN9VGp7MUJKWK3Wk1z6TAtSwTs8HTI1u0ENDboajSb6GR0GeTr?=
 =?iso-8859-1?Q?ytnHBKW3tQZcEfuX4zO0NB89Nm4W+4v1vNaLEscP1B6vqjHZ/edmIPA3N3?=
 =?iso-8859-1?Q?QcJWSI102NutJXXiI5X1CF4u1mhcqM6tsNyuZvvwgMvxcBrfGNr/KKiUN2?=
 =?iso-8859-1?Q?BCz96neI8RgrqrZg/ezpQWxMAyBZ+svhHPuCDgCbPfIQvZ4cYZVZYOyvva?=
 =?iso-8859-1?Q?L8qRv9/nobHj/shKwSNhvxxUKvqp/t/nVEYh92xNS0IjNOuzHY0W/rlIDF?=
 =?iso-8859-1?Q?+NdWZRIQlC7L+ivb1ArcPoHbjurkxz+3y1czCytjNQHDWuXlQHwvpbJs92?=
 =?iso-8859-1?Q?DNFIfXfD+R+ZmBOEBfOvb0Ir8hSUTm+/6greGi827hqe8wkW/AZds5DkXx?=
 =?iso-8859-1?Q?jgkzOBsQ3Y/ApeUW65gMaoO65gwZbiG3R1z9Vk75ikt5WlOvOlLBVUCc4E?=
 =?iso-8859-1?Q?vaMSQStErYlzzE6YCHEPR/9hXOZkaOFNuNYcPpBR3Z2UXImdi49Ngo+qYm?=
 =?iso-8859-1?Q?WlqQDUSd122E/0UcHN97BCVmgKaqcqMyjEfzMLvTRkl9QcXuzJHOsQgzkn?=
 =?iso-8859-1?Q?ozK9Ta5a2ZmckK5UjPFoFc/UOM07mFMXUojhot6VYr1/YUSEQ5I9B/7g+d?=
 =?iso-8859-1?Q?+iOnlnwIqYqbcudodLoXT5bLl7b10ih+Co2ADzaPszKwCN/N7W4GvRWle+?=
 =?iso-8859-1?Q?o8WzIsUFS3dobdVUFRZ7qFk16mUtT8MXSKX1kTqiG1BaOd0nPMx2+04Ntg?=
 =?iso-8859-1?Q?Vgy7/16kb3RNLrWlcpBABnfLYXIlIxc56Y5bN0nESjtY0Z3AV1TkHCnMpT?=
 =?iso-8859-1?Q?PlVHzCHloRQDMPVRHsgeF9e2p8FP06sCQpAdbUzN/5CW56tCvMn+JfA1TV?=
 =?iso-8859-1?Q?0xn+dlu6kWD9yoA7bGD2o+6txyc5FL+r0uDSY7hd/CaYzO8OH8k17J0Wyj?=
 =?iso-8859-1?Q?W4J0WxoR9+ah7EA0sZkQNf5nfulo+hS1hMtrwcnE62qgnzrmSPzOLeDJZj?=
 =?iso-8859-1?Q?pF8cAYGFqGN7pZ+2AQrra72s8+QHBWXQjLi4vpJLEVDxmkrJEctoYV9yqU?=
 =?iso-8859-1?Q?ucsClt1cysf1AXB34yTJiFz0IX47QyeD50kn/duIKauESIgUNToRE53x5A?=
 =?iso-8859-1?Q?8XRo2fAmuyNc9mDhD5GoxcDrh8MNJi884JfquZY5X44CPnKlIjMkhLO++4?=
 =?iso-8859-1?Q?cRF3QTVFJFlHAZs3gCa0zzXvuaX6aYvTRGMpX6NGOvsiIdJmVMnwclOirZ?=
 =?iso-8859-1?Q?RwhXHpE/lU/MYLevTCLmCqY5nUnnTVnbN424+iM61hpmGOoWpNQmzh4J+J?=
 =?iso-8859-1?Q?peH6WYIOqXg5k9KO/VKOZwl4E=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cff732f-717c-40ce-b0e7-08d9c54c0343
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 13:07:31.1808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uAAQHNhGvIRk+xK7JMMghzaHmK4RXW7FxVwuntkNnPRJDvPJHhTd6ukcT3yLaZzKM3Q5u3sqsA3iQIOwWR8/qu/QmPAUifyKastFS3CUuK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2691
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Boot fails with GCC latent entropy plugin enabled.

This is due to early boot functions trying to access 'latent_entropy'
global data while the kernel is not relocated at its final
destination yet.

As there is no way to tell GCC to use PTRRELOC() to access it,
disable latent entropy plugin in early_32.o and feature-fixups.o and
code-patching.o

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215217
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Cc: stable@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>
---
 arch/powerpc/kernel/Makefile | 1 +
 arch/powerpc/lib/Makefile    | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 5fa68c2ef1f8..36f3f5a8868d 100644
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
index 9e5d0f413b71..0b08e85d3839 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -19,6 +19,9 @@ CFLAGS_code-patching.o += -DDISABLE_BRANCH_PROFILING
 CFLAGS_feature-fixups.o += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += alloc.o code-patching.o feature-fixups.o pmem.o test_code-patching.o
 
 ifndef CONFIG_KASAN
-- 
2.33.1
