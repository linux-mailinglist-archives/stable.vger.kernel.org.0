Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E61680123
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 20:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjA2TJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 14:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2TJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 14:09:04 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020021.outbound.protection.outlook.com [52.101.56.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796E34EC0
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 11:09:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wu3mkBnLcPsJNuJz99/plaxZB3g/tTdpJxcIRc6NY6+GQQNzQUWH5yC71+JP54jaSweJPKU5rcZgvfLvVXZ7fBDTm5L0HODNQYuQI+LkCpMMhEf6dxXJzl7HlHRN1OT1rdRJ8bEoTgKvv5hCrlH+W8IdSFf5Gj8AK3v49224wpViHTfVfirFb6Dcl3FhGcs5X8+C9lNEBMGWt4iYaFawgNNa6P1E0TH1BxVYDdzn2fef5FdpgyxCUQfo1zvPL017AAAGMxnCxiqUAtPq0Q9YOcqgoLPFnk1BW1KwWoC3q/kRNpTHVU6UGBt/TopTxXf8Q/NMUzyx18VdXU4bzxnuPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gIBh5eRLDz9oGZc+T66V0ccSOK3EEX0QVnd3iF3oN0=;
 b=TxRtieRd7WJyVpSAMTBv3LTH89ZQXpGIvIgwGVQU3u/BDJjkBRZLk1RvrgWEeS8Cj2jgXCzz7bBUa+GIjcZu/n+GJQ9obH8b6ZQd8u5Q6klU0js8ZKIYi+TqlkyNRaa9lHs41F5y3F3Bu9McAaN5YpoOpYHHEqgsoGkCI6aBazPlv1u1eE483IYLfddiK+dP3tcmocO9tN/p62Z5Ym42aqM+yMb21jwkdGSrr3spVFoe5uXUblyNHNQyFbk2s14UcsjM3qXknleEWVnuxAFLbQBwEiU8s6D4tw/dOAeR4vSBaZE8lTx9bQD6Ssh439DjtDJo7fs+nDA6PAL/344VPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gIBh5eRLDz9oGZc+T66V0ccSOK3EEX0QVnd3iF3oN0=;
 b=GsBBkqpEamMMcTcdevVaQ/Tax/3D5TZDSBcSyUsoNOMvr/S7Sz909eZlv0jw/oyOAPb3fN0pkODyRyLW7eBuSIqh8W3qX2BLPwQ4eaDCsRNMEe9/KIC3QSiN7zoHUmgsMRyOKd0iL1F6NGYHxUBA02+/lUgTjx6tmwZfx9ry7eY=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by PH7PR21MB3143.namprd21.prod.outlook.com (2603:10b6:510:1d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.3; Sun, 29 Jan
 2023 19:09:01 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce%8]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 19:09:01 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] net: mana: Fix IRQ name - add PCI and
 queue number" failed to apply to 6.1-stable tree
Thread-Topic: FAILED: patch "[PATCH] net: mana: Fix IRQ name - add PCI and
 queue number" failed to apply to 6.1-stable tree
Thread-Index: AQHZM+XD/LjK7+Vey0anHEGIUDk9sa61wlmA
Date:   Sun, 29 Jan 2023 19:09:01 +0000
Message-ID: <PH7PR21MB3116075DEBE5A66964B9A549CAD29@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <167499898174157@kroah.com>
In-Reply-To: <167499898174157@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6446e58c-35de-492f-aa94-68c4336b4088;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-29T19:08:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|PH7PR21MB3143:EE_
x-ms-office365-filtering-correlation-id: 3e53af51-1668-4295-8b13-08db022c4812
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2mwrjdqn+CQIpVur1Fsp+dIO3IG1bqvUAf6pPYFtZS4PHCilMr/M+MAhxv2m9HLiLAxOE/dNcv/deXdWo7mxLBhrfeD/CwsGMlFf920s1v3IWSWTx9baKYAJIlPp3bLHCUKJPiHFXLMg5CWTGCaky56bKFFwjbzyo2fQJJNdHiqzzuMqIS8aY+oJ4yuZ6aYmdrUEe5Wo9N6rzKDK3NYGSmCU2nRt3Bh16qV7Jc3BIpeaC9dvlTX0+vLotOZFP1duymhLjCwl8+4DSHvo5D2ltyQNw0W8Ia/75IpJtf8Ip+K72I9gs/EwNv7ncLFnlcz1OOzVqUZwIJ9UdkSGWQ6W+dww9vLfc9OlTIQcYSbOsR9lj3fDv0hIawntoAsiBWXPWnCC9wThUw0++0h+OP9j/U4l79beR0B4LPLaSVxOIOzWIHAPsjANK6YWmyXaN4Y1vEqMbXlZnWSNB04AMICrBUkZUF3AvbI0mOKQhmh9bcsm5MeuSMZRJnjvCYtlhtPvp57HEFdbmyY+LEXxqvRXmRo4i160nd7Of6hTrZ4pCY0i+FmFBlYSPN1MIjFMD7hevDp7XJo8dkfVCvGfpUFyG8mjxlsxRVDVcauKWDxiJqn1gIJdNK45pbMnxaoURWiNxgCj8MhrIVklfjFAhvAiLAoLljC1USUDpEqEij/LHkSo9qtWDRSQYI3uDn7VDlrusN+OaulVbbDtzu+xv/Hxdj1PXzIKF0W8zuXWZjPo2MG/6T74zXAT+P1e9ZyIQPqt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199018)(66556008)(10290500003)(83380400001)(86362001)(6506007)(38100700002)(82960400001)(4744005)(8936002)(52536014)(8990500004)(53546011)(41300700001)(82950400001)(186003)(38070700005)(122000001)(76116006)(110136005)(55016003)(4326008)(478600001)(71200400001)(66476007)(26005)(2906002)(33656002)(316002)(9686003)(7696005)(66946007)(64756008)(8676002)(5660300002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WSXapVyGbp4Cpbzi6Aj22GkOO3Xjuf+ftLkboIRQ5B03W1Z6XBhVg9FcfrNX?=
 =?us-ascii?Q?9BnKTPshDeagG5H/f6TbGg2YLxXctMndz/twrA4z6QtvKCRG3GDtlLirkOsA?=
 =?us-ascii?Q?sIHpDdvWemiEKBGmHjzQiMJgh+Cm/llAFwiv6Ac/0nfEinIK2OeSl6coKBXA?=
 =?us-ascii?Q?aO6DbiTMVGbSMZxx2WXGWo1l3pBwXO1YdfOQ7jEAz9L1FseNU6Lr3EbEJ25d?=
 =?us-ascii?Q?3eCgJXGWd/UEGaYTRbWicCKGJAmNk+6pojw9DIEnrtFRtJNs1ovOr/FyklXq?=
 =?us-ascii?Q?ZbcklZsJkYDUMnyWV9kxg5w370C6ZKBM92sMOTei45sU7hpgKu3+bFDYBUZx?=
 =?us-ascii?Q?UmbIqjbiDVhaWX1x+XRld3qW1w/OqwYigH5Lv2Gwt4kgpOjkLzASgll40lvA?=
 =?us-ascii?Q?qIi+jbcwRHKYQAJju8MDNbF9lE2bf1/XcoDBXICPJpVCyCU2yiykg9XOc0Gl?=
 =?us-ascii?Q?1NNagE9ERXIabl2dNFE9QIYAJLVic/y3/PL+/P8hj/Vwj4jNGzrE5G3fxVb2?=
 =?us-ascii?Q?1riFbAFDplPQMiwO7ufLqh/0rVtLrudfGVbYRsenHDGTmWK0C4XvoCXHYLaT?=
 =?us-ascii?Q?VSVOQcvSdzmVgWbGGLh3mb0OToqpLrCg/DEERKaMUwC8ncAkYSV2QPn/gNJK?=
 =?us-ascii?Q?6WAQJM9TNpFYo6Cpx+N0c198eJoMEg28DjRudLI2SNGbTPVBQikq77y+lmhy?=
 =?us-ascii?Q?lwSIYpRQfzzkXrF08Fzgz4MS3oBo+ieywpih9ECvvmS1hYsSmDWBpFFVNX4I?=
 =?us-ascii?Q?zLtl1UtDN1ZBWkcfEHzax3XwarrQ0znHdSm5RS4d5AM+lLChC0BpdJnTgmrh?=
 =?us-ascii?Q?NsdP9uyAodACj3b5pGriyfhYYCxAWGeaXiGNLzTDH8+dBvcLIUKuF2rT4WQV?=
 =?us-ascii?Q?LL9/U/kROTwyHXbVdzMT0gsalMsyH3LDFUL54FQbpatNc00sbN6XZZLIL3EJ?=
 =?us-ascii?Q?S88gJEj7/4I2gt5gTz61JYwkarvtbZSPQbZEdLZd3JJSnr5h8KkSu4ttcOpx?=
 =?us-ascii?Q?P+7D1yD9Fww4LMlWKGNeqLPFPH/gHy22E7rXx1exl1P8NXNojdNiv9wvkO7k?=
 =?us-ascii?Q?eSJq/wOk3lxRuGDUnlZ3i+5ynrnPL3sPYxXA2TNxu+Vnyb7uRN5eTLB3ZkCr?=
 =?us-ascii?Q?6juiJh9teyYNICvjfdH3NnffTiQnT6fJ3j1wbuFxn6lRyp0IfaLuxHYomdkG?=
 =?us-ascii?Q?9Q0r2oRZQnlSCdB7dlUR51SN7Szn+/Lmb8MDIFBzcgTESNoHkxCgVIgStTWg?=
 =?us-ascii?Q?UYtVCOU9StKIHBvWomANL4zQnt1pT9eiX8YwIyZWvgkvcDSOU+zYhGpergds?=
 =?us-ascii?Q?rTUVXx8hR26sP1IbxdIFJgDx04INJPB77YC30jrn2GGl7k44zcCotikkjdDD?=
 =?us-ascii?Q?DbVpbMR0FfB96MoHHhsUcNvN2u3g/gMaE7g+CL69/AK0X9QkZSbR+4N1ph4Q?=
 =?us-ascii?Q?+r71kMv63UYiBBLcLiEZxCdJNpTALEteYJ/PNwFP1WzX52OQY9X4YJ1A4kWP?=
 =?us-ascii?Q?jdYLGrhT/aRW5ezYvxveHzFy+47jyrIBFJBYRT0Jt6yhE3cfleuiDdKUDD9t?=
 =?us-ascii?Q?eUOHqYC1Ozidy+8e56JEKckYySo8wtIRxxyfIdbS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e53af51-1668-4295-8b13-08db022c4812
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 19:09:01.3892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LHkNFfPyrnInUirzDZDSUsUnzqbuEKr3JXSqZaROr6FIZ0ZnL15I+Om2acYFeYa0MzCGUamC+gSTJAroovLsew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3143
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Sunday, January 29, 2023 8:30 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; jesse.brandeburg@intel.com;
> kuba@kernel.org
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] net: mana: Fix IRQ name - add PCI and que=
ue
> number" failed to apply to 6.1-stable tree
>=20
>=20
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> Possible dependencies:
>=20
> 20e3028c39a5 ("net: mana: Fix IRQ name - add PCI and queue number")
>=20

Will do.

Thanks,
- Haiyang
