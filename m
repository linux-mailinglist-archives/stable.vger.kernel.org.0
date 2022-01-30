Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51D74A3564
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 10:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354492AbiA3JpS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 30 Jan 2022 04:45:18 -0500
Received: from mail-eopbgr120087.outbound.protection.outlook.com ([40.107.12.87]:29216
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354463AbiA3JpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Jan 2022 04:45:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi+bgBa25zx0cm29rTHg5E3kvxofp7XSxupWD/cVyg3W2CEEqCcDwFqzmvrDSdqFj263uytfybE1xO8jz1wg/OIT7YIgCpHYxhtJLKiPPKb24ahN0cv2dune1XYkeU7SlEHYI7zrYONdE5/l/WM3/S74MRkx0jtHCA22tCIb7zNFA+XS8RUwemU/x7TAdleMD3kAdF9nUae8Y+S8yetG5qXeedIDUaWrb1ACpJ/OyLLjC9JhHckHHwfkKm9EtmiwE7XoUPlhx5c6aN2yOVAQWmwIp4ID86oIGv/24IXqVsW7oB97bLuEwCIB6raOkgzdQ60OGuncmjNKbWQrd37LiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUZBRHrJPodr+naq8Xw2gBSIPmwWk9burGP6FsgJyAs=;
 b=PBh0bRRkfv9LHo5Rod6NQXdP78LgS3YfTqUOTjcsFmvrpVGGryxuYPYEUO7BiPfrZ9g1usQQ5FGmFfbUievYYm8lJa75wvuUHHckPKJjO7mhtqWw5hKMW2zuUfNiNADIXK0AGYtxowJc6Jgu3H9NqM/ZGeCWCOZ8NZV9aLqFbrpLvPCgUgMu3jFL9oC+lu++c2tGQtIDYRDFSLVE/4bSqp32tQhJegI5wp8BDUwITZaMSlEAY9NkLQAi04SWtPaThylDzeqJ7TVDkPWjY4LLbs6o67jtZ0ZxNwxpHAZW6JTmnAAe+e3mJn/aqM2ClPBSvukYrvdj4yxBARjjOWOoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR2P264MB0084.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sun, 30 Jan
 2022 09:45:11 +0000
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
Subject: [PATCH] [Rebased for 4.9] powerpc/32: Fix boot failure with GCC
 latent entropy plugin
Thread-Topic: [PATCH] [Rebased for 4.9] powerpc/32: Fix boot failure with GCC
 latent entropy plugin
Thread-Index: AQHYFb4SE5OtDxlEHkCorID54UeKzA==
Date:   Sun, 30 Jan 2022 09:45:11 +0000
Message-ID: <636306e2355919bb031d9d5a871170bd431d5bdc.1643535758.git.christophe.leroy@csgroup.eu>
References: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
In-Reply-To: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 982f4e77-7eea-46d5-1377-08d9e3d535a8
x-ms-traffictypediagnostic: MR2P264MB0084:EE_
x-microsoft-antispam-prvs: <MR2P264MB008475C6D3827D28D1CC0DE2ED249@MR2P264MB0084.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hO8ayB/rvmk+t/c3KCsifmL36AIi2MHMB9oeaPcJxA/DuwU0GztOi/W+g2b7grhi7liJG9TuBV2uyQpqsO5Xk/uJxcFgn+Rj/vYA47vx05VFoRyjpDbk9ZFO6BDrNaq6a3UHqVMpzwz2W9mfJyoBzS65ta65u57QHhydLvj5ZkDvZ/PwSL323kIgOf6nNMIXs+f7IoYKt90UeIby2xayxas5SvnjOpbOVSBsJb89kmdPbZg+2mEz5SJZMSEJNNj+7psx8RvNdWAxNt921zx3BmWF7HElaJS3V2o4NYt+LlieOsJXW2rKpCODtGcns8k99yIU1QjeBZFvc9avfPB+RqOf5SKpVsWldxlV4TMym/iy7+6B9IfVjc8gdThSBfcyyOt4AVFmLVbTFPU7fVYQizsBvxq3XT8v4Pvtgnr8DIikG8N1Ng4Lm39F6+PbwcY/u+Lxp8wMLKBVcysWXwQSoYXD5wj4BM/rtKShKVb5LGa8FWNgXfhc4CNwx//DuUA7HSuJas+5X/vOxJnThKOcoKZ37cc5AOBWohvbhJPZUKkLCSSOdzYCDjTbxKfeBwucv8Xe2nYBw6rhrSAOMWyA6WFbG6lxUGlJb2dWXeEq4aBSGPe6D4MlXwkpGAuDpDrIJ+aCVVWI6JRb02ZV4t2qBjCO02I3C9wiKUc+VF/muenaL0+ZTBvED9FO2ymw2mF/pkOkLR8Viy2+hkncqdJ6yYfP1qJbSn2Y1Mb18tzCtJHdhTYamOnkRv72attXR0yNwItdngaC7TglwM9uHWyMA/pf3q2PB6EN4PifofdOuHc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(44832011)(26005)(83380400001)(186003)(2906002)(38100700002)(86362001)(122000001)(38070700005)(6506007)(76116006)(966005)(508600001)(8676002)(8936002)(6512007)(36756003)(64756008)(6486002)(4326008)(71200400001)(5660300002)(66446008)(54906003)(110136005)(66946007)(316002)(66556008)(91956017)(66476007)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?V7fqJCMBbKJf24ju10S0YplB1JloV5ThhhP/udRpFIJMjxGCvreCZ9DiBt?=
 =?iso-8859-1?Q?CWzQRZveY2ZarVKny/QZsfECiUq0tbkJVMOQB8d7OdUBw+BBs8xZvWo7eW?=
 =?iso-8859-1?Q?kNKPOvEbwSGd3c/JvHDSXSnNFOyB/makznCLocTsJ5G8/Ml3BoIUeh8M0C?=
 =?iso-8859-1?Q?bmaoxj3HcAafHLHQHuB18p1MUmSx3z8vsGi896VdagzZxsU7HxKoWtcxi8?=
 =?iso-8859-1?Q?N0hfwGN8swIb6r4f9i/NqvOze9FA1TdwGROFxR3L49BFya8yODkWouhotk?=
 =?iso-8859-1?Q?MLe4Q/o2uvAvQtLiGWFuDs9QvmvNh4nmBGZ8+N2q+VmrT43hSRhMYLVzoo?=
 =?iso-8859-1?Q?BSU9Ts8q/WntJpVKGFZQcOZUvKtDjWVtQghsEpp1ae5TDs/KUZmEkSALrw?=
 =?iso-8859-1?Q?2MzrsjwaLSbdx8mFXqWP9IFatGKNM164MP7p/9tvUflDjYP31GEryAn8ek?=
 =?iso-8859-1?Q?vqQzXNHlb62/R5R7C1ERdedSWZml0ZqB6ROgKikdTNw1FTJJpGbuXxclkc?=
 =?iso-8859-1?Q?0Kjes4tGwPjSGg+dW3coR2HMOSd4fmla47ohjhWqKz5iPKD8YR85MU0w9v?=
 =?iso-8859-1?Q?vD3EomEqnnerUpK/MbrJhBlYAovwud0WV0IT36rxo4dAe7tYtk4rAtvyt0?=
 =?iso-8859-1?Q?7V4GVMC1yXyubIHIu7HXF+tj0+gEErc5vDh/yDTJyWN3RTeDn+teabNTzB?=
 =?iso-8859-1?Q?/kYhQA8UJh0huV2EUEBMEw99skanodiTsE2obEtTzZQ0qZIrar1JswcG0v?=
 =?iso-8859-1?Q?MkhXUR9iq7jWrB6DnbbTeOyw08rCfPsKLxm9iOeCUyVmny2hYH4gQs6Nm8?=
 =?iso-8859-1?Q?9wmpYYcMGdteuDoVSgJ+5T1oId5owp0OzGt+qxmsnmSVpHWoAPYSJtZANo?=
 =?iso-8859-1?Q?eJ4kfnKQtBpZonT5Ln5Ncx5PCCOqmG63s1/1vcr81NhkQSdxDwLd1d3FvB?=
 =?iso-8859-1?Q?aYOLl9bG+IWmbgp6kCczEcLTH1VRzpE+6LWKWybuheQKM193k2BvDkhG8K?=
 =?iso-8859-1?Q?zBuxmLH5uh1w5c6HCD4mQ9ZHy2wvlVaV9zoT5s6xp6MeF051/Nvpk77PUh?=
 =?iso-8859-1?Q?iTYyB9WPaXGNWo/caiPh8/jObC3llbP49tEQhovAOciThHLafW+qOU5aZK?=
 =?iso-8859-1?Q?koD0NbwEc2tjedUCbCnkFXOmEl8sSh5zSAbKrdTFnIDXCT2hh1ZsPKbbRT?=
 =?iso-8859-1?Q?UBbM5ZGrNXunpyaB0FHrRJh7M3d97RNprASACG0CxkPRKK9dzgadiRH3Gp?=
 =?iso-8859-1?Q?D3NE4U/kpj2pXXHQoOMHcLl9KAT9LDUYmFcwZVU87HfYnNj0wtGkNJS1/q?=
 =?iso-8859-1?Q?jaeH9DczFyOEiHosuqCEErch6G3/FeyaYVj0pMcmbNV4Apy3uoz0egtcUX?=
 =?iso-8859-1?Q?EH+xyEPb5yBmfsbESrpoPBxQqIqt1wZoBQnpOOeffac63GE9FPRPCNqLlp?=
 =?iso-8859-1?Q?tFTcN9tSw43InXj2LUBnOKmmGWDt1BynmFpyKbct6D9U/Dsijwf7jT90iH?=
 =?iso-8859-1?Q?qGzilOfkcy44X+FKHsP+UEyLbDpF3k30PFjkZ8hPxiEZ9YbkfED2xnI/j/?=
 =?iso-8859-1?Q?JcbO5uyWcamKqamMFvO4EKKb3ajzy14gHtO1ZvQ7qoNwQPXzRmEUrTetHl?=
 =?iso-8859-1?Q?wqBovqjQ9o9/P3+Ni0+/Vh0lt22li5skC4xqyYyze6ksRHm8Mv65f3NzIC?=
 =?iso-8859-1?Q?+r8gDepALsZpWnXFH0H7EDqAVJ3WwH7RirExEf2hYutnhUvLvFkfNTphLy?=
 =?iso-8859-1?Q?xwYlBAW1ACex5UDuweuw1eWFw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 982f4e77-7eea-46d5-1377-08d9e3d535a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2022 09:45:11.1758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Xb108zom4trnB8P+PgQIuhDV/mXIaCLLYvUgVeISNjCjeYlRU9b8REqNkWMlhntFOCAVl848l8XL3pDFMSKphSWovpn7xInn0V9ozSkhrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0084
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport for 4.9

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
index d80fbf0884ff..bc6c85788b84 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -14,6 +14,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+CFLAGS_setup_32.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 309361e86523..3e3370d126ae 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -9,6 +9,9 @@ ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
 CFLAGS_REMOVE_code-patching.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_feature-fixups.o = $(CC_FLAGS_FTRACE)
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += string.o alloc.o crtsavres.o code-patching.o \
 	 feature-fixups.o
 
-- 
2.33.1
