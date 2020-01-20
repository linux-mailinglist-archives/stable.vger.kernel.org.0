Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AB914248E
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 08:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgATH40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 02:56:26 -0500
Received: from mail-eopbgr1320129.outbound.protection.outlook.com ([40.107.132.129]:4512
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbgATH40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jan 2020 02:56:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZ7/HbQ1piYvztU2SzUcou3AUvaRjIro4D4n8LGGdxPp65xvAReNmkzrSqQ+d6X7BPCm/5Qb489+N92Fsh25Xf3srE4EKsoVkLveZ3xT3Q1zPskN1DCE0DciK4kv1EmJq+7zfgMMYCEDLGEhNOyJeuuYt10PHH+IgcP0zsWOz2opDU/nyUCzvA8n1/+Cdh0aHz2V1r1/3FNiKfUtTaJ4wvDtGG1TWV0lsbAAKBLL0JIalz0TUlAPgbZjTOzNFVm2j0313YuFMYHC8Kb6sVeaYhlUM11Z/gF1rTuK5VHjbqH0zt9J6+OtJsGvEl9+4WPzBkyhuzWz8vLWhkgR/zDtdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCphCZAAiG8enhlYStV+g8AcfrRNWboTXVluCYE87Qc=;
 b=PuomB6zwpJmnwyDAgl1vXicyx35uO2HbfnI5lDmdrKlV8sadt+ELJHTxmEdcFBMzgFVzu73Cbxux0SLNvtIB2+rVoq0Zdme0yaB73Vfv+ap+6bJvwU/nV17UEjlGpo99B8rNTzRUW/vyTCuUvfV3DFBATmtebGHjczc3RT0VXSgIX3oACCGZr03eh5Ph2Mv0z3LL2qAOMAisxZXpSkFk0uQjt5urmIqb5glFcVth8XbpbTAIi+YK2v6XbWZOAbEWak8pIMbVHCfznZcZ5hN+iYj3axJWKINhMvAnyoj6VF2VG1vAkzBhYbTYfM40Os9bvL97mA1YpSOXg/0fm+Cn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCphCZAAiG8enhlYStV+g8AcfrRNWboTXVluCYE87Qc=;
 b=W+yDabe+YAu+8PF6hw+FGeOMD3k6KKJLXe3wiwpSNxDQVypi9Zt0OsY1J5yCkmNLfieMPmkoCmIKU9pEa3cS6Rox+Vk2/J8vQDUf7omsaOoFus4zZsNZFqPiuzDCiEefFjtrNyWmvaDBORnVFq4RxofgHRv0Bh1ABBa6G6UnI0E=
Received: from SG2P153MB0349.APCP153.PROD.OUTLOOK.COM (52.132.233.84) by
 SG2P153MB0255.APCP153.PROD.OUTLOOK.COM (10.255.246.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Mon, 20 Jan 2020 07:56:17 +0000
Received: from SG2P153MB0349.APCP153.PROD.OUTLOOK.COM
 ([fe80::e8e6:3ff5:1354:c16c]) by SG2P153MB0349.APCP153.PROD.OUTLOOK.COM
 ([fe80::e8e6:3ff5:1354:c16c%4]) with mapi id 15.20.2686.007; Mon, 20 Jan 2020
 07:56:17 +0000
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
Subject: RE: [PATCH V2] x86/Hyper-V: Balloon up according to request page
 number
Thread-Topic: [PATCH V2] x86/Hyper-V: Balloon up according to request page
 number
Thread-Index: AQHVzjWbsjxOGkWFdEaVS9cNDyCZfafzLvxg
Date:   Mon, 20 Jan 2020 07:56:16 +0000
Message-ID: <SG2P153MB03494F5D6419A9DAA2E7A18192320@SG2P153MB0349.APCP153.PROD.OUTLOOK.COM>
References: <20200116141600.23391-1-Tianyu.Lan@microsoft.com>
 <MW2PR2101MB10520A27DC77E3B2F15EC75FD7300@MW2PR2101MB1052.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB10520A27DC77E3B2F15EC75FD7300@MW2PR2101MB1052.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-18T19:29:24.8895054Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=20eeef19-b79d-4e67-97db-f5edc5648f20;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tianyu.Lan@microsoft.com; 
x-originating-ip: [167.220.255.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f5731fcc-3060-43c2-23e1-08d79d7e3adf
x-ms-traffictypediagnostic: SG2P153MB0255:|SG2P153MB0255:|SG2P153MB0255:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SG2P153MB0255ECDAB6D3143F9C2C092D92320@SG2P153MB0255.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(189003)(199004)(52536014)(5660300002)(10290500003)(478600001)(33656002)(186003)(8676002)(26005)(2906002)(81156014)(8936002)(81166006)(54906003)(316002)(9686003)(7696005)(6506007)(53546011)(110136005)(55016002)(76116006)(66476007)(66946007)(66556008)(64756008)(71200400001)(4326008)(66446008)(8990500004)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:SG2P153MB0255;H:SG2P153MB0349.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SO7fQdqxXVbC5xcVHfBit6iULfQ3ulxxjb7qX4r9BNlpz1NrqBdjsAPy9JH2b14yeK0QjXScBHdmLOYKtTG0OZkH46FY34XzUMwhSNi+XbBJ6l6DW/F2Xy4oMnGoxrvKbaFHFG/0hoavHhx6M/3EGyTL1QaJwaq+49ASGjB/S7DZ63ElZlEUGwiopS9A5O/posdtH3cVSxM5NoCDkwV6dVtkJOhVX6+8FX2h5n1Ekud+5qrA621qLiqrLmJDvV8orSZGWx0G8c9FUD5SntXALuHas9OmAv7OxFnXpiowLlRdt6rHVV0o5D2vBQ7rXvkGBL0BHoMvAOtvdkVb3PKLX2ovFiO3+t/QJrmoFhoRmXCXrziPyi5JsXfdblovtnKQiIOKXscLLguopfh13eXoG1bGmRBd7lHa2MobvVXov2EK5P9kgornUrgqVWGiayyr
x-ms-exchange-antispam-messagedata: 70sjRXhE3n/eIoyOy3fiu0gUk7Qai5nKMNmzYL7DTBY5nLuwPVWRUhyao8fTqqYMeVXgRTkaVxzK7bZuqAQ+QtJ/FcntXooc0Qv72irMf/l2hLd2tJ1X7dnaUvqWjrtTA3WuFObowL9wEURjP9PW6w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5731fcc-3060-43c2-23e1-08d79d7e3adf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 07:56:17.0589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xlYVHHwlHr8h08VaGpZpmbskgnmsIgeCx9J1H8hfDmQ7K8rYhsYvA5KWWDgmo1j15Y9Jak1m+d/DE7QypdV4pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2P153MB0255
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michael:
	Thanks for your review.

> From: Michael Kelley <mikelley@microsoft.com>
> Sent: Sunday, January 19, 2020 3:29 AM
> To: lantianyu1986@gmail.com; KY Srinivasan <kys@microsoft.com>; Haiyang
> Zhang <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org
> Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>; linux-hyperv@vger.kernel.org;
> linux-kernel@vger.kernel.org; vkuznets <vkuznets@redhat.com>;
> stable@vger.kernel.org
> Subject: RE: [PATCH V2] x86/Hyper-V: Balloon up according to request page
> number
>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com> Sent: Thursday, January 16,
> 2020 6:16 AM
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
> > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > ---
> > Change since v2:
> >     - Change logic of switching alloc_unit from 2MB to 4KB
> >     in the balloon_up() to avoid redundant iteration when
> >     handle non-aligned page request.
> >     - Remove 2MB alignment operation and comment in balloon_up()
> > ---
> >  drivers/hv/hv_balloon.c | 12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c index
> > 7f3e7ab22d5d..536807efbc35 100644
> > --- a/drivers/hv/hv_balloon.c
> > +++ b/drivers/hv/hv_balloon.c
> > @@ -1684,7 +1684,7 @@ static unsigned int alloc_balloon_pages(struct
> > hv_dynmem_device *dm,
> >  	if (num_pages < alloc_unit)
> >  		return 0;
>=20
> The above test is no longer necessary.  The num_pages < alloc_unit case i=
s
> handled implicitly by your new 'for' loop condition.
>=20

Yes, will update in the next version.

> >
> > -	for (i =3D 0; (i * alloc_unit) < num_pages; i++) {
> > +	for (i =3D 0; i < num_pages / alloc_unit; i++) {
> >  		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
> >  			HV_HYP_PAGE_SIZE)
> >  			return i * alloc_unit;
> > @@ -1722,7 +1722,7 @@ static unsigned int alloc_balloon_pages(struct
> > hv_dynmem_device *dm,
> >
> >  	}
> >
> > -	return num_pages;
> > +	return i * alloc_unit;
> >  }
> >
> >  static void balloon_up(union dm_msg_info *msg_info) @@ -1737,9
> > +1737,6 @@ static void balloon_up(union dm_msg_info *msg_info)
> >  	long avail_pages;
> >  	unsigned long floor;
> >
> > -	/* The host balloons pages in 2M granularity. */
> > -	WARN_ON_ONCE(num_pages % PAGES_IN_2M !=3D 0);
> > -
> >  	/*
> >  	 * We will attempt 2M allocations. However, if we fail to
> >  	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
> > @@ -1749,14 +1746,13 @@ static void balloon_up(union dm_msg_info
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
> > @@ -1770,7 +1766,7 @@ static void balloon_up(union dm_msg_info
> *msg_info)
> >  		num_ballooned =3D alloc_balloon_pages(&dm_device,
> num_pages,
> >  						    bl_resp, alloc_unit);
> >
> > -		if (alloc_unit !=3D 1 && num_ballooned =3D=3D 0) {
> > +		if (alloc_unit !=3D 1 && num_ballooned !=3D num_pages) {
>=20
> Maybe I'm missing something, but I don't think Vitaly's optimization work=
s.  If
> alloc_unit specifies 2 Mbytes, and num_pages specifies 3 Mbytes, then
> num_ballooned will come back as 2 Mbytes, which is correct.  But if we re=
vert
> alloc_unit to 1 page and "continue" in that case, we will lose the 2 Mbyt=
es of
> memory (it's not freed), and the next time through the loop will try to a=
llocate
> only 1 Mbyte (because num_pages will be decremented by num_ballooned).  I
> think the original code does the right thing.
>=20
> Michael

Sorry. I should remove the "continue" here and then it will work.  Will fix=
 this in the
next version.

>=20
> >  			alloc_unit =3D 1;
> >  			continue;
> >  		}
> > --
> > 2.14.5

