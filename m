Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7725EAC0F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbiIZQHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiIZQGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:06:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1589427FE4;
        Mon, 26 Sep 2022 07:54:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcJse8WmJj//e+L/5WVII1vZqXNTmZaWPD8ma4kIJu04GWK6X8hETdby6kBJW4rlpuQqNWUyxtdilivOHMrfXoqsVbLoJeG76YaYT/DOFEHPqVauBXtKEysO+Y4A6RPwAU0K8pAE7se8IuSdmzuX1QCbiM2ObrcU2zUHfkv/vWozyKK4yy6Fhf3flPadw62FMG1MbIMuVIyAburlPn46s//z9Md8BjZLK0jlUvJ4T003f+CU7Ty9k/8aTxRsnBeS1LOEKJnXqiajJN8e7zyTIU7wuvHgpKSG23UGNzsYL57wVtpRwN1vePiJhB5EupzK/iGuiduWn8iMFDTxfS047Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwzLcL7aeBlAmT/+aRIGsOs6z0wzn8089fWlvsR5m4I=;
 b=kGRGMJg1Bd3m7/FSYFa4pj9AoZbAofLTPBxKsyb8wdtguE6FDXS5jz96h+xdSzhtIjX/MISE3hvlwv/7Pp5mfZbf8z8XfRBxlcD5KZDG/s7jMHiysKBcG0191VoEqhFhf6o4/gUItpQlWTJ1fgJm05rVqcPeQqE5gQX/bbXFFp+8QYsVDpXzs2pjowkp9dNDl2wJLqN8nnf/GZ/nNUETw/ArT3UAeyMTPBavTzDbyBD4E1xHOA8AGIELh6bzxXX/wBWx3uJnHCcjPBS8XS9CN3VZVlTOxXCwaH+Y+opzoSlISUAZOySbYipmBYRcoNTJBYu7xTlSEbL3tyTOyGJHTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwzLcL7aeBlAmT/+aRIGsOs6z0wzn8089fWlvsR5m4I=;
 b=C7fhelfmSnx2sZmvkHwXVMwlAKs1Up6kdUI8JjIffS6Hdxe7BFnS/0GLdZb4EV4hAkfNk8oLNYpR155Dh7MWitnTmWI//95IEdrjHxSSU46cuwt/pIXfTJEXfc1HU5UQqpqKvcH7fnklFZZAiVlkgC22ES2VtG527A1+DVWqnWw=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY5PR12MB6132.namprd12.prod.outlook.com (2603:10b6:930:24::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 14:54:22 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%8]) with mapi id 15.20.5654.024; Mon, 26 Sep 2022
 14:54:22 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
CC:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "Mehta, Sanju" <Sanju.Mehta@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] thunderbolt: Explicitly enable lane adapter hotplug
 events at startup
Thread-Topic: [PATCH v4] thunderbolt: Explicitly enable lane adapter hotplug
 events at startup
Thread-Index: AQHY0bUDKlmjkRBJPEaSAJ70Iqdn/K3xzAaAgAAACpA=
Date:   Mon, 26 Sep 2022 14:54:22 +0000
Message-ID: <MN0PR12MB61015D287945A57D82910CE4E2529@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220926143351.11483-1-mario.limonciello@amd.com>
 <YzG84WEuVdXxclJB@black.fi.intel.com>
In-Reply-To: <YzG84WEuVdXxclJB@black.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-09-26T14:53:30Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=5a8edbf4-4dae-49d7-982e-14ba0f27329c;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-09-26T14:54:21Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 2a683e03-a707-4dfe-8fc9-61ab7b06b03d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|CY5PR12MB6132:EE_
x-ms-office365-filtering-correlation-id: a2461e9a-c17d-49ac-625e-08da9fceff8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Up+v9urfmHnpJMm10TvEVyL8C/dIyAH4TAptzlDX5h5TAkcwd0Vc7sDZYLu5C6aHfzHpLYFgXiXAG+50UvPsSlcZfwAbMf37EJqphmfnJu9vyCvh7N0Wg5fl3gh3ky3aWGjHnV45XuaTHU6bbNNbobwsBgzqYTHKDXf2gfDTYnS1wcB8t7FcTyM6Eelu5ohPWhcUovPh06W+vU7tQv4/QRv9JPN6P/0RHOZWsg1DYMwCvyIy3YaTUAa1wNHh8rTKUCRAAQ3RzXTjj9AcP2jUhj8LsMhOImvD1xEG3XzykwBXTMDDWsCJuqMekWZ3kVnN8TdiuqEun7SEXLR7MHEGXUoxWmILPfLNpj5+965p5bdXrt/KFaqKRhBFEjW2lrK54phpyj7AT1rX9Lq/2EYAYYQ3OtKX/z2PTdo4UQTiiE/6qw8DXuj78XhHOiuWTFwNNv218jIBPnq9CcQ3kVGs69mxc2Y8JTn/1ZnDPbMyim6RXqfwCQnZx473XpGp9yX1MSlSiH6kQZeSV0cf0bs1bzY+m7nMOO440mBKnDKBUQ6idLzis+cHPbscV4HJhiP8zm9fatz18CqI5RVV6KEw+aiuSgD6yZZzrtD309wNWnlWVvK8BMr8MPtnaFRJ6FxtYxNGYVCXpUoE/NvQDGb0VkVmq9A8jKluvU92GiY6e7kjdOl5z2JTwvyxN6qxKFRBaOhp9J+wMwMQ5U0DRv59KmJ3v/MoL9vT+J+pJTkH83LdDbvNW8Fvw2xGpMprKeY/1S1XggI5psGxOnK+o5vFHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199015)(2906002)(66446008)(64756008)(8676002)(66556008)(76116006)(52536014)(8936002)(66946007)(122000001)(4326008)(5660300002)(38070700005)(33656002)(38100700002)(86362001)(66476007)(9686003)(7696005)(6916009)(53546011)(26005)(186003)(54906003)(41300700001)(478600001)(71200400001)(6506007)(316002)(55016003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LZNuJppF3u4jNGt8FihQJZx49c+wqX/HUfta5JDyO0EqnTapWTnmkUnVo/CK?=
 =?us-ascii?Q?23g4qQjTXrbvPrGKH41sc3VTGTVoubqGxWElJ4dfWgg20hx0z+B+MMK+ByrN?=
 =?us-ascii?Q?dishgLMsGZmtuAbFH9uOGO2d5uHMBAi0PLH/3yH8oIevjI87PAUFUYNbCCVZ?=
 =?us-ascii?Q?RAq8ZeQT6kXfs0giVsyoiVvE9qhOU764EW+SFLRYeEmmdp3EWDtCeBVBjHHm?=
 =?us-ascii?Q?RlqE5PoCj2rTgGi/o1ORvMUQcH6WpMQxX5TwywqdcRJ47i0B45I13ln4dTaG?=
 =?us-ascii?Q?o4pznuTCbZx+or6IAXXCpgkOeRDDx5ujznr5QWIfpx3rX4OVkjGmNCp1Hz0d?=
 =?us-ascii?Q?/IFrv8/sxnjDoT4VbzmSFprf0p6cgOqpp3s71jw/WGMPoda3aXiMg3dDe24T?=
 =?us-ascii?Q?JKnlv+x+9C0vbb2vitxK+Ot1Uug+nxfGMe55b4INqakD9LeUV1len69aHM3v?=
 =?us-ascii?Q?n3WdLKl71uPpd/Z9fTpvm5yYacgPLY1YuBcEHg0iwysdhj7cPDXOCwR67+1T?=
 =?us-ascii?Q?YiP5KF4FfqAkoemSpH5DyXvKYN9seIpnxG+3Fg5Cg0AxvMQqZnvINOdYIFtj?=
 =?us-ascii?Q?ZoGAz9wHZmCJrrgSz6e2Ko39jMY84A1c4Pg39rIXsBR/2/92+IEBIT5DhK0u?=
 =?us-ascii?Q?FgeD+tYtXfzJengN8ribuzBoA3Vcx7++kjDkMSRAJ5Xu7WOhbTlgC1zx9yXT?=
 =?us-ascii?Q?2PxTBnocFOc8RZ0xh5///GlMnzzQM7mIWt2KjYqj42z0tN8dbnV3pTXQK3Kt?=
 =?us-ascii?Q?k/8Qz8+eS5ICyXKrbSf6E62xFfN7O704Kh1NsM9kQ+7wUNnhh4qH5tdyju30?=
 =?us-ascii?Q?0wUTPhcXBBGAqcmZFtZu4pIxai7ac/E6o8RpaR7GYbBeI3nFM8gqsLvWHBJm?=
 =?us-ascii?Q?ajm9iNSQRQjIxgcqDeZTkmHH24NZjF1mRZoNkogK2Hd4aQYYmhbY/XVjpySQ?=
 =?us-ascii?Q?HG3Q4cYsUXR1E1JdnQpfrl0NENQ56gq5Kuab2/SU6C3Lokc9tw7rTymzAnsf?=
 =?us-ascii?Q?dLheHFLknugpA2BGArtuZcYOd4UP7PKlC0qrGKFo8B9CQzODWxZRZS18Eoel?=
 =?us-ascii?Q?sDnysVdcyKwbNz20uRMiO2KK8ODlzl01oRglC0QK1BN3R6bsyDrJEgu2cONR?=
 =?us-ascii?Q?cH0qfofuFASqbuL/ofPT0KR2EuE1nK4IlyqWvMrxOiDdohhPGvjGci5skv9j?=
 =?us-ascii?Q?Fnq3bNBreHWtavTpLfzQ+opQZgIeJV7xjRTEt6zOOas148BSNxJ1fAr9Zgi2?=
 =?us-ascii?Q?kmLkD7GtKYddeHeslTuJnup9oFUkswqSPQ2NGjb4yZMQVeKfuqcpG5ZogzTu?=
 =?us-ascii?Q?LCBpOGXdjLhIpbwXAT0o28geIX1weY/Vpffkq+Cl2aR9cckBlqCaKb/60vp5?=
 =?us-ascii?Q?YS90PXmkADZx0empd6OPdRKmVv9BAXsYgtFyOb1mh4UzsL+8v3eGgWxbLzdd?=
 =?us-ascii?Q?pFyu6mDYVizEkYhv4dghYIYBvjUHnJmDI4+T67/Y5IOn3nNWP7g8zS66+WBm?=
 =?us-ascii?Q?7MP1wyJknCEIxk6UIqXPHOHybRZJF0uySvrXMQD0xP5gvZb58h4vXLfWbZzI?=
 =?us-ascii?Q?Xna8NgHz3LvYHiocYqA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2461e9a-c17d-49ac-625e-08da9fceff8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 14:54:22.5528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9xNQAs/gBbq7i/IQsUKO85Q+gNsztLKiJaIyXW9yypebDRYB8fCy8Nn5eXW0tm3+h0Q3WRObV/8Gcf4sYK7fGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6132
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> Sent: Monday, September 26, 2022 09:53
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: Andreas Noever <andreas.noever@gmail.com>; Michael Jamet
> <michael.jamet@intel.com>; Yehezkel Bernat <YehezkelShB@gmail.com>;
> Mehta, Sanju <Sanju.Mehta@amd.com>; stable@vger.kernel.org; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v4] thunderbolt: Explicitly enable lane adapter hotpl=
ug
> events at startup
>=20
> Hi Mario,
>=20
> On Mon, Sep 26, 2022 at 09:33:50AM -0500, Mario Limonciello wrote:
> > Software that has run before the USB4 CM in Linux runs may have disable=
d
> > hotplug events for a given lane adapter.
> >
> > Other CMs such as that one distributed with Windows 11 will enable
> hotplug
> > events. Do the same thing in the Linux CM which fixes hotplug events on
> > "AMD Pink Sardine".
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>=20
> Looks good to me now. Since we are pretty late in the rc and this is not
> trivial fix anymore, would it be OK for you if I apply this to my next
> branch with stable tag? Then it gets slightly more exposure before it
> ends up in any of the stable trees.

Yeah that's fine by me, thanks!
