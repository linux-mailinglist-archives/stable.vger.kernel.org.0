Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6249116300
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 17:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfLHQW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 11:22:26 -0500
Received: from mail-eopbgr10061.outbound.protection.outlook.com ([40.107.1.61]:63909
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbfLHQW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Dec 2019 11:22:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wk04mAaG18VpxCK+XV++OHypQwVFCwaNOXxTn8Jv+qjRnHgsZKXRQB7M/4iFTnCC3dIE1gdpEuqlI+n65O7GWzJjVDV0CcfTqHjNxb30MQCsEJAEo+B8iWtWiNogV7e5MMha67LrDQysPTTHdUNd60pSS+tOmmmZnsVgI3b6vwwQBfG9JqDJWWFc762bGA8mbwfp+bmUbJfexS1CWMDIEl+BvPU+JX/OqU8RjGcZbZRUjYGNYtT/c5SY1N2Z2+IWno362QrdI0ATOn4WJGcWqeQoYAlQm8phtjcTwH93zE7U5/DZGhKZ3kOM7u8PLhFlZN6wj2vEV6zLUN4iAhbGUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+0zkJCswDwGT2QabveuRGVXEWQoofWbYIiABTJVLys=;
 b=VVtob/9Dgs0WPT6BdCn6LfX3qDnUcQBM6HBVuYUvZEbesJDw4TcIDBMca8F+lsfXB3YRMZewkAM3dTtwA7zdlkBirdUq+d9hrmJMIYnHPVeEhmce48hCgmIjBJHoM3wwWvQNrx8H65rM2RGf4tsRniiZzjszbkkFthkjeFKYsXxgoGO58i0+/OKjTRH0A4ycJZa8D7ESyDuyqkzCwYOSasP3cFzoVUA6R54Ih3wNRe1JfuaFaKUJmKab4H/9/r6UFWpbZHpjeMzZgUvlSHz6Ah8X91KPUuJKcVKkJREeYYep/tbGS7DSsYEjCwvKv3GKaBk1/e5wa9NHh3xcTRPh7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+0zkJCswDwGT2QabveuRGVXEWQoofWbYIiABTJVLys=;
 b=ty840IIS/FVRi9aestEy2b8Q6qrJR5b4NSkZt731/smyVuXBCKhqxvrUJtpDe4iPh0S2xPWk1BUd6wtwSy1FWN88q/Wou4aYJTBAHvr5y8XhlDTaVM1KI9tn/GiNcEOR2W83I7n451oPyZlnH1YX8+qz0l3Pc4B8pF6RvckI8Es=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB5178.eurprd05.prod.outlook.com (20.178.42.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Sun, 8 Dec 2019 16:22:19 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::c18d:99a0:b973:685e]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::c18d:99a0:b973:685e%6]) with mapi id 15.20.2516.018; Sun, 8 Dec 2019
 16:22:19 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Ben Hutchings <ben@decadent.org.uk>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "wvw@google.com" <wvw@google.com>
Subject: Re: [PATCH 3.16 43/72] thermal: Fix use-after-free when unregistering
 thermal zone device
Thread-Topic: [PATCH 3.16 43/72] thermal: Fix use-after-free when
 unregistering thermal zone device
Thread-Index: AQHVrc8N/eZVk0ubv0iT/v06kKfr2Kewa7EA
Date:   Sun, 8 Dec 2019 16:22:18 +0000
Message-ID: <20191208162216.GA330015@splinter>
References: <lsq.1575813164.154362148@decadent.org.uk>
 <lsq.1575813165.267246545@decadent.org.uk>
In-Reply-To: <lsq.1575813165.267246545@decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0173.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::17) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [79.182.107.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5592f9bd-f0e8-4eda-da8a-08d77bfacbd3
x-ms-traffictypediagnostic: DB7PR05MB5178:|DB7PR05MB5178:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR05MB5178F53010E3BA751CF05E37BF590@DB7PR05MB5178.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0245702D7B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(39860400002)(396003)(346002)(366004)(376002)(136003)(199004)(189003)(229853002)(33656002)(1076003)(478600001)(6916009)(4744005)(54906003)(6506007)(4326008)(26005)(102836004)(76176011)(8936002)(52116002)(99286004)(86362001)(186003)(316002)(71190400001)(71200400001)(64756008)(66446008)(66556008)(66476007)(5660300002)(66946007)(81166006)(8676002)(966005)(81156014)(305945005)(33716001)(6486002)(2906002)(6512007)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5178;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BiJGKAMcQ+sSkNDc200RbsfcD6dpk0hC/VDMezsWJPm6BaZQX7CZTYEPYRl00lMIEjx4ZFS1IaqmZ5WIBy6ADnJjVqD0bHgJzgFs7WO/d88CPsS+BFx7El+J2F4M3aDg8DXn9vlv9rm5w832mE68EXudNqRnWW9Wwuv79Rh4ZKgGrpMalhba8mb9qAaOp44c3f7WSAuIi68Nlz4igUfpKaGRB5ljZhk0MOrscArmgPzb8O3AwvDOHK+QbPXf0z8R6l3BGG91FpMTime10ujlKmFeuySbLTxQ/3cY89MqX5n8a06PEgGUiTjJAP0ncZW1Y0d6CZDVUZYGjw+gVc5FXOjbt+UKq66IYctoQX++vE99/486PgQij7sHN0e0aULpKgU08T6+zIxuFyo+msrmqQfpe7jby2Y2NiwMIPyqepFMjWq0KwvVWthY1uLFqROnrqrsJkVeb9ZRV08lftqJZ1CRZA/3n8Jc8ZNLRIeGax8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F0C62A250EB1AB40BFE5F73E2863965C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5592f9bd-f0e8-4eda-da8a-08d77bfacbd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2019 16:22:18.9283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vqFsjqlo4SBlB/y+cyC3F1pRmaek1ZR0rIVjXUtmZjyXBMCMIv4dIvWt2tK471RGawwF81TPUUgCp2gUQ9jwBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5178
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 08, 2019 at 01:53:27PM +0000, Ben Hutchings wrote:
> 3.16.79-rc1 review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ido Schimmel <idosch@mellanox.com>
>=20
> commit 1851799e1d2978f68eea5d9dff322e121dcf59c1 upstream.
>=20
> thermal_zone_device_unregister() cancels the delayed work that polls the
> thermal zone, but it does not wait for it to finish. This is racy with
> respect to the freeing of the thermal zone device, which can result in a
> use-after-free [1].
>=20
> Fix this by waiting for the delayed work to finish before freeing the
> thermal zone device. Note that thermal_zone_device_set_polling() is
> never invoked from an atomic context, so it is safe to call
> cancel_delayed_work_sync() that can block.

Ben,

Wei Wang (copied) found a problem with this patch and fixed it:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D163b00cde7cf2206e248789d2780121ad5e6a70b

I believe you should take both patches to your tree.

Thanks
