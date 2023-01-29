Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32C9680122
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 20:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjA2TIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 14:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2TIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 14:08:31 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020021.outbound.protection.outlook.com [52.101.56.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27504EC0
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 11:08:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSav7z2ORXItyBpxGtw+DkmA8bgj0W2yuZoHpRNbOQETpOXVhw6Mp7G7ytaxLDras681/p+Z6MH/HlJRfW6m4uOoUIU2adLps+BdlgIqHNW38q+V9RAFqHGL/WJcRv9OlMADALSsYHp5pnTvlNZdFTxCuDdeB0a5iHrCyfBXeO+tfn66uHe8lbu/QL4EfFg/O8/4XUauGcQ417j4FhmODKelcM5d3odOlwU/4bGiy5LumWxvl+Y2u09jitn0SP8DpkG+fKXoSBwOjLQjg8366RY02yj98k2FFuQbNZAquOL0k2RUV3z5TOWb5Si2K/+5sPOYSl0+ruEJLXu3ZWTy2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oyJUGh2dupPI/50Pbsg4Fxj+8Z95TWdZZivTA8PzJsM=;
 b=GXMX6htg5KOTDHExqlZcELFkXugZ7Bjj9qHgEhjTUsJ4GyxQDRF52tZScVY81Cuf+/rID1ShZuCxvHCSXtYH1WQSjHhMwXLxTxE2iT4RNi09oBgikLLPJbwhoKQFNnJEAKsQwZNg4Rzi4kAy2mXsYMfKVRTI2yQalppxprgailB7e7bFbkVsZhfvVt+o1i/Zlo2H8Vq1wnuV1HDjyVAYhrrKHSOqvGIGxbqd79XFK+J1p1juB1RFi+/oGoABuXzWKCYTRgZ/PnHfKF7J3QjAbrgz/O6wDEQSg7dNUpdBQT7CPBumnj9P4YVanaOrzprqONfwUwepCGeKZoPMz8CzwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyJUGh2dupPI/50Pbsg4Fxj+8Z95TWdZZivTA8PzJsM=;
 b=BCC2f8GWGga6gbK6tBWWOKawNDltk2nUMFww8xCuasBRvJ9S6AETh0T14HEKOvVDSbz+TfTQJx7vwjlUp8PjD1W/8+Gqwpm5fWEsjMVcEQGQzgyAMS+31bil+a6hyyP5lVnTixj7QEi/0cuGGSCdj+XWwQOOV0gaJ4dtVWQWJgo=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by PH7PR21MB3143.namprd21.prod.outlook.com (2603:10b6:510:1d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.3; Sun, 29 Jan
 2023 19:08:26 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce%8]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 19:08:26 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] net: mana: Fix IRQ name - add PCI and
 queue number" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] net: mana: Fix IRQ name - add PCI and
 queue number" failed to apply to 5.15-stable tree
Thread-Index: AQHZM+XH8vpYorr39UWuqrXdOuJxmq61wdxA
Date:   Sun, 29 Jan 2023 19:08:26 +0000
Message-ID: <PH7PR21MB311666C76242D0B0870DC1DFCAD29@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1674998982450@kroah.com>
In-Reply-To: <1674998982450@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e8dcecc8-d312-4a77-9439-82e12775dd5d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-29T19:06:44Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|PH7PR21MB3143:EE_
x-ms-office365-filtering-correlation-id: cf31a8b3-9492-4680-2028-08db022c3306
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cUZWGg8+QFjRwA4kDsqZlsf1CMKg8xq/esOCGuSvyQKXWCdQ5FnkoLytk6Qgw+h5fUBlSa4gBJohaUaF3KIuefW3d/pDKBAIT8/dGMKH19h46VCv6aUE6FQRvBgMCIJhUx/7JXXw97Km/LV6l0tZ2vL4KTfJw9BudI9dktHPREvgEeWxijKpEGi0YdwfrISZA+zs7hn8m86UH9PmvHd27JrYpks2KG5hu7YHyG2smTp9+PRNqkR+kXRLz/3Qm8hPkC1ip7ZSKbzQM0J6wCOj2sjRe6GhIFJdOrHJCOTHk/znFX8Ueq+EjD7UJxOiVOH0Pf2a+58Emcc2lAAd2yK3P7YMWBMeCz3lpDEub+EBeNUuifFOUW3X11lk7a/VI2pJjl64WKaMekXZwitzgYZvzRoHBvA22L6FQtXgfWT9CDcNDgdoZonEgmVOk+61NddAlhlO6bkF2arJgsK8ZSFoyBteKEl7S8N6POwRayE4yKYT9YWQWWD4JEBWsmVl4RZpRtz/BEJA3uKypr3NJf8KxE9anzEPmStiFq5pDpYGEwbFUCj2na9+6N3YYa5Bx3/grNY4fJkalnhsqdNEr80V9iRwym992eG+rkZ9cLCFBvGZhRf54cf7tRA6qyL8Uiic0P6eYAKvjHgTISTnddy6K/fnFoCiqf6QrXpvekIBQsHROHgRBeO9mtgEnAk3xR9hDIyWTr9x6BGK5jwvLBpbpFG92V/A7gkYWV3/6ZB1ya+V8Rv2F03Rb/jcIgWtLLxS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199018)(66556008)(10290500003)(83380400001)(86362001)(6506007)(38100700002)(82960400001)(4744005)(8936002)(52536014)(8990500004)(53546011)(41300700001)(82950400001)(186003)(38070700005)(122000001)(76116006)(110136005)(55016003)(4326008)(478600001)(71200400001)(66476007)(26005)(2906002)(33656002)(316002)(9686003)(7696005)(66946007)(64756008)(8676002)(5660300002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?idH1OLzhjwjWzkphcL8C/3ouNwFmZtagaABNx6scGBmX2EZrl0zD06Prs61/?=
 =?us-ascii?Q?BzNaT0MVRI/SvFgo9yTI++7SoGWDZQUfVyz49NMHXX55cZakO+DyHrX/7RAG?=
 =?us-ascii?Q?7pbMQR9NGtQJ4nzLoCUvECVOXnMKgzW4IAE3arOAVnINw5507IvZ0Jj4jw9i?=
 =?us-ascii?Q?XlEo2k9Rcv2cue6+JO6HDeqFXxSkENvOwxP7QoPgzDEdjet7/QX2FwGYOmdm?=
 =?us-ascii?Q?G7uW1n81JTu/8urtQwMUOJsBs0ObYtG/cw17COSQ8OmhflcpYRS7Algoleq9?=
 =?us-ascii?Q?VC50yg87cHoVh9eO0rFYlPgDtP8UyuHEEeqUu94aolqUWjDCkJl4NyQny4ZP?=
 =?us-ascii?Q?wSYb+rNqnXwjqL8LydEZBoADqYLlJvla7UT9CTHAi6OkrRN5dT+DlH9WZIJc?=
 =?us-ascii?Q?/3JOcuKV4NW3D1oJqpW01dI9QMcF+kfie9lC4bjXbI4KIVjtAR9g4a3z4one?=
 =?us-ascii?Q?9QzkWHTS0hNMG6tESHex4oG3oVKeFfJCx6JToh6E3J2E/x9EcJGd/x/+VyBG?=
 =?us-ascii?Q?2ccc1+gLfl2+SVx3resY2pNgmiyNGmqHzoX+cGvBCkEmSYLrBA/2iB7+4G66?=
 =?us-ascii?Q?+up/rAt0YNjfDLr+o95rlorWo73xAzhhaT7C1Z50/EManLchviuCXnFkfRm7?=
 =?us-ascii?Q?H1pZuP04EPh1DoW3qvKlbwM4C29ApYw5WlhZR1n91BbPml1lZx45W+z1gNiN?=
 =?us-ascii?Q?WHLagULL+ApgM45qVmXtKWlAcTEbcNrqCz55uZ/QFX0gEDHGTXY50QlcwsuG?=
 =?us-ascii?Q?fVrU44aOZ7DZC+RUIRoOaVvwTFhYOJESRtvqCoxrQUFvdAF41UNOnlSojCbb?=
 =?us-ascii?Q?bhPBVdJYzt9t9iZm+WeImzNYtK+oK5+vk02Y16iBW3ebTbfMZvcTbHt3P+sl?=
 =?us-ascii?Q?Os/1u70Hb4j9TWZbJ+kqTVxW/vhOAigBBFbScfBfrVCJfTK48o/rVUGWMTYq?=
 =?us-ascii?Q?hfs7aZJ06MpG9SXREMEk94YKltBOJgFu/firpetgzYSPHYRdSMof98cGi/7B?=
 =?us-ascii?Q?FDfwW0cQHjWqkfsHo5MvQ8o+r/B5qRMDXNn4OegqCkFjZtVIdhBdRYtRQtWG?=
 =?us-ascii?Q?2Tyv1S/3b+TypJuBYBl5v/UO6RBzdPgySACsQAM23T6tUVZQxYf5qMCfr8Lp?=
 =?us-ascii?Q?zC0ETPW1hKQ/xifJOtfWQpuGS3vpzF6shjQKmjbT6bNb8zOURYMwbStpHJjQ?=
 =?us-ascii?Q?BknQjS/Om3ah7/tDPh8n6LhjXrK/qoEOi4AqGyz8A3A+jGbOkc9QqGgeaceY?=
 =?us-ascii?Q?UPSJIpOxLBUeMZ9bw3oOS3D5DST7nXJ74nGaO9UR/9A6eDKncE7V8mQAPDVq?=
 =?us-ascii?Q?75krkVPJHyOGNtfG6/STUqxzSz+fDmmXSkKAexIGSRrG/LZxs1ky0Y/IwfXm?=
 =?us-ascii?Q?OrMG1iGJEYwyHv4c9OdGQNuv2oGUYV7a/K+LbsUipAf5VdTeQVNSsAXowFAc?=
 =?us-ascii?Q?319UcCCixaMOtwmPXsExbMNcSMSgRAf1s86q8ywFAyyeuh1ivL85Xj2OKVo2?=
 =?us-ascii?Q?iEudH+9HrDpzS6nxVApLVg+Sb/I4hxkxoaacyPse7JLRq86jGPDd5ynF5q1G?=
 =?us-ascii?Q?X2BFKf/zzvzHAYbM05sH524Y5PTF+Biibd9ZTqdx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf31a8b3-9492-4680-2028-08db022c3306
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 19:08:26.0288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2WfdI2oo56He30Zaqe+tjHewAtlaolyeYhAGd9GI2lYLLO2YP5LajvIWLUUxdLGgXBsPAAprMNsugu9sfTb+w==
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
> number" failed to apply to 5.15-stable tree
>=20
>=20
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> Possible dependencies:
>=20
> 20e3028c39a5 ("net: mana: Fix IRQ name - add PCI and queue number")

Will do.

Thanks,
- Haiyang
