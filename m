Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38CD14334F
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 22:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgATVT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 16:19:29 -0500
Received: from mail-bn8nam12on2123.outbound.protection.outlook.com ([40.107.237.123]:55488
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbgATVT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jan 2020 16:19:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFPp/VyYl+iiNmyK5bDWVIzjb4aEh/94HLANAIiG9mAEabSIahjDTRDPzNEeheXPVck1P70Gzudz7F9nL1pn71prAtTW9lyR02jLGrYqbbBPZ0MjmKPOXYgMvHhsrijXRRKQy/mwvmugaXOE18FgH+LdNJmWHDLNlwLB7tPlDmJsh/0t4HWRPgK17I+Lo8eV28ykFgOKuZmfA9TxqnUBp3+EAAE4U2Vcy878SBBAeRGjbJ3a/soSMTfqvyos/JGHkvwbzUPgmVcE61RjMBrLiKiSSyY5jWJk/vZEpjgBIqqsOJ8BQiMRhMqpkNi0UAp6u2TB4gzU0vhUYapdysExfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQo07sjsplm+qelLIRvgBMGR+Ov5DNvELVwoB44v4ws=;
 b=F5kpr4nRiQlRVRgFXSKt0JcsdieUGLjZWJLZ7YFqThS9eB22gAFndYP0LOTlPur0IPoB7CBrCCtYWEV6DumlTWrb3ev9uNGxKN0aI3IDPZGODTRFVj36RJiPbA1z64F3OGDHZfwvzwcbG4m6a2rjZLkJWzandgvO1totAwB8U1ClDCyrZrVJp9BGzpySEO+I/wHIhZ6m1RCbQBIgzFHASbTlphgVs5555UMkLrzHfmTpONYL5JDITa58vCImHzkUla7XKyd4ebJjC4zCzIrsIiZOqJFWprvGgdcJa6UhNA4WNMLu4m+ZuzZ3pYdOOdISe3llhKMsAkKRvz4pFoswvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQo07sjsplm+qelLIRvgBMGR+Ov5DNvELVwoB44v4ws=;
 b=GnjP+lSAbaR6ImItzlsqWAGtHBqJM964VxoVUaugGQHF3aVhxmD7GWi8jhYI4rAaRp8Zb2JZyPp9bR0IGUtBLy7dG2+gCHO7/3u4anr/1LWxG4KxjcwthnbmKWClkuJp+lED6aN55nN0erX2en/OmT+teLyDYFdvJ2Us/wWN1y0=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (52.132.149.16) by
 MW2PR2101MB1066.namprd21.prod.outlook.com (52.132.149.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.8; Mon, 20 Jan 2020 21:17:49 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::f1bb:c094:cb30:ba1f]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::f1bb:c094:cb30:ba1f%6]) with mapi id 15.20.2644.015; Mon, 20 Jan 2020
 21:17:49 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>
CC:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V3] x86/Hyper-V: Balloon up according to request page
 number
Thread-Topic: [PATCH V3] x86/Hyper-V: Balloon up according to request page
 number
Thread-Index: AQHVz219fxFYFMG+5UOXJtwliYHKI6f0DXlA
Date:   Mon, 20 Jan 2020 21:17:49 +0000
Message-ID: <MW2PR2101MB10529ECBC84A6BA130FB9134D7320@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200120084149.4791-1-Tianyu.Lan@microsoft.com>
In-Reply-To: <20200120084149.4791-1-Tianyu.Lan@microsoft.com>
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
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f94b8c97-28ab-4299-fce2-08d79dee3408
x-ms-traffictypediagnostic: MW2PR2101MB1066:|MW2PR2101MB1066:|MW2PR2101MB1066:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB10661451E9C6F30AF79501BDD7320@MW2PR2101MB1066.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(199004)(189003)(33656002)(81156014)(316002)(5660300002)(110136005)(478600001)(8990500004)(4326008)(81166006)(9686003)(54906003)(66446008)(10290500003)(2906002)(186003)(26005)(76116006)(64756008)(66556008)(66476007)(66946007)(86362001)(71200400001)(7696005)(55016002)(52536014)(8936002)(8676002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1066;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R4b6xe9WA6YzbRLh4B+fVBipw60nU0oQpNr9LQL9yn8FfnsmDozGm6OBadxviaAXZzZYcWQnv8jxReRq+Tnn8yRHwUOuGGzHVxe73fQ+eEWx/MFoMPOuUHk03QhPfRZVEnryWtvMiSSVtrPANblXwvvidaqoEyiELa/K0oqKq3yneq2Y8VvI6BAwwVpnsa7cS8cSxjpdKxsGKZArwyr/xm+SJyf5oW46ztHdztgHUnN2ERwZawkP+yNzqpa2rApX8d0LZb38ajS9xYT1hbOyN5OwpF0a1krWRBWPLi3rrDhB92m5U356G5gSbjUGT0E+xbvQFAwDASFG99idgtWvNddZdfD9iuDwVwi6OaDEKKxwye7yrrxX1kTyRQkGLGXUY/eb3te1calUbxy4BNzx2l7AGQXLUQvbPby1s+LK8Q4SnDhu80R6dQ/6TBqphI3U
x-ms-exchange-antispam-messagedata: eLrSTSguGyPO5rOpFcFWklRdOgf4B3PobqDUDK1qD3arYkmKZFBr9srVQUHIOg+eWdcor854H4syF8adlziWvnqejzLub4hipPAmuyxa3UqmdQkZylvp3xAKepNpmgoxIuCKB11/YkzlaLODQBdEcw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94b8c97-28ab-4299-fce2-08d79dee3408
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 21:17:49.5416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SJexm/tQqQN0+8+0iNqhPulXFmoi3o41VaP+QIjq8yw8w4v9CtaHI1Zh0XPXjAPk2vBD9UGMG29UasILaaCb6TYYHlAqx52kov0NNTYM0bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1066
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com> Sent: Monday, January 20, 2020 =
12:42 AM
>=20
> Current code has assumption that balloon request memory size aligns
> with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
> balloon driver receives non-aligned balloon request, it produces warning
> and balloon up more memory than requested in order to keep 2MB alignment.
> Remove the warning and balloon up memory according to actual requested
> memory size.
>=20
> Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error of=
 2MB memory
> block")
> Cc: stable@vger.kernel.org
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v2:
>     - Remove check between request page number and alloc_unit
>     in the alloc_balloon_pages() because it's redundant with
>     new change.
>     - Remove the "continue" just follwoing alloc_unit switch
>      from 2MB to 4K in order to avoid skipping allocated
>      memory.
>=20
> Change since v1:
>     - Change logic of switching alloc_unit from 2MB to 4KB
>     in the balloon_up() to avoid redundant iteration when
>     handle non-aligned page request.
>     - Remove 2MB alignment operation and comment in balloon_up()
> ---
>  drivers/hv/hv_balloon.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 7f3e7ab22d5d..73092a7a3345 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -1681,10 +1681,7 @@ static unsigned int alloc_balloon_pages(struct
> hv_dynmem_device *dm,
>  	unsigned int i, j;
>  	struct page *pg;
>=20
> -	if (num_pages < alloc_unit)
> -		return 0;
> -
> -	for (i =3D 0; (i * alloc_unit) < num_pages; i++) {
> +	for (i =3D 0; i < num_pages / alloc_unit; i++) {
>  		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
>  			HV_HYP_PAGE_SIZE)
>  			return i * alloc_unit;
> @@ -1722,7 +1719,7 @@ static unsigned int alloc_balloon_pages(struct
> hv_dynmem_device *dm,
>=20
>  	}
>=20
> -	return num_pages;
> +	return i * alloc_unit;
>  }
>=20
>  static void balloon_up(union dm_msg_info *msg_info)
> @@ -1737,9 +1734,6 @@ static void balloon_up(union dm_msg_info *msg_info)
>  	long avail_pages;
>  	unsigned long floor;
>=20
> -	/* The host balloons pages in 2M granularity. */
> -	WARN_ON_ONCE(num_pages % PAGES_IN_2M !=3D 0);
> -
>  	/*
>  	 * We will attempt 2M allocations. However, if we fail to
>  	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
> @@ -1749,14 +1743,13 @@ static void balloon_up(union dm_msg_info *msg_inf=
o)
>  	avail_pages =3D si_mem_available();
>  	floor =3D compute_balloon_floor();
>=20
> -	/* Refuse to balloon below the floor, keep the 2M granularity. */
> +	/* Refuse to balloon below the floor. */
>  	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
>  		pr_warn("Balloon request will be partially fulfilled. %s\n",
>  			avail_pages < num_pages ? "Not enough memory." :
>  			"Balloon floor reached.");
>=20
>  		num_pages =3D avail_pages > floor ? (avail_pages - floor) : 0;
> -		num_pages -=3D num_pages % PAGES_IN_2M;
>  	}
>=20
>  	while (!done) {
> @@ -1770,10 +1763,8 @@ static void balloon_up(union dm_msg_info *msg_info=
)
>  		num_ballooned =3D alloc_balloon_pages(&dm_device, num_pages,
>  						    bl_resp, alloc_unit);
>=20
> -		if (alloc_unit !=3D 1 && num_ballooned =3D=3D 0) {
> +		if (alloc_unit !=3D 1 && num_ballooned !=3D num_pages)
>  			alloc_unit =3D 1;
> -			continue;
> -		}

I don't think removing the "continue" works either.   Suppose the requested
size is 1 Mbyte.   With an alloc_unit of 2M, alloc_balloon_pages() will ret=
urn
zero.  The code above will set alloc_unit to 1, which is correct.  But with=
out the
"continue", the code below will mark "done" as true, and we won't loop back
around to try again with alloc_unit set to 1.

I think the original code needs to stay as is.

Michael

>=20
>  		if (num_ballooned =3D=3D 0 || num_ballooned =3D=3D num_pages) {
>  			pr_debug("Ballooned %u out of %u requested pages.\n",
> --
> 2.14.5

