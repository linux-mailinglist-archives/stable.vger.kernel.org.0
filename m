Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5974FC2B2
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 18:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbiDKQvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 12:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348691AbiDKQvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 12:51:06 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D679393EA
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:48:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xe3sLW5widPDfU9jSeuLe7w02WThVnJJJPRRDcs8TlsCvFT+9s6cGgSKxZp0LjfkP80UFSflkrQwBEEnASfhR8IY3kVxTH6jXka+g0jCoMjUxbfDewyyXFnF7INFXt9O8nIym6p5YUoYW6VIDxVXWuyxhiArIis75G0gkVJsV5cvsNfXs/8euuc5NOiV4dpP8SM0oeE9SpmKTumpDNibsBlzfUW95k4ZP9f1MM00I2Hx1krxHZnaaXwjQWJlepJ/42q8RCK9ehfqSZ1MWkrbrcbtzQurnHeUQ54Xch7yLezifX/9gYjFY9jS1OeOvTB7jcoH6h8Z8uHboarTLrheSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+EGuR4RGrQNk7nyyhL3NNsp6rfporbjtEs7Z4hf3x4=;
 b=NyspwUk6moxLjDxeqpvE9UpvLg2yaDMUnvc0dmU7+DNTsnKMDorZ2/8VBYYX62AgSm4bcjqR83J3PeqHqa8o6We5qGRtmKB05x4ZKOzAMDcaEUJKnezRR93sJhv8oileQs+b7gbM9BvbkhnZ9We3vAPN5Lrk9qWiuEc9jU/XZ40CSxFV0cFejBWOFcWMteaRRbyKvTgs94ccbptP6ulWeXlxfa2uWiWWkMpqvJBu3zMRhlK8Qoo5QiEp1Qjz9H0yToB/s3pOFtWLDvrTfGqBc1M8pl9d9eT2q4V0WQZReYWLUMTU4GSL2vyoDiurTE4nmavyoeGfo4X3HO9Z14lMeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+EGuR4RGrQNk7nyyhL3NNsp6rfporbjtEs7Z4hf3x4=;
 b=z7YxXqPZ7/c8pmCKTN/UgVD+NTShgxBsJr86mTm5IEVCVMk+Gv1P0Ugl7JRyFAc2ELV4sI3ApFdJphAdCGKbrY7v9kbESY2oqDFQCFUk6qd60HFh3dw7HE9WWk/bXV1tv6OFfJs5teXP9fdS3KeT+GrzZ34L/gyMAJW/odDteS4=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 16:48:49 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::b057:2bb9:60d0:b3ad]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::b057:2bb9:60d0:b3ad%7]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 16:48:49 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
CC:     "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 5.4 0/2] Fix two instances of -Wstrict-prototypes in
 drm/amd
Thread-Topic: [PATCH 5.4 0/2] Fix two instances of -Wstrict-prototypes in
 drm/amd
Thread-Index: AQHYTcNNBKpRVdAH9Ea+UmMsG6F7gqzq7DkA
Date:   Mon, 11 Apr 2022 16:48:49 +0000
Message-ID: <BL1PR12MB5144CA4904352E58F22F72A8F7EA9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220411164308.2491139-1-nathan@kernel.org>
In-Reply-To: <20220411164308.2491139-1-nathan@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-11T16:47:54Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=63ce5d67-481a-420f-b892-7b62b562b785;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-11T16:48:47Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: d21c83d7-02b8-4f03-98f1-920e432ec727
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 297663e0-a945-4adb-c811-08da1bdb2732
x-ms-traffictypediagnostic: DM5PR12MB1803:EE_
x-microsoft-antispam-prvs: <DM5PR12MB1803CE867CD26161BDDD9773F7EA9@DM5PR12MB1803.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ECA0Yb8jC435D0jJxWEuqMBS3SsWvKOdML8RdItl3JO6DwoJKJ8/ySVruJiVRRQHcvpTVfVjqhKdU48QVBLG0/tlmEpXr5NCwwBSYkWpJYbTZ9pKB1N9dv61xrUo76iJ80T53uB95+RazXPF7auFsOrycgZYZ8y699F1SwDvhxOIHBAcD/z/iNgfe6TCNNBdWvDpiahKqfXcBmuNWH5qsJyaCZi4CCFtTqFFl+vl6X/eX8JKKAZhE+OzGM4NX0gtpDENzJItvHip/j3TE68OGPggiTtuo4iCUbJx5pkZ1Kd5Ed2J4jzhlsuyAlnTgK90wzbly+tC+8tUGJZFMVzIldlBN9PqdrfkmdfVPo1l5wnAURmtpycfclCnY9wS3RD/LWnbX8X5a8/rnSd1nUtnHPFg9vbH3TZ1NnudEExIbGKHq4A+KEpCxCvxnEEv2Sa7RNSP1hMsbv108ta+TF/y5sxH1hlPdCUTV+SRTdcOIDh3qD1kye0dGNWUwYjq9UeqdbLVM+Ny4HJ2DSnP2wZ72r7GjrKkxy+oKD7ltnILZ3tazj0UDQErkKRfinkrE1xGN/mSyGfgooQRn7aQ2qu13B8k7Q1rmP2KEEHNOl6VCtATmQYbbBFJ9QkJ2Y4iP8EbPNCjliDyPQ85UQovlRiFrpU5tfsdtcm+9TlgDWZP1r6zF4g8Bw/gZy6bKiyC31HtUM3tOVH9vTBdjedd1K/Dyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(9686003)(53546011)(7696005)(5660300002)(66946007)(64756008)(8676002)(66446008)(66556008)(71200400001)(8936002)(66476007)(26005)(4326008)(186003)(2906002)(83380400001)(6506007)(52536014)(110136005)(76116006)(508600001)(54906003)(316002)(38070700005)(38100700002)(122000001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kMWIDulYAIz9kHXIU/CljfpCLf3Hr96QbkgBbM7Cu6Ml0UlWeryEKeFdub+S?=
 =?us-ascii?Q?jP1XqN6f1I6F93vHGi4H/LvLKatW1cxr1eWJTcg2jCG1MOAUjvcDby2PBNWm?=
 =?us-ascii?Q?mzfCcim6pZ6lOrEpS5X4whPnEsZHlH9ipW2J+TFcg7SpmakgfGDnZfYtbk4S?=
 =?us-ascii?Q?Hgy9tePxNH++mprfLimjDTcqKeaEwvG8WNZkF97pztLm/AegCt53pVUachD1?=
 =?us-ascii?Q?Bou3IW0Is1he7xXSlTLI7DIDGQPTr087pzkRCH4nGzR9LbT2wDuINulniCK2?=
 =?us-ascii?Q?VrRbp33VxklzXFCDyZXlvyM8e5xPAT+N03rEkITxuewQ7xuygVRHAXF1Divb?=
 =?us-ascii?Q?cqlch06XW7kG2vmsDb3hPeeDtSP8tw4Ot4MbInkz4zzxUp/2xwSyEa299o2Q?=
 =?us-ascii?Q?A02mdRCtZ2sB2Hm43eP/vJrs+CJ6NuyaauLdbIjNVMPDn8KguY6GieyN3dVP?=
 =?us-ascii?Q?chqyiL5BT1dtNZCcqLPMgbLSaRRt9vDjnLzcg4J1Ydu0RJOIWYpDKwv/Q8l+?=
 =?us-ascii?Q?hpSj/sHElG8e2R5weyFJowTC6UEpQQLon3a4MZBj/q4xW747b2OMvTXFtYrA?=
 =?us-ascii?Q?fVWxZ6UNLuDXta3VUx0/6jnHhHf2pD3s9w12DJC/ZUN4pVc1wFKmR3IjTGrx?=
 =?us-ascii?Q?OYir9lM00c+bWgU0lA2/GVRvId6yr67ys5hyvHHTXjanfVY1o4krWgigUmhy?=
 =?us-ascii?Q?Oi7nJlbMt4kAKm9NzJ3+kOfG9xAA+yxDU2mwGq01MqHGAlYMWSnGvA/CS8y1?=
 =?us-ascii?Q?pNvFdU30W/tVHc9WbyZw7A+mZx47anv1LzBgEweukugkCbaEXtBNFQ3CJ8FX?=
 =?us-ascii?Q?b53tVWwFV2ULJ6D7BCc5XNf5RIYdKHg3L9dkYFZwzwdLDvt3d/xlOdbxqq4i?=
 =?us-ascii?Q?nRRS49cvkBd0fAD9eL9cY20DWlalM1U3/VR550/KgeFA3qWHh04HEpKckxrd?=
 =?us-ascii?Q?3c/Dq2OHZJk6Lzm9qyXmzHllLN7wVizZrG3g+iw0h+x0PwFFk6OQVTR8FZPY?=
 =?us-ascii?Q?/l/2N3RLaLrifq9ss0n3xnUIuYrANAMpDp2cW/ifXsygDBtog10VvHiISv2/?=
 =?us-ascii?Q?60jY6Db+TqU7N7Uax7weuIhBYlzAn+Qz+jVqTOsPzfQAs2ZrcBzqx07S5RE/?=
 =?us-ascii?Q?zhQLJKiJvbvQkC8o3axArqVaG/gQMVRhlYYk577BfSO8DYfdLkF/7JrF5hpb?=
 =?us-ascii?Q?vvSmxiYIH+LR94HPZz+VaAxjoMiXWWoeDNYap4vlp/2G3bj+y4EVd3qKDGxm?=
 =?us-ascii?Q?V6OgqEbsf8DspcF5UNgntr8RMHaVFqPJLAfToNHT+AZZhRRj2vi3fE9doGTE?=
 =?us-ascii?Q?o1Dd05ahZj2BCOxzGoJsypYAecBy29VDMY9zp2jk/QsVHGHPCOaa2cSR68YM?=
 =?us-ascii?Q?Hk0lMXnHbx8WrO4NDgtO09pvRuz478N9tjzAP4dJX+jkVIHT1IC24Ww91XZT?=
 =?us-ascii?Q?jSc7GnzaEuSXjt9lcSAEpSmq9TPq8dECIKSyhdtlMC67XI4KCn/l6PzjcKtL?=
 =?us-ascii?Q?TmrXSRaRlnLEqIvbRWD6/f1SAhq8JjtjaVArMC6pYBJBzIo5FH10yVccjouB?=
 =?us-ascii?Q?Dxc0+0CEGSOu5nUlEWnj9NUXIjhiZAWbI2Bthrw85TVpJsEMWkZjpbbSV5QQ?=
 =?us-ascii?Q?8rKZYQADN+LTNrNleZS6q8+YdFtfbPWVhawAucd+ZR9+72vMIqHfQdZFzra/?=
 =?us-ascii?Q?g3WRqnh3EXWgUMWAKLogvH+ZPUKZlAQEeYCaeOgfdTVfoc+HtKOvcO/A/FJE?=
 =?us-ascii?Q?Zur5eLcpig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 297663e0-a945-4adb-c811-08da1bdb2732
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 16:48:49.4836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a1xkAsVSNpubjtiWX2ZkpNdtZWwuI6QpgNv+DOLvsaHCZb3eFUiU2rMbfJJA2TeP+DOeNDkc4Vi0OxKSU8uJ8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Nathan Chancellor <nathan@kernel.org>
> Sent: Monday, April 11, 2022 12:43 PM
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Sasha Levin
> <sashal@kernel.org>
> Cc: Kuehling, Felix <Felix.Kuehling@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Nick Desaulniers
> <ndesaulniers@google.com>; amd-gfx@lists.freedesktop.org;
> llvm@lists.linux.dev; stable@vger.kernel.org; Nathan Chancellor
> <nathan@kernel.org>
> Subject: [PATCH 5.4 0/2] Fix two instances of -Wstrict-prototypes in drm/=
amd
>=20
> Hi everyone,
>=20
> These two patches resolve two instances of -Wstrict-prototypes with newer
> versions of clang that are present in 5.4. The main Makefile makes this a=
 hard
> error.
>=20
> The first patch is upstream commit 63617d8b125e ("drm/amdkfd: add missing
> void argument to function kgd2kfd_init"), which showed up in 5.5.
>=20
> The second patch has no upstream equivalent, as the code in question was
> removed in commit e392c887df97 ("drm/amdkfd: Use array to probe
> kfd2kgd_calls") upstream, which is part of a larger series that did not l=
ook
> reasonable for stable. I opted to just fix the warning in the same manner=
 as
> the prior patch, which is less risky and accomplishes the same end result=
 of no
> warning.
>=20
> Colin Ian King (1):
>   drm/amdkfd: add missing void argument to function kgd2kfd_init
>=20
> Nathan Chancellor (1):
>   drm/amdkfd: Fix -Wstrict-prototypes from
>     amdgpu_amdkfd_gfx_10_0_get_functions()

Series is:
Acked-by: Alex Deucher <alexander.deucher@amd.com>

>=20
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c | 2 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_module.c            | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
>=20
> base-commit: 2845ff3fd34499603249676495c524a35e795b45
> --
> 2.35.1
