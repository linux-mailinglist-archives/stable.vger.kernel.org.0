Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71A6630C32
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 06:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiKSFiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 00:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSFiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 00:38:00 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11020015.outbound.protection.outlook.com [52.101.51.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E165E77;
        Fri, 18 Nov 2022 21:37:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaCIrMTu2YKq6vNw3ABBCBlTP1bnoYA9Bg46AtcMpcb/mDq6AV/Yn9n+b98sEsEcbD1+9KaR+VC8NTcHmI5GtmcI0ZDIqViqCGAbOnnpVinIv8NLc4o47LEK+mM1MU9Icsn1JoydFHB2vN1PKQMLVY5lB9LQBC71rMIji6vworO2iO1Jk8C0+9XwM7bh/IjM1NP+dIhOBiVbkt7QLcNUGcRyVP6EoLNvcPQpP35aLtEmZBXUdDCahiSgT/RfJHZj2OmnXrYQmr7fG7RBloSeHONgy+ftAVia0ORxJu6pARHYCkA7/hN4fFEGtZeebDcjpOvJpeqbmlnoxljF/kLlaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTlAKENyA9e2KHnBia7nGlhRk4nFJ8FJ+kYE4yFQG3I=;
 b=JaFfnkz0m4AVQn6b7S7mjsdbmG3OiWKAWdKvXeV6hHNYRzOu1k4Ke9SEaV1xfnOn+NCfIU4IVO9IV8T01A6mg735du1xv5TSbINyLZgJB4r7SryFZbOeboHKH+xL3UL4K1SEylaJ/LxgiPNY825WpY0nxYiDkhaBXzMTH0DDBaOLDqifZhp0/X6rVtmHBMCjOw56R++v6q7mfEPehm5zaxEE+UCg7vkI+/1/Zo/cd0nPR6rw4fxBnH05rQaWOEm0VR/wH8PllLYfO2M9ojf2RoqwS0Pfl++pNJkiUDTtbomeK1/67edtjVVcG3tAkcEo2cPd2hxEh/kNwWTPgSnbZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTlAKENyA9e2KHnBia7nGlhRk4nFJ8FJ+kYE4yFQG3I=;
 b=Em+MhR9QGAlAoRJPc9gzKwTLSTqIAoXaHrYIieIkaTz9R+4cvz+c8s+6z+YjTpvuhVCnNp1+A8ZFMlaW9ZKraVSokThzDgImnnn6I8rvrYoF0Anl9UZ/mbOjznj/UMSETIVWG0M9lXEqgITK+WE2p7M77WxXn+sb+DCLZpDVFeU=
Received: from SN6PR2101MB1693.namprd21.prod.outlook.com
 (2603:10b6:805:55::19) by MW4PR21MB1938.namprd21.prod.outlook.com
 (2603:10b6:303:7d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.13; Sat, 19 Nov
 2022 05:37:56 +0000
Received: from SN6PR2101MB1693.namprd21.prod.outlook.com
 ([fe80::bd63:35dc:eb6e:3c9e]) by SN6PR2101MB1693.namprd21.prod.outlook.com
 ([fe80::bd63:35dc:eb6e:3c9e%9]) with mapi id 15.20.5857.008; Sat, 19 Nov 2022
 05:37:56 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 6.0 14/44] x86/hyperv: fix invalid writes to MSRs
 during root partition kexec
Thread-Topic: [PATCH AUTOSEL 6.0 14/44] x86/hyperv: fix invalid writes to MSRs
 during root partition kexec
Thread-Index: AQHY+7xQPmd/q8gcTEaiICSPyjTsNK5FuakA
Date:   Sat, 19 Nov 2022 05:37:56 +0000
Message-ID: <SN6PR2101MB1693B87627474E6541A5E1B2D7089@SN6PR2101MB1693.namprd21.prod.outlook.com>
References: <20221119021124.1773699-1-sashal@kernel.org>
 <20221119021124.1773699-14-sashal@kernel.org>
In-Reply-To: <20221119021124.1773699-14-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=59bca398-736b-4b61-a37a-9dc52f7b624d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-19T05:34:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR2101MB1693:EE_|MW4PR21MB1938:EE_
x-ms-office365-filtering-correlation-id: de26bdb6-75d1-4ec7-bd18-08dac9f0365c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jx+SnZxnxpz3A+9K5aWUeniiO/m8HKoN0UDdT5hCPF4v2joNjZ3Dz9sDVEnOmsK6mdJ245udE6Mlt92VkDC2WgKrEFIPF/9QqgLPStVraNWmxO+IcmrQih8wTnE2+KNAKXb0lHa+hwa370YhVWNBrIYCVnmulNT2cHHcMVbF0kR3ParKiVIFR7bL5ufvKw9TP5vfB54BGaYgZq6/XQ0kGboypF0H9F8c0ETqzpqkuT9iSoR5yfij14KMzLgygUglsjYrkDX27PnDvEK0Am1zw7NtmY/Ze+7x5Mg8oDcYhLTsgop4DzqZcH20HQwGjJiqUhPKjRgJlOVQBW6iPHxCLbm4na71gHK3KzqPOIRJrGXHF38il0Wi/MfVjamywb3cAOawRPY23e51ipNPbKyrAVrkbhx9TRK+Vu7sRXSsUfhNI++SONuxCppz1tssPRKOKTfKNgwiMRapMHEOdF9JN7NMP2AvpifjguGQ5VTRwBC8WzUPWAoYNDCs6LCFH1/8xEzT61v4q38NbDm87vTgTkAVb0sjwzudGLt4obM6A1DshKrkx1UXh3Y3DHREKbuXX5sPRaa4pIQ9mk2CGuHP7WQp0rzXfLFQCrgvf4MOt2pB8uVQBWpHUh4xvD60pU8wVOg1FjCpPtcyBoYqYGKvNnl75IwseQFUB7DSQNGG2/pSW2bqnPtdFhcXazl/y3szgLUu1QlP4HBMpE9ktzqqPflJvUxkQ7Dt6/60I82V7FncXXgsV9L8eVj+FYN4iVjm36wM6lQncIy9uSs22r6o5DXIjBZrNpk7g+ewUEFTP3c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1693.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(10290500003)(6506007)(7696005)(2906002)(86362001)(54906003)(110136005)(8990500004)(41300700001)(966005)(9686003)(71200400001)(7416002)(5660300002)(66946007)(66556008)(66476007)(64756008)(66446008)(55016003)(478600001)(82950400001)(82960400001)(4326008)(76116006)(83380400001)(33656002)(52536014)(186003)(8936002)(26005)(122000001)(8676002)(38100700002)(38070700005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P52iaDYimCO486FY0x3xYsOdWV+MMruw44Gn+EJLopha5dT0uUzqPYURCgXc?=
 =?us-ascii?Q?X/53/Ea9aKhmKQgox6MQDJ2+1wwJCnv855Pxsx6qyVWJkQnUKis7tWqfddIP?=
 =?us-ascii?Q?p89d3dMziCoKiBvrLyaYphtmZ0DyktxULH8QXuiy2zzI6KIQu5jhw7TF+Liq?=
 =?us-ascii?Q?uH8ljcryhXemyuacLhLO3j8arP8VTEMbt5mdcMkKAc0AoClKq9m+902frtAw?=
 =?us-ascii?Q?gVigISF0fl1WTz2sca3XQjzP6dwPt2x+M5ECdSdMYFHq080HJQKv1/vnh/jj?=
 =?us-ascii?Q?JDL207OpeNSN96gWuW9akaVI9HrfaI0Ffvn5IQfstwqRXeqBdB4eHOHGX64i?=
 =?us-ascii?Q?+tZhREamD4KprhiwnW6u1Az2tyCjk5VYS6ZtS75u4FwGnGWJeQKbQoDSOuzU?=
 =?us-ascii?Q?5C1E0HhtA8jU/RNcrGctmyopMsm2VhOoxOET5W5MksqUH5H8gGFWi3NhztmB?=
 =?us-ascii?Q?yWn7P6+CI/TzPZ6v3m8pE/22RJCjtLtqinKOYSjkHjadX+XawVHDwa0cY3pL?=
 =?us-ascii?Q?B63OtZl23flcRGUMNR/ADvhMC5Ag4Fgmnw0M3meNE8q8RBR42UHsiNvcjB2X?=
 =?us-ascii?Q?asIg2/CP/1MYWPz8jWip/pjaGuZYZdSQM+u88i7fxixOKnBfdH5eNze/xqdL?=
 =?us-ascii?Q?qKjHQFksCIZmF5kof4ZcYVJRf+RE4xubVcyK38fRz/Tx0enhf4g0/3aapqB5?=
 =?us-ascii?Q?Cz72IhV0RkKVkSfqRe0KAkv8QH+4OJyz6qQC3+Czh255KQA4ElhgpdYvT+EA?=
 =?us-ascii?Q?7l09jvtwlRkmI/XCdJEMTv80FYhooQOJ78urardpq3a4QV2BULwcmVQuWA75?=
 =?us-ascii?Q?v0dtq/nvUGVTPYKNM2+vUKJze8HX4NJy9ZPjfF+LuPOK8CoRNu7LL7Y/xci7?=
 =?us-ascii?Q?6ZCLIaII4rrpPnsVb6o9f1SyhjPo3xSemdUB2x8uUpYJsZl387yUfQf96yL6?=
 =?us-ascii?Q?SxEdbaIwSxY+IBA7fywsu2u5k2kF6K/epT9F/cl4y24/NfXyK3ZgiBg9h6dn?=
 =?us-ascii?Q?ZoGnv8zPkeDNz3nC1l2+ND94N88gAewC1kZy8sQc4MHr7IJwBqMLJHtfhW4H?=
 =?us-ascii?Q?AgQcnsZg9xpWhPIKkiYoLK3AyVCQbNbaBmSx4HNHWO0x5i7qjbt6DwMEEmYj?=
 =?us-ascii?Q?qZ6I48AGtw8nkmTPfaXW7GiBeYHPYLX6JJ7PDSqSH7qzOYAZDMYECQzRMXk2?=
 =?us-ascii?Q?GHFKj2Dz8UYBLTzULD0cPpR/qDO3SDO1E2azBPSiz5GgOgJxFAQ+xML/gRIV?=
 =?us-ascii?Q?L/tuTDXWnJzWc8v731eLqlUCg3p0uaNArczhTR2mYuObjhwNUbkm0YRk03A2?=
 =?us-ascii?Q?C+CnzbDl7OO+t2sVqCbD1TrzGlyoDN+UEDCPMnpdDPXopEJc5FxK+YaDHySM?=
 =?us-ascii?Q?68kHmGkwjLN/x1KuVFOjdRmhswltyJOGu4c+w2Ume/PX7A2d6yRuNtGR+GoC?=
 =?us-ascii?Q?nFVwmsyczMkBVCRNq3E8oYXqNl4snUN30+GOA7Rnp9Bc5oKOfmNAUYzrgMKS?=
 =?us-ascii?Q?IsgJDAfCdI6Nq6VLm/RNlG7te83bQt68tsP/dsdA/lOn98Z4kEVo6o6T943h?=
 =?us-ascii?Q?ySzS4lb2z5k3vbv8M9KQLP4F5gh8aNkKXwEgmWU1u6KTTXOEbTJXv6ujAmme?=
 =?us-ascii?Q?fQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1693.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de26bdb6-75d1-4ec7-bd18-08dac9f0365c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2022 05:37:56.7102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wl/M7cNaLaIgladKI6dBKYO2GUNp3l8YnoXCYlxF1bjQyHZ67w8YXSH0Wa32HROvvmP1ykDabYVm4URStOlnU4LD8m2ggZ20+oqFCZ3rzLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1938
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sashal@kernel.org> Sent: Friday, November 18, 2022 6:11 =
PM
>=20
> From: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
>=20
> [ Upstream commit 2982635a0b3d08d6fee2ff05632206286df0e703 ]
>=20
> hyperv_cleanup resets the hypercall page by setting the MSR to 0. However=
,
> the root partition is not allowed to write to the GPA bits of the MSR.
> Instead, it uses the hypercall page provided by the MSR. Similar is the
> case with the reference TSC MSR.
>=20
> Clear only the enable bit instead of zeroing the entire MSR to make
> the code valid for root partition too.
>=20
> Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Link: https://lore.kernel.org/all/20221027095729.1676394-3-anrayabh@linux=
.microsoft.com/
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Same with this one -- no stable backports are needed as the patch is
more about enabling a new scenario than fixing a bug.  Again, Wei Liu or
Anirudh should confirm.

Michael

> ---
>  arch/x86/hyperv/hv_init.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 3de6d8b53367..10186bd6d67e 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -537,6 +537,7 @@ void __init hyperv_init(void)
>  void hyperv_cleanup(void)
>  {
>  	union hv_x64_msr_hypercall_contents hypercall_msr;
> +	union hv_reference_tsc_msr tsc_msr;
>=20
>  	unregister_syscore_ops(&hv_syscore_ops);
>=20
> @@ -552,12 +553,14 @@ void hyperv_cleanup(void)
>  	hv_hypercall_pg =3D NULL;
>=20
>  	/* Reset the hypercall page */
> -	hypercall_msr.as_uint64 =3D 0;
> -	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
> +	hypercall_msr.as_uint64 =3D hv_get_register(HV_X64_MSR_HYPERCALL);
> +	hypercall_msr.enable =3D 0;
> +	hv_set_register(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
>=20
>  	/* Reset the TSC page */
> -	hypercall_msr.as_uint64 =3D 0;
> -	wrmsrl(HV_X64_MSR_REFERENCE_TSC, hypercall_msr.as_uint64);
> +	tsc_msr.as_uint64 =3D hv_get_register(HV_X64_MSR_REFERENCE_TSC);
> +	tsc_msr.enable =3D 0;
> +	hv_set_register(HV_X64_MSR_REFERENCE_TSC, tsc_msr.as_uint64);
>  }
>=20
>  void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die)
> --
> 2.35.1

