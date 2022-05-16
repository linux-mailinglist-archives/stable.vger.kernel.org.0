Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D29D528C9C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344652AbiEPSLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 14:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344594AbiEPSLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 14:11:06 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8497D2DCF;
        Mon, 16 May 2022 11:11:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqBiMliB1dMUjl7NqXG6xDZiV3G2ZXhaMTukul88rrl4YtlSBOqewr1CxNgGYj5NkyfW6Qa7Egyga3pKhGAeGWoVChz8lh1z56O8cKfGUjTg4MNt0qJVSUgpna4kTmwhEd8M8bFlfYhq7626L+AzxWSVdDuLsJChnxf6+A4qH0OSIOGqHY5fj6flYsMFyDRzHLbXiU0umAHrkmGezm5FBbKOwcQO1mwFN3m/mqQkBH48u1CWc2qV1zU4jzEbdTp6hFRZBP7uwIWC0cxnabrmBZj2Zy8peMY+uYSNKqHvNJ8MS46WRjiiqIwOKZAShCe0ofNRLsvi9XSOF67q6xMThA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJcGDmtRFT62t6blsYCuFow79wNBOkPGC45xJ/D60Eo=;
 b=kt5hv8OW6lc0+Xlem42GhQNTMsswd8hKEx6KDg7KUQ1EFImqHPhS/8ejLaYdhZIvKUh3MAPrS9rKWVu8Kq3Ezz0QzEYJCng+K+DXnxzz0yMBQx8h6mUJ3yXjvnoh9Q0keH7+3E0H0wM9z3k4Ozev5uVCknX+MPop9RtTjY/4EcL9l/97w8RP4Tm1dGWgbzwKVuq5xaQFov/7MX/WHrniFrnNFRO4Vwfh3uzqP0eMPJDeRYA8gtTJTkXL1QLDNOpt6koej9qDGiqh4ObpBhLg3zb4lSGhzcGAxE7RwkgW1f6g9e9tUq0GB6S7BCT77xf8PQ0mG1IfF9kwfymHuKJxTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJcGDmtRFT62t6blsYCuFow79wNBOkPGC45xJ/D60Eo=;
 b=3o4IaRKfxGFnc2B2VelWukeZXvQN9Jbw4A4R3JN/S7LGI+hm425anovMUgjJn5bpSVkTnoHo/ReowQdBlFU9S88oOqOCV6q8IFSLxRey1Fw+RFEtxb4XeNik8uxmU8KKLpr3aT2wdPnw6lDYcLMyk465hq9AtClQobv1i67K6HI=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BYAPR12MB3382.namprd12.prod.outlook.com (2603:10b6:a03:a9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 18:11:02 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0%6]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 18:11:02 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Peter Gonda <pgonda@google.com>,
        "Allen, John" <John.Allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Thread-Topic: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Thread-Index: AQHYaTwUxoMisTo8TEW3VgseD18R+K0hp6QAgAABb8CAABTegIAAAVcAgAAG6gCAAAO/wA==
Date:   Mon, 16 May 2022 18:11:02 +0000
Message-ID: <SN6PR12MB276737E018DBCA12EF6EB3218ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <20220516154512.259759-1-john.allen@amd.com>
 <CAMkAt6oUxUFtNS4W0bzu13oWMdfnzfNrphH3OqwAkmxJcXhOqw@mail.gmail.com>
 <SN6PR12MB27678261F176C5D9B5BF64EF8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6q7kTGS5QgZRq9xc0HaEYyntmj3GRWehr-3Sb4y2eQ=HQ@mail.gmail.com>
 <SN6PR12MB2767B4A3919E38C7F429CC2D8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YoKNDoiXKGbBhuIk@google.com>
In-Reply-To: <YoKNDoiXKGbBhuIk@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-05-16T17:56:02Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=4f3af9bd-17d2-42da-b60e-56a7ee097c15;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-05-16T18:11:00Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: f15d382c-8246-4249-9184-64548c71154b
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ef49790-10c6-4e72-6f07-08da37676ffd
x-ms-traffictypediagnostic: BYAPR12MB3382:EE_
x-microsoft-antispam-prvs: <BYAPR12MB33824D65726DEC5E4638138D8ECF9@BYAPR12MB3382.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hByThre5heXecrH9MSLGWQl58dmbI+hiB5rsfEdPWYq7CzCBQFJkD4WcVHvdCEzJnpWTqcRsBEeXzvKmtNb8UpmTQO96V1rBeBqNqeFHmci0v8LbQCiQtZ9oNZ67Uwl1An0ZtZIElRzZwNYDY4jelD1moGrMTn2UY5WfKQv8e8oIBDKHsZvp4u6jyTo0Zhd7YUcM72GZjxBzhNSTkikctIpiWP9z7zMAggchdooDoKuL099+T8aAmqS2vwIa6ehcFof0fXTBEjrg+fxNZBybH4WVlYQNconiWeiNzOtqwW4FK700jzF+670ALOWLPMNxxIKlsyKlPXVLpWGjzew4ZXD4UWVHYWFscemY2VwogcT84Nb9NVO5S5FA3J8/VRBPIv58wlGPI/FTm9O6UsBoNdg14AZuOsnQIUh8gyG7Tb3EEFy51P4fGjnYRmCgcUwJLDQh7YaZyuNUfwUEFHRoLHyF1E3WZdUdLK0mWsuCyeAoYtb0EGPNV+4fg3aXrNO+a959TzKnkHjS4myzQDImMW5bzy1K6qkdOCfaP+2IEP4NhZ5HTecP8jVM2TkLtYGmAqvCHAuTyM8t4zhjS8fVSHgHmTd3JLdNYlCmKhwyLvCdZwbydt2oVw96Rk+0hfAxvDS6eYMlbgKkLSQVnn60oNgqRg/3iCWHGFkPmLGrBoxVhq4ZODr1V4xW6w1TIjQoM6niHNc4hrbNRt7UUasQWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(8676002)(53546011)(64756008)(66446008)(66476007)(71200400001)(54906003)(38100700002)(316002)(83380400001)(8936002)(4326008)(26005)(38070700005)(5660300002)(9686003)(33656002)(6916009)(66556008)(508600001)(52536014)(86362001)(7696005)(122000001)(2906002)(186003)(55016003)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fT+4Fv8runMJg6vo3TF6Ib7E4mB3ItAMd8+GNv8wyC9Dg3zTDKROXiyj2OZg?=
 =?us-ascii?Q?9uyjKmLs20be+K/uuhR6Tdqy7puMUvsUfcpfT/Fn4RHbC2MNX32V34z9gRXm?=
 =?us-ascii?Q?W+7TUTAwsQzUDN5sWetNV2fIv35ooKNt18pjmY3EQGnwIgbSMVILDfvVsSWm?=
 =?us-ascii?Q?5DVYnpGrQkLO/+rSagKp7/4h7U+YGDR5zg4NSpXc1SD6/d8FmeV/BcyisfHG?=
 =?us-ascii?Q?/KEoHVbD5PcKc4zajGSWSqU1Tq6bx1LEGjPkH2f8oGKX66Rz0qW65eyYDwTf?=
 =?us-ascii?Q?fAv8dhFlL8hziQjahfRo8JGwIpMdClZsSVciRfed4USJXpe+OwAcdzGmaEuz?=
 =?us-ascii?Q?K2wXSBFYrF/h0RPk7mdMHIBMOJwssGJqHo5koCBOGGYzd7/VzkUx4QqtFOtL?=
 =?us-ascii?Q?KlnWlWOznNCbqr9hT33YxeMa1RJInbHAmYTXm5bpCGJRu/viSbKekqvnUmrM?=
 =?us-ascii?Q?EGWe0Th6wINFqLok/ti7D2vTAcpZkEFJssbWSlyD36uEB+3IaMxcOfO7OtMf?=
 =?us-ascii?Q?D/BDXCl8tIA0H7cRBMGvsa4b6o4xlVG5f/mGOMLVTrkjMoZThqUJ43Cz8pT1?=
 =?us-ascii?Q?vJyLCLqKyiTnHM7jP7gBa07ZZ0+3Gq3dFJoYzEuOjYfw4xMVdBVQwKMNkhTl?=
 =?us-ascii?Q?x2UTMZHYODwD2MkDUeyJnSjrdz8aG2ew/oCaL9pBtYIAX6/3rgUvqSCZlHBB?=
 =?us-ascii?Q?huf/dSaj6P34XDRGCfoq6Ang5WyH1cU1wQw6vfCRGc4vVboiLdOSfWFfXe9o?=
 =?us-ascii?Q?KQ/p1s9mJ7oTlw2f2zM/Clp69wV61YIyTIAHJeQDGdtsljP3kqRnNkeF6B0g?=
 =?us-ascii?Q?fSrhvFXlyjulTuEaMEMjP1zXn65mBxDImpDwDeoZl2LO7ZA8tZGnOLDarCSR?=
 =?us-ascii?Q?ZalZmh8mZYoe+hdd39DscBJWIfrnSPij95cRNh7AGznnA+gyGL1+H8XgAF5j?=
 =?us-ascii?Q?9Rpl/FllpczkPTz0oFV2KJ3rg6HIefvi7VcqHY2m+G4h8o3RjYsqvwYSLUsO?=
 =?us-ascii?Q?MZrMWWUhjrLde7N4cyN9QiZLhcNMTexLPRoRF9qyNmNcEsRzSQ0VUUFgOBSg?=
 =?us-ascii?Q?OUAcov3LnQeoOIsWjNn6l76Gqiyca61QJMYhZ9GKhQ1Aue/NAc+8f1ujBHjZ?=
 =?us-ascii?Q?djcygDAy48TTnisqD044yesaHfcxdSZeIKAqSgR8UE+PbkTDPX/E3kj8t+pZ?=
 =?us-ascii?Q?yLtIqOD6uX/3j8E7WIMMzgVNJyMG92NL9mRB1bnvf3xz6Wgal5LashuqlPzl?=
 =?us-ascii?Q?B3mdMciQvV1R2+KYemg5fg4l0UG6zXfH6qZQ/kuyiORKDoZJtT8wLWDCPWVW?=
 =?us-ascii?Q?cbegA1AOp4rDDqgeRQtHOmamgDXXWE0pRQb3vcr1PDD9O37QUNVX96ABbHei?=
 =?us-ascii?Q?1V0VvXigM/ArcROeQu7vDgjTDfy/YtsliKSLGIC36vleg80Myws9hXE/OnDy?=
 =?us-ascii?Q?ozNLhREJPVzMLikbRlPzn+ohCbxClaRaUdle2UPqXEkIXqSdcx8EgTjTjNZr?=
 =?us-ascii?Q?NZvdOx2k/iEO5Yyl95cB/V4wzONz6JqgXKZXpEJmwC5fe2bUV5T57gh8p/Up?=
 =?us-ascii?Q?oxkYexo9NL+vYwUbLfWzq2Ovopl18Oj4DHmjY5/Urlc+eIhg2OMBC95VjPoj?=
 =?us-ascii?Q?iD3iPL66s6m9sSxp+u4h8np7lYZkp4te/xR4E2MPfRXXQeXoMAR6cF7FqIzS?=
 =?us-ascii?Q?B+yhnyqR/5ErkJYu1vLdULYbD0dkL+ToTcdVQ0kkegr8JAvm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef49790-10c6-4e72-6f07-08da37676ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 18:11:02.5916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xtJizT+mF2/HQR4tH7mY/s7HXltWJp/7Ewg7G54n1fF5OfKV06R3dLg1ZeaeiPV1gspDHP8uSIXgaj3Co/UsLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3382
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - General]

Hello Sean,

-----Original Message-----
From: Sean Christopherson <seanjc@google.com>=20
Sent: Monday, May 16, 2022 12:43 PM
To: Kalra, Ashish <Ashish.Kalra@amd.com>
Cc: Peter Gonda <pgonda@google.com>; Allen, John <John.Allen@amd.com>; Herb=
ert Xu <herbert@gondor.apana.org.au>; Linux Crypto Mailing List <linux-cryp=
to@vger.kernel.org>; Lendacky, Thomas <Thomas.Lendacky@amd.com>; LKML <linu=
x-kernel@vger.kernel.org>; Andy Nguyen <theflow@google.com>; David Rientjes=
 <rientjes@google.com>; stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces =
to prevent kernel memory leak

On Mon, May 16, 2022, Kalra, Ashish wrote:
> > >Would it be safer to memset @data here to all zeros too?
> >
> > It will be, but this command/function is safe as firmware will fill=20
> > in the whole buffer here with the PLATFORM STATUS data retuned to the u=
ser.
>=20
> > That does seem safe for now but I thought we decided it would be=20
> > prudent to not trust the PSPs implementation here and clear all the=20
> > buffers that eventually get sent to userspace?
>=20
> Yes, but the issue is when the user programs a buffer size larger the=20
> one filled in by the firmware. In this case firmware is always going=20
> to fill up the whole buffer with PLATFORM_STATUS data, so it will be=20
> always be safe. The issue is mainly with the kernel side doing a=20
> copy_to_user() based on user programmed length instead of the firmware re=
turned buffer length.

>Peter's point is that it costs the kernel very little to be paranoid and n=
ot make assumptions about whether or not the PSP will fill an entire struct=
 as expected.

>I agree it feels a bit silly since all fields are output, but on the other=
 hand the PSP spec just says:

>  The following data structure is written to memory at STATUS_PADDR

>and the data structure has several reserved fields.  I don't love assuming=
 that the PSP will always write zeros for the reserved fields and not do so=
mething like:

>	if (rmp_initialized)
>		data[3] |=3D IS_RMP_INIT;
>	else
>		data[3] &=3D ~IS_RMP_INIT;

>Given that zeroing @data in the kernel is easy and this is not a hot patch=
, I prefer the paranoid approach unless the PSP spec is much more explicit =
in saying that it writes all bits and bytes on success.

I agree with that and we will resend a v3 of the crypto patch with this cha=
nge added.

Thanks,
Ashish
