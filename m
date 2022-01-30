Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BA04A358A
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 10:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346943AbiA3Jzq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 30 Jan 2022 04:55:46 -0500
Received: from mail-eopbgr90089.outbound.protection.outlook.com ([40.107.9.89]:33040
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239760AbiA3Jzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Jan 2022 04:55:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R17SYY9om7iJQ4lEHSBKbi5beJU+og3HkH7GAQ73Uttiv+rmvgCWvL/u6Th1+vPeXhWvtCo9Gy2yMoupElAssb+XW/n2LVq4WvcP53Y8ES7wbm+GI7bwMIVOqlfW/I+bYzIcnVb11UmsQ+skfXi5vnN5ji5JfqazrsmzdpHXaRfE252yKNIkOUj3gNgus5uEgJWAgh6lf8owJkoyVEoSplZaZXadqU3S/xt/A6Xot2A250wms5IdD5a+AiOTNvrd9lfxzOdNrG+ME1VQ1g41n77WSLVZcYsNSCwxytvRdCD7nCNiOkGgkrcHRqCSyTLs9h7uE2DaqQjVvaxh/IwdpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0pFT4jon4M/wf4hXEJ8fVFZZtbHSN2U6qzJj/M7OZ8=;
 b=epPsf0rcl2kBWnTqU1wIeDzP1QvnLmjPr8SsJ2n2YOpgz4ZCRvlWhsbdnL23GkGPbs2DCzObkdtmSRmcjh10xtzYYTOMHNWmQaQLxbVMRXTf10sDy/6AsIBApIk37l+c63uJImU/aeSv45y4mxl8/5zpNkEBwOs3YMpTm24N9ztGnNh/OhMxBExPXbawtbZoD4EpwH0y1H5fkwKjkTJl6w8UBnb0IUYHij3Lb9zTnMydbagIGkdfi7OEJ9+ff9H1tz7chcbzfQXbnezNjiuypIF3PwXYxCBn9pAc5iJtxs34mAq3+nGaja2aTmvbbc22Wv5SfgvIwgLcLsQOClMBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB0825.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sun, 30 Jan
 2022 09:55:40 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%6]) with mapi id 15.20.4930.020; Sun, 30 Jan 2022
 09:55:39 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] [Rebased for 4.14] lkdtm: Fix content of section containing
 lkdtm_rodata_do_nothing()
Thread-Topic: [PATCH] [Rebased for 4.14] lkdtm: Fix content of section
 containing lkdtm_rodata_do_nothing()
Thread-Index: AQHYFb+JVDWALiF3l0KHVv16Qql+pw==
Date:   Sun, 30 Jan 2022 09:55:39 +0000
Message-ID: <32bbc122ba24b863d048f51ff13fe391b16b9f2e.1643536487.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbc67731-7884-47ab-c800-08d9e3d6ac1e
x-ms-traffictypediagnostic: PR0P264MB0825:EE_
x-microsoft-antispam-prvs: <PR0P264MB0825DAD772D7BF82715C97A2ED249@PR0P264MB0825.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:644;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /+dXRUFOJ4aUWvYamRNF8HSCsKwY9cb+PAWMh+llUdScchSnEOUSGbOvWSJdEx9DobComWT5uv16K9gsSgsJBxpoGSjf1kHuBOnmHL3FOS2uJ6Iag0+UgDQZjfNxhYvVUdDKSFMSWf+hYzkK2aTl1/XmhQdU/g0PvxFDV0Ei5LNUuaFR7qNHo6iFd+5VjVmevBrq5h6pv1o7JtPn9NUDs6gZnauYRPjf2MjpCXqxzP0/6uVT4YLPEjSyRbUwlrqfdpkkaAgzmfWZtTDHEHDxLDgj+paOOWs+TdhUovF36Pu2p0o4QK0CVgN3/WmxqB3VMj4OBqSsGxG2CU0UZb6UQSk+dFj6s3PLzrswrvO21HbGDHH+lwKe6gVtnR4ab2Ha8YeTNFBNOXBGOh+AezKF4l4OuT293FfXtjOpSy51Qy12j81oVPtAzXZrv9gXLai3CIiAUu3B2S5oE6bdTiuy6+ikaSejP4FGStO0GeGtCuoxxe4TaUEAWVbH/17JQwB8kd7wEF6dw1VHqlbnUFw4uxaHA3gq10pCdZn5jBMZIMgiVcTU+WZap/logIb2p1qlCv4cFGZSjnqLZhGBV5xemzYQBb4Cu49clZEahJ46tHX7gRs25jMP0U6st+8Vad1+Ieq8ygiQ+8MrY+WxY3q8xY3vPbL9FQkrIe1OIZFcJOQXid93n+TpsySmMqqsN8lvtywArF+S4zB4/PP0BvYHIBQJFIvj+1wBymOZJE8pV62DQpMjDB71TRLJEmzIFEMvDci3i87IQ2CdMajsIKVR1BG4mUZb2Mfc9TeemJo4f5k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(4326008)(316002)(122000001)(86362001)(83380400001)(508600001)(38100700002)(36756003)(66946007)(76116006)(71200400001)(91956017)(66446008)(66556008)(64756008)(66476007)(8936002)(8676002)(54906003)(110136005)(6486002)(966005)(6512007)(5660300002)(44832011)(6506007)(2906002)(2616005)(26005)(186003)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?wrPCRg89A0YLr9KWFTZAstonbpbzIMGBLdqb5BZvyhMYezCgoyDOk0xQB1?=
 =?iso-8859-1?Q?XxI35CWeFWXX3q/8GeSp5iNhqGWrYdSawRfsoQdrpTC8ulTc167z9FohwY?=
 =?iso-8859-1?Q?RUOvlHPrAvrnlua15OkjG8XtJIhAjF6ZDv83UI4LqhcDSUWNm+5QlAJ+d1?=
 =?iso-8859-1?Q?oL4FsmCmNb/ES0z2DXZgfCItKrVjpHGQxcD8vmFNBib8cttWfR2UsjggCk?=
 =?iso-8859-1?Q?EAEE9LayXDOJkJWqgoUulRYQRx2i3L4iiHKREX+tG2vua+8R/1cset2lmC?=
 =?iso-8859-1?Q?VZ4qaZOzWNiTy4olZxYXo5LvXGC/4wCwqOa1OVJTSs+Bou8wz4KmJlTP1b?=
 =?iso-8859-1?Q?EOocgUHfl/ADFDBNAOj0+Vt2+iizbm7sxsOWlf4CTMIeUP4N9+lsLYqlI6?=
 =?iso-8859-1?Q?H/fyCc1jKG9mydQMhPNaBYEnCGy1SJjLlIxpF7evsMuI5ylygqC/CB5++A?=
 =?iso-8859-1?Q?vz2Qz5UAKChhS5rzVzNYywg3+MUTZZ5ezdDwJiMQkv5bCcpgHBasPznem0?=
 =?iso-8859-1?Q?MKkx4OZj2cPwQiWIn2TLOPCLMxGT5IRPo7fnUkn4RBP4ypjIkAq+6kQDg7?=
 =?iso-8859-1?Q?jwDvZhG7k6DhSxRAhQGBUh2nRECnPeu7C2xn1kf2Fc5wjzU6QtxcWwoH5y?=
 =?iso-8859-1?Q?ukSjCLNuo7JJXRGm7nAxC/9FyHtvWr0JHBbbN79p5uInv3bk2F5DCLstwv?=
 =?iso-8859-1?Q?b6CkfkBN8qq9njtVlbb/zpQ2g2RshU43Kh1skqvMiQmF0LkuIuKX9lE2S8?=
 =?iso-8859-1?Q?dCiyvxiRpxfDMRolyWtG81iM5TBX4zu5ii/ORRZ4fyIxJ8Dc50ILogeMnn?=
 =?iso-8859-1?Q?yGUh03xWfFJOwfamarQQPyiy8HR9ZHwMmbKIOZozu1AXSuc487QbmGryu8?=
 =?iso-8859-1?Q?6QpPLMy+lbVM3skJA0/bgTW0srjcbPMoBObWXsfI88eq97qSWWBIWHdvmC?=
 =?iso-8859-1?Q?NxKJfNljg9zKZoF2PEuA5INzBVbFOZH1qZp8XfLZv66Nz425XItTi+JJd8?=
 =?iso-8859-1?Q?NYTYMCFScORL44RCOxxsNI23UoMr63PNmnCqVqj/ra1pXE+vlwrQhajNkJ?=
 =?iso-8859-1?Q?cDdYg+okUS6SLjoDRNSodDHvk8qswVEH6csWMNCfAJSI/BB+LsQWgMRIp9?=
 =?iso-8859-1?Q?P9NZ+aYXQbXUqusLDCy6Ri5BV1lLJ3yj+FqurLgnpXpR3tz2XSkM/v3CTw?=
 =?iso-8859-1?Q?geCr+BeXD9pABSAdkqA7R6dIlOn75kYZuUSuo1wxPbFZ4AZ2+xLKiBNH6v?=
 =?iso-8859-1?Q?c03eUMZ9y4LIlk+rTVRF/MvA3/X8xXiIHGyfAKbglvFBc56SMsmmfjj5af?=
 =?iso-8859-1?Q?i7OIVXsYk+9KfGcBrYc8CL7nSvY+tonhaJF8Ccnw4zsITgs8F7AiO6uWbJ?=
 =?iso-8859-1?Q?n8oRAz4l8yd3srIP/+pbQOfXh88CuiW6IGCBUyMR9DEsp7sLX/o1Tv3hD5?=
 =?iso-8859-1?Q?xkUFMjQYqutFBhxwscArV6yLvhh9AivGkzONzLKaUEQ/zWyPO+uspVzBmO?=
 =?iso-8859-1?Q?qhqb8mtua5MSJeZOdLKjkXSjVmMTCOj4Ka/5olssQdP2H6FQXb3hMWoVZN?=
 =?iso-8859-1?Q?sMgy3bURc2clAFMU7Yn63k6Hk60Ptpsb4krPWvcG6AfSV0HodpVNTubksd?=
 =?iso-8859-1?Q?e0jvLs6ri9TbvXPQSONLJFZ9hba6XLindQ/uiWdnWd+n1ACwnUYQPyvy+w?=
 =?iso-8859-1?Q?zsKoCJRfbHFwfyck7p+3lBoyojl1Dkh4zTfLijp51ctSkt1xLSiGqZ0i8V?=
 =?iso-8859-1?Q?xqb7uXccet450SSlvUjKAndS4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc67731-7884-47ab-c800-08d9e3d6ac1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2022 09:55:39.9215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aWQbLYGaXCFjdJzGipn57jJuXi6QkUWMWor17DhPKKUEcMjk1v1BLaJ1UjN8gZQRNk7J16DaJQx/cBmy9xhzFw3K59qrrIv2qWKrf8DYdVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB0825
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport for 4.14

(cherry picked from commit bc93a22a19eb2b68a16ecf04cdf4b2ed65aaf398)

On a kernel without CONFIG_STRICT_KERNEL_RWX, running EXEC_RODATA
test leads to "Illegal instruction" failure.

Looking at the content of rodata_objcopy.o, we see that the
function content zeroes only:

	Disassembly of section .rodata:

	0000000000000000 <.lkdtm_rodata_do_nothing>:
	   0:	00 00 00 00 	.long 0x0

Add the contents flag in order to keep the content of the section
while renaming it.

	Disassembly of section .rodata:

	0000000000000000 <.lkdtm_rodata_do_nothing>:
	   0:	4e 80 00 20 	blr

Fixes: e9e08a07385e ("lkdtm: support llvm-objcopy")
Cc: stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/8900731fbc05fb8b0de18af7133a8fc07c3c53a1.1633712176.git.christophe.leroy@csgroup.eu
---
 drivers/misc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 76f6a4f628b3..cc0df7280fe5 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -69,7 +69,7 @@ KCOV_INSTRUMENT_lkdtm_rodata.o	:= n
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_lkdtm_rodata_objcopy.o := \
-	--rename-section .text=.rodata,alloc,readonly,load
+	--rename-section .text=.rodata,alloc,readonly,load,contents
 targets += lkdtm_rodata.o lkdtm_rodata_objcopy.o
 $(obj)/lkdtm_rodata_objcopy.o: $(obj)/lkdtm_rodata.o FORCE
 	$(call if_changed,objcopy)
-- 
2.33.1
