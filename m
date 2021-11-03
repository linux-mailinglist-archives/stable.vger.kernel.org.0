Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE734447C8
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhKCRzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:55:20 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:13888
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229697AbhKCRzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 13:55:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dr5BUNfz3ZhpnVf6x5hpb7WV16pSPDgEIRTr9kepguP8cjtQRWTyROjWqfpbw2fmJqKZl39E13deZ0cM9sTaIqIDpS+5mBd/J9hCTRPaNpX1jt2D6/zOKU23uastwNud/C04OZgiXJxuy/dJnDxcKQbmbBjLIb5fe67nawfH2U6u+cjxeW1s8b7g9JvaJq/4RWqq1sZbpLJVUnuqIFiRg0GPjJD03ocP16f9SMwnBIUe6CPvZ4ezYfGVYTzZ5JaDoTnJNYyjVCWv8SYuaItDk6LKd6PawOdItnvPMFItb0xNVvJk9R9OFjlXofEF+Nnw5WPZS7W7hm0Mp4bXD7YPIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPXxPoUiTbFI7QbJD6Am/W0ARC89bH7oZz+/NtI9npQ=;
 b=PPIwN0RKbB8akjCqHeZN7AVdUMl2CxvPWww02PmHwNbsHooe5+XrM5WKKqiPzTHQLvHbhbsLRMwfusnU4+N9jqIRZj1pQbbhHFpe2XF8s+1RBeUkBOMhVjDQuJ1r4l1Iqd/vqrnndOIRIPAlN6kJiXdwHqioePdk1geUXACAM9T8TbkhuQLZmyG6ibA4MJbI0+UwHXTTkmzDh7NtrKA4hPpsD6Mc1HmZQ2PEXovLY9FRB2OCm7rliDeGmVtv6DHDWHBQemxnWFwWrBgoigf+jIRfFdhEzUdaMZ5ohgka4k4loA89NHzjZMZSqgLNY2y1ub6FjCsx3MGz7EzGYMdUqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPXxPoUiTbFI7QbJD6Am/W0ARC89bH7oZz+/NtI9npQ=;
 b=dhV8QIk6o+ca+6m27fT5N/DhzaTrKJZ+Z8t/jrj/8Glkw/7I6Ckyo2a5wa7Owm7D1HV+sLzMHn2LvXMe4qyoQ5PBIyAkjQwKu0VD0X1PlGZrE9c7GLUw7QOBbHuGqf/tCfi4lhwcBYVEu2g5TVQZgveu04swbkSs2Arpa3hZSqk=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5319.namprd12.prod.outlook.com (2603:10b6:208:317::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Wed, 3 Nov
 2021 17:52:38 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::6452:dc31:2a24:2830]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::6452:dc31:2a24:2830%8]) with mapi id 15.20.4669.011; Wed, 3 Nov 2021
 17:52:38 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Zhang, Yifan" <Yifan1.Zhang@amd.com>,
        youling <youling257@gmail.com>, "Zhu, James" <James.Zhu@amd.com>
Subject: RE: [PATCH] drm/amdkfd: fix boot failure when iommu is disabled in
 Picasso.
Thread-Topic: [PATCH] drm/amdkfd: fix boot failure when iommu is disabled in
 Picasso.
Thread-Index: AQHX0MKOoUbHAuiERE69wbSaR9pXg6vyFDAAgAABDdA=
Date:   Wed, 3 Nov 2021 17:52:37 +0000
Message-ID: <BL1PR12MB514414DC0EDB244757084059F78C9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20211103145256.1359520-1-alexander.deucher@amd.com>
 <YYLLKqAxsgg+dCGU@kroah.com>
In-Reply-To: <YYLLKqAxsgg+dCGU@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-11-03T17:52:34Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=8ca6dc70-4858-41dd-8a29-fe4594974f9b;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b141437-19ee-47b7-cd78-08d99ef2b9aa
x-ms-traffictypediagnostic: BL1PR12MB5319:
x-microsoft-antispam-prvs: <BL1PR12MB5319921D95623C56494854B5F78C9@BL1PR12MB5319.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:425;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EfCML0L64L06HombPPRxlvX1/Puxx4it8bTWSPfQU4mL7sXVuWY/bw73XYRTWsOcH0kluFof2PDXZg1h6GOVgn/i/JsXtjVSj/993n9FWzb+lQhZvealvXDEkgZdneZN93W8UZieyA04rfngC8c0ZD6II50lPq/0qA8CeYgVZVW6bR5mt2Gegj4GBFd6umeV4Yrs5gYQNYc9d2LmMQ1zH6+NINrxKaKz4L6rn4kBzFW7qIsFYWl92Oc6x39Nqm04N2w89l5NUGonlCBs2d2QK8XX1er2m/1gYVTS91G1+fbujvbYHV+NHqCtLMaj4ZRdplTmbfq8td2VsbUaPv+gFlark6d0/aCUXIAoSs1QcJsFugXUZRXuxsCJBlRvW+M9cn63GWWqbDWDX+cL/pW3I9IrfQrOGqYGfxGpRVKnQ9Mzy7WR5H0+MyxXvyR3TYCpSK2nvXvtihXSEpBm56HKQkl2IB8NIWk1vEzkCbX0gHdh6HI5nG6s5O0iiSDTQu95z6GjeFtIOuk2CVaNJkYKV3yay+eoiOGYHE0IAz/7c1eaQAQ+s6tBLg9sCZTwlcKcsjIr89as3D1aAGQYDZCuHTumm7w9CHoop9kNIU8Z8PQNCQATz/6/0/eiZtUQmhzaIZFeg3mhInQjfIO31dd0xn0xKA372L2Vyn9ndYzaNLdM0oTzn4UXYB4ecZJR1tjTJ4HzTDr4lJ3GUGQoGA04lEk0GWGowakD0yXDufNql4Wfk0cyX92lP/+PBVDVTDxYYC3ICvMlWBSkEr2/wCNONoLvXBwjANxClsEiRzjHg1JJhqNhjO4SY6Z1o3qq8VJd1IFfkh1zVONP8cta+WEUdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(2906002)(53546011)(6506007)(83380400001)(7696005)(86362001)(66946007)(8676002)(52536014)(9686003)(66476007)(66556008)(64756008)(186003)(66446008)(76116006)(54906003)(6916009)(316002)(26005)(71200400001)(508600001)(4326008)(45080400002)(38070700005)(5660300002)(122000001)(38100700002)(55016002)(966005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z6F9lAwE2+L4O7ktTGJsIEjbN7Dkhd5gw2EPAiYAXjfI7TWXUYZQ3pvjOB3v?=
 =?us-ascii?Q?3UVf/AH7kD/U88/8oqD/Iw9gGS4KxT4IEWEMmtx3Hjrw5J0be+ymQf0VhZUd?=
 =?us-ascii?Q?QB9SXaclwCTMTtr5OBliIi7xB3vmlIBH8VlL3d9ycNZbYbbNkCVJl7jVW2UE?=
 =?us-ascii?Q?HAp8IPAUGADRgFfccL3WnpgtvzEukyhG3+yZBXpZRhZIRE+896UxGDON8Fmf?=
 =?us-ascii?Q?dEVGjI15gpm/lTVVWsNzCLicmQrHYTUgLhhCx13dt5tiAJL4oy5O9qKwFkKe?=
 =?us-ascii?Q?tTGThDRNt2Xk6WZ7O56zUbmUDLps0dezAq4gc6LSwJfrgIK0CA1sMjr1cDLz?=
 =?us-ascii?Q?O9SMOZv+xcbdDAOI44WxIPkakwnajI8NZAOa405SKQE9598gIWWytPD8kgmM?=
 =?us-ascii?Q?oEWERuzoqEAaeZXqxSxd7Xx2/cAwZ/szl7q0mYXjG0CCjso1S14dWk3Hy1Cu?=
 =?us-ascii?Q?qcdXsX6S0GVEINbM94mz5cflatMgnIlrhuMpmnYh1yzIVNNLwcLkxUGpz4tW?=
 =?us-ascii?Q?mnTuQHBs+YnPDl3e2lnAh5XRJ2YfQECHMR3K5iW+es113Dcp/ROkeSd/vHz8?=
 =?us-ascii?Q?m1AVqkDbfV0Ew2Hz24DrrWHC50MGGZ0Hw2NumNM3wl0drpRbKPco3WDYelPr?=
 =?us-ascii?Q?+zCAMkiIB/l2vkfpgBnA4He5URf9J17C9/R+Y70FQ+FHcIl28gfiOO17OpCn?=
 =?us-ascii?Q?GNB280hyLdxvmA2eIxESRarCBnavivRoPSZOZNSnc0kctKUvaPxaJp7EiDmM?=
 =?us-ascii?Q?FLOzPl//827arAhnDGWX3IolrzgVH5aL7jyrRyeSCaSrig7WfS5QfJ0HhlxN?=
 =?us-ascii?Q?TCn6X7uUtFB14z8RbIpqFyUL/62h+i6D8PIFPAe8NYc/hNREvmPCK95PN18x?=
 =?us-ascii?Q?S1nRNhnr3gwLnWFs9lmHtHgncCKYVTLRPKAgpPKU1nk/F1WnKk5o2CwqZbrA?=
 =?us-ascii?Q?CaZj/4Ut/Hz7pyUiKCow8VN/LabZ5UH6qNr+bdLiZPIZeQIxkFbC5P1FvvQI?=
 =?us-ascii?Q?2zFmtGVqlSa3VaYy8vxKB53oVtn6vybJwZ4tVVeIc6lleeUwY/CyeIvA+GAH?=
 =?us-ascii?Q?AegeBPpALNp08f+MXNA9tGawGq1D+wWaqLbJ721ZwV4Z3OzfgcBjXWUIcSBC?=
 =?us-ascii?Q?ICej6IfeEJPcW0UAaR+ooPcWpNPdJHgiCgrXaWQFYAZNMB89WfJe6FfecoBB?=
 =?us-ascii?Q?u9/BOLvUfUMa1MPQqTEIHq7T5ciTuH4fF84yNtxDP13eIBGxcn/q0qfRKJ5v?=
 =?us-ascii?Q?cPfNXk+jA0exIzuRUMCtPAAsoOREUkKK14DeiFEW6PnirGZvuJD+z4o4riGs?=
 =?us-ascii?Q?Kxvi/lNWsD4oLZKpn+rfo6qvoHbDmzXo3X38iJ2Fvt0Irr+u26TD7tdwYbnd?=
 =?us-ascii?Q?vLKsdjQiJj12g7/SO0iHSmAarnP4lYrdxiXeb9CQc8FslCLPMZ3X1dwCuT1t?=
 =?us-ascii?Q?pxF4x9VSbNEDFBgMLT+Iq4QJm+bKnHDZBgu3E3CLSLAce+ClC/QTtR3RdrRX?=
 =?us-ascii?Q?PVHGDCicFabT3KEjSSxOZ6XAPYQ24FvLgYl0xWHD2MJbJJ5p+jc9yu/vwk2Z?=
 =?us-ascii?Q?fEG18D3LSHQa2+3UjCrDSk3UNlRHMOXNJu+bDd6NoKuSxcqGwAijNn/v2Vj4?=
 =?us-ascii?Q?fbIvSDKHnGRxz3JAeMZxs7Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b141437-19ee-47b7-cd78-08d99ef2b9aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 17:52:38.2365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IJvrYaol0vitbJpN72XmJe4MbqPTJtftWdWussnopWClpAHUnneFxjxD3l3RXd2YOz9If92jHNj6QIK93oRwWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5319
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, November 3, 2021 1:47 PM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org; Zhang, Yifan <Yifan1.Zhang@amd.com>; youling
> <youling257@gmail.com>; Zhu, James <James.Zhu@amd.com>
> Subject: Re: [PATCH] drm/amdkfd: fix boot failure when iommu is disabled =
in
> Picasso.
>=20
> On Wed, Nov 03, 2021 at 10:52:56AM -0400, Alex Deucher wrote:
> > From: Yifan Zhang <yifan1.zhang@amd.com>
> >
> > When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2 init
> > will fail. But this failure should not block amdgpu driver init.
> >
> > Bug:
> >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugz
> >
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D214859&amp;data=3D04%7C01%7Cal
> exan
> >
> der.deucher%40amd.com%7C995f91a70fdd40d87e4908d99ef1ffb9%7C3dd89
> 61fe48
> >
> 84e608e11a82d994e183d%7C0%7C0%7C637715584500181786%7CUnknown%
> 7CTWFpbGZ
> >
> sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6M
> n0%3
> >
> D%7C1000&amp;sdata=3DJ9BXIQq57fr%2BfvFHNkrPYps0M7JaFzq4mTh3dMNsk
> Xw%3D&am
> > p;reserved=3D0
> > Bug:
> > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
l
> > ab.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1770&amp;data=3D04%7C01%7C
> >
> alexander.deucher%40amd.com%7C995f91a70fdd40d87e4908d99ef1ffb9%7
> C3dd89
> >
> 61fe4884e608e11a82d994e183d%7C0%7C0%7C637715584500181786%7CUnkn
> own%7CT
> >
> WFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLC
> JXVCI
> >
> 6Mn0%3D%7C1000&amp;sdata=3DOTO7kY60xizpZ0uHUn56OcZG0OzzUoytRnv
> QJfFCABg%3
> > D&amp;reserved=3D0
> > Reported-by: youling <youling257@gmail.com>
> > Tested-by: youling <youling257@gmail.com>
> > Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
> > Reviewed-by: James Zhu <James.Zhu@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (cherry
> picked
> > from commit afd18180c07026f94a80ff024acef5f4159084a4)
> > Cc: stable@vger.kernel.org # 5.14.x
> > ---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
> >  drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
> >  2 files changed, 3 insertions(+), 4 deletions(-)
>=20
> Now queued up, thanks.

Thanks.  This should go to 5.15.x as well.  I'm not sure if 5.15.x stable i=
s open yet.

Alex

>=20
> greg k-h
