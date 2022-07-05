Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75162567668
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 20:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiGES1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 14:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiGES1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 14:27:53 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C3B1A3AA;
        Tue,  5 Jul 2022 11:27:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGaiBGIbi7kDF9kDXb6EOrYHPgad7x5WhWggt/1MiPDLCjJe2s0oQc1mNSkIDBcUiLoXSVLO55veRdOpDulE5JXA6Xd2pfwI3y4zG5gDdesxpt6jh9hP/2ELu9u6Oo3ZfmbQGm8/itBkKKxWFElxbCd/l+k5zg0x65Jk7DIJYxNkFgu15gOHD/KvBOPpGLB2ciIOfmO78wVyOvWG5eMm0hILR1ecgtEIZjO+VYElFEYdTxkZlBtpaEe6i/GVH7kvKk6tPBZmMLa5v8QJ8ZDuHxMBn6KO/VfsixiRFGY5t81KlSsCaz7DiwiuSewWQJZ+ecbPFsdl2NNh2qiXLvES7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t92HdF54hkTPs18CFrczZ7yMQdQ6Sa6/ZLz3LsCwky4=;
 b=gc20nc3iDbh/JPKAxaYW9VHG8uC3uj8ySxlm5xSmlJyqN3POiw+D8sV/iKWIX5DRuQOYBA8ZCXHlAY5nwfuN60F7jwe4hgnbPZnkcBme9cCUaU1bngW6Tu8RFUwXCaBzGGsDg5m6Kxn5iIYpOIjgSD9Ll7DFoopTG/m2TEFakDRTu9SCR7wEtcF3VP3nWZRsAVfvb2Iq1ZnI5yI268QrQfBM5Iaqh/1tpFxnjwogEaQoN4U3FssCY/drXJqlnXNAKHONc5k6219qjsCCXv+kNT894FAdzQfkLtdTJwXFDGr4U2FANqXAXIl1yaZKT0UsiJiwvRkL2EZzNtCpUNGRdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t92HdF54hkTPs18CFrczZ7yMQdQ6Sa6/ZLz3LsCwky4=;
 b=FoC+PAQGSI368IFvIUagDrAV62u3alU0WZ4XQnI08fKUXOzKpv3IXJIv1Te0b8j2B6ITzp4whhVclYLMQsfqEr9FmBsLqB/aGJztCTyT+2gNKnqnlAC8H6bXTrhyBKafFClQhJ06Vv6jqmoeRpOLH6iwR0UnUYt2LEET7AemH24=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN8PR12MB3377.namprd12.prod.outlook.com (2603:10b6:408:46::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 18:27:50 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%5]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 18:27:50 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Chuanhong Guo <gch981213@gmail.com>
CC:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Tighe Donnelly <tighe.donnelly@protonmail.com>,
        Kent Hou Man <knthmn0@gmail.com>,
        Len Brown <lenb@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5] ACPI: skip IRQ1 override on 3 Ryzen 6000 laptops
Thread-Topic: [PATCH v5] ACPI: skip IRQ1 override on 3 Ryzen 6000 laptops
Thread-Index: AQHYjL2tlspw6T7w4kShvO6Qi8X0oK1pdz4AgAaoIYCAAACaEA==
Date:   Tue, 5 Jul 2022 18:27:50 +0000
Message-ID: <MN0PR12MB61010151CDD4D74F75619684E2819@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220630022317.15734-1-gch981213@gmail.com>
 <b84edc24-0a3a-a4d2-6481-fb3d4cee6dda@amd.com>
 <CAJsYDVL=fgExYdw3JB-59rCwOqTbSt2N0Xw2WCmoTSzOQEMRRg@mail.gmail.com>
 <CAJZ5v0g7JOcYTwwLxPws38abn_EVGjG0+QY9E+qpM=guhF11tA@mail.gmail.com>
In-Reply-To: <CAJZ5v0g7JOcYTwwLxPws38abn_EVGjG0+QY9E+qpM=guhF11tA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-07-05T18:26:24Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=ea12ae13-0544-4f8e-90d2-e3e34b93605e;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-07-05T18:27:48Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 2ef89ff9-848b-4329-be2f-36f7b6149992
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cbb07fa-7411-4c3c-1cfb-08da5eb41119
x-ms-traffictypediagnostic: BN8PR12MB3377:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JQMsnkmHmM2Gcqe0H+6NWtBYUa3sajzU1vE4Bgif5kzuL0/U3Vq3awU/hVp34W8ARyCeZ6j5/4DSTBurkdpLEh3PNYF6d81YcPEvGauHv2uEcsUMwfCFqqFpYnRa4yU3c/1ubrdjTShjOtv8giyETfRXMOcZd/0HfAH0IEGi4AjQz6Vr4aYk794MJsGpf6il08xWjZxJmTd44JMrqyLsQ/Q2HqnWqLu6CkiIsvQ0iEHdDH1HFTWMRZgpGqC8eN8s6w0tdC361LU4wetzRsRyKkxTfrDLsyo9dP6xQXxDFECUpE5k5HG1nwMT8B4JvoZLE6YrZaV42YiIUuZXm3pmWPWiUKvJGHN8ARRVms6J0NqjassZlYqNKz7TdeMMSBGKnU6WM93B8UGySAH1iOtvM6S+c7bLNwYGW/o0n+bPj/MGsyOYe0CJTDQkLt+Rn03Ku4v36cnT7XdoMhnu3V2w8M+HPotU/F2wDg2IZuZER0Cpo+MrcQVy5Diq60c2LAOtY1bXp4KYkWihqREjt16MOeMuMUGCw3uQL6pT81o+9kVM/Xijbm61NqxrapHXZqn+iArLKdjX/FgjnYRhrFjC+HTpOKfl1b/jiMLDGoQCf9VONxNof5fAtac2CAqSS1bdzLjTtKSXMRXixSY5vNLrQwY4jz7b8wwJ/RlGIdE3Yb/U7MQItqoyZMWUH0mW8T04gb4X1pM7uB+isxY8shDcYLLTfLp94iTAvuFEEOb8b9UK9CANINP+K1NnOg1MfSN12vjgd5nDrU8/mHWmYW/hYmJe1kzo4+MzZmsfjRzQhAsbYdaHcMUdvN274hmwUHTD1klZcsZLL61KPjd2R4qbVI6myS1J2nDeW2IGYVepCW8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(52536014)(478600001)(966005)(5660300002)(8936002)(33656002)(53546011)(7696005)(6506007)(9686003)(86362001)(26005)(41300700001)(2906002)(38100700002)(122000001)(186003)(38070700005)(55016003)(83380400001)(71200400001)(66946007)(76116006)(66556008)(66476007)(110136005)(64756008)(66446008)(54906003)(45080400002)(316002)(4326008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5j6DxhqiPHuepcRdBeRUO6n5WbNmi4Xvm8ELWzf7MGyvpR6xPugww97RM0nX?=
 =?us-ascii?Q?aRZCuUWcCsORMrmcgeDc7zjM87eoxxuk2G99bZwyMyeNZ4Ps4703/hw1ZXvZ?=
 =?us-ascii?Q?uNNbd0R+AguAUlqWmmR6+4St636ux/Os9eI07BePBi5j0QocPtZhyhxdDyWC?=
 =?us-ascii?Q?sSAtRZ7YKU6Y2MSoTOH56EnuBNJZke7oxtAT3usvSbF05xLGgAh7W+ATIhxA?=
 =?us-ascii?Q?TXtAyhD2bazA1Hdqg4gJ9R6RVMDfJAu1vGKAuVYzEhh0YKmOl2U+JJ62Tnsm?=
 =?us-ascii?Q?9DbPx27N3kOTJIJDUoEjMjblxOulPgx2ms1LLDyYFE8JjHD176aJdE+Zqfp9?=
 =?us-ascii?Q?i263Aeb5PnX0XNTXJlkkyU+z/dpNzr3BwKvDdVnf+n+cHipplKe4jkyIl0zA?=
 =?us-ascii?Q?+tuEQoXLJesjxBgskE9F6Fz4jTDgWAd1JdMmN5idhgNSY651O4v9wM5kGrCz?=
 =?us-ascii?Q?asCcuH8UB55LPVlVt/XtFdZTyRZkYtH/g0sHx7Ks44GYAL2dJdHdQNXpIdDd?=
 =?us-ascii?Q?ge2PmcNSuZgLmVeRMLcSLiT24AYbYZkxjASSIAO/geBAG8jxJl2tQw5v1+uD?=
 =?us-ascii?Q?GFBI1t1C9FrRdXGvFhPKJHZsanGUIJcO2/H11c0rmHy9iYEZOrb64hieQ2OA?=
 =?us-ascii?Q?TLrpFQ8zVKx3JtO9tQVZT7Ih9n6PEQHnocnlAoS66sOPj9b9vc5QVKGC7y3A?=
 =?us-ascii?Q?4oqXBJJ7EAQaYHzsvi5aJiIIDiGPnQRp9rLdwnV5gSPzITrcg1/2bNCnCUij?=
 =?us-ascii?Q?rIYuK3C0dwYNyX3lcPmgZ6D0wC6dRrGBJIc1iFuAuwTU7NpNFkINe5VUpCv9?=
 =?us-ascii?Q?/aNhrFP8w9EYqWN70c2d5V1ywkXZ7edQ8Dd4YdiVzBGXUuq2LkOv1EHaFj5D?=
 =?us-ascii?Q?A2bZMs1dao5IpY4wC9z2PRg55j5tZqgSNAlNC6/N1DMMwdLGM7QoIk77Mtdy?=
 =?us-ascii?Q?V6tlYywlKkKT+Nt4OusMpC5o+IATwHeer+2aMEskGOP637FOd+Y33Ypzl+9u?=
 =?us-ascii?Q?ESw3LJulCO562JTTmQ1MK0g7nY+RxtFegj5+zj9kc5OngHF0w+kuLRkltIg9?=
 =?us-ascii?Q?Rcy2PoNiE6eJxe90iAMbBcHe49lpcbzSFVVa+Qk8nFXFi9ycLxgBUX1irTwL?=
 =?us-ascii?Q?ix/Z7Vtj4T19RJJ9petcgMLumeT5trD/8c6ReQTxRN1SvmRY8LZ70b1dcWCA?=
 =?us-ascii?Q?8GVsFGOvxoL+mYeI2N52tpzrpwcipjDlKNN//UplZkd9pVr5ujUpXosxekn0?=
 =?us-ascii?Q?rcsBX8VM3N/pBIkFVMCMXwmvNY9oXzHqrDC6IUPSQvf7AmNcRabr6NHm9z3E?=
 =?us-ascii?Q?wK68jhqDnqPJrutQ1v4FWjkLEnkh4h/eCp1dO65p9VAH5kTs7GIgCzFXamAb?=
 =?us-ascii?Q?dsQi0SuJxCxFDNAOxm2jJE2wmwrWHWkeTUtPg4/GlMcR/W1Ww1F1cCJyTvUu?=
 =?us-ascii?Q?dkaw8PjhnE2Ip+TzblVBjxuaZW/tRTSeJiygzsE7TQxe/lDlSTQADSElKqb6?=
 =?us-ascii?Q?l0UAJykrosQ2qzRhSgpjT9ootExJylviQVGHbNJ9Vq5bvogHfluXLQrvCu8H?=
 =?us-ascii?Q?qcMs/tRt+x1+otSlLyY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbb07fa-7411-4c3c-1cfb-08da5eb41119
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 18:27:50.0172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jWnrBjFRPga76XWnm2Tzy6nG6z0tGn02n5QrlTlv+7av5VUJES/pfTSFozUTYrjMsEIc4C5sSv2CwGerkr9p7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3377
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
> From: Rafael J. Wysocki <rafael@kernel.org>
> Sent: Tuesday, July 5, 2022 13:24
> To: Chuanhong Guo <gch981213@gmail.com>
> Cc: Rafael J. Wysocki <rafael@kernel.org>; Limonciello, Mario
> <Mario.Limonciello@amd.com>; ACPI Devel Maling List <linux-
> acpi@vger.kernel.org>; Stable <stable@vger.kernel.org>; Tighe Donnelly
> <tighe.donnelly@protonmail.com>; Kent Hou Man <knthmn0@gmail.com>;
> Len Brown <lenb@kernel.org>; open list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH v5] ACPI: skip IRQ1 override on 3 Ryzen 6000 laptops
>=20
> On Fri, Jul 1, 2022 at 2:45 PM Chuanhong Guo <gch981213@gmail.com>
> wrote:
> >
> > On Fri, Jul 1, 2022 at 4:12 AM Limonciello, Mario
> > <mario.limonciello@amd.com> wrote:
> > > However I do want to point out that Windows doesn't care about legacy
> > > format or not.  This bug where keyboard doesn't work only popped up o=
n
> > > Linux.
> > >
> > > Given the number of systems with the bug is appearing to grow I wonde=
r
> > > if the right answer is actually a new heuristic that doesn't apply th=
e
> > > kernel override for polarity inversion anymore.  Maybe if the system =
is
> > > 2022 or newer?  Or on the ACPI version?
> >
> > The previous attempt to limit the scope of IRQ override ends up
> > breaking some other buggy devices:
> >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatc
> hwork.kernel.org%2Fproject%2Flinux-
> acpi%2Fpatch%2F20210728151958.15205-1-
> hui.wang%40canonical.com%2F&amp;data=3D05%7C01%7Cmario.limonciello%4
> 0amd.com%7C106955e4611344d3bc3808da5eb3971d%7C3dd8961fe4884e608
> e11a82d994e183d%7C0%7C0%7C637926422673112765%7CUnknown%7CTWF
> pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXV
> CI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DxOaRbkCv9EMhpLO%2BGAP
> mDjEhQ78xjYFBvehLZdg1k1I%3D&amp;reserved=3D0
> >
> > It's unfortunate that the original author of this IRQ override doesn't
> > limit the scope to their exact devices.
> >
> > Hi, Rafael! What do you think? should we skip this IRQ override
> > one-by-one or add a different matching logic to check the bios date
> > instead?
>=20
> It would be better to find something precise enough to identify the
> machines in question without pulling in the others and use that for
> skipping the override instead of listing them all one by one in the
> blocklist.

How about using the CPU family/model in this case?
