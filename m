Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9214212AD2B
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 16:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfLZPFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 10:05:01 -0500
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:25056
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726453AbfLZPFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Dec 2019 10:05:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+8xhrSNqDg3xhvw8rvieRK5LPnLgN/IgiUFvsEEBQrsQWehjmLdB28cTqdIH24qeF2bvBJUFZymGlHmzsOwuU6Eoq0uEjcG4stXEcMGj6XrGHjBTF+IklVndREzsCvaJuUoUJkZk3UvwrPkoAzQDcVG9Jlf4FagnCq4uvX3DdWl/ODOH2SssW5VRb2XMxKsj2iqL5iiaE9zgd4MJK/KtPt77i0Bm9yQMb3j9u66jqDz9y9lqJA/ff65geAHgtT2FcWUs2sdx6LWoLewBDwX5AV1i4llJpGyq8JzUKn66YuTtzDKE3ieHBlEd3ml5GapR0c4DbeehXd1MoVIAJIQ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1GAEArwlIIvOMMaDzbf9fB5RJGrRHFMbMwN8tDwrWA=;
 b=YLCXqF1LQlo6MDdYY0SBzxV6Wzrs2cCMPrJv6g/V8WirQU49Sbi4IjMTt0PyYjpkxk7xZdsRzK6xlgUPcJ+W9NSoXMUG+UaDxAii5j31favFzkHXEymrAANfStFjY2V2gOV4NVtmMiagz/LqEV4qrW5t18VLFcCz2Ol2Jo523c9KWZ8woYv9ARA/wOVE2+03sGa295s8UiauZJ5HwnzT7IEhgzpjwxrlHTpvpayPUwY7/QgAsf/Liol9p/lFI2JPTKlsTkIu1W340f8VndmE+gZfWeUtOYQddumBw9efpUpIteApMZ/SevHi5wwWHufr8CoX6QE8znODG2Eef097gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1GAEArwlIIvOMMaDzbf9fB5RJGrRHFMbMwN8tDwrWA=;
 b=G2N3DWLcent7Sa020qHj1WKawW+OT+6759HnWVNQHdD0+k9ztx9v5qNKRO4SSmcY9PCG24w7WL0BFqz8Blmq5hcg3j4ybaTX8+2fwRLjSFC1Rk+kMFXu3xCU/9X6wLivn7t8cigHv/5sktyZbYVW7Hj963hOfFeAzO6Ep5LfVxk=
Received: from BYAPR12MB3013.namprd12.prod.outlook.com (20.178.55.219) by
 BYAPR12MB3606.namprd12.prod.outlook.com (20.178.52.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Thu, 26 Dec 2019 15:04:18 +0000
Received: from BYAPR12MB3013.namprd12.prod.outlook.com
 ([fe80::ed87:95bf:7c40:3fa5]) by BYAPR12MB3013.namprd12.prod.outlook.com
 ([fe80::ed87:95bf:7c40:3fa5%7]) with mapi id 15.20.2581.007; Thu, 26 Dec 2019
 15:04:17 +0000
From:   "Lipski, Mikita" <Mikita.Lipski@amd.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "lyude@redhat.com" <lyude@redhat.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/dp_mst: Avoid NULL pointer dereference
Thread-Topic: [PATCH] drm/dp_mst: Avoid NULL pointer dereference
Thread-Index: AQHVu5TOqUe8yqwXk0mualXCY3AL3KfMg5SZ
Date:   Thu, 26 Dec 2019 15:04:17 +0000
Message-ID: <BYAPR12MB3013AADBCF71055D3AD3288CE42B0@BYAPR12MB3013.namprd12.prod.outlook.com>
References: <20191226023151.5448-1-Wayne.Lin@amd.com>
In-Reply-To: <20191226023151.5448-1-Wayne.Lin@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Enabled=True;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SetDate=2019-12-26T15:04:18.123Z;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Name=Internal
 Distribution
 Only;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ContentBits=0;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Method=Standard;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Mikita.Lipski@amd.com; 
x-originating-ip: [178.125.212.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e89750ad-c45c-40da-c899-08d78a14e14b
x-ms-traffictypediagnostic: BYAPR12MB3606:|BYAPR12MB3606:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3606D816B438F74C8B3F6C1DE42B0@BYAPR12MB3606.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02638D901B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(51914003)(199004)(189003)(7696005)(6506007)(316002)(478600001)(66946007)(5660300002)(64756008)(91956017)(53546011)(54906003)(66446008)(66556008)(66476007)(52536014)(2906002)(110136005)(26005)(76116006)(186003)(9686003)(81156014)(8676002)(55016002)(8936002)(33656002)(81166006)(4326008)(71200400001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR12MB3606;H:BYAPR12MB3013.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C0oQnuKk0q0TTQQt7DPzK5kvlIZmLBDi/fBx8YDS+6A/iggaPNERCRCbiD/3k5vIFtmA9IACVjbwj+eIknVaJ9LZ8zFL8CvJsJiDwXTw5clYMUyR/1O9pgoi88UOngP+tMGz+N+QnKNfZaPUVJQurT6wA1N23oVW/Y3A6ayYeytB2J9Pnr5FlBKZBuE2VWMXPuWZ9HgM9JBylH9o7BVwNgkqSmihcN0H6gTOBCGgtis0KCerlKOf4/QBr/UksJnab5q7NOK2H19sk99EzsyG3l14GFnJ9b7CIJBFzM1Hb6M3VsH8I8SiRL6sSC7mTOKbE6mxdGomcSzYcIbI3jAzJuis9z+9+pFdM1nx0PF5qkjXHgiN73MpOp2yWf+EqJJAcoHaDIVCZwNuK54etG9+IjDchpQdszyIEjyexHGQ0ipnLivrmXgo0Izx8B6bb48Q5QbYOwEXm+dC5CwcdeN1C1i9/8Vik6sv7kbbUv1ChtQduoDVU9hSBA9d3tenr9cO
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89750ad-c45c-40da-c899-08d78a14e14b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2019 15:04:17.7355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Itp0baOmjDN/UtjKXFZH3PA7FucKegIcHpjAc1q25r/r94s6y1YDyDbpYk+sHSE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3606
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - Internal Distribution Only]

Thanks for the catch,

Reviewed-by: Mikita Lipski <Mikita.Lipski@amd.com>




From: Wayne Lin <Wayne.Lin@amd.com>

Sent: Wednesday, December 25, 2019 9:31 PM

To: dri-devel@lists.freedesktop.org <dri-devel@lists.freedesktop.org>; amd-=
gfx@lists.freedesktop.org <amd-gfx@lists.freedesktop.org>

Cc: lyude@redhat.com <lyude@redhat.com>; Kazlauskas, Nicholas <Nicholas.Kaz=
lauskas@amd.com>; Wentland, Harry <Harry.Wentland@amd.com>; Lipski, Mikita =
<Mikita.Lipski@amd.com>; Zuo, Jerry <Jerry.Zuo@amd.com>; stable@vger.kernel=
.org <stable@vger.kernel.org>;
 Lin, Wayne <Wayne.Lin@amd.com>

Subject: [PATCH] drm/dp_mst: Avoid NULL pointer dereference




[Why]

Found kernel NULL pointer dereference under the below situation:



        src =97 HDMI_Monitor   src =97 HDMI_Monitor

e.g.:       \            =3D>

             MSTB =97 MSTB     (unplug) MSTB =97 MSTB



When display 1 HDMI and 2 DP daisy chain monitors, unplugging the dp

cable connected to source causes kernel NULL pointer dereference at

drm_dp_mst_atomic_check_bw_limit(). When calculating pbn_limit, if

branch is null, accessing "&branch->ports" causes the problem.



[How]

Judge branch is null or not at the beginning. If it is null, return 0.



Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>

Cc: stable@vger.kernel.org

---

 drivers/gpu/drm/drm_dp_mst_topology.c | 3 +++

 1 file changed, 3 insertions(+)



diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp=
_mst_topology.c

index 7d2d31eaf003..a6473e3ab448 100644

--- a/drivers/gpu/drm/drm_dp_mst_topology.c

+++ b/drivers/gpu/drm/drm_dp_mst_topology.c

@@ -4707,6 +4707,9 @@ int drm_dp_mst_atomic_check_bw_limit(struct drm_dp_ms=
t_branch *branch,

         struct drm_dp_vcpi_allocation *vcpi;

         int pbn_limit =3D 0, pbn_used =3D 0;



+       if (!branch)

+               return 0;

+

         list_for_each_entry(port, &branch->ports, next) {

                 if (port->mstb)

                         if (drm_dp_mst_atomic_check_bw_limit(port->mstb, m=
st_state))

--

2.17.1



