Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4501F141929
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 20:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgART3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 14:29:32 -0500
Received: from mail-dm6nam10on2138.outbound.protection.outlook.com ([40.107.93.138]:63962
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726806AbgART3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 14:29:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBtBvB1lD7GOgPkfSbGIJFBj5e6//AT3fZPXmVioVvMhhtfMKv1rbV1pj8mr+ELg9vTd2KbxOOFOl6DKCNLXuXq6VYjyIdX4/eUfTLrb+3Py/xSX/Zi7hLe99sGBBnHII2DfX3GnmQwh9Tm7b7vZaGme82YHyewfRfrs6lbSA96B90BDB67vivLuaE+RDQPL14ybR1KzLO36Axpfn4GrpLyJZZF1G5wadKhlV0fL68v68mWpISMePngcQdnMMDJaaS4r3i3FT8SSmeonfl1ZIAjaVr6W6famtLGLLRhc2jGQxRzN21TWbOUI60I5y4kXcMuw+ogvv8oieJaBDiTjEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvQXSTONABnpWNd33pVwgZD/aMU5i0BZrnt5B+W9FCw=;
 b=nF4AkD3SRC70Had1kTQvhdXjtIf2bwBD0LLkbUQ7IQNBjcd1iulc0E/WzyS0WYk01BAfqV5ZMCwPYT8Z7c8JAzONtIc8oSdplhlyYVXYP1YdE5R4YiWcPxXyISrmcma7n72gwSv+VQ5ElUTRMmOBrOjtOoUwPz4ttcWA1x3TAR0h4KGz6aQCf4mcjMiFq3rLYYlORFOgYWM6yFvOp8/+p8CdiWVSiV69ZSB9RiMbQiSrMM6SXDojVS+2gRFsmuC6md8lANs48DmD8FqaZ+MAoZJOho/4WzF+9OszNbTsuBBYVO+/+XXl0xl6oR7oVLpdVuI94fj4GAZoGnSL9DTJtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvQXSTONABnpWNd33pVwgZD/aMU5i0BZrnt5B+W9FCw=;
 b=df0GpXq7x22PRzlY86x3HeFghI2r1Y2eUS+jFCAAjLn5/u0arD6+l2o20a61jFg8Ul4Y6P4itFnzJ2fGPLZ9Mq0JsvmNXAT6XSWABAhqc7ZLe+KokPyHUTckren38xGVUE4h7Jd9sN4IRuZuFSxjtDnRVnGh0oys7tn14QzmjdM=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (52.132.149.16) by
 MW2PR2101MB0940.namprd21.prod.outlook.com (52.132.146.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.4; Sat, 18 Jan 2020 19:29:27 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::f1bb:c094:cb30:ba1f]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::f1bb:c094:cb30:ba1f%6]) with mapi id 15.20.2644.015; Sat, 18 Jan 2020
 19:29:27 +0000
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
Subject: RE: [PATCH V2] x86/Hyper-V: Balloon up according to request page
 number
Thread-Topic: [PATCH V2] x86/Hyper-V: Balloon up according to request page
 number
Thread-Index: AQHVzHeBeCcAgW5Bc0OpEv2JOO+xBKfwzQOg
Date:   Sat, 18 Jan 2020 19:29:27 +0000
Message-ID: <MW2PR2101MB10520A27DC77E3B2F15EC75FD7300@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200116141600.23391-1-Tianyu.Lan@microsoft.com>
In-Reply-To: <20200116141600.23391-1-Tianyu.Lan@microsoft.com>
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
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 51104d43-e1ba-40a9-29aa-08d79c4cbbbe
x-ms-traffictypediagnostic: MW2PR2101MB0940:|MW2PR2101MB0940:|MW2PR2101MB0940:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB0940F7C5C844E4F6F9786B82D7300@MW2PR2101MB0940.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0286D7B531
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(189003)(199004)(81166006)(33656002)(5660300002)(81156014)(10290500003)(186003)(52536014)(478600001)(9686003)(6506007)(26005)(8990500004)(316002)(8676002)(71200400001)(66556008)(76116006)(7696005)(66446008)(4326008)(86362001)(2906002)(54906003)(8936002)(66946007)(66476007)(110136005)(64756008)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0940;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7CZ2t0jBEpyJyKOm1Rx5QKa8cC3aSBPV1vm2EmHguw+M6ZMV164Y1HguLe/VkNF9WRDw+xCw5G8cbTnSFR9RogJp8rD5aO0o4+2F3H6C4eGd6LIIXAygPbMVSNCEZJXLJqR+CnYJpolhGnN1RfP1iHYFbaBoE9XawA5SH3MWwqN3NRcInocKmo2gOReUipobEIR8NogPUgz6deAx78XdxgffRCKFt298gEh1pw9T16vSWlOd4CpJjkcDPpYSUScIDEZDqbCVbnKYz61kacO2L+05TgtlKqQEksF1Cr0FuGepnSc2EGcbEgrC+hvf+5CIigy0LNYB9vHZL9w9qK+M69mnOeGqHHzo1zUOSgY/ANuNTx9QTGiyziBcz8HfAWyNzdWZb/nYSYqPdUy7NyLcHEpnMoaG3XJMSB9SKiaNmFQzIrtXXKSDrON4Vz+DvRzK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51104d43-e1ba-40a9-29aa-08d79c4cbbbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2020 19:29:27.5934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K6EjvkPm4Ld31anXM4jo0mm2Rs6VUUjb+PBcfV2Xh2zBqam/brD4ovDo6etJ8LyOg3+zjdTFYVevlLOfCpE71LZMA7Dw/SEmK6xojctgt2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0940
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com> Sent: Thursday, January 16, 202=
0 6:16 AM
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
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v2:
>     - Change logic of switching alloc_unit from 2MB to 4KB
>     in the balloon_up() to avoid redundant iteration when
>     handle non-aligned page request.
>     - Remove 2MB alignment operation and comment in balloon_up()
> ---
>  drivers/hv/hv_balloon.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 7f3e7ab22d5d..536807efbc35 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -1684,7 +1684,7 @@ static unsigned int alloc_balloon_pages(struct
> hv_dynmem_device *dm,
>  	if (num_pages < alloc_unit)
>  		return 0;

The above test is no longer necessary.  The num_pages < alloc_unit
case is handled implicitly by your new 'for' loop condition.

>=20
> -	for (i =3D 0; (i * alloc_unit) < num_pages; i++) {
> +	for (i =3D 0; i < num_pages / alloc_unit; i++) {
>  		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
>  			HV_HYP_PAGE_SIZE)
>  			return i * alloc_unit;
> @@ -1722,7 +1722,7 @@ static unsigned int alloc_balloon_pages(struct
> hv_dynmem_device *dm,
>=20
>  	}
>=20
> -	return num_pages;
> +	return i * alloc_unit;
>  }
>=20
>  static void balloon_up(union dm_msg_info *msg_info)
> @@ -1737,9 +1737,6 @@ static void balloon_up(union dm_msg_info *msg_info)
>  	long avail_pages;
>  	unsigned long floor;
>=20
> -	/* The host balloons pages in 2M granularity. */
> -	WARN_ON_ONCE(num_pages % PAGES_IN_2M !=3D 0);
> -
>  	/*
>  	 * We will attempt 2M allocations. However, if we fail to
>  	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
> @@ -1749,14 +1746,13 @@ static void balloon_up(union dm_msg_info *msg_inf=
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
> @@ -1770,7 +1766,7 @@ static void balloon_up(union dm_msg_info *msg_info)
>  		num_ballooned =3D alloc_balloon_pages(&dm_device, num_pages,
>  						    bl_resp, alloc_unit);
>=20
> -		if (alloc_unit !=3D 1 && num_ballooned =3D=3D 0) {
> +		if (alloc_unit !=3D 1 && num_ballooned !=3D num_pages) {

Maybe I'm missing something, but I don't think Vitaly's optimization works.=
  If
alloc_unit specifies 2 Mbytes, and num_pages specifies 3 Mbytes, then num_b=
allooned
will come back as 2 Mbytes, which is correct.  But if we revert alloc_unit =
to 1 page and
"continue" in that case, we will lose the 2 Mbytes of memory (it's not free=
d), and the
next time through the loop will try to allocate only 1 Mbyte (because num_p=
ages
will be decremented by num_ballooned).  I think the original code does the =
right thing.

Michael

>  			alloc_unit =3D 1;
>  			continue;
>  		}
> --
> 2.14.5

