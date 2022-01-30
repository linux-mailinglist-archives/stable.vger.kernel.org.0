Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643DA4A3568
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 10:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354514AbiA3Jp1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 30 Jan 2022 04:45:27 -0500
Received: from mail-eopbgr120087.outbound.protection.outlook.com ([40.107.12.87]:29216
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354499AbiA3JpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Jan 2022 04:45:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1BHN/cv60LRSo003OVfWjjZgLE50I5Gk6tPW2GBwggYV+r0R/jHM9hPFYkbfwi66m3AFD4YmkXRXenzmjJfIqycCXZBVUqS3bv8LePnYyw+qKzOCAibzIFsWyU+7chTkuBqF0UU4R8Ju+YiguvXu0sof12cmDqR7q4Pzm8RD0I7KTb4peAG3N00KyVTAH5aGc7Tm6pPqgTNf1wfGTWyZ3X9nhBWvheAAz/qFTJewX1iJwB976+epwdIzSUmmjOUTxhdnSuuWxTUsRqKpuH8krVQpLhVfDyBVOYOq3eFHGoKjoZV+bAUIGY6INJ6UX7/+K7ZEThQmvZwkDBj7ilfhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKLFFpCrjGJVcfk4VdEIQb81xnAU+hl4nEShq+yPYVU=;
 b=fYR6YPm/QtYFn4qVecuktGSD55+tifGXCFTTq/vlRNVeJBoxEfjWOS5MjsgXmGSlAbHfPY7Jf6MFspIrzlUKjKuJ+41bhXapPfdaFJ7hHSVLOmTUGz7yr38cYmDIPxkpNknh0L+mlDL6K/5Vdfb3c2qvWcMVks9Cnrpow2MEAbf9Tzzc6L0VzHRuV8oTlG3qyqSARLYxIOx7cU9OFtq88YueOuM/tpZoizECwiXwB2XIJnnCnj+Uqrby3iwo/JVas9LxCHb2VRaH27rbYaW/V6BQ+q7czTRd/uraTUrYu8QFMcurmCBodpgYPDWs9nHOOYoXr3p/FFVp2OQzFSiq/w==
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
Subject: [PATCH] [Rebased for 5.16 and 5.15] powerpc/32: Fix boot failure with
 GCC latent entropy plugin
Thread-Topic: [PATCH] [Rebased for 5.16 and 5.15] powerpc/32: Fix boot failure
 with GCC latent entropy plugin
Thread-Index: AQHYFb4Tp5XsdKGgp02AJT814XeI8w==
Date:   Sun, 30 Jan 2022 09:45:12 +0000
Message-ID: <3deea43de237d9eb35340cc2784c9373cdbdc96c.1643535400.git.christophe.leroy@csgroup.eu>
References: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
In-Reply-To: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53954399-3028-4c3b-af00-08d9e3d535fb
x-ms-traffictypediagnostic: MR2P264MB0084:EE_
x-microsoft-antispam-prvs: <MR2P264MB00848FC8AFA0E2E7BE7B8806ED249@MR2P264MB0084.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cu9QWUmv3G6RtSXRluoqKALZBHbssvAd2i662OezVnYC7HATVhtZEQ/+855KUQeRuBq+IHA6xcQ55wse6c8L3Fcdl1OwCI6tOlEbC1HdcO2X1Mk2SbyL9llVAhlK3BK19P9fXv2N6GHeMvTAPE54YtssQHXkdAILJ9SMCh1S49XxRer+6/VElFMVPdqzhGcWl1ibrc2CSfAAu9Zgo8O/NBSIQrJYiPZKjy2RJe+wsiVFiwydv5jONK1En8RHblpJHr0ZTdudSxfg/xiGgWyv3GZ8uFjUwfyx0y5L8cqZ3eQLgi0TgNDQqN5PeFotCKO2j0/rW2kEhpf81kTw67DWXKYrYmShhy4E1IO0wUKB3EYTQAP3P7Jx2bicFvNrZ7wbRR5nYPbwa8+ea7JL64QVRsq229xWIT9iR5efvIFswPZX0VsVdyCAuCu6+aKIiZJ3qT1xFWLvuOhr/SatcD1BHJkEz6R/zFgju1CXlZuL9+9zbgMh7P0MOkAP/4PBhLuRAl0d+iTQFZy1yAr0OSovLfSZs+1/z3yFKfsEyRvRLiOqnsEFX75A8tPE1mOrpDG8+SJAxdYYu4T8Xva4eO8erwlxm/6kZfU1CTwUErVHiMejsD2LUUqQomUkeOYo9OdoRlAlo6Ls/bH+PKZhNAA9l/1XeYySa8s6A5dUqsTttgSqfM4dZ9QzXZkjXu7SgjMmCHf3W1LC/glfZzAIcKK/e2i8a9LdWUgVOUO2PrQBy6xNzZXesy2tEvMQnoXe300wMb29udLV2W5veFXFB70rfC9Sf3GCBkmd2xVbtDIo6+w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(44832011)(26005)(83380400001)(186003)(2906002)(38100700002)(86362001)(122000001)(38070700005)(6506007)(76116006)(966005)(508600001)(8676002)(8936002)(6512007)(36756003)(64756008)(6486002)(4326008)(71200400001)(5660300002)(66446008)(54906003)(110136005)(66946007)(316002)(66556008)(91956017)(66476007)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PqbnAIoK8PCl+QQgD8TxzTktC6avtE1mhPsNB7yf3j6SQ1OCfTvZzeLF9N?=
 =?iso-8859-1?Q?pZ9+W0KRTwU45rE+bvRAB9LbLkWK6DNoD7YiLaAwjbhfU0fSL18cljpnh4?=
 =?iso-8859-1?Q?0Lei+OV9cEjgf7O10eKSmi9Z+Hrg5q60ZZnnO0MMAOkwkEAntEv4OrCeNF?=
 =?iso-8859-1?Q?zGS0kZTHeT+6RyBiLpectBPD77AvrO9Rn8qwucq1hZpgfWhaHzLVx5s6w7?=
 =?iso-8859-1?Q?B5s4QOysgVqfPbNbQ/qjsWzyasLD2ql7vONhUiQotQ1PexnFREk7itKM0r?=
 =?iso-8859-1?Q?jje7MnDrpBSDdbpr9Lvxaf9CEnpp6yqWO99RGqR9N3XH+Kd4YO/ZNEWHnD?=
 =?iso-8859-1?Q?Xlu9FpVQDwBuRRMHHiRydblTGzxEyVFQOncgCWcCNFACMc6qDrA+A+8j6o?=
 =?iso-8859-1?Q?NNjnM6yQr+GFopRbrDpUGAk38xn8655b9XzBtBu7CIqSpXatK6AwKcngIY?=
 =?iso-8859-1?Q?llHWXQDkP5HROi3ki2JljYScxJGlemtsjNypLmovVAPqkTtaJO85/smsyB?=
 =?iso-8859-1?Q?6AEGJ3oHZgtqEio6aoKBVflUuBZfVzFQiqVgyrDNw2PK5kDyRJFMtVMq0v?=
 =?iso-8859-1?Q?rpVXvB9MiDfnUeZ2J628tU7D/fgxYqAUJKRQGPxHZ69g0YYv+lBAUriabX?=
 =?iso-8859-1?Q?NDD3mD8DTbptH4rlCkhlqAIjIK6h3Qwz56n0VQKe5za0G2UtgMMNqcFXSx?=
 =?iso-8859-1?Q?ol0yAw6B96gh5sL9ZAuM0xJFH01Vdv679RJOVrRMZxtp8OXqgyuhHH6/t5?=
 =?iso-8859-1?Q?QfU+EfHQNZCXDQiyvt+2pI3tpaxaLVmAdEivWBIpo42isQIE7DBixF9YI+?=
 =?iso-8859-1?Q?xdQScpGA6p2wa615rDxENAcOh6dyZE1VhoI0JhwYXvRdnoQvgMKtI3efWK?=
 =?iso-8859-1?Q?xgUrabnbvUMrEmZpASafTyV+BvoUC3b+wAtSCdxQ2mjP7u9WXkl8HZkHmK?=
 =?iso-8859-1?Q?Vav2+kXQCJaKdwDcheuYcwLQgo5h86VNPFjHBNxmUWeWGC0Amh7tWuSc0L?=
 =?iso-8859-1?Q?MzjI4X+mgqv26VnAlYiq7IF0T+QmeWyLb5qube7i4w0TOzRKPBykUcEXMW?=
 =?iso-8859-1?Q?UbWJMfHvQryTDH8HaQWRrZOUTp//FDaCBVu1RwL6w89zi5gKtrW+Zg2Xjm?=
 =?iso-8859-1?Q?WDO6m/KwL/cgLPmBywPMgLgCj8yAZrxbapDb7jIxq4FisbT0C3loh6Zwf/?=
 =?iso-8859-1?Q?tE4lxg6btbWAR+Q9gR7SpqwMXzyK3XiiaWL1hw7QDhdGpJGx9NsZ3CV07U?=
 =?iso-8859-1?Q?vSPU7uWTFoWnfJb/i/KVdmtyW5NgA+t9xZ/Q2xxI717GVy8ogxyyuyxej9?=
 =?iso-8859-1?Q?3nHF/zbTN6fFpEYeo5aZzmlldobyFnWO79PDa3CweCDuC3/ms3pTNeGP9o?=
 =?iso-8859-1?Q?kyWdXnhe4yE9prEt+Vlzv6BAGE52ysmFvSMsOJ7SBnANtAsAirrPM9SHxy?=
 =?iso-8859-1?Q?MngSw2NFYNBS9ZXmmTxc92VA7bjZsmPCXtcQKBclw/qNRYvs1Tl++50+ai?=
 =?iso-8859-1?Q?P7k/x8oh0PUmBRkG5vzu32WULQs4liPKZvy3Mhnkc+TcTi9qt5sWkyBNFx?=
 =?iso-8859-1?Q?qwNTD08tO9S21dq4CpG8fKfjgDByDRiKGjhQggYywz0hDkfxc1jvDNK2Q5?=
 =?iso-8859-1?Q?aMAtOVvEuLYGAOlxUyq44sq+TGEi0mdkPc3CkV5TZxkgx4wJubfIkyPqGh?=
 =?iso-8859-1?Q?LfmEfP9k2oijnsloGW5LiDulzsP1xOPRa7VCgLhkc+5Y90YvbVHT+yyDDL?=
 =?iso-8859-1?Q?ZOjYF2T4SQ1d1blCVYBzFc+f0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 53954399-3028-4c3b-af00-08d9e3d535fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2022 09:45:12.2392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H2ibG7M2rW1+2V3UrZM81G9dICBeZ/itZvUiOvyuv4681DW4MF8/hro4HwrNWknt3WUqoa6Dak/BRgq9NMugje0mWTiPlzIO7pZV/0bHQQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0084
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport for 5.16 and 5.15

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
