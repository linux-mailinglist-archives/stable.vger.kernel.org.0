Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EAE6CF984
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 05:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjC3DXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 23:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC3DXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 23:23:50 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020024.outbound.protection.outlook.com [52.101.56.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C92D2703;
        Wed, 29 Mar 2023 20:23:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqbdsPmGmxFABTLRDZeaOpLeG1HV3AF0OfyAudpgVRdB/GElrn+Mp1d8HMIewVM9xPy5AjQ/3UfcrFfTT0ZEHaa80se7MlFpVXU77zPYTtJTR0wjFRtNCARnDyT37GElqmBeVl2DzKnAT3SgRBlMnBsV/BmReZcBZEOJi7syd75y6fAygdJrpUivycWtb74nGs7C2HpO6CZTXbJfQHI3/aLz2rrkU8312qokeqMtZ+9KyAFTxdo7m/3DYO7TSlEmpXsMWyK+ocd8V3UliWd1Clxz79WXHV+aONOwFfl09u6aW/3+CzpPbD8gEcwn/n0glDKLwaYR0dOEAgDyantF+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UB1Lk2oE8E2h88KNW456AsQ5fPelmAq5Hdzj7sLIAUY=;
 b=HT4M11qdwZTAwOfrQjTG7jlYuuwk7LMXxW26GS8nW3XXMBS4ef9ABO5boGaD0xtFNW/yCwmH2ad1/mMT/oOPnP96pEpIuA4iz84JKcbgpe/lNVISCYyrkGVmdkcO+I9/FzV8HodmnpGOzB5kSascKUZ7JbRZ3lxXGf61RF6XDTVR3sHL/UKo87uk1tuytCLh8rhIixewU6NbbSdK0NXPUK0v5v4s1rodKhJvEGnSdxblv/uoYdTmZyTn7TngiAWZX4tqw9S4kJMSvdz6qNcKYmodIpsQ7f21/uKgpnFVhcQG7fRDoi3kSYBIUy3MNFSSm2FCESa8K5KJLFZfrNZJPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UB1Lk2oE8E2h88KNW456AsQ5fPelmAq5Hdzj7sLIAUY=;
 b=U+0aGA7fu1oz9QQ97dmPoct/hbIYeeIxsAI9QztxzxZwXWKC8HRS7Caa3Ts+/6QFLRuMo88ayFcQN6aZfwVnS8+lleX8LUyBs3GznAiLgGTUdldgRHxODi/3oFcHus9+cq2gpud3tMUjyLs4HxBdQFt5AkYoaWJmWiVaPIPYbYU=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by PH0PR21MB1896.namprd21.prod.outlook.com (2603:10b6:510:15::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.11; Thu, 30 Mar
 2023 03:23:46 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6277.013; Thu, 30 Mar 2023
 03:23:45 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>
CC:     "quic_jhugo@quicinc.com" <quic_jhugo@quicinc.com>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Thread-Topic: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Thread-Index: AQHZYrMXe0Y6kEKNA0yWUzOcmG4VZq8Sosvw
Date:   Thu, 30 Mar 2023 03:23:45 +0000
Message-ID: <SA1PR21MB13354973735A5E727F94A169BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20221027205256.17678-1-decui@microsoft.com>
 <ZCTsPFb7dBj2IZmo@boqun-archlinux> <ZCT6JEK/yGpKHVLn@boqun-archlinux>
In-Reply-To: <ZCT6JEK/yGpKHVLn@boqun-archlinux>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f0e2d82c-9be1-40d3-8693-5b81e75f3725;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-30T03:02:43Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|PH0PR21MB1896:EE_
x-ms-office365-filtering-correlation-id: 3794a99e-a024-4dc1-863c-08db30ce2b7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /pRlqWRqxzFHfJPSoMzMXbP+4sMct/vjQy9sn6qaBd5TaqfmKTE8ppiKH8ZGWeMOYCPf7T0MHCR/Dh3ESmT0bHN+wSzzw1qRTG1VSnSOKYsly/55+Sh8FuFV1oNcqrJOpY2BZp3tbnAr+5zi2+cEULznSxkh7VYvNvkKScpQblQ0Q0+7qtab4xhVOmzat3/zoZeYT7PRI0RlxBQplvhbg6iTwKn1Qgacxm9Mt5d9xfG4Ihj86dqFpwXl0KC5e4Z51WVYaPXAakIbAxjHHwYSQGQhVpoYMqXjeGyb0/hMbvbrA4ansQbR202o9ARZgFam3G4QvKlHeVnzeeNqXG0XYVqMeO+g9PCD0Brd1QONv6oCUWOg6l6c7iP3vwJqrgoGPAP4vjF4N8o1NHxQLVb6GL9ZueQlEqg8J5CG0TOZjJHqTajYyy2elM36WtI2e4wbm7mH4zDDVcTsj22snZqkoll3I1nGIjV40TbjNEhx9XvVr9igHggq95WS4c2LuxU/tcvB0Zw9YRjag0zwlBKzfJPVgeq2pTlbPpI8HdCT+otAwzJp6CSO5GSm3iYAk3AY4cllN6lrs/ZH+9e5ZLjGTkpUGP856brpT8AF7n+mdWBn6v9GNLZ1brrCG5GVIEx9DZimQMIG/QbPHQP6V2oDyjW77yJGQYdQFuvA1CAjZgs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199021)(316002)(786003)(54906003)(186003)(122000001)(38100700002)(55016003)(38070700005)(33656002)(82960400001)(82950400001)(478600001)(10290500003)(71200400001)(9686003)(7696005)(6506007)(7416002)(5660300002)(53546011)(8990500004)(2906002)(41300700001)(66476007)(66556008)(8676002)(64756008)(66446008)(66946007)(6916009)(4326008)(76116006)(8936002)(86362001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?81JEvRcxB36M5lm3arfXPADKyVUZ6EUa2euHlbD2EkdVrYGiHry/iFDie8AL?=
 =?us-ascii?Q?ujeR1oA/QKgCn/5M4HFl5W2AN27I0+CU+GD7a0zHous1jX8H5GSh+qbF+WZU?=
 =?us-ascii?Q?3GTyZ7++WGYhOHsNrdnBRy4LAQ2SiuHNFNzSvnnD7VVngY3vh2/xp1VS8m8P?=
 =?us-ascii?Q?Mn4fjhPYgHkdszfYYAscByNdR446yqI3aJWqiTyd5eXQCipUEIadsYzJslEd?=
 =?us-ascii?Q?3D/tqbIr42iDejgc0CWJLCXpJSlCUtRBZTUwIWKLgUrZz50X8YGRsPstqLwQ?=
 =?us-ascii?Q?chgNQ1FxMGMLEtHQ6grw5t0ACDFejTc04YIUkNmpwKR4gJIs09c0nOGGkOhq?=
 =?us-ascii?Q?K+wX863cXXXB1AYZY2HJaZjqJAoQHjsihbUju5BT2bngDr8og9uV5BQAfq/a?=
 =?us-ascii?Q?QkX6+rrBfOXgfqRO16nH62wDteJfiPDBsh183qi/KMNTpGrKcgRR+qWglz07?=
 =?us-ascii?Q?q2at+SNukWohrZsMnazh7WnvLLrCit4nwwAYRDzBZcgX/NFjV8D3XFrp4ZZt?=
 =?us-ascii?Q?8Hj0UAmXC00nagLAe50i4SQfRXeDFvWXIvZ26RBtUEG3MgeykHDfGFdhI9JE?=
 =?us-ascii?Q?gGEwTewgXXolIOyNS3MXjO5JvJlKyofJZ1CpD72GiL8GCVbSb5e06wDvAKJH?=
 =?us-ascii?Q?nUmLJFKvlxviIaKbvk5irDpt+64uXvpDzgC38b4aK7j8ZxHVTVBIHn41vX9A?=
 =?us-ascii?Q?IMNnWtfx2xRdPwrNzKvdp60KuJ87c20qedYEofe3IV8CefMGi8EAbxwz/9Y7?=
 =?us-ascii?Q?z3TBgEF1PEv9kV0H0csWD6+H2azHcvUdrKJmgpRFC9EDxxAzObvmSD+T05EB?=
 =?us-ascii?Q?9PQBXSWmzJwk0UOJpfBwMNm6aC31jtRu6BOiN2tgylZtlRG9tCcjQc/WQFkK?=
 =?us-ascii?Q?vdyEh5OK6M/gNP5vMoEdVKWbwGFvy8ZpCjHUB8TDqvgVSZhXv2nwyMRsYvER?=
 =?us-ascii?Q?cMsjODsWL3sndBFYRzq4GxNeAbPv/XnEjGgkoa8iXn61YSbQBBYMxbZBJMt0?=
 =?us-ascii?Q?iBqmyVLfhZC8tEwQvuRzIgrG/KmrGGEQHnEI3rOlFNreqps2pAfm6Cav8lrX?=
 =?us-ascii?Q?qnoa9fzhH5DltYO0lFeXYnD34HCJo1en9l0nJgqFPkGLZ7S43Sc3NKkarRAL?=
 =?us-ascii?Q?AzAJ8qitQZLcfqJaNDFk2/BHAGLaEVF+apyxADqEHW3/n9VxNgJWNTz1gQFH?=
 =?us-ascii?Q?k60TPSywSlpmy2WuDo5q75I3SOso3MhODv7YfO5/Kwaf88l7nlECz1a+hXde?=
 =?us-ascii?Q?DwvGRFIlk0Wlpslu1v7fqnNt8XCcuBhg6usx7meP7+7EZYD0BNeaeNIguHLX?=
 =?us-ascii?Q?wxn2fzeejegzFRto8dgNPkxe/8RTDR9EO/F6aOyrkETx22CnXcWHz+xl12PT?=
 =?us-ascii?Q?H2T5jvptx7pM+J6eXNVcDHzebpBNif9PK0A2rspDLU7c5RQxL9CGLIknlXk4?=
 =?us-ascii?Q?PdpDIPelUNU2CxC+DiZnRGoNoi6jUX7mL1yrt00TdjbStXlgo0sbY/1p0vEh?=
 =?us-ascii?Q?TB/JKkuuKmUYz/uavlL9OIrNTm0HTa/X4iGW+OBTpM0ybTAHFAwKbqKUFvlx?=
 =?us-ascii?Q?7Qy6yJMyhS/Pc3rRtyOhUZfS34LsxlA/xnIQvAGPQX/KpTOsKF0D6M/J4+Gc?=
 =?us-ascii?Q?Si5/WmMWzPxGHw0tkHB906kbutqtP24UMMyYeXG2aTY/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3794a99e-a024-4dc1-863c-08db30ce2b7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 03:23:45.3706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7iXIiogQdzpBplkt9ApSrxr4k/sCWFLTXs3azqzlHMDBs2ClfjoobSuivONvUs6dxmPEkP2XLq8eb7mDMr7qww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1896
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Boqun Feng <boqun.feng@gmail.com>
> Sent: Wednesday, March 29, 2023 7:56 PM
> To: Dexuan Cui <decui@microsoft.com>
>  ...
> On Wed, Mar 29, 2023 at 06:56:12PM -0700, Boqun Feng wrote:
> > [Cc stable]
> >
> > On Thu, Oct 27, 2022 at 01:52:56PM -0700, Dexuan Cui wrote:
> > > The local variable 'vector' must be u32 rather than u8: see the
> > > struct hv_msi_desc3.
> > >
> > > 'vector_count' should be u16 rather than u8: see struct hv_msi_desc,
> > > hv_msi_desc2 and hv_msi_desc3.
> > >
> >
> > Dexuan, I think this patch should only be in 5.15, because...
> >
>=20
> Sorry, I meant:
>=20
> "this patch should also be backported in 5.15"
>=20
> Regards,
> Boqun
>=20
> > > Fixes: a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")
> >
> > ^^^ this commit is already in 5.15.y (commit id 92dcb50f7f09).
> >
> > Upstream id e70af8d040d2b7904dca93d942ba23fb722e21b1
> > Cc: <stable@vger.kernel.org> # 5.15.x

The faulty commit a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-M=
SI")
is in all the stable branches, even including 4.14.y, so yes, the commit
e70af8d040d2 ("PCI: hv: Fix the definition of vector in hv_compose_msi_msg(=
)")
should be backported to all the stable branches as well, including
v5.15.y, v5.10.y, v5.4.y, v4.19.y, v4.14.y.

e70af8d040d2 has a Fixes tag. Not sure why it's not automatically backporte=
d.


