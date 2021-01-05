Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA672EB05F
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbhAEQmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:42:06 -0500
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:14689
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729152AbhAEQmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 11:42:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROne+Fxnw2kRrgvzaXLRgqJFAnembX4dYWEM6GkTL6M27YMAnuI1ir3QK2ATAvvQ+wR5C5tsV7xMBYRPi7fhprO0PS48R9OJii/ZLYFuVa0RCI9Hr64ynqrXmDH3kaUGDC3mg53KFRxagK0qd1YY8L/gj6sapVDubhdlyCk7tmdII7VCiZ/TMyGx3TxtuBYdqjnsjJDufzYGcTbtylu8XAZnK7E17JVGkJ+HNquSEGUiqW7p77juuR7cw2TfunJ1PZfp6uJ8HCW8xOA6tAgBhntps2dFe73C2oHV1COg6EpK8Mbu5Usvo1vhIOpJjg/eJUv4mVUP+0rDaq0/BSSxTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blgrJqdScbz9PWvKO2tT1RIFpMPsGGwyCpG/WsuwOcY=;
 b=BuoRhW6uUuY8uEC6p5JglHRJoaaJd/SFTlwDhbM863IwDMS+etKUUS1DR1/6hkw1C60jeUYbPAfA7rZO50piUjfQK9Lxq+eHM7PeWRDrmrNOo4Ggnone3bbDuW4g51gurv4UQDDXdGpnF7COfpXjA6wandO3Y8EPjqYKeWvHVzRuexUPCiC7gUVICb6aQRznPbucABVuS9jIkh97xNu/KPsgDwy+FcBVCbpq/vvgoCSGkXalFYWQql2HuGgp57QvZR804Vubqk6tWopx7PKaWPUhBdZ7nCX+1DjyRWmrDr2oH2PypIFFlbzpFI8C5ITMBtt/Df4OjCAG996tICsS/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blgrJqdScbz9PWvKO2tT1RIFpMPsGGwyCpG/WsuwOcY=;
 b=Q9gLTd8mJl5+pITorvs3mqO7AzUKQLvGAr0USb3jlYvnz6NM4vfNbsQPEtjP4YMG6fCeBwT9vbAzQUAFpvjeb6FUVwefnacdMQVpX0HI5OdQZDmO5kHlMoqrIGyzvLwbXq+K3QTvN9Su9qzi1Ff4FakNxbKajlMOMqr5mN99ZKk=
Received: from MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18)
 by MWHPR12MB1933.namprd12.prod.outlook.com (2603:10b6:300:10b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 16:41:10 +0000
Received: from MW3PR12MB4491.namprd12.prod.outlook.com
 ([fe80::5c12:3aed:288:11f0]) by MW3PR12MB4491.namprd12.prod.outlook.com
 ([fe80::5c12:3aed:288:11f0%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 16:41:10 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Andre Tomt <andre@tomt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>
Subject: RE: [PATCH 5.10 637/717] drm/amd/display: Fix memory leaks in S3
 resume
Thread-Topic: [PATCH 5.10 637/717] drm/amd/display: Fix memory leaks in S3
 resume
Thread-Index: AQHW3SXJd+MYEQEZK0Sr5La/AT9yfaoX3nYAgADGWACAAKGbgIAAAhhg
Date:   Tue, 5 Jan 2021 16:41:10 +0000
Message-ID: <MW3PR12MB449192B8AFE4EB288EB125BEF7D10@MW3PR12MB4491.namprd12.prod.outlook.com>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125051.444911072@linuxfoundation.org>
 <e5d9703f-42a4-f154-cf13-55a3eba10859@tomt.net> <X/QNCtpIiU5qzRp+@kroah.com>
 <8db47895-e7e4-ed9a-e996-c071b5c6f750@tomt.net>
In-Reply-To: <8db47895-e7e4-ed9a-e996-c071b5c6f750@tomt.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-01-05T16:40:56Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=66a5f3da-ab97-4143-aa65-0000722d6577;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_enabled: true
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_setdate: 2021-01-05T16:40:51Z
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_method: Standard
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_name: Internal Use Only -
 Unrestricted
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_actionid: d3e80375-9a97-440a-a9e7-0000ed086283
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_contentbits: 0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_enabled: true
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_setdate: 2021-01-05T16:41:07Z
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_method: Privileged
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_name: Public_0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_actionid: 1c828ea0-0c90-40d4-ba80-0000f10fc71a
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_contentbits: 0
dlp-product: dlpe-windows
dlp-version: 11.5.0.60
dlp-reaction: no-action
authentication-results: tomt.net; dkim=none (message not signed)
 header.d=none;tomt.net; dmarc=none action=none header.from=amd.com;
x-originating-ip: [165.204.11.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a0a1932b-0859-49f3-8e14-08d8b198b55b
x-ms-traffictypediagnostic: MWHPR12MB1933:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR12MB1933B7C7739013F4EF165F43F7D10@MWHPR12MB1933.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tO5vUWYUuljWLeTXK0wbNv3vsTZXVhvbjwGaLNxizcpb9sGZA4jW+GYoDXrHzgcBpyXFSXTwNHONbIxOekYS/8W736TO+uJaKlicPhc/DRE1OX/d2ZzUXfqytSh/QmjsGuanr33qM/Jp42WRpFbicJhWNYf5CAQ1jSnCxRjplm09giuQFac2K0JEO4cGQKXg4qz/YzIUDlWTDjdA6zbxi4MMp4JKZgLtNKUCwlKL3opnlINDVQ07wIovtmN5fWU54k01sJiR4IdD/rOTAIwXEuseQtzHejgDpfccZIm9OmK0b3hmW5gothFAxOu6+qRlSJ5GreQTH554c63E38/g8pPl59fmvM2BAzUxtqozSrQuJg1VKXX68y4AEWTJbiNOJTsPpy9rFlmAQPDMjqwfuY+z9bo4pNh/2Z0fS3pnew1n4+ExCELqSHbxd4yht8WxmkcaySHLgQtRZEx/3wRSRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4491.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(8936002)(76116006)(5660300002)(66446008)(52536014)(54906003)(26005)(7696005)(6506007)(53546011)(9686003)(64756008)(66476007)(66556008)(83380400001)(66946007)(186003)(2906002)(55016002)(8676002)(45080400002)(33656002)(71200400001)(966005)(316002)(478600001)(4326008)(86362001)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0fIXsowTaI/M+bdI+AOBuYs9PB0yvPHgfbLI7C55UgYwqGz9qMjMjvvsa67G?=
 =?us-ascii?Q?rwo+3K24R+FA9JyXBjanN6AHoWt/QDNLdKD0W6b2A00booYUIpPy11UDGLby?=
 =?us-ascii?Q?APQ/MwVAj+UxEu4IwcHzCAg8ehSdKpGBUBqPjNlFV+eudCpg/WSyMkJoscw9?=
 =?us-ascii?Q?+Dfc8dlRmV/GqzTKXU0c6cr73MJqsJ/xuvRzszApCtzqz3D4CNRxna6nj9zh?=
 =?us-ascii?Q?42mCNS4P20wM+Ah6l0mfL1NbYF3jDTQ8DRimcbR1QzaR5xj38NfOp7aMNaJw?=
 =?us-ascii?Q?1PBXGbRAuHKciIwTdsrQTL1ddGYYmBfyjXfzClWA/1WLa+uqNLHnE+xzhaF1?=
 =?us-ascii?Q?Lq9J3QL//UgCHzXDccDDRkmGkfv/cHMK1wLLZ/7QT57i+oRDiaJ4M5MSzfuH?=
 =?us-ascii?Q?ORR7d99ZJbBWwRbJl0a5MNNOxeq40f+By45f54Z1xRIVSGMWxu116yOoGZhu?=
 =?us-ascii?Q?FAoOjCl3ArP/jxbeE4Lr5nT9TuTyHEq1y28P4bB7G6WqqUOwL4NeG2LfdCHY?=
 =?us-ascii?Q?Ezg6r19f6QJN9VQFu246aCd0V/Mza4X9DvzQUVt55GYuYATSRC/YMOn+hyre?=
 =?us-ascii?Q?Gyy2kvxFKZN8CNecJAGFsdMzzWXI5Stire5Wa5FJleRiUs4ZMwbydcW9VyFW?=
 =?us-ascii?Q?k+BZRAV9NaGyEIk5mRCjWIrichFeqkX7kxQXex7BPO0t/CHPS4fKHlbBLjiD?=
 =?us-ascii?Q?Ahclyz5k/yvF03s/oj8vu/EKJ9gBt9ZwQijxZTm9ZePLJzDJud+ZeM0Ma8lQ?=
 =?us-ascii?Q?HXHLbHRBF0fwb/PT645r4i19oM+hVEDTxc1CjKdE5mmbzzNuFOXYRg6X1ofw?=
 =?us-ascii?Q?Y1c1ziHHmq/Y+toXKq9DRdVS5RAtgAISLwTOseGBxLvGDI7cp//uFZMS9zBZ?=
 =?us-ascii?Q?mZ/58cOatmef+NYEFclqzga6ZQtndDtcF77IU2nCiSYU0HP+FfJd2QVw+kTU?=
 =?us-ascii?Q?vDBeCFymW6+q3XbJhQzxFo/IR43kwg3cZgcqiTYoHfI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4491.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a1932b-0859-49f3-8e14-08d8b198b55b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 16:41:10.7970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U+MS6xsJCurAN1wfmlrFYAK7jOgX5U13Y7KyAmAQ3snSkFOftaV1elYT8zDHqbHMP6TDlgzPeA4ejdthdz5F4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1933
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Andre Tomt <andre@tomt.net>
> Sent: Tuesday, January 5, 2021 11:32 AM
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Wentland, Harry
> <Harry.Wentland@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Kazlauskas, Nicholas
> <Nicholas.Kazlauskas@amd.com>; Wang, Chao-kai (Stylon)
> <Stylon.Wang@amd.com>
> Subject: Re: [PATCH 5.10 637/717] drm/amd/display: Fix memory leaks in S3
> resume
>=20
> On 05.01.2021 07:54, Greg Kroah-Hartman wrote:
> > On Mon, Jan 04, 2021 at 08:04:08PM +0100, Andre Tomt wrote:
> >> On 28.12.2020 13:50, Greg Kroah-Hartman wrote:
> >>> From: Stylon Wang <stylon.wang@amd.com>
> >>>
> >>> commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362 upstream.
> >>>
> >>> EDID parsing in S3 resume pushes new display modes to probed_modes
> >>> list but doesn't consolidate to actual mode list. This creates a
> >>> race condition when
> >>> amdgpu_dm_connector_ddc_get_modes() re-initializes the list head
> >>> without walking the list and results in  memory leak.
> >>
> >> This commit is causing me problems on 5.10.4: when I turn off the
> >> display (a LG TV in this case), and turn it back on again later there
> >> is no video output and I get the following in the kernel log:
> >>
> >> [ 8245.259628] [drm:dm_restore_drm_connector_state [amdgpu]]
> *ERROR*
> >> Restoring old state failed with -12
> >>
> >> I've found another report on this commit as well:
> >>
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbug
> >>
> zilla.kernel.org%2Fshow_bug.cgi%3Fid%3D211033&amp;data=3D04%7C01%7Cal
> ex
> >>
> ander.deucher%40amd.com%7Cad673e351bab4f6af94508d8b1977ed8%7C3d
> d8961f
> >>
> e4884e608e11a82d994e183d%7C0%7C0%7C637454612140560971%7CUnknow
> n%7CTWF
> >>
> pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXV
> CI6
> >>
> Mn0%3D%7C3000&amp;sdata=3D8Rsnbfh4P5GmFUlybb31mT7C0Ee4vDInxJ1gt
> C3jrVI%3
> >> D&amp;reserved=3D0
> >>
> >> And I suspect this is the same:
> >>
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbug
> >>
> s.archlinux.org%2Ftask%2F69202&amp;data=3D04%7C01%7Calexander.deuche
> r%4
> >>
> 0amd.com%7Cad673e351bab4f6af94508d8b1977ed8%7C3dd8961fe4884e608
> e11a82
> >>
> d994e183d%7C0%7C0%7C637454612140560971%7CUnknown%7CTWFpbGZsb
> 3d8eyJWIj
> >>
> oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3
> 000&a
> >>
> mp;sdata=3D1149tCcm3rcaj1MkVPbWqWhWFIPgkeBoYxo0oVv%2FzNI%3D&a
> mp;reserve
> >> d=3D0
> >>
> >> Reverting it from 5.10.4 makes things behave again.
> >>
> >> Have not tested 5.4.86 or 5.11-rc.
> >>
> >> I'm using a RX570 Polaris based card.
> >
> > Can you test 5.11-rc to see if this issue is there as well?
>=20
> Just did, and have the same issue on 5.11-rc2. Reverting it also solves t=
he
> problem on 5.11-rc2, as it does on 5.10.4
>=20
> FWIW one easy way to reproduce seems to be unplugging and re-plugging
> the HDMI.

We are looking into the root cause, but I'll send out the revert for now.

Thanks,

Alex
