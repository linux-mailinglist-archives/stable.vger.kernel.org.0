Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B266D5056
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 20:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjDCS3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 14:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbjDCS3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 14:29:38 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020023.outbound.protection.outlook.com [52.101.56.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C952D53;
        Mon,  3 Apr 2023 11:29:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIUHYVnlONXufNl9SJi2MgMYLh0eWJO9ExbHBuZYuFLkvTZNGAlnGKy7fbdZ6wUISQoBlr3k4tF9n46W7IjYIojPAaAgFYgvHS9WeXnsTAnwyxEp2DUckHKgsOukipxeONwMndwQnIOkdBOwRgH0E1MwsgsW88XWYSHX3LmMbvIny2tZDC9AzWfMqPgAN5W3HZxUgjHIg72150ZPwg2/VeN2owQVp+h9QqQlR86AtqJYY59aJDyCHeWRSz8qNjem6qaleJyfZ8MIcN1K/kJ/06tNwWtpwe1nA1SPpQcoCgXg3FWnbh2yJN/2Js2c06mqKRnVdt/aRrCZv27DR8oCqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FoZa9LTrAuCPzmJPPCh3RcR7qUnWsdp1DMUzTWj/3I=;
 b=QwmH/c0hpC2vfEtHA8UEuOIFfL8DXb4v/EQGlcjguTwHFtxGrEiq4mTYuEpOHpbwajx/DWDY6dhuCf70vxL94vQy8gb/6ccKV34gR1TW5nj9bNTM82XFngM5Bd+ePolTqt6boBABYxUxrjlIBz/l2F7ioKcFU85tMTNdtSCAQF0l/Kp9BS4B31WFj/eRH24xO+X321H0fBTwVTKrXzCu1E5sO5y29aUyPPK4l1aCn5JfX8QeojgNbr/YIIHzcWNGCGZCzOduJxYp/GoRfBehxgXI0lXyoXWWZ75Zgi4a0ITAhJXR/2w2m3OKlROQFuXVVCP1r6xwLx2cb2Lg+eK0+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FoZa9LTrAuCPzmJPPCh3RcR7qUnWsdp1DMUzTWj/3I=;
 b=CJE3grK60GDvvSt04YBEPEvWcpX+5MPF6TxwBCT/D8AJY2bUjCKh5LckDgsSllFFeFsXTdRbWFPjLxY3pPy1fTuZiyTJOPoi+DLBOiOUjMnothBtxXBpwI4xF0U25iNuySDjdDSbCSgMJLWzIhiJdkad6Gt14J9mAk/R4LlD4Mk=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by SJ1PR21MB3432.namprd21.prod.outlook.com (2603:10b6:a03:454::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.8; Mon, 3 Apr
 2023 18:29:24 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6298.009; Mon, 3 Apr 2023
 18:29:24 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jose Teuttli Carranco <josete@microsoft.com>
CC:     Boqun Feng <boqun.feng@gmail.com>,
        "quic_jhugo@quicinc.com" <quic_jhugo@quicinc.com>,
        "quic_carlv@quicinc.com" <quic_carlv@quicinc.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Thread-Topic: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Thread-Index: AQHZYrMXe0Y6kEKNA0yWUzOcmG4VZq8SosvwgAbyUwCAAFlhoA==
Date:   Mon, 3 Apr 2023 18:29:23 +0000
Message-ID: <SA1PR21MB13359EE68C74282FD9B75168BF929@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20221027205256.17678-1-decui@microsoft.com>
 <ZCTsPFb7dBj2IZmo@boqun-archlinux> <ZCT6JEK/yGpKHVLn@boqun-archlinux>
 <SA1PR21MB13354973735A5E727F94A169BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
 <2023040305-evaluator-come-fcb8@gregkh>
In-Reply-To: <2023040305-evaluator-come-fcb8@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9705706b-0836-48ff-b1e8-5bedc0c02d01;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-03T18:27:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|SJ1PR21MB3432:EE_
x-ms-office365-filtering-correlation-id: 425af6a5-c005-4c25-cc4d-08db3471597f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tWqfyJQLoKGpbrU+W7pXK8q2uKzodMOOkTjY9hSB0BpzeThs3VFBgffE3vnspUDd5eD0AasAyMlKhcdBCFM0YEQW+8xn+0gSLHYgGh1SrR87yFBYA1s0YME7RXQLuobTcb08iGGHRML2EgfjOh+pICm9VlPCXO13RWrEdZzgm1AY9ZCprqK7YQccfGaipG/ctoK3ene9QKkLLfWFvzQ3RhZ9Mod2Vi73btUOY2XSbw53H9XP231GPepBXhniLM3IqYZWgUgx9TwoKD+EmFGTLv7j/331x8lRYtF0wsTAte5EJpYulc3Hz2MmwFLtXyzo/PgSE1cdbHz59ka/zPjCnchI2NCKRY7cRRsSAsOfQZxUDZjYakCiCsGeBpGqgZ69M2ndKWAdtcd/i+YUMnnQD67EIQcjSfhWh2fjg9SPjxS2R2pIWm3hlp/fkXfESmeg8IFQP5TbludtnHxeJC0JqxIjJh4HYNC7UF5ytjRSivH2th+kfh0VTp++irwjThaPACxMD20PUzUfsmSiql1/skSDnk0LwYGfw9JLwWVUKdzu211cFtM9c/SZZ2rkKdvpVZ1eOhMjnadoGyGLrXyfgsQjfhLEUYTiiuRAFugwT4O0DaZRRpqQd1rmgZ8/uumNYCqkaGKyjMelWZJq+ytXy1JMZkmuVp8Z6PysYqKXw34=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199021)(86362001)(33656002)(38070700005)(10290500003)(316002)(76116006)(41300700001)(66476007)(786003)(66946007)(66556008)(66446008)(7696005)(110136005)(71200400001)(6636002)(4326008)(64756008)(54906003)(8990500004)(8936002)(55016003)(5660300002)(7416002)(2906002)(52536014)(8676002)(38100700002)(478600001)(53546011)(122000001)(186003)(82960400001)(82950400001)(9686003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nqY68ObieQGn4TKuQ92Uut6vy2Aiu++cTIta5teiqBRtcitdi2+orkhUhfoI?=
 =?us-ascii?Q?r3/Uvcs6Le2a5BsahD7m0J5XaYFACueZAhzdW2VqHKXDefPfYFc2EALaGLY0?=
 =?us-ascii?Q?zCUW0E8eMPIpSlJiPqYvGDfdzPK7C6L1z7Am5H0W7/HuSfjmYXlPo8MMvK5I?=
 =?us-ascii?Q?FQoGlsE6VFd2iUVtrjaufl2fnueacfCrJCm8jQ5aJlMBQSQHUay/PLW9BBWY?=
 =?us-ascii?Q?sotjEQZQeOl0m/g/Eix8m6FtiqZXGFb2oKXawxHXwxtQzd5eovARGUasmDtH?=
 =?us-ascii?Q?HDHY4w2ngHXjflhY33UBx1K/5uTLnzaCOBZ8T6HtIbAbEp2XtMtKSzjjqKjj?=
 =?us-ascii?Q?JCSvsK4kLwrtIzmaN7K94RI97xIhLS202Ifdavzsyh+c8hcGCAmQ5n+tDgPM?=
 =?us-ascii?Q?QW1nVQ9qiZ14gBLoZSPowyUCf7OPBS57+tYjiP8Lw+F07rrhuiyTKHJ2TISA?=
 =?us-ascii?Q?xtYHVUKkFrSzsEcmTMEvA4hrhvB8L/MifX4sD5xSvgThj2ntwm1sPjc9f8Bj?=
 =?us-ascii?Q?/LEQ64DOZvCDjcy/u2CfJ2NblugQUjIMMJE8pSXdKVHfg0vE95tevWhmkMVy?=
 =?us-ascii?Q?C7DreU6tZJSNAdsPYH+Q+pNdUOQz4003wMCoxa6EnNfM+QxWhdnmuXrvVt+O?=
 =?us-ascii?Q?JqXrutac9Er4o5t9u0/8TE1I0aYV0sKnAAjzHSn4EmnRmD4SkexZ+qdxJC6t?=
 =?us-ascii?Q?y4iJFDkc/HdysVRxL69hhAzKhfs1BBlvcslo8BVj8zkGnfuMODEz97djwhOv?=
 =?us-ascii?Q?ASmSLHTY+bSWqOaaVYOv9nZlDvoMRaPKjuBO+sG1yvpUsBbJRQLoapd40kBL?=
 =?us-ascii?Q?evJH2/1yWap5wPGTu50jmoqta7NJo9NE7zcZa4XBy+oxuJkpuXIPVM+JYNHB?=
 =?us-ascii?Q?fTLzjNEAnliX8lYAPoiQ6Leuo9sbVGzXeVIT6G6Q6lUeQgkoRkf8jHwIQHhx?=
 =?us-ascii?Q?rtSsbgrc+UKF4Mtr7snBZ+Zf9P3I6UOI7wEh4+hXJc+pzZMUxmOVUItto1mN?=
 =?us-ascii?Q?vPZ8IMdQLt0EqB4CKIdaebnlTgTyxknzwVz5uSHYrgGcXF9Hl/5KCiWOtFfp?=
 =?us-ascii?Q?htNjSOtrIV9XR6qSR4ktjvTUOV9y+HFDZh3gpyEBmVlMTNaSsFav0O+JUxVl?=
 =?us-ascii?Q?2TENb4jqT1jFDCGZTfz92+foPSAa90uutIwTz+HWBKIUqcivILsdlIMtQSf/?=
 =?us-ascii?Q?CQOEYYo0rcs6rbPVrDU6RY2DDegFW8i76226ifW5AfhDOPiBjCSUabFuh2G/?=
 =?us-ascii?Q?QxWjWP5/+tLSMH0JtQL5EK6BboVBKwU/tnVxw8XltAO35amUqMH9fn3IepG3?=
 =?us-ascii?Q?TR86t9/e2+wDEzu2CsUUm3m30zOZekEd4YNagFgZ3sqdARiX2ifOQIV1MlrM?=
 =?us-ascii?Q?DViA0XB9er6P7XOrVpm4/UTBsh/Js6vDc70WG6GmaneRdMAVChs1qqP5TBi/?=
 =?us-ascii?Q?i40Ki39i7B7JVoCEpJ6RAFGp26LMm/mNFZYaYIMqVssOJEADlcOCEqQH/e8J?=
 =?us-ascii?Q?ikDirANTUogvkzkUh5AGK8hAPVhYvP4XCtd77egZp6kzEqyPPX+yltimO8gT?=
 =?us-ascii?Q?Fj4EUlj45NsHlox1q8e4QyAK7NDDWNxJF0bE8Qxx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 425af6a5-c005-4c25-cc4d-08db3471597f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 18:29:24.0084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFG8430PYnE1inwTCyErVo/Akbd2S/UrhyLEOuV/BnEbqPeTNaoHMOIOz/yC70duC6CjTz9BaPk71O460gvgcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3432
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, April 3, 2023 6:08 AM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>; quic_jhugo@quicinc.com;
> quic_carlv@quicinc.com; wei.liu@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> sthemmin@microsoft.com; lpieralisi@kernel.org; bhelgaas@google.com;
> linux-hyperv@vger.kernel.org; linux-pci@vger.kernel.org;
> linux-kernel@vger.kernel.org; Michael Kelley (LINUX)
> <mikelley@microsoft.com>; robh@kernel.org; kw@linux.com;
> helgaas@kernel.org; alex.williamson@redhat.com; stable@vger.kernel.org;
> Sasha Levin <sashal@kernel.org>
> Subject: Re: [PATCH v2] PCI: hv: Fix the definition of vector in
> hv_compose_msi_msg()
>=20
> On Thu, Mar 30, 2023 at 03:23:45AM +0000, Dexuan Cui wrote:
> > > From: Boqun Feng <boqun.feng@gmail.com>
> > > Sent: Wednesday, March 29, 2023 7:56 PM
> > > To: Dexuan Cui <decui@microsoft.com>
> > >  ...
> > > On Wed, Mar 29, 2023 at 06:56:12PM -0700, Boqun Feng wrote:
> > > > [Cc stable]
> > > >
> > > > On Thu, Oct 27, 2022 at 01:52:56PM -0700, Dexuan Cui wrote:
> > > > > The local variable 'vector' must be u32 rather than u8: see the
> > > > > struct hv_msi_desc3.
> > > > >
> > > > > 'vector_count' should be u16 rather than u8: see struct hv_msi_de=
sc,
> > > > > hv_msi_desc2 and hv_msi_desc3.
> > > > >
> > > >
> > > > Dexuan, I think this patch should only be in 5.15, because...
> > > >
> > >
> > > Sorry, I meant:
> > >
> > > "this patch should also be backported in 5.15"
> > >
> > > Regards,
> > > Boqun
> > >
> > > > > Fixes: a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MS=
I")
> > > >
> > > > ^^^ this commit is already in 5.15.y (commit id 92dcb50f7f09).
> > > >
> > > > Upstream id e70af8d040d2b7904dca93d942ba23fb722e21b1
> > > > Cc: <stable@vger.kernel.org> # 5.15.x
> >
> > The faulty commit a2bad844a67b ("PCI: hv: Fix interrupt mapping for
> multi-MSI")
> > is in all the stable branches, even including 4.14.y, so yes, the commi=
t
> > e70af8d040d2 ("PCI: hv: Fix the definition of vector in
> hv_compose_msi_msg()")
> > should be backported to all the stable branches as well, including
> > v5.15.y, v5.10.y, v5.4.y, v4.19.y, v4.14.y.
> >
> > e70af8d040d2 has a Fixes tag. Not sure why it's not automatically
> backported.
>=20
> Also, the most obvious reason, it does NOT apply there!  If this needs
> to go to 5.15.y and older, please send working backports of it.
>=20
> thanks,
>=20
> greg k-h

I also found that we need to manually rebase the patch for 5.15.y
and older. +Jose, who will help to do the backport.
