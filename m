Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48ED64A3565
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 10:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354497AbiA3JpT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 30 Jan 2022 04:45:19 -0500
Received: from mail-eopbgr120087.outbound.protection.outlook.com ([40.107.12.87]:29216
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354490AbiA3JpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Jan 2022 04:45:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ud4VSrOz6Wk26afIB0qabPQJJr41Nm/T+kyw74ZmyEgKqnd2bgLR9W3f6pJhE4PwrEWGST3lz2ekk/h80VEKg+4oRF3QnrAGUBjPCfl/k5ocVBhhk5cVfoUtnIJ2bqwKbk2oQSh5dYbokX8fzfaFwEfKVM8SbnvhPaeHolsG1TPdiZom84TEuSglKnh0LnjdPepJZp7OGL77VmOhWXRLVy0KwPxU4+xxLUb/2+2P4Oct4vZu/NOtYRfyPC3CGIJTr89kq87Yxq6dufEyUoHCTDnyIzAOBm1iZOyO3nwgjnuh9SUidGhxpbDCqM4wqhs367v7k7GPW2YtevsIjjJHFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hICisB2VemkgfsXUfFO2QPvOzDQC+oA4ZqChYt6MWE8=;
 b=huh5Zis9PGcqGFyGZB0LCKfOK2uFde9l6a+2fhCzo5AlxbYO+5GakCQ+hfaznpHeB/EI2EskWaLImmzZfcOX59o2PDa8WouA1qX6UQ+B2dWNavdmg+5l6emNdm5aHDD6RbEynKmtbEqTgOh0M5zwCkcOdFwsuAnoOfw/wSu5Gdtq/98UYVWtP20/n6SSB/O0cLJTdwC2vB3GBVn3TEAelLUlD5jSTjTUo5ngjcpzqg2If0AktYIsMVj5GbfFrh3x0+6KzgX3n6mt47Kp3JmfpqODiH0kz1dDYD5wSp96DunbQV4/IiIls4xcnj0Yx9Ppt1+0L/26DDBRO3Krqirx/w==
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
 09:45:10 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Erhard Furtner <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] [Rebased for 4.19 and 4.14] powerpc/32: Fix boot failure with
 GCC latent entropy plugin
Thread-Topic: [PATCH] [Rebased for 4.19 and 4.14] powerpc/32: Fix boot failure
 with GCC latent entropy plugin
Thread-Index: AQHYFb4SdIk4VY6uSEqn34ouj1+4xA==
Date:   Sun, 30 Jan 2022 09:45:10 +0000
Message-ID: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d729d4dd-0b9b-4242-e67a-08d9e3d53511
x-ms-traffictypediagnostic: MR2P264MB0084:EE_
x-microsoft-antispam-prvs: <MR2P264MB0084CBE598133F203A55C2D0ED249@MR2P264MB0084.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZcIMAtyNkrMLEISPXq4KJboZZy5ujDdWS2c08SPnwvAL9VlQdNRfBnM0AYpmcWHoIELqct8+nQKoWFxE08IhFNU7r/Eq4crGTvpB/AEEyZRzsAS0XaQd+3aGa8TScPXiI8T+Tc/1vcGP94EY/dD5lAgM5fopOFJqiR4++/smRsEXkF2YgJYW4rGO4WEpbAnMBSbfGYF+vVseXQ0o5fXptKHPr/YnOQWFvS0OkzEBSmq2ji77ciKihtIcZBUv44SLORN4sUkP1oLDYvQM/IOXQRAGLEwghLiyc1BqAEBVQMdswizSJjO6nr6RE9GGofjYI96dfBHO3wqeO3+C6ZAp3cNnteUCBaMIQAVe0xLK7hXlD+J1qLZFCeZTNxxCcfDYW1Q8yt5j1OulQloWMCCLbzBDkY0RpgDBm+h/Ol4engqMeIfXwUbUxzDnRaerni4Qb6cNU+gMbnVh6y0iYX8jlGYu6ey+k0BzSVGFsE/azRMtv97L7NCw73ed+cGB6i3ZKSRfCkPmyGcPSTLbWnpFNxF86l60LqKjPFRTqNzO+89cS7tNzmNplaSknxy9Wg4myyllIUiReMRIu1bexPUcdl2t6NiToOfuRxMOgy4PHXGlaKwQPZbYdN9PaFlrgheHWwsDOTTpvehvIZ9MdTpsVQe1Cntpi3GutkZkN2pLkPnxbyfPAcbgNSSR56g+LwaW6gTmqx5jnxsJUAYH/Rx4w1m5bWp6KfuyJnB2HJI607m8t3ty8HGKbZ82ONbymmBKzqe3KJc1nXaorNElYOXT7I8EnBvdlzJTsJCPdmCWDKs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(44832011)(26005)(83380400001)(186003)(2906002)(38100700002)(86362001)(122000001)(38070700005)(6506007)(76116006)(966005)(508600001)(8676002)(8936002)(6512007)(36756003)(64756008)(6486002)(4326008)(71200400001)(5660300002)(66446008)(54906003)(110136005)(66946007)(316002)(66556008)(91956017)(66476007)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?M7OPCmEW724sI1TTQ3h+1Bo8WDG5VoGpiAGk1qImb8wX6w2TrWCU75MPGm?=
 =?iso-8859-1?Q?9AVsqtlBWZyMBsETfaOPI8iUBtUCYnisMQwE51STL3vHiBxqpXK1HiHErH?=
 =?iso-8859-1?Q?iPTS6Cf7BfLbyu6LlckMyIoKSv8AtcL1QWOJOQU3fwFQLy6zOnk07HP09G?=
 =?iso-8859-1?Q?o8BzxcDcDZljZWo1RwnPTlEXLdfYOEST9qMpDojHCAMvfoKDOrXlR2TgKy?=
 =?iso-8859-1?Q?miDWASaviU9E0C7xkDFKCr+8atKsS5N7gyTjfJ/wuYHEM4hfzIHMbTtIUJ?=
 =?iso-8859-1?Q?r2n9pEGHPes6+r5s848ZgbrgnvWa/zYm8fNArdYbGsUxY9gBHaH6KxT23u?=
 =?iso-8859-1?Q?f2rUvrCAthnZeRklgFqwxLKBPQI9H/TmH7SCUPraP9VdAmvi0NDBNhGgAP?=
 =?iso-8859-1?Q?Uf7YrXht9MrGFUVU50GW5Lz6FE26Oysn/HoPbrb5bK46lwRePIXf6UqSAQ?=
 =?iso-8859-1?Q?N3w2BzBXy+KVs0NDi6tnigeCyN3jeex73tu92BqJY+1qbOqHBERqdjIY1v?=
 =?iso-8859-1?Q?FzamggVo6ukW6er6D2+zoAbOgDzR3xEZ5Z9eDNDAq0nAHMSodUBILatB9O?=
 =?iso-8859-1?Q?sth0nRVW9kM5XeaPbvUkcJDv/xHnr5sYCW13dGS4B8awgff37SnNViZ6a/?=
 =?iso-8859-1?Q?zq80fWldnIqlNgYpMMRiLw9YiCKT3qqZ1ZFM2X0wjRRDFbLR7tZHaTTIN0?=
 =?iso-8859-1?Q?Tihrn64UO1SuNsAKJgqn4WnS0KZKEJzYOmQc9Xmz0TTTYSCDHIT2REQ5+O?=
 =?iso-8859-1?Q?2Wef6gO+FUk0BjmUmx3VDhC1SaENOzhINfUR6sJs7l4/bDdKlKw+/ba3lo?=
 =?iso-8859-1?Q?nj+KczPyJ25bT8lcBGLez+846LIkkzGU6CoqIvL1pLBjmC5biYxVT+SCDT?=
 =?iso-8859-1?Q?0Qj8VQcYZx9jWBVblMONh1zpp5QqBrVUbP7fCi8LoVpXfvfK9YQM3V+ps3?=
 =?iso-8859-1?Q?RQMSD6wRXNdn2CYhlp/unQbKfX0fQCJkA2DMUNIIUpGHqWHbFgTaUE0+zh?=
 =?iso-8859-1?Q?96sOsSDaji7wfQP14/LUphEmc1YAxZI9C3i5Da/cveh4So+v7sBS9msEUv?=
 =?iso-8859-1?Q?4V65Dz/ICo1hjHkNDzEvwdwHFPbB8NPMx3A32slMp3iDD58vT3/NlkaCzu?=
 =?iso-8859-1?Q?ZlGAh6wOhufMRYdGuv14D5rk1mzbKsXAkIO+h82EX95k4cN6RaM/4xbYfR?=
 =?iso-8859-1?Q?Yfniz9jpvbx2C5quEcwEwn+ynK+u9hFrJ+9eG4rV3WxnHCk4nHkVAuWTkW?=
 =?iso-8859-1?Q?Z/h7L+EnpExsgbDLVXQAePvKzYh9nWhnVPo/l1pD8ui+fT0k7n1axF4Fi/?=
 =?iso-8859-1?Q?sRvfWU1WswRukyCFo4eZIQDTo0Vxbmjl7oS09VqrGpsjJGm228TIWp64yD?=
 =?iso-8859-1?Q?cXzwuQ3++shaJjESe6P4YLTrYjDGIC9Ay7BkUm8HB7UO8w3msmdS7s7Q4V?=
 =?iso-8859-1?Q?pQ7Zq6LWi+9fqHrNki9qFtZwRiB/9QTQ+LudxH5gNCIP7AqYEqC/JrstM/?=
 =?iso-8859-1?Q?93/OmWSr+X5fhAbjo9TzEfKleZsRuFp3g9BNp5mFm1ofj+KEiDA5bF7e7W?=
 =?iso-8859-1?Q?SwlGnKvhWtW9BmrfRiJxzoE6e//XGWfCOV9bv7uCNUH5ovm3YtvUWE8hiU?=
 =?iso-8859-1?Q?tp7lvZrDZ5CbqMdzBCG8QFBxObJP01Wojiay2gQ4LmEOMnJ9W6Hx6eHWsy?=
 =?iso-8859-1?Q?YrNfOkXxr8iYgPQ01o5vwcXtlcTR9N6WtziNlw6Xn4+JXcTEmubHispIb9?=
 =?iso-8859-1?Q?njwpb8bc17+nd/RAw8L3vfzlg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d729d4dd-0b9b-4242-e67a-08d9e3d53511
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2022 09:45:10.6603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xr8R6fbN41YDCLdivgjRK65MyZ4fnahdYGDrkE4qJsByM2Jhh5TvvJicMStTW/m4C05gF+SmEgaZ+aNUMeYU7PQiBzFCVnn6omqCW2ORGgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0084
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport for 4.19 and 4.14

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
index 1e64cfe22a83..bf19c5514d6c 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -15,6 +15,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+CFLAGS_setup_32.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 670286808928..36f913084429 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -10,6 +10,9 @@ ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
 CFLAGS_REMOVE_code-patching.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_feature-fixups.o = $(CC_FLAGS_FTRACE)
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += string.o alloc.o code-patching.o feature-fixups.o
 
 obj-$(CONFIG_PPC32)	+= div64.o copy_32.o crtsavres.o strlen_32.o
-- 
2.33.1
