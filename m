Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FD76BB5E5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjCOOZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjCOOZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:25:05 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2118.outbound.protection.outlook.com [40.107.114.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EBF2D15E;
        Wed, 15 Mar 2023 07:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1/h/aqkcaws3de1D8aaTc3+ngWv4OQ3cKwApipguIddYaB46aycGp0q+ANZHpfFYK01qhJM3l+KjjtDO/uuecRjqrzmIwYizpphkPplYz6xvh/BQtecmpBILiJVHd8YTexD17fO9LeugjwL8t1d8v/dzKWruhm769SLh8/HXAJhONGQGOy2kcVnKkEQTiiPkFv6Rn5awU66fPmypvVxNVW+Rht8ntfM/2JCct7lNipKo6lX7qgSvkrC08t4RVuYBnWm1Q5oIVGrXpTqwWt1HH9XOWE12KFWFRJnV/Ahp999iIPbN4ohMPmuytuL0h4NSqErnilTuJrEDUNfDVmkhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MD/JNFJbCC5i3j5rjnjeBCrbf1FEdelwnGU9vBnPYH8=;
 b=RE5SPhAexX3DoaKv7VRl3h79E7lUV8dnQ8l6+EmTRs8X33pN6geRUjs9p+nDyWxevkdSQJK6HXGP1NhqHoHaCyRP8ZLe+g5zVJjNuInlINEHqhcbVcq4/xMBAVhuRYTxxdnPuUtAW3V/wLAVFz2CmFDpizx7cwZB1u1AAdIFBq8hFaA0thVUqQr6dnkvQW4x+MEDUrBP7eNJ8r2Q+LdtmTpJ3nf3AUXYrWcWezUOQP0L2nFGRRphEgTd78/ilPnZnUXkFKccOXqQ5xyU70H2LaVApCwSIg+5OphgJMWTSKw51bMnRZItz1OSxSHc9sbmuj2aMAsI2b9xlpvUg6YZwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MD/JNFJbCC5i3j5rjnjeBCrbf1FEdelwnGU9vBnPYH8=;
 b=g78/0OcE15uKdF2GHNDS+d7UHEIuIjp7VWUWtqidlGdbiRy/WFYnU3Rs93VfcGHBPvbcWCwtPoB3fOa4YHNc4ce/qgmOUsUbYD7kjTZp02Ocr97wzMSixOOPSGOVnHLzL9qXYFnjilhAIJV+v4jjXb0MGQt4EQKS4HC68Mpz9wI=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB8394.jpnprd01.prod.outlook.com (2603:1096:400:161::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 14:24:58 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 14:24:58 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Chris Paterson <Chris.Paterson2@renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: RE: [PATCH 4.19 00/39] 4.19.278-rc1 review
Thread-Topic: [PATCH 4.19 00/39] 4.19.278-rc1 review
Thread-Index: AQHZVzfuhR3skiOhnUWjVQ9NMNaQlK773mWQgAAGxKA=
Date:   Wed, 15 Mar 2023 14:24:58 +0000
Message-ID: <TYCPR01MB10588A7F9DC5EF1EA77C0333CB7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230315115721.234756306@linuxfoundation.org>
 <TYCPR01MB105881FA616DC8A6623140062B7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
In-Reply-To: <TYCPR01MB105881FA616DC8A6623140062B7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB8394:EE_
x-ms-office365-filtering-correlation-id: 883ae2b5-203a-4482-3aa3-08db25610e76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8d5bbIA6XBT8PZMwik+/Ce3A4J+sQAASiYIrNz8KmzDEuPAW/RgB2CaXs6N/ulnj6lyuX3o0j7b/2uEQeJKNXzq4EWr1WASkkxaOxjgVopSpMpE2vk5qHgVAliRVuFxBwXg/4clgllSqtRAu1aLFulW3pMalPJgtCR08T9VAVRg5D4uBpCXBUlvg2Bu+nwd/tWSVZ+lnB8OLemSqrdDbdooLDnFf6v67Het5fqAxKTnFQFKN3Re+GUENYUutP3ax9TgQmusavN6U1oiDx/u5M/PWM2iCgIvb+21u9KdvWiaI16l4XnE4T88JXA1pdrsl+HzqXLBkwjF2vQNtr2WrwUmzFvyrv10LC8hetOangAoN3rHNBnPrjU25ddOYRLOqudeOWqXHK2aWSa7nNF8AXCu3XiZ37dLTq8cEHAPfElRoYeTtsaHLxIbcq/FgJyvU4A384k6iIrFdEzCN3Qz5Uk+/idbqm6EsGWOff2DPYAhrbDXBg99BF+KjQ9r1G0Ev1QvIsFAuxrYA5QBEGroo24oTwe0SUpXxfZlwGi7BtGSUP7sZv2okR+Syv/VwqUvBrsaN0Uyh36qPu5X1WGFE84i89OA0surw+gNx/memVdjDtDIpYTlb8WMmo/fwT2bqEiB+5ntUR1F+Y9JID2P2sPoLhOfkBxHQqki3MWTeVyZfGm3FQT51VRw9fkreUtuhn1zE3CPLJaHR1xjUae3C+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199018)(33656002)(86362001)(2940100002)(9686003)(186003)(966005)(26005)(6506007)(45080400002)(7696005)(71200400001)(38070700005)(83380400001)(478600001)(55016003)(110136005)(54906003)(316002)(41300700001)(66556008)(66446008)(64756008)(66476007)(122000001)(66946007)(2906002)(76116006)(8676002)(4326008)(8936002)(5660300002)(7416002)(52536014)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?g514twZVnC55g6aFNDO+7vlxT5oqNvDi2xsWW/LPXFJj9qfNVYVsOzPv?=
 =?Windows-1252?Q?wLtENytmK415V914ylaOtNr44ebx1B5dXGXF5Lha0HCZ0ZBxBqUzXAxR?=
 =?Windows-1252?Q?E/R3h1vxyvi1xD/FrLDC/E7bvT0t5T4d3W3Nq9+72pg+ADjJsgSt76Vj?=
 =?Windows-1252?Q?I196dR1lWV32Q/fa0SrE3bVBON8DC6LYNzeVd519IyH2mRhwcDA/Iy1Q?=
 =?Windows-1252?Q?jPmIsRgAeLDBUFgH4tJMjhYE8BJf8MHUQvtjP2EC5HrpQPEFhJyEAp8B?=
 =?Windows-1252?Q?J8Rjowzc1F7prCD5CVzscxJDKItyb5BfKaAItTNLBntzHzr61zn7XvlN?=
 =?Windows-1252?Q?iHCfVNx495rHceV65qF1m9z3z0qpfH6eVXedkQsFC9YXc8oA9Od5m1f3?=
 =?Windows-1252?Q?p0umPClpCo3Zn/k0WVaj8xtktmfhe0315X9JPgqdqkvRBqyL63tmYJVC?=
 =?Windows-1252?Q?g3BJLY8p4G2/jmo8bfrw+0V+XieS6+WIVL7bn3gNucMwTSERiZdSi8u3?=
 =?Windows-1252?Q?+4op6n5Xa9KIr9htNsocdfVZC9jrHLxS1UxvYPJh81ZvfwbA4FazxMgf?=
 =?Windows-1252?Q?Zyq/YHoFSe3hOCbzFyuqeHs2HfnYUTqMoT19fFpXnJINRcZu5gkLeOQS?=
 =?Windows-1252?Q?pyDhC4yuTmIvKNsKRzpcoDxRZr94MzhOvHUX7qII+BPN0VBcI3LzfdDm?=
 =?Windows-1252?Q?WwbzfxGdNH+0U9eNTLOfF2bcFdqVqv1Fiib8ykJ7RwWq20dNChobXFMN?=
 =?Windows-1252?Q?BSltMeG4Ux9VSdxZ5Yw36yPIA0yWyPGEge+1gZ2/kPwMTBfVS0rrnzCj?=
 =?Windows-1252?Q?Ti6zpb2DBeCdbjJsLftSnmgpV8sn+smU86wE03MDpld0NUKGkGBb91/l?=
 =?Windows-1252?Q?CIeLF1V4ih6tSF2tfqWort5KNftDpFQLw36A0/3Q1vipjpCfNN7maXko?=
 =?Windows-1252?Q?/lHOZIW2px/rXZDpPYuKoibWx193z1kWURvd3Mt4MtLM3iDo+EKZqrA+?=
 =?Windows-1252?Q?qazpsSXKdo14i700EUSBZ8hFBsBVk9tv+KhqZDcYVBE48QbHNbyMl83+?=
 =?Windows-1252?Q?imr5/yIgt+S1ZwKgqpjAwpgnE+0c6F2SGGelxFOjrRHuMxTeeBerLL/k?=
 =?Windows-1252?Q?hej8l5xfPHnc00H4SDE1f1esTkgCADOqU+6AE3gl/QAS+NZ+GpytAD0I?=
 =?Windows-1252?Q?+HUQTvrIXYZQohxPxXixEC0ALiXfJ2wms9VPYs/Dwv5z79KNV9/KHLR8?=
 =?Windows-1252?Q?3McUr/UDyjiN6H4PFt5zNF2teh41GrQ1Bnk6MUeEU+FHFpt8TNHQ0cLc?=
 =?Windows-1252?Q?eAIn9wFdZouQ0c8F/+B7bcfNjovucN8pZsRpxohJJifWOdYfFqszX2Pn?=
 =?Windows-1252?Q?nCnNMTlPcpzbtA9OC4obmZgiGipTg7xJayErQcxZhDiQYOIoBC/Fn5YR?=
 =?Windows-1252?Q?D7kyVVTqT9kTDtf8txGrigo+3kJaYHx8CZLdZIJF0vOFlszUotH0rFFy?=
 =?Windows-1252?Q?vBebwrFirnjizjnH5eQPk/MILVh6ifyQT6tAXibWSPO/B3rHjKtzZ67d?=
 =?Windows-1252?Q?JQR83I2+bdE3EZuAhT36CMH8H9hsrsWfjN1DbJqRY1qNc6of6IefFD95?=
 =?Windows-1252?Q?1HcbR2GCXotrV3VIKSqfvrqXVIptvxD2aNgcQcomGb/VSPKJgiH+qd8U?=
 =?Windows-1252?Q?VnDgLNCfkVzp5pyReff+sjPRdSSoGSVQoI42EVUfioR+O42mdYMvCQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883ae2b5-203a-4482-3aa3-08db25610e76
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 14:24:58.7429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6OaQTGQCs2AUGXhtWxAfVjcB01eDc4s5gm2+Lvj8asMP4+7iVm6j5B7okByjuhvldBgGgdt4G1q9QSts0TAHBLdOTTsiKwC3TbueRzWIIqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Chris Paterson <Chris.Paterson2@renesas.com>
> Sent: 15 March 2023 14:13
>=20
> Hello Greg,
>=20
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: 15 March 2023 12:12
> >
> > This is the start of the stable review cycle for the 4.19.278 release.
> > There are 39 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
>=20
> Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>
> CI Pipeline:
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla=
b
> .com%2Fcip-project%2Fcip-testing%2Flinux-stable-rc-ci%2F-
> %2Fpipelines%2F807195668&data=3D05%7C01%7CChris.Paterson2%40renesas.
> com%7C3e2acf37d58a4bfbbd3908db255fa3c8%7C53d82571da1947e49cb4625
> a166a4a2a%7C0%7C0%7C638144864918022713%7CUnknown%7CTWFpbGZsb
> 3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0
> %3D%7C3000%7C%7C%7C&sdata=3DO61NN4m1S0Zhr55UiQSADXniMYXWx2%2
> BBLcAAy4MtHLo%3D&reserved=3D0
>=20
> We (CIP) are seeing some build issues with Linux 4.19.278-rc1
> (7cfb8ee7c98e).
>=20
>=20
> 1)
> In various arm, arm64 and x86 configurations we see:
> kernel/cgroup/cgroup.c: In function 'cgroup_attach_lock':
> kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function
> 'get_online_cpus'; did you mean 'get_online_mems'? [-Werror=3Dimplicit-
> function-declaration]
>   get_online_cpus();
>   ^~~~~~~~~~~~~~~
>   get_online_mems
> kernel/cgroup/cgroup.c: In function 'cgroup_attach_unlock':
> kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function
> 'put_online_cpus'; did you mean 'num_online_cpus'? [-Werror=3Dimplicit-
> function-declaration]
>   put_online_cpus();
>   ^~~~~~~~~~~~~~~
>   num_online_cpus
>=20
> For example:
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla=
b
> .com%2Fcip-project%2Fcip-testing%2Flinux-stable-rc-ci%2F-
> %2Fjobs%2F3938632173%23L1274&data=3D05%7C01%7CChris.Paterson2%40re
> nesas.com%7C3e2acf37d58a4bfbbd3908db255fa3c8%7C53d82571da1947e49c
> b4625a166a4a2a%7C0%7C0%7C638144864918022713%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C3000%7C%7C%7C&sdata=3DteWNvt%2Bu2l1S60qiGOTPyLA6bB1
> CvxJ0XedA2qCDmFI%3D&reserved=3D0
>=20
> Presumably this issue is caused by "cgroup: Fix threadgroup_rwsem <->
> cpus_read_lock() deadlock", but I haven't had a chance to revert and re-t=
est.
>=20
>=20
> 2)
> For arm_multiconfig_v7 builds we're seeing a some errors when building th=
e
This should have read arm multi_v7_defconfig, but you probably worked that =
out...

Kind regards, Chris


> exynos5422 device trees:
> arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR
> (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map0:
> Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR
> (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map1:
> Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-
> odroidhc1.dtb] Error 2
> make[1]: *** Waiting for unfinished jobs....
>   DTC     arch/arm/boot/dts/hi3519-demb.dtb
>   DTC     arch/arm/boot/dts/hisi-x5hd2-dkb.dtb
> arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR
> (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3:
> Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR
> (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4:
> Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-
> odroidxu3.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb: ERROR
> (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3:
> Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb: ERROR
> (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4:
> Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-
> odroidxu3-lite.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu4.dtb: ERROR
> (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3:
> Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu4.dtb: ERROR
> (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4:
> Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-
> odroidxu4.dtb] Error 2
> make: *** [arch/arm/Makefile:348: dtbs] Error 2
>=20
> Log:
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla=
b
> .com%2Fcip-project%2Fcip-testing%2Flinux-stable-rc-ci%2F-
> %2Fjobs%2F3938632189%23L8634&data=3D05%7C01%7CChris.Paterson2%40re
> nesas.com%7C3e2acf37d58a4bfbbd3908db255fa3c8%7C53d82571da1947e49c
> b4625a166a4a2a%7C0%7C0%7C638144864918022713%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C3000%7C%7C%7C&sdata=3D6JWX1vUABxWE27R2%2BzPSNnQe0
> 8erwGJHyKkhVYKANww%3D&reserved=3D0
>=20
> Presumably caused by "ARM: dts: exynos: Add GPU thermal zone cooling
> maps for Odroid XU3/XU4/HC1", but I haven't had a chance to revert and re=
-
> test.
>=20
>=20
> Kind regards, Chris
