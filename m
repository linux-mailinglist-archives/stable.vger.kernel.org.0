Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710E24508E4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 16:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhKOPu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 10:50:27 -0500
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:9604
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236762AbhKOPuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 10:50:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIyZurm+ZOUoPrItSINmx0QBC4NctTkN4wRpGi5ViF6lPy4++IB6LHH0xWJuD6QGf+EmbLjGy9tT4/hN/Sd6iBYNN/LF7kznr2Klf8YtcYVWSgj7D6aA9SZSn64wyn3gcMm59SKPhS4HeHqpi8vf/kKSCv+aUmM67lMPF75VPr8KiqCLB8iufq2Xitm6No+sv9cfAy5IVw4WQ1b75bYBQYzhGmmHF/s44eeXgfwfDeagC0jS7AQC2FBDxNYSJgu0F/akIzOQpcp4qngSs4ZW+gJ1aS5mQHWsIXoOGa/kcto3ohRCD8SoDbCxmSD3PimkT83b9LVmEIQ1mrfHaXRhAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYrtTdniao/rvPLnMSEknePvJBXQqTyal6MYwgGWzkY=;
 b=lvYj4458vToRz9e0Hkqr5JciJC1LEM+Sua21WlItFEESdcysyx6FpbGnafnX/rvpT35wB9UNlA5WtKYwzYAlmdLKMhyp478VXTxpAg83cgFQwW7PplHLzp/yqlIVPs9TyukZBAuSZ4zRvdiwQyZ26iwyFc3oWNHu6LJCS13a1jxVn3R0iwdCtXn5j6uTSh6TsM9c8ElXP4pdIEGiYrHrTUIj8kMvfreJH0KClFY7yCSESnNYGfGW3PlwTwap3ft+Bv0BwHN2gXbUokkJTm1sz1BTEceDTpwkJC07zCydTk7ba6AOgZ51IzuileiDQxH5vIYbWVK89WT8bzG9uhxSkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYrtTdniao/rvPLnMSEknePvJBXQqTyal6MYwgGWzkY=;
 b=ACZHlv/hNK0TYl91VrKafV4O8khvyeMLHYd3VIWy/RAQCDWdGiBEYtO3a3dKVjAoF/4nfNcMauyP//3z4b3SV4ofERW3n+vwqz8R9c7U7nPxwRK5GRDYa2rRKnI4cXDpimNBhYmI6Q6GcYhA56MeQQbwWsXoLiirh+pznXZVVwE=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN1PR12MB2366.namprd12.prod.outlook.com (2603:10b6:802:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 15:47:24 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:47:24 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: RE: [PATCH v2] drm/amd/display: Look at firmware version to determine
 using dmub on dcn21
Thread-Topic: [PATCH v2] drm/amd/display: Look at firmware version to
 determine using dmub on dcn21
Thread-Index: AQHX2jafYBLJOwYPw0uNGQpEtcUQPawEu1OAgAAAGjA=
Date:   Mon, 15 Nov 2021 15:47:24 +0000
Message-ID: <SA0PR12MB4510EB1DC98B5156F8FCAFA8E2989@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20211115153655.4870-1-mario.limonciello@amd.com>
 <YZKAs1rxuonK64kN@kroah.com>
In-Reply-To: <YZKAs1rxuonK64kN@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=true;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2021-11-15T15:47:23Z;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD Official Use
 Only-AIP 2.0;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ActionId=ef7c2325-c67e-4d22-8724-efeb93011fc0;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 274cce92-e69f-4f31-7a82-08d9a84f37ee
x-ms-traffictypediagnostic: SN1PR12MB2366:
x-microsoft-antispam-prvs: <SN1PR12MB236665CAC55BE829A6232149E2989@SN1PR12MB2366.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gIvdMq4OQ+YyOtaES0rVxc+MmEM4usrfQYYImgvvk4iP+05yH+fggJNCqfGd0rGVEaT9iesu3zxmEvyqBlvy+Rncad9EL0bdDtmSP48QEvvuVPqzHjSTcjKhDQ/CB3v5YGT/m+0FNvDEHDunQNtmTEW23iGqaQLiz4mVSn/5GAH16n3lmDF9kA65WQtZFo/wOlul1Fj0NfAKOtvpDazuw93VHljiB4kx3kFsnuWZ9khAbtpUPo4NqTgvFHW6Xja6xdB+gaAW1JgMg6W10tomonZAcx4JQuo2Ugi89e2aM3/251uQ0OdkMTOpHgv55Q9YZdpIyft7QgC7EecanET7O3kVYK16aGoNlFC5qNmu+3k4cXNmi/PfUDq8ITLGR2pIThzsOJM/rFeMYPlb2kPJf9HQUIhq+MBfRLT9ahZsG2e1Dr96mLDLTKUy+H/ik8C7Pris3Pss8+4Sgo2OIxwnoZWwQJ9ossDsWhjO1UHSxFtScTZ3e9ofK5tuS7/LoWyoOYwa5FMaf/VU1hjW3akr3kGkPOnnc26/qVf6woqm1UePzM1FmIl6GSwNna4let/FgOM3PCf7viPDqW4GmValWHWIE1VVHCiM0Rw2UOe9YXJGJp8JasjTzV6d3fYbh4XEULYlcq2AxujaCVxbz4XEe8gSlhET85zMNAYBcM7rY5cBg7cb3lot4dEPj7aUHykYgUtv/YEw+rp3AqzxCvufV8sb4+HTFQRqNzWaGo+UtVlNIz63oedZQaPzMVAbGStGSGQvryht7KC6bzyJPe1dbIqg4Eu+tzzPRtebAgL3sOs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(122000001)(66946007)(316002)(966005)(508600001)(6916009)(8936002)(2906002)(83380400001)(33656002)(86362001)(54906003)(4326008)(38070700005)(45080400002)(71200400001)(5660300002)(53546011)(76116006)(26005)(7696005)(52536014)(8676002)(38100700002)(9686003)(55016002)(186003)(66556008)(66476007)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SpMrQHYWI+DIkcnpkKgYnQiQbfMEDhDGITk6NbSe8oCaajtAuTfubTzni/F3?=
 =?us-ascii?Q?Plc9leMgpyKSjUEnUIMsr2l53EBGInZxY6CbbzSCLkWxIJJOIp/2GCDf/NT9?=
 =?us-ascii?Q?v5AATaWWJXfJ3URgFzp/VWWgGBX0tWiac4oly+h4BzcOQP4E5XhjxPT3QQw1?=
 =?us-ascii?Q?+ucz6NnXkGIVjba3pLOse6aMoFIRm1XUsHg5Bi7mN7CMAoRc+z/eP1f+7IVe?=
 =?us-ascii?Q?LSR1LC1M9Uh+mMxrv4e75aAz2s41YXImtFv4wv13VwIafqJX/k+44vcBiSlO?=
 =?us-ascii?Q?1OoHY+dn7oIBoaGw4neP6DmZlHouftuT/MUkvXMw0WGUVdcWK/6BCPI0s2xd?=
 =?us-ascii?Q?IHQvjGXp4UknfLAAEsQ3uRtOKRMKKuLnyEX3Z9wIL55Z+nhsGAETA8QXqmei?=
 =?us-ascii?Q?HEqn0NS0xxpWBsgvdLmcQ18TXzHK8NslsUWtoXwLzasKjxDJ7JL5OR1rZCcK?=
 =?us-ascii?Q?bXOzhRGTMDJP4eCT96nIPrljRgQ0OrwtTe7CbM8W7NSvm1Bp5jVm5z4x5Yru?=
 =?us-ascii?Q?0vpx+pIH08Pvr3VNNccSTYlsopX9eEyyRjvIecoE3XuYtI8hCCszTawgeevc?=
 =?us-ascii?Q?K8NgNXbYylk34DIjiozUV0MDgt09BpD1TziU2Sa1paeT0JvFhRtfH7TFpQtL?=
 =?us-ascii?Q?VBcuYTVJdtuRoHJInGrBPKqGNHjINVBvDeqPFWJmQMDTuLYvVNEGPLaU6Qh+?=
 =?us-ascii?Q?rd7mgxKKSM3YelmS/7nLVCq1/Lieuma9xdor1EtXwPMlHCal+6WkQY8424nt?=
 =?us-ascii?Q?jaTwqe/jpCpPEIO65N0zWxsiVodREjJe4S9jfNjwe2wYQljNv6sN+I7s2xDi?=
 =?us-ascii?Q?Up3cWMjDSruSbq3rzR/213+HGgJsIKRXxsr1pSi5K+y8BvvqNSq+aOYtA3sx?=
 =?us-ascii?Q?sgeMUC7HMCZ0yMFnPmyhBQ/uVGIS24q5/2Fnh9gxz7umBCVs5AAij/wuqHdU?=
 =?us-ascii?Q?WkVnn42pn7BVMSaYSvkF1dpgs0UMs0WKRdfsXF+1xVTsTD4zuIggHfLRpLK6?=
 =?us-ascii?Q?5jGZO9ZeUg9SETDj5n/oTHHIB/QpWeXGc+PO+pvMb7pTVhqtWmCmt5OCrAoF?=
 =?us-ascii?Q?sL4fr4NHwo/VNXN2uDg9NP7vrqsw4/VUsMWN0mnmgQOr/4Bn593Hf4ucCIE0?=
 =?us-ascii?Q?syYvgmYo5/oBFzsQakymvDyttjTQtlij7iZ9TwE7oiFUbDiE878wc3+tVGsI?=
 =?us-ascii?Q?Ubb/+oqsbaU6Ud2CByv0qOAsQjElbJiF4oPLHxCihaY1sGLRcT86PLVDydna?=
 =?us-ascii?Q?dH3HstzP/eSy5uR6lJ2lrFaZyDob0mi3mK/iPEBjbdT2/XgyBtk9Fod53qdR?=
 =?us-ascii?Q?tkSlCOSRdPuHOdsVw66oSNjqyyTR7ZCZOAH7i8Pr5PDx/bQfIVv1hPiw4ox6?=
 =?us-ascii?Q?XfLiu2j0l/CJaxFXpVpD+38RsPntadrvULOXihPcOt+LXh0/WGaUrc4hb0r/?=
 =?us-ascii?Q?cM8hrS6R5fp8Z7Vcnv1ewwk1586b4Ru/tH8C1f8T+9VBtWw24lUU7JGKum9h?=
 =?us-ascii?Q?b3+plARVuZRBnmUhRnLcJPnMKiDMpoPoetcN69NLGrKy2molaWnoPfDmkPYj?=
 =?us-ascii?Q?plFIPjhDPAFf509MVc7oT48EpDLPBybBKlfOXYVm/sBsY4Hlpop5xZNlMmJj?=
 =?us-ascii?Q?Jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274cce92-e69f-4f31-7a82-08d9a84f37ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 15:47:24.2012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5oHdMFFU3nFg4xe0iJVRywRhCsgWat0yCBwh9BqQORD1Rs47ljTJHOXBe2HW83AGF0/wnS4BuWXtRs9MVjMXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, November 15, 2021 09:46
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: Re: [PATCH v2] drm/amd/display: Look at firmware version to
> determine using dmub on dcn21
>=20
> On Mon, Nov 15, 2021 at 09:36:55AM -0600, Mario Limonciello wrote:
> > commit 91adec9e0709 ("drm/amd/display: Look at firmware version to
> > determine using dmub on dcn21")
> >
> > Newer DMUB firmware on Renoir and Green Sardine do not need to
> disable
> > dmcu and this actually causes problems with DP-C alt mode for a number =
of
> > machines.
> >
> > Backport the fix from this from hand modified backport because mainline
> > switched to IP version checking which doesn't exist in linux-stable.
> >
> > BugLink:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1772&amp;data=3D04%7C01%7Cmario.limonciello%40amd.com%
> 7C6601c50631344fa7148208d9a84f050a%7C3dd8961fe4884e608e11a82d994e1
> 83d%7C0%7C0%7C637725879609631767%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> 7C3000&amp;sdata=3DjIGJARLqpAL6Vc6AyK8qVj1yZ7qFm5sXFj%2FerhoMEUc
> %3D&amp;reserved=3D0
> > BugLink:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1735&amp;data=3D04%7C01%7Cmario.limonciello%40amd.com%
> 7C6601c50631344fa7148208d9a84f050a%7C3dd8961fe4884e608e11a82d994e1
> 83d%7C0%7C0%7C637725879609631767%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> 7C3000&amp;sdata=3Dt8iG0MlBgncmZ5Py%2FhWuWBHMbSCCK%2BtFTV4faxcl
> N3c%3D&amp;reserved=3D0
> > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> > ---
> > Changes from v1->v2:
> >  * Update commit message syntax for hand modified commit
> >  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> What tree(s) are you wanting this backported to?

5.13+

Thanks,
