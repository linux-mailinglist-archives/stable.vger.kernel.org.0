Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD64C6EE07A
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 12:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbjDYKjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 06:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjDYKjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 06:39:53 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2090.outbound.protection.outlook.com [40.107.113.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7677E13E;
        Tue, 25 Apr 2023 03:39:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfwJ1KscQA/NRvjLb2Fq+ErUutntbNKmf9DlI5Y2tCLEcfWkf/a7AuWauir/I55IonB8IFTIqcqPiP0sGXANg2kDZCr6AJo/cWPV8WJGpNFiBlTyKBl2PPv8N2cbIHOt90VgV8TRENEDIruwkjBBne4faJyTTrxpT2PvHaV2aF84nPfj6e1NWrv2PP6zV4pvO/xQi8kLrEkYpMMyYwhs/jipulPTjGQqrpWbNWQ16PtfHycq2/tb2vVBqgVLmNCfbmjd0snLvjCL6DOmelaPwLycRbiaEmWY9nAAdXI5+yoiIEN+m289O8opYB0RDqHCLwLriNwahUGNttKFB/T0dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgfFo99/F7beNfMw+pV/lNG6sFppS8boxOUXnFZ896o=;
 b=W1D+nRiXSS07hVUA/4wU2Qg9Lt+iF3unF6m4zRLkb7Tk1bmpY8W2MNR6kZoow5dL6UawtFWZWIAXxnRwvcHVtEkWF/rPkeKO7fv29MknovfnmT/ypfU9GbB+i/XKgZglzRogK52W+rFTytT+xyKuAtNqLenCKDwE7TCAbEm/9l9J+tjxaNNT9Ojwuhvq5PscrjHu4qEHhc1Y/FnHCX3cU45jZuqYfznaar8KbPRm95/S+CfGltoMxuIO5q4os0YMfLI2vUTZ35qRW/z/eonwmK4LFP7k2sCSc795h2Cbz8+H2lY/4Y40S0F2PcIar0geUsIGTuPO/2df8sxZsCRh8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgfFo99/F7beNfMw+pV/lNG6sFppS8boxOUXnFZ896o=;
 b=CAu/Q5Rn0zQNwNu2/Oa2hqOG8QCmT9bFvMOIsgJvIDh++POGnV5SYIs0a+UZHPK2w+ofMzDtlFNzkRAxOlvVNwitd0DjL+wznKLYvkIhas1JyPX/WJOWp0tPkrGNImY3mwP7JfiO05YxIbuRMmRB3MWqERq+GVA+gQrQ12NeK9c=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYCPR01MB10762.jpnprd01.prod.outlook.com (2603:1096:400:296::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Tue, 25 Apr
 2023 10:39:49 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 10:39:49 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: RE: [PATCH 6.1 00/98] 6.1.26-rc1 review
Thread-Topic: [PATCH 6.1 00/98] 6.1.26-rc1 review
Thread-Index: AQHZdrAxwCxukxWdU0q7Oh4jnWZ99a871s0g
Date:   Tue, 25 Apr 2023 10:39:49 +0000
Message-ID: <TY2PR01MB3788742A50C7419F80ABA583B7649@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230424131133.829259077@linuxfoundation.org>
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYCPR01MB10762:EE_
x-ms-office365-filtering-correlation-id: 37698fe6-89ae-4e19-fea7-08db45796546
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cE3Udk5f7sixciV3LCNgNNBhnllia80P9Eb14Dgv2XM3UIut9yyCg/PHhG40bjf/OBZkji/lqYT3KZQRX/lj1zCYCYF5wl00a6Qd6YekMlR6ziyWd97FWQD3WYwTmh6M1OkJeGXLrtlPNPOo2wvrsIIKPOaQKhlhMIhh1XkbifWrvrmP2mdpCRlHhtOzxMx/RSagH6z2pC6szx5TDxU3pqBGTW7zKuWazJId3Kr2t3JR0msK89mb7YHJBOYrjhE3C4px6h4f/MDZpFQX+1ndelkCTHCtCA+AJAQDHm3VjXgjGOekaMwSj+8rV5GlEbV8zXpB+BFe3+ndivBn9+6c+SGkvzVqBQhGgALFKMhkOopKr172pysb4gmfw/2CwaOj1uOPTYjFrVELYfvklYPyQGLGOAlGMTpfnco8oIzMah/ey/2w1NKfhx1mqBxxxOuKHCEZGZWag4fZo088ZwrJHv/QML3/0Cb8uQ2HjVddAPFb959rKhCQum+gkiSWIBulKCAl9tbcw3t3fHs0syGxxdAjDaTVsaJXVqxUlBYc79W49OzGYvnNtwPXb98H1ZMASMiFFkdNp9WOnhEPssFQvYvBQC448V17nmBViYqfRWGs/5Cyeykwz04RX1fMZ4xLYsg+nLTAx5vc0IM5u8NzzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199021)(66476007)(76116006)(66556008)(66946007)(64756008)(316002)(478600001)(966005)(33656002)(7696005)(110136005)(186003)(26005)(4326008)(86362001)(6506007)(54906003)(38070700005)(9686003)(71200400001)(38100700002)(66446008)(55016003)(122000001)(8936002)(41300700001)(8676002)(52536014)(7416002)(5660300002)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?D+kBBI+BjQ7ukkpaFIAxQPadqJ95mGeraXRVrNXvgLnKsHYCgPxaRcvR?=
 =?Windows-1252?Q?QqZyvQclYTGtyZvt2cwDJUcy+9hmUmCOMuq2NdKqInDesxCMLhCyebJ2?=
 =?Windows-1252?Q?g+XHRrY7nxl52FXbHMbIOlB5CZgBV7MH1RktwRthKPZWIIWRRD6Z9zzQ?=
 =?Windows-1252?Q?cMdA2lXw2/4bgI1xIHV7qZfgTDe3clJHuh3FOvNDKkxn4Fid+4joicvv?=
 =?Windows-1252?Q?ev1thyJvkYBaHMDJtxF2FlAhGMm7j6P55i2Ve77JHyXdnn19PrkqM2u8?=
 =?Windows-1252?Q?QF5F2CRBiy10yrWZUHBWihvUui4SkZwp94l/bclKEsBxJWwUr370e9jH?=
 =?Windows-1252?Q?kjn8JPPkuWujArgd+VzeiZuEPQXMPegCClskr0tXz00vEE8Q+/z8JUDG?=
 =?Windows-1252?Q?/DZ4X8cUuEJEL78fui7TG47FJJO1hnkpB4IgAjVHwtf4bpFWswZt2d+j?=
 =?Windows-1252?Q?9p+rPVXr8WPEyn5nutQOT+jqRaNyAG0pqMFziHGlliNcyWy697Jkhdg4?=
 =?Windows-1252?Q?m1Cld/kKTtkIrymfndwQ4v74F4CwJ83MAj+wFPqwsVaxCAmp+l9bohle?=
 =?Windows-1252?Q?bMkGDwVh8EL+UreMMHvMAtUrksyocrFKMR9L1i0J2rVrDwQ6CkhvkD1j?=
 =?Windows-1252?Q?HecJp8qCyjPa/t7AgQoOwGs4dxU8hVyCuIo15pjh2je9gQTJmmGCBg1w?=
 =?Windows-1252?Q?j1/vKgE3iugG3vJa1v1mR9EDvA/P8EpRbxdHuOf3dA0vdx4CT/kLCTob?=
 =?Windows-1252?Q?ibvuobNH0M74ASooR/MimL9ZTgp7BGDj+cbMsC+th4N8vzzjHsSPgvmk?=
 =?Windows-1252?Q?/InrG+ss2lklkSL9c3uyuBEtU8wsjRdd/fgQMiIdVP6AwXBiufJvkbTI?=
 =?Windows-1252?Q?kJ54axfOBaZJA+h9mypOJNZP1rUYyYwen0a9rPNAd/W22wkyBvEdYjB1?=
 =?Windows-1252?Q?RtmMyQYCyhzCWOKGmtGWUPFxkGGcQGcD2Dns/nmuvGEm7ckAZOUdcyJ1?=
 =?Windows-1252?Q?oDeKCxQHILME62e1zHVZaBlWLtXWITAixR0FvB9q7XZNvl5/EC6qhZIn?=
 =?Windows-1252?Q?UecqXK8ba8ZdKhZwFq+b84TiwLhOi0x1r5W49+Sc/sxyzaMBKTPVQIdA?=
 =?Windows-1252?Q?sfVHDk1AIkF4QOoy4K3JEvS/z9VTQCBMRAjgQamxwfOEA0JFpKO2ejRo?=
 =?Windows-1252?Q?gKAG7LBF5+nJSwmDtdRzmTteCGT6WPW3k/2lBy9un/mZAhrxLWMPSQVJ?=
 =?Windows-1252?Q?j4GiOUIhYu5ccKLenisyUBaT9c6v/8OfrEKg9srDRND/q3Vk8F3jfDrx?=
 =?Windows-1252?Q?rsf71yUSKHuB+W1wJaff4K9RLPB8P5DXFjdG3sbAwtUNZ/1nBYDE4r8m?=
 =?Windows-1252?Q?MGQidRNmOaVdF9lCS3WQrJOWfuUWrdyxrNd5j5XQjcJwsnwPEr7seYT7?=
 =?Windows-1252?Q?L2lKeMJhZVn2SeJLr9DaAdzeaVtWE7LAuYCNnUrvB5fJOItOjONix+FB?=
 =?Windows-1252?Q?ENiFr3PflZYLlhqKN9fxC4mKzbi/jQinrWlrZOZG8mGRjPyBrgEpPXyV?=
 =?Windows-1252?Q?liC6ycMFFwDNhMnVizZVo+5Ss7I1ZDVWbo1xf9iZzSj+MNp/tcVhqHBd?=
 =?Windows-1252?Q?rnwq0WsqZmAGrW2yEzpsq0VzjhxUFR4UdZBKBWut0a/OAYp/gDB5x+oo?=
 =?Windows-1252?Q?Uq908pgX6FutsVjucRPKXD9avbXLHyr3wHPkooOiM05zy+BQB/rDOg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37698fe6-89ae-4e19-fea7-08db45796546
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 10:39:49.5342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L/x5Kzs35JwyiKIcexZ6YHvV+47q0OEyWu64fo1XwVmiK3VAsXDAy9dnoDxxfuCef/vJzavJ93GSG3/1JGDGEJeCXnuRkq/sl3Pj2CCVdGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10762
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, April 24, 2023 2:16 PM
>=20
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 6.1.26-rc1 (e4ff6ff54dea):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
47554120
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-6.1.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
