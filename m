Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F030D531E4C
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 00:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiEWWB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 18:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiEWWBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 18:01:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EE037AB6
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:01:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKP4XYLU6UlbPmwpNBveV/vRmvxqbTPkGV1Zv2NYC2yUre8uL9Ep0GNAts6fD4cIVnb+4fbUeVBZ3qJ6qfH3sb92JzGllbsZsd4R4R6tZq/cS8HZLwZsffGIDdZZz3oX9i4VQoeSvA4/rEHNinCRrGkDfdi2Yc6UqVNVZgfNxZBv5KbBDFxSoMvGBXC7geO/68jPd5g4QDDjXq+wyWrKqP1bDKdint1e2HvAeLUkbEyoWtcZ8Ttc58DB/Cxx2KY15Wmo3d72jSQY/tRt1d8vM8/w5161tDXKVcJOsiOWwUdDEfp6qIpf7r3cW5Spg4TQdJV2aoO51+ml1+zjVFjkZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2uOeCzbnewXFKxStjf0uNnLBVaNri3vJzdG0UeNhvU=;
 b=Q47DZ4A+5scWI7iXgjWvjobEeG0lvyeO0cd9rS08pfGposy87ZlahLZlh1UfWpcpgXhttr6yxGDca8nld+r5A4K7nmiFN6PQNIG7RRB2A+uvfjeGSsqME+3NugBvdY78PTWT4yaFkcOBLcsl6G5JnW5kDxWkbijuYDzNFpsw7cxfMFoXzV5aE4uUIsIgdEYFoPdOBIzZJVckAQyHFQW85H7qlqJppWn8rAuBsS/zAINemBzcJPSt9OPQ0b4J1acbxOxj/U8dUydduhmSK6AkDXgkjeFW52Sa50awM4RMrbHzgThT5l/N910ByNYgrrS2Inc627/B8hbjVy8LtPN68Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2uOeCzbnewXFKxStjf0uNnLBVaNri3vJzdG0UeNhvU=;
 b=xTUAOUOCrPR/g7kTVeTMdfOLqD2bJSgsl6hEWBn3a52Xh/WeKvinmMdZixQ7mpIkpApVURhMdZxuBhuVm9SiAodX2HQOeIjbGh8G9OL4r33/1JGqV41ucxe1PnxHLkOx3n8tBcI7V29sEHssx6SroD1oDLX+hkcVmxzUpK7K+Go=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM6PR12MB2732.namprd12.prod.outlook.com (2603:10b6:5:4a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.21; Mon, 23 May
 2022 22:01:50 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db%6]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 22:01:49 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Christian Casteyde <casteyde.christian@free.fr>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Thread-Topic: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Thread-Index: AQHYabuPQo7dlCpjq0mwll14F3A0P60jViwAgADNTwCAAACrgIAAC92AgAhHWYCAAEM3gIAAUJmw
Date:   Mon, 23 May 2022 22:01:49 +0000
Message-ID: <MN0PR12MB61011E787AAAA98597A3A9DDE2D49@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net>
 <2ce8f87e-785a-25b2-159a-cca45243b75b@leemhuis.info>
 <2585440.lGaqSPkdTl@geek500.localdomain>
 <2408578.XAFRqVoOGU@geek500.localdomain>
In-Reply-To: <2408578.XAFRqVoOGU@geek500.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-05-23T21:51:58Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=8eff50c7-d37c-4932-b419-4aca6ebe7931;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-05-23T22:01:48Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 5b6af8bc-d7e6-4c0a-a9d9-5dac7dbdd38d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2056b8a-edde-4bde-e8fb-08da3d07d67f
x-ms-traffictypediagnostic: DM6PR12MB2732:EE_
x-microsoft-antispam-prvs: <DM6PR12MB273217B4892875F624482F66E2D49@DM6PR12MB2732.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K64Id63X5KYUw+NljPWkMAYtDHTPcGXqvEJZkFnyN+WJ8pJI5I5YulPKfNpXkFmuq68304sTqOvWq/GpSpsSg3Wjqsc5AShj22obIjskavgbWE96Yw5twPly3eHPqjp0TAi50vgtp5VwA5ya5fg01b+zortY1dhO8y50K6MWhqU+BguaBkBmXE7m6uFsEAbTma7xzf67WCmb00R+BN5AOZDrgiaQlMeiGAo2SRC1TyLg7tKeezsynSjdUg8XuYzgDcaGqiZWY7V10DN/mbLw95PMm2abbLzN1EThVTF5vUhzQImLFEo/3ZR1BIP2HZUl3YO7y2Wamavg/MTkkANeADljJxahvTEZ3FAr3fwsU6Fe5h07MX9Tv6dpk1mc05aqbshGF/wPgP/drXQZDuOcDvlhWnmRd0lg4ZoeaKDajADnFp699WWmDxbg2yvIjCTerW1md7xdoHEI6XzsYLoAq1A9INooSfMpdz0veskM1mU6/GF8je78sVK3UOTUSyZyL5p9/Z1TjvSaxgleh3Ms48DTemHCFJcFAkyS2LLlOD3wADspgKz9IueC4vyUQwt6BAYrVmQIf44RQwVniQHiUa4Mt32Wxzij974uVz7J/lYeRJXZxAnRNhEKDqmxyVlF5hMVQWpg73p6tcCuJFUvDlkvYUjg8hgicNubEF9DhdRDgT5n0iGo1lwcgjqBzg2rTtZJZ7aAanBZeQgtvCqCNZeDxZzg1Z0ULiDJZPbvP8qRD4yCQ/HuE84UvTQ7WTYkLUmuhZGwrukaASiIH6M54scndJbb2ZiKMGC7AXbHWhKeyAffAp17ws6GH3dvOhJVJh0j6A7szPkvtI86W70iSTglRB+J9iZDaFIgB31gmdTggrsNUaEcpsLBc/vECSzB7WNYYVdlgVaMl0sNT6Xg4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(8936002)(76116006)(110136005)(54906003)(66946007)(4326008)(5660300002)(33656002)(83380400001)(122000001)(38070700005)(8676002)(66556008)(66476007)(66446008)(64756008)(2906002)(55016003)(86362001)(316002)(38100700002)(966005)(7696005)(71200400001)(45080400002)(6506007)(186003)(66574015)(53546011)(26005)(9686003)(508600001)(41080700001)(15866825006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?yWUgb7GN9siVdroJ1xhtWbikHGvF4+LTSUK3ARyHtnBe3AYJ8+iB7jD7LQ?=
 =?iso-8859-1?Q?gzuh9BzqY9tK8YUlE6cNAR0KFve0m4Z86d4iMrbVKeS5vJPs6odVISKGNN?=
 =?iso-8859-1?Q?w64cLXB4IICN1NbH1NtBuUivpf5ekAaGpsu7L2eeU58SVIrb/B1hXGtJ26?=
 =?iso-8859-1?Q?uitE1pJsKVUSwVGer1X8kUh4pe9Zo0u4nif6H5WjSrGCEwyGwQ16BVt8l7?=
 =?iso-8859-1?Q?adKh3eLmL18SDewwq7dZYk52pBKv3AGiysz0JlQM2VrDiMs5RuZCfRHwXK?=
 =?iso-8859-1?Q?UFwZm8oH0U35SOCAtH0w5lF2MzOwMNS44FNqZqq9agy5PSIth27b+XGxkV?=
 =?iso-8859-1?Q?R7JjAYevQ2WtI6+KHGCbjIg15Kj2KbdsC8jIro/e8Nz1H96Th23x5EAfnS?=
 =?iso-8859-1?Q?h10aDy9aXGJxxjjFYXgKhFcZ8kyItBvri90x4n/5WHOEVFWJu7TtqL+BE4?=
 =?iso-8859-1?Q?FBs+mmOVroYsoeRbUpMp2lqhslJ2w8tBjFiiZlfQ5SEAG9tttOUpURqJDq?=
 =?iso-8859-1?Q?cCvNOtAPpn+a2B/BKShDyA85dnOoF6+vCOMoitttvAJdFC+jNyQlg/j+76?=
 =?iso-8859-1?Q?KSG5Ufj7RadFwFzOVGDjpIbVauiTf04u0jz1wjczGP2ZRwTY/2p8zBXvDt?=
 =?iso-8859-1?Q?uAA2ctjI9aZ9FhY82/GzMiqNTSPj/p/s+LvGUfCpGljaZTAEkV1E5HvdtU?=
 =?iso-8859-1?Q?dJeyi3jk+lfc1DDq9ZWyoFbkzskX1hioeqxeCNN5di07/qHkwpppZRgSRi?=
 =?iso-8859-1?Q?eqHyBknTZBZMIHzwcfn4+FTpcPvqI+bW/C7JxnFP2ei5JKZFti7ql+BmqD?=
 =?iso-8859-1?Q?iaf024lkHH8UBNSviuBmngm3xSC22uofHbDRta8AD89OvTyjYtS5M1mgp2?=
 =?iso-8859-1?Q?dW7nmqLHpIrPFk9O2jHrax5ZUO9MZqj5Abmx+3h49CFJ2xocN+0+z15wAZ?=
 =?iso-8859-1?Q?YIMI6RRV+y1yqERGve/BNkS1doAPEZJCEmAdrYWcUN3URVF59IRhdEv/oT?=
 =?iso-8859-1?Q?THbBHpgqtzxqU6WerI29lQtTG5SkrKKsN3lw8avCfQEY9KR45oJRKZQice?=
 =?iso-8859-1?Q?hMoIybyRlV0MDuj00m8Ix8PXrejRSn15ut6m0e7hrkPF/LfZpJgORScE0t?=
 =?iso-8859-1?Q?reNBvop6Ji/wLG18HBEyhO9h85V7mKEwd2OvYeeGP99p+l8E4LVCbx1UnY?=
 =?iso-8859-1?Q?avw+W7SUAk7GT1BD7A1gF9nA+RJDxGVMmZeCKIt8amtv6Buu79DMrYUGPY?=
 =?iso-8859-1?Q?MwGY+Bxr2XeyStnBJuDugikc45IXlGUvKTaYyCknGYH86wsRbSw8daRizL?=
 =?iso-8859-1?Q?4GpPwmNG1Po8bi/D7iDk9RM8QbSQz5xcmY7AfB1R7TCbZ++4OIr6PZosgY?=
 =?iso-8859-1?Q?gS0USwfDhCi2AnSMFFJ1waaHF4u/YqZ+vkVC+wFD4kssMIENkOSQ8PKClE?=
 =?iso-8859-1?Q?TFS1MuKpi3Knv4v6kz+XJ/9XtMMMcyQ+Y4EtATPqShz8Jp6OV2bR1bOcRu?=
 =?iso-8859-1?Q?WfqpRZGR9tXo9B86J2wCjCxzRxIi9aRVlcOwHkvUFrxBGpkq8O8yvN84Ma?=
 =?iso-8859-1?Q?/AZlJ55I57UqGXhFK3m4+uTNouA4UTwnShqL4QefYseRKg//N9yFvtvvxs?=
 =?iso-8859-1?Q?fi+a1DOTMFg2QUKosvrwFzthqISTQueYWTJVHHZCcZZ/Jo7j/7s7Tv8xwJ?=
 =?iso-8859-1?Q?GJFuyS/m5b7q2tWu7LmkKUNW1YPWIkeeUM3PgGKYXhNrbvcoKHIXdnBkZw?=
 =?iso-8859-1?Q?+No9yFYw+7OOzWXfoMIEPujky2IYzqjH9Ufy7gxYGCkl7/?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2056b8a-edde-4bde-e8fb-08da3d07d67f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 22:01:49.8650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RUwONf57exLx696rhVK1yFzIB8NIuzfG3UQDzVI2d+xahd15IpBi3lTl0ywHRSbCQqSgDNBmPf3YfJLo1EPZ1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2732
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Christian Casteyde <casteyde.christian@free.fr>
> Sent: Monday, May 23, 2022 12:03
> To: Kai-Heng Feng <kai.heng.feng@canonical.com>; Thorsten Leemhuis
> <regressions@leemhuis.info>
> Cc: stable@vger.kernel.org; regressions@lists.linux.dev; Deucher, Alexand=
er
> <Alexander.Deucher@amd.com>; gregkh@linuxfoundation.org; Limonciello,
> Mario <Mario.Limonciello@amd.com>
> Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video
> since 5.17.4 (works 5.17.3)
>=20
> I've opened the gitlab entry for this discussion:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F2023&amp;data=3D05%7C01%7Cmario.limonciello%40amd.com%
> 7C7a9cf928dd1e491f0c2c08da3cde2e21%7C3dd8961fe4884e608e11a82d994e
> 183d%7C0%7C0%7C637889222210477502%7CUnknown%7CTWFpbGZsb3d8ey
> JWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> 7C3000%7C%7C%7C&amp;sdata=3DWnQwbF8J4j2F69GINpz49Zg5Qg0tpVCmUG
> i1FjXrCu4%3D&amp;reserved=3D0
>=20
> I confirm I 'm not receiving mails anymore from the mailing list but I'll
> follow gitlab.
>=20
> In reply to the patch proposed by Mario:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatc
> hwork.freedesktop.org%2Fpatch%2F486836%2F&amp;data=3D05%7C01%7Cma
> rio.limonciello%40amd.com%7C7a9cf928dd1e491f0c2c08da3cde2e21%7C3dd
> 8961fe4884e608e11a82d994e183d%7C0%7C0%7C637889222210477502%7CUn
> known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6
> Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DFuhEnUyC8nv
> ycpaGr4yfBbGpuXHXoKqImBTQ0PL8caY%3D&amp;reserved=3D0
> With this patch applied on vanilla 5.18 kernel:
> - suspend still fails;
> - after suspend attempt, the screen comes back with only the cursor;
> - switching to a console let me get the following dmesg file.
>=20

I spent some time with Christian today on that Gitlab issue, and want to up=
date this
audience to a few things.

1) The first suspend failure is caused by something wrong with acpi_tad dri=
ver on his
system.  Blacklisting the driver everything works properly.

2) Failing the first time with deep and trying s2idle instead is caused by =
something in
his userspace (unknown right now).

3) This is not a regression IMO.  The GPU was in a bad state from the probl=
em caused
by acpi-tad.  We introduced poking around and resetting the GPU to help wit=
h
aborted suspends, but they've led to a pile of "Oh but not this case", fix =
this ordering
problem, deal with this repercussion.  We shouldn't be dropping any of thos=
e incremental
solutions to deal with a path like this; the direction should be for fixing=
 acpi_tad or whatever
userspace is using it incorrectly on Christian's system.

> CC
>=20
> Le lundi 23 mai 2022, 15:02:53 CEST Christian Casteyde a =E9crit :
> > Hello
> >
> > I've checked with 5.18 the problem is still there.
> > Interestingly, I tried to revert the commit but it was rejected because=
 of
> > the change in the test from:
> >         if (!adev->in_s0ix)
> > to:
> >       if (amdgpu_acpi_should_gpu_reset(adev))
> >
> > in amdgpu_pmops_suspend.
> >
> > I fixed the rejection, keeping shoud_gpu_reset, but it still fails.
> > Then I changed to restore test of in_s0ix as it was in 5.17, and it wor=
ks.
> > I tried with a call to amd_gpu_asic_reset without testing at all in_s0i=
x, it
> > works.
> >
> > Therefore, my APU wants a reset in amdgpu_pmops_suspend.
> >
> > By curiosity, I tried to do the reset in amdgpu_pmops_suspend_noirq as
> was
> > intended in 5.18 original code, commenting out the test of
> > amdgpu_acpi_should_gpu_reset(adev) (since this APU wants a reset).
> > This does not work, I got the Fence timeout errors or freezes.
> >
> > If I leave  noirq function unchanged (original 5.18 code), and just add=
 a
> > reset in suspend() as was done in 5.17, it works.
> >
> > Therefore, my GPU does NOT want to be reset in noirq, the reset must be
> in
> > suspend.
> >
> > In other words, I modified amdgpu_pmops_suspend (partial revert) like
> this
> > and this works on my laptop:
> >
> > static int amdgpu_pmops_suspend(struct device *dev)
> > {
> > 	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> > 	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
> > +	int r;
> >
> > 	if (amdgpu_acpi_is_s0ix_active(adev))
> > 		adev->in_s0ix =3D true;
> > 	else
> > 		adev->in_s3 =3D true;
> > -	return amdgpu_device_suspend(drm_dev, true);
> > +	r =3D amdgpu_device_suspend(drm_dev, true);
> > +	if (r)
> > +		return r;
> > +	if (!adev->in_s0ix)
> > +		return amdgpu_asic_reset(adev);
> > 	return 0;
> > }
> >
> > static int amdgpu_pmops_suspend_noirq(struct device *dev)
> > {
> > 	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> > 	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
> >
> > 	if (amdgpu_acpi_should_gpu_reset(adev))
> > 		return amdgpu_asic_reset(adev);
> >
> > 	return 0;
> > }
> >
> > I don't know if other APU want a reset, in the same context, and how to
> > differentiate all the cases, so I cannot go further, but I can test pat=
ches
> > if needed.
> >
> > CC
> >
> > Le mercredi 18 mai 2022, 08:37:27 CEST Thorsten Leemhuis a =E9crit :
> > > On 18.05.22 07:54, Kai-Heng Feng wrote:
> > > > On Wed, May 18, 2022 at 1:52 PM Thorsten Leemhuis
> > > >
> > > > <regressions@leemhuis.info> wrote:
> > > >> On 17.05.22 19:37, casteyde.christian@free.fr wrote:
> > > >>> I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd=
0da
> > > >>> ("drm/amdgpu: Ensure HDA function is suspended before ASIC
> reset"),
> > > >>> and
> > > >>> the problem disappears so it's really this commit that breaks.
> > > >>
> > > >> In that case I'll update the regzbot status to make sure it's visi=
ble
> > > >> as
> > > >> regression introduced in the 5.18 cycle:
> > > >>
> > > >> #regzbot introduced: 887f75cfd0da
> > > >>
> > > >> BTW: obviously would be nice to get this fixed before 5.18 is rele=
ased
> > > >> (which might already happen on Sunday), especially as the culprit
> > > >> apparently was already backported to stable, but I guess that won'=
t be
> > > >> easy...
> > > >>
> > > >> Which made me wondering: is reverting the culprit temporarily in
> > > >> mainline (and reapplying it later with a fix) a option here?
> > > >
> > > > It's too soon to call it's the culprit.
> > >
> > > Well, sure, the root-cause might be somewhere else. But from the poin=
t
> > > of kernel regressions (and tracking them) it's the culprit, as that's
> > > the change that triggers the misbehavior. And that's how Linus
> > > approaches these things as well when it comes to reverting to fix
> > > regressions -- and he even might...
> > >
> > > > The suspend on the system
> > > > doesn't work properly at the first place.
> > >
> > > ...ignore things like this, as long as a revert is unlikely to cause
> > > more damage than good.
> > >
> > > Ciao. Thorsten
> > >
> > > >> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker=
'
> > > >> hat)
> > > >>
> > > >> P.S.: As the Linux kernel's regression tracker I deal with a lot o=
f
> > > >> reports and sometimes miss something important when writing mails
> like
> > > >> this. If that's the case here, don't hesitate to tell me in a publ=
ic
> > > >> reply, it's in everyone's interest to set the public record straig=
ht.
