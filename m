Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEF181435F3
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 04:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgAUDgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 22:36:15 -0500
Received: from mail-eopbgr1310107.outbound.protection.outlook.com ([40.107.131.107]:56832
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbgAUDgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jan 2020 22:36:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIIFu24Iv30EMcFuDpgrsyIE7mWSQ368vM0T/sD25ffJetRSaWbioIjNP5zSDRfoWffk+GeEDwlXGlRI9rF/eKEu6IHJXOdUkVoQXyGzS1AsD0ULLLmzUal0c8jTHklzpZ5qVwDy+iT75Lx1YTiYO4Bo2INPKag/4iWmQvjmfodw6mM1gOM9oRK1k13nc1bU8LnrPrTqG1rzBjeg2Hu/cYRco15/yWpJ+23NKz1sj4sUKw4eFTR8KHc13psOxr4mnSqmxwLq9h9T0BXR7jFRms0WcZKV3sJCpGZBCRFUoXK+MxLtTJmNEFa0d/R+XboZ0jRAViVl+OWdI4kuQbP0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TP/3mk/bODhY852DjyVOYytCk3cirB3Sv/bKv3+OEKk=;
 b=mSCNcDQzG8sSIeoBdy4k4UHAAsFTXfzbNB6S0Ajfh7hIV5UkFUSO3x0MzeW75dEa9zdmtK9/JdGWTPbiwE2ErLPnfSqInNWQ5G1dZNjlzCguRTSN0gLr98YWxo9SxtiPOQY0zZsEKxiLrc6QY5Vkmbxg/5RLxNP2eBxt/m37ciZ/0AVPDsKWaXVGBCAAVhoC9dN9aF6nei/h5+QBZpKpIq9RjTH0HNE8MYHQkl4anMskygrmtd5GHhNl5Z/0fzZNs4ihPLe0rpU3MmwBzxjKA3Uluko3zuiFwDJpFdwHSiueE6xE3e42EtfEJFrxnH7D/TtwyIbfCnkuBhOrqRiEdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TP/3mk/bODhY852DjyVOYytCk3cirB3Sv/bKv3+OEKk=;
 b=InFmM+1CACyHyaRcne7GytW2e6cfpqYxY+Vn1jtLh6PsMQN64HjTz+t7EoItaBQPSsUTe8rMJBsqOsIb0aHbtFllIfOqsF+JLdjwsv8AWrZi7wiRZE+AXhWQiTQ/EhjY0yg3i2zTKqifLJjrmW55IXGQ/OMgpqEPb7GceqMl9po=
Received: from SG2P153MB0349.APCP153.PROD.OUTLOOK.COM (52.132.233.84) by
 SG2P153MB0320.APCP153.PROD.OUTLOOK.COM (52.132.232.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.7; Tue, 21 Jan 2020 03:36:06 +0000
Received: from SG2P153MB0349.APCP153.PROD.OUTLOOK.COM
 ([fe80::e8e6:3ff5:1354:c16c]) by SG2P153MB0349.APCP153.PROD.OUTLOOK.COM
 ([fe80::e8e6:3ff5:1354:c16c%4]) with mapi id 15.20.2686.008; Tue, 21 Jan 2020
 03:36:06 +0000
From:   Tianyu Lan <Tianyu.Lan@microsoft.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V3] x86/Hyper-V: Balloon up according to request page
 number
Thread-Topic: [PATCH V3] x86/Hyper-V: Balloon up according to request page
 number
Thread-Index: AQHVz9cTzM+cFKZdRE2yL0gSmnrbEKf0d83g
Date:   Tue, 21 Jan 2020 03:36:05 +0000
Message-ID: <SG2P153MB034973B6258618608EBA371F920D0@SG2P153MB0349.APCP153.PROD.OUTLOOK.COM>
References: <20200120084149.4791-1-Tianyu.Lan@microsoft.com>
 <MW2PR2101MB10529ECBC84A6BA130FB9134D7320@MW2PR2101MB1052.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB10529ECBC84A6BA130FB9134D7320@MW2PR2101MB1052.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-20T21:17:47.6293435Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9b695f0e-65e6-4cff-8fef-9ee6a6ee20b4;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tianyu.Lan@microsoft.com; 
x-originating-ip: [167.220.255.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4514a93f-fda1-4f39-8c8e-08d79e230c6e
x-ms-traffictypediagnostic: SG2P153MB0320:|SG2P153MB0320:|SG2P153MB0320:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SG2P153MB0320546816D0B5BFC1549940920D0@SG2P153MB0320.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(199004)(189003)(52536014)(478600001)(2906002)(76116006)(4326008)(5660300002)(8990500004)(33656002)(10290500003)(8676002)(316002)(26005)(8936002)(54906003)(6506007)(110136005)(7696005)(71200400001)(66946007)(186003)(53546011)(81156014)(81166006)(55016002)(86362001)(9686003)(66476007)(66446008)(66556008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:SG2P153MB0320;H:SG2P153MB0349.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nYWH2GroTWKN+nUMELHBoWsmZ7Rslip+GvmrZdpPnF2ESuVldDfqEJqgUy08DI8faRDe7oVOd/Zaq5JQij0uYpH2z2AUwyiUogRrfAsFQfUKUTttICcrh7wbW30FGuJWeUYWBtjHzttXQ4CT4vPnTGFZWrtR9+f6MTMthZr6ftV0327z/7S53B2qH2vWq24LbBqILatMgzkN0Oo+CpLfshs9qv8b6K5VHfSD30xOaJh6veJNpkmfsk+BaGb5lO6iNZHvw6bN3vYNZI3DSW+iW+fjmbLJqIwUqjiJVRa922vY52hCTZ+OtxmHsiM2PAHHBX0pfrzj49j9PdV7nXLyRhgogYugQ9Beml2aShtdup36a7Ke1fjL42ybcAR8AF9tzRi2LVV4eAGLzk2X7/KPF9VFHw6iggDIQLwr9BpGvfSuGz5umoi8UaS5nSPfNBfA
x-ms-exchange-antispam-messagedata: o8WXlF8QCk5vqn8XkU/sxlzRphCT2UjyInuKytlaYcGlx4A2JZCeMh8Nil6L0mKKp7zO2i0paKeatCFmBv3kpv7pSTDywyiVfOFhw3eVKJU4yo6eNpoVtmntng+KyCnPyWehjF0NqpDNxFp7tEuEnA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4514a93f-fda1-4f39-8c8e-08d79e230c6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 03:36:06.0632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tWEyMLs8Ld0oERAz6gL83IeQbzH+uivGQQyEasL/urcCjSt1nwiAdcZyxSJ/uC8Wws6q5P+OSY5IKk3zTA8DWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2P153MB0320
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Michael Kelley <mikelley@microsoft.com>
> Sent: Tuesday, January 21, 2020 5:18 AM
> To: lantianyu1986@gmail.com; KY Srinivasan <kys@microsoft.com>; Haiyang
> Zhang <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org
> Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>; linux-hyperv@vger.kernel.org;
> linux-kernel@vger.kernel.org; vkuznets <vkuznets@redhat.com>;
> stable@vger.kernel.org
> Subject: RE: [PATCH V3] x86/Hyper-V: Balloon up according to request page
> number
>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com> Sent: Monday, January 20,
> 2020 12:42 AM
> >
> > Current code has assumption that balloon request memory size aligns
> > with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
> > balloon driver receives non-aligned balloon request, it produces
> > warning and balloon up more memory than requested in order to keep 2MB
> alignment.
> > Remove the warning and balloon up memory according to actual requested
> > memory size.
> >
> > Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error
> > of 2MB memory
> > block")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > ---
> > Change since v2:
> >     - Remove check between request page number and alloc_unit
> >     in the alloc_balloon_pages() because it's redundant with
> >     new change.
> >     - Remove the "continue" just follwoing alloc_unit switch
> >      from 2MB to 4K in order to avoid skipping allocated
> >      memory.
> >
> > Change since v1:
> >     - Change logic of switching alloc_unit from 2MB to 4KB
> >     in the balloon_up() to avoid redundant iteration when
> >     handle non-aligned page request.
> >     - Remove 2MB alignment operation and comment in balloon_up()
> > ---
> >  drivers/hv/hv_balloon.c | 17 ++++-------------
> >  1 file changed, 4 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c index
> > 7f3e7ab22d5d..73092a7a3345 100644
> > --- a/drivers/hv/hv_balloon.c
> > +++ b/drivers/hv/hv_balloon.c
> > @@ -1681,10 +1681,7 @@ static unsigned int alloc_balloon_pages(struct
> > hv_dynmem_device *dm,
> >  	unsigned int i, j;
> >  	struct page *pg;
> >
> > -	if (num_pages < alloc_unit)
> > -		return 0;
> > -
> > -	for (i =3D 0; (i * alloc_unit) < num_pages; i++) {
> > +	for (i =3D 0; i < num_pages / alloc_unit; i++) {
> >  		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
> >  			HV_HYP_PAGE_SIZE)
> >  			return i * alloc_unit;
> > @@ -1722,7 +1719,7 @@ static unsigned int alloc_balloon_pages(struct
> > hv_dynmem_device *dm,
> >
> >  	}
> >
> > -	return num_pages;
> > +	return i * alloc_unit;
> >  }
> >
> >  static void balloon_up(union dm_msg_info *msg_info) @@ -1737,9
> > +1734,6 @@ static void balloon_up(union dm_msg_info *msg_info)
> >  	long avail_pages;
> >  	unsigned long floor;
> >
> > -	/* The host balloons pages in 2M granularity. */
> > -	WARN_ON_ONCE(num_pages % PAGES_IN_2M !=3D 0);
> > -
> >  	/*
> >  	 * We will attempt 2M allocations. However, if we fail to
> >  	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
> > @@ -1749,14 +1743,13 @@ static void balloon_up(union dm_msg_info
> *msg_info)
> >  	avail_pages =3D si_mem_available();
> >  	floor =3D compute_balloon_floor();
> >
> > -	/* Refuse to balloon below the floor, keep the 2M granularity. */
> > +	/* Refuse to balloon below the floor. */
> >  	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
> >  		pr_warn("Balloon request will be partially fulfilled. %s\n",
> >  			avail_pages < num_pages ? "Not enough memory." :
> >  			"Balloon floor reached.");
> >
> >  		num_pages =3D avail_pages > floor ? (avail_pages - floor) : 0;
> > -		num_pages -=3D num_pages % PAGES_IN_2M;
> >  	}
> >
> >  	while (!done) {
> > @@ -1770,10 +1763,8 @@ static void balloon_up(union dm_msg_info
> *msg_info)
> >  		num_ballooned =3D alloc_balloon_pages(&dm_device,
> num_pages,
> >  						    bl_resp, alloc_unit);
> >
> > -		if (alloc_unit !=3D 1 && num_ballooned =3D=3D 0) {
> > +		if (alloc_unit !=3D 1 && num_ballooned !=3D num_pages)
> >  			alloc_unit =3D 1;
> > -			continue;
> > -		}
>=20
> I don't think removing the "continue" works either.   Suppose the request=
ed
> size is 1 Mbyte.   With an alloc_unit of 2M, alloc_balloon_pages() will r=
eturn
> zero.  The code above will set alloc_unit to 1, which is correct.  But wi=
thout the
> "continue", the code below will mark "done" as true, and we won't loop ba=
ck
> around to try again with alloc_unit set to 1.
>=20
> I think the original code needs to stay as is.

Yes,  you are right. Will revert the change in the next version. Thanks.

>=20
> Michael
>=20
> >
> >  		if (num_ballooned =3D=3D 0 || num_ballooned =3D=3D num_pages) {
> >  			pr_debug("Ballooned %u out of %u requested
> pages.\n",
> > --
> > 2.14.5

