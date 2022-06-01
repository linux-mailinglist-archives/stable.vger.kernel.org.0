Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B32539BEA
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 06:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiFAEEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 00:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiFAEEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 00:04:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE236899F;
        Tue, 31 May 2022 21:04:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=geJ7oDK8xOGrEWnx6TWTIPxX/k8p8v7HFVKmmBcicDKRL6p0rp7p1S3Yy3WKcF2znHyn72uaUVcxx9beB38j3Z5Zk1r5PvDE7XzqMj02OfWOu9fInppirpk/T8EFGFtPRjIkgEP8t93aBmlrAR8POczt7se3AUyyqZdMclPexHixxXOIA27q0GsvJSLlu+CPiaXpQjhLyDy2HesBP0Z+dlcXDcpu0IefGs014VIU+CGn8W5XVHb2vSDtMvJf7KFDuzQyhxld+rZe2cBhx69oeJxOzlznnfXwROQlntDxTGgstoS/zJ0AucLPbNDZs6D8sA7pu6Bj5NF4bhjs4M/8FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDl5KL85ziVf1UNRMt0a4b6PzClMKrKw5OmAhmA1yFg=;
 b=HMsWkxtGhSnJ/BHFiTMaAT3Q1kXYnfO+IHg6TWehtBlwazV5djBf3jBxVEeekqfD3qVPIGsCDmyDVTz7/J644sUw8IkbPMKgALCZcnproDvdUvNYnnGy7gW8zysEXG0yfC2cN1pS6G2vEtxkS/4Li7O4iR/WqQ3uhJlxdwO5tWM0b2EhTPIOoam5/vzK5Sxb8UiNYx+3dJNhPT9TCnyOObGFPtnEn7TyrVK57Q5cxq2suZnzfyo9fsJFDshvVFmZ8RQLE1WQRABaGah+oJBuws6Ogmtaz9vaJuWgqwpowTeqtkyq0urWgctfK/6D5g5lqvIDcP055DAYwTqXm6scqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDl5KL85ziVf1UNRMt0a4b6PzClMKrKw5OmAhmA1yFg=;
 b=vjwWOrqQxHftM1drabzOYrOiCEFXinN+KXWKkMbPRB2vjzJ1nISBzEG0orbK8p5N86oh58hXUW3OPWRobaOG1ur4J4YBRzcJJSUxzEx4TNCze3+YMpg9tFgGCGCTfXXQTtmObwa2ydxohAZOkgsYhSdCd1u9PlrUQdg07S36paU=
Received: from DM6PR12MB4417.namprd12.prod.outlook.com (2603:10b6:5:2a4::12)
 by BL0PR12MB4948.namprd12.prod.outlook.com (2603:10b6:208:1cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 1 Jun
 2022 04:04:46 +0000
Received: from DM6PR12MB4417.namprd12.prod.outlook.com
 ([fe80::8936:1265:d9dd:5505]) by DM6PR12MB4417.namprd12.prod.outlook.com
 ([fe80::8936:1265:d9dd:5505%7]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 04:04:46 +0000
From:   "Lin, Tsung-hua (Ryan)" <Tsung-hua.Lin@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "Li, Leon" <Leon.Li@amd.com>,
        "Swarnakar, Praful" <Praful.Swarnakar@amd.com>,
        "S, Shirish" <Shirish.S@amd.com>,
        "Li, Ching-shih (Louis)" <Ching-shih.Li@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        Mark Yacoub <markyacoub@google.com>,
        "Li, Roman" <Roman.Li@amd.com>,
        Ikshwaku Chauhan <ikshwaku.chauhan@amd.corp-partner.google.com>,
        Simon Ser <contact@emersion.fr>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] BACKPORT: drm/amdgpu/disply: set num_crtc earlier
Thread-Topic: [PATCH] BACKPORT: drm/amdgpu/disply: set num_crtc earlier
Thread-Index: AQHYdCXjvhdxFTwVA0eKkChCabvSIq0573EQ
Date:   Wed, 1 Jun 2022 04:04:45 +0000
Message-ID: <DM6PR12MB441701EC6E6D2A678F42A480B2DF9@DM6PR12MB4417.namprd12.prod.outlook.com>
References: <20220530092902.810336-1-tsung-hua.lin@amd.com>
 <YpTBBPVxcdJ8sn8m@kroah.com>
In-Reply-To: <YpTBBPVxcdJ8sn8m@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-01T04:04:40Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=a3654156-dcea-4497-aa93-c136fb84cd82;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-01T04:04:41Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 4743cccc-ce71-4c26-bdf9-6a2c1b7ac630
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88822882-5b87-490a-6350-08da4383dd4b
x-ms-traffictypediagnostic: BL0PR12MB4948:EE_
x-microsoft-antispam-prvs: <BL0PR12MB4948D210B122BB73A8D736B6B2DF9@BL0PR12MB4948.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aDm9kIl4eRpuLynDzKsq8EJ5LhGuGftLdCHKUTdhnAqdZza1BXEDhE1A4vLBeosYtXcFiUtbAJO6LPwxmINu44yY5zMyC5G32dQV7br/ILuFRy5cWshDDvWyW5QQA665NCP2ca5+nzjj3QL5gB291+VMgfNhtbBrZ2D8P8/Qsl5HMTpuhAqqYyxJfiRTEM7OPZL64cWWvmItNij1YGIJG76KwfXY52HvO7GmrQYsomVcHYppbsmKE37KXe32zaYgQ0Zza4rDmVtrC593YabG4Et0hDL+XJgIua5VwB5tguKsf6u6fuvbAnb3clsMF51ZcvWUFevjXfFXv2iST/EORmqATIPsky0RQZEKFpFH0MDipmMKIHHNgjXgQApfr1Cmh1eBVypcVKjTH2KAlMhzK58yC0lhI1W38DKN5y4Nys8ZAc2qjz9eZXT2kzDj1uA9mSXV513hwTmRrqhc/3Vfs44ddeL4bWtts2q2CCz5n7hoAHR6D1vxxmhuHFPZcldciWTpcbic711qUVNpld6Dn6F5D97cqShxxRf+Pv8urOO1YRGgeTtsLsv7rhESNHUlJy7wTO5n4h5+Nk/n+yDIUSOtpJwhX2sSgEmYS5EOxjuRn3nzbJmZEtCNmu1QMITUZqG1j7Aafe69YDtVsmjkLpBA4phtOIn0MkI+8p77//hZ9kB+BGDwd269CDdeQBUjkhOMqG4FqgRfJt1k2ttviQGhuNsrR4tf89oOBAtrJhzLs//wu6ay+EYphCGB5hXQOPwR557qgkO0fB9mH5RmjGipm5ZlObBfWbSA3dISeHg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4417.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(7696005)(53546011)(86362001)(26005)(2906002)(38070700005)(316002)(6916009)(966005)(66446008)(66556008)(66946007)(66476007)(64756008)(8676002)(76116006)(4326008)(38100700002)(55016003)(8936002)(7416002)(54906003)(45080400002)(186003)(9686003)(33656002)(52536014)(5660300002)(508600001)(122000001)(83380400001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E1U1ll1f0C9NVL1+NUuXA3TCUQypj///e2CZxsjM9bDQYd3TnhmpSJ29QKAT?=
 =?us-ascii?Q?mD71GyPQSrxMNz2sIVFneEqbGY0lzgQGQx+TDQPUM6ueGzH2REDIbIhmQmPc?=
 =?us-ascii?Q?9jzB/R5TF+BuGaLTGWF9iziIHBvptwe5L448HK5q9FjhFyeuIjPBVJ8mpSjU?=
 =?us-ascii?Q?je2uj2dIsqz4TT6yVv0dJ1mDdto7DNIOcryndPAuWubkokdkMUri8wKHb6rm?=
 =?us-ascii?Q?rd4xS6Zj7TO0fiNi3wL34d5G0yCUe3HuMZchd8hyc3xPauX+2+uRiF8n0yHJ?=
 =?us-ascii?Q?zwuuY0rKcLy9bt0x870xPY5kvEbDKShAaB4JNBbJrAW0SXofYPWdKcxpOJPX?=
 =?us-ascii?Q?ShJiMIj7awlRGJofCq21KF+CeaeZtKCtS46JWFYoVLA/o59qi5X1ttzpRwUr?=
 =?us-ascii?Q?GYsOXk3coOoiJK9u5OuJZ77rkhE+ORfnU+l5xoCH1VRLUAqZbaY/RuL8qU74?=
 =?us-ascii?Q?uO3VMrgrKYg2+Gx3oaGe3x66EawrLXblzQpxw40j1hDPqaEPKuAOsBm6qEp2?=
 =?us-ascii?Q?T4lH1ZvKcyHzOjrxH1tOjnkNYpT1qa/gdPbp43o6Our4G7xaFgJh6rfZ3/Qx?=
 =?us-ascii?Q?d4EaQjJIPdnpyUYhyRHtTwEwY95A40JhTMUmb713Uos7CJ33GXQtfKWRwzxA?=
 =?us-ascii?Q?DrufjpRgGW+lpda9yL/c8Y6VYPRLT6HWTs9JRjxBMJQSm4cU+FvqXpmjdwNv?=
 =?us-ascii?Q?s8KzcDIacs9yIAkGZrMEHxzmxnrTXPQ68eUopjb3qzWSe8npRcyxJp94Z12Q?=
 =?us-ascii?Q?5LF4IB1mX4xClqaFiAfxnXkN7U1ylQfvhFRMtNgfqPwdSXTAJzd76NZCtqI3?=
 =?us-ascii?Q?+7ctQ68rnNYCBAg6vA/ie3QqOVYf50IX9LRf5WMc+Ns/a4khkg1jzCCARnK9?=
 =?us-ascii?Q?IV666Zs0k1HyW3eMbydHvuanDt4UncG+mGTL7tuMvFaMEfl85lHMMiexKef0?=
 =?us-ascii?Q?wmjKukZJ8YpUs9cWnIVXI8PXJGNmzsBOi8/f/bU87jj9hO1EF7vCjX1S0iWO?=
 =?us-ascii?Q?Qr4ohu97sePmpnVVYV3KPYkQVzafefm6uCbBEVeIVvC6eByGdvjyUwQ02QPI?=
 =?us-ascii?Q?KrCDRhBWqagrS5JUGB91tO9Dl6vLby0189F76SORja8KlGrnK28Zu+RBjPD6?=
 =?us-ascii?Q?4PH/C7uU5p9cSlndyT9WsDYBlds12QhnxL6X6w5FmgDuLN0krKSZWm1Df2mq?=
 =?us-ascii?Q?CzeyMX6pqzD58VNzkBt48uTeQjJ8NPRRTOD/cSIxw2JQ3foRvZDmhljuJLT6?=
 =?us-ascii?Q?5cZ0cJ7CP4kaiFKoMXbiIdCzqAgncJS1UW8Qo30HdfdE2m+TCa0l2VYsK0OX?=
 =?us-ascii?Q?p/ioU23lcH24JmW7AF3aPDkyokkRR8gVKgmY5Wn8Q8rqbigCeRXyWunerr3G?=
 =?us-ascii?Q?S6k1lo5khoGHMvRox+dBEKfDCl3Sn5Mi9OcbblpSJgOxgWMbuqboMEOqLYEp?=
 =?us-ascii?Q?M8DP2bIhKwRJ1z8O0O2f4EzWJAkX11dTqJv1hvTbBxgFw/+3ZJ2BB9ctzdqw?=
 =?us-ascii?Q?o6qB56qXtaPFBTiNzaPVCYPVtJ/QiPWA2pMKcaaJFRnerXNNglB5/ipVP9Nt?=
 =?us-ascii?Q?F29aKJf1jS4NWRdeudFwVtqsXUXJUmRVkB5ryklExgBQ6PGt15iDAeraYVdy?=
 =?us-ascii?Q?i2sWBTNBf2JotaBkPsYT6cLNP9PfibqmwdnAdRVNNoJGz1GeZAwXD6EDAypu?=
 =?us-ascii?Q?TQfRuFlB48DY5oOWe07mwXeRKsn2dItYjUUuzSx5bs1PUwB+m0rxQJG+ZVl/?=
 =?us-ascii?Q?5dPgdTbrLg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4417.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88822882-5b87-490a-6350-08da4383dd4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 04:04:45.8359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JrB8vs/X5LYtGNp4uSjwNPVHWNf+NXjH4KhLI4zxt0ZHSEawA3lzabA64YNT0153RZoetNOCTdeEZfH4/GJA0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4948
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

Hi Greg,

Thanks for your advice. I have modified the commit and submitted it to Gerr=
it and it's under code review now.

Many thanks,
Ryan Lin.

-----Original Message-----
From: Greg KH <gregkh@linuxfoundation.org>=20
Sent: Monday, May 30, 2022 9:05 PM
To: Lin, Tsung-hua (Ryan) <Tsung-hua.Lin@amd.com>
Cc: Li, Leon <Leon.Li@amd.com>; Swarnakar, Praful <Praful.Swarnakar@amd.com=
>; S, Shirish <Shirish.S@amd.com>; Li, Ching-shih (Louis) <Ching-shih.Li@am=
d.com>; Deucher, Alexander <Alexander.Deucher@amd.com>; Daniel Vetter <dani=
el@ffwll.ch>; Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; stable@vg=
er.kernel.org; Wentland, Harry <Harry.Wentland@amd.com>; Li, Sun peng (Leo)=
 <Sunpeng.Li@amd.com>; Koenig, Christian <Christian.Koenig@amd.com>; David =
(ChunMing) Zhou <David1.Zhou@amd.com>; David Airlie <airlied@linux.ie>; Bas=
 Nieuwenhuizen <bas@basnieuwenhuizen.nl>; Sean Paul <seanpaul@chromium.org>=
; Sasha Levin <sashal@kernel.org>; Mark Yacoub <markyacoub@google.com>; Li,=
 Roman <Roman.Li@amd.com>; Ikshwaku Chauhan <ikshwaku.chauhan@amd.corp-part=
ner.google.com>; Simon Ser <contact@emersion.fr>; amd-gfx@lists.freedesktop=
.org; dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BACKPORT: drm/amdgpu/disply: set num_crtc earlier

On Mon, May 30, 2022 at 05:29:02PM +0800, Ryan Lin wrote:
> From: Alex Deucher <alexander.deucher@amd.com>
>=20
> To avoid a recently added warning:
>  Bogus possible_crtcs: [ENCODER:65:TMDS-65] possible_crtcs=3D0xf (full=20
> crtc mask=3D0x7)
>  WARNING: CPU: 3 PID: 439 at drivers/gpu/drm/drm_mode_config.c:617=20
> drm_mode_config_validate+0x178/0x200 [drm] In this case the warning is ha=
rmless, but confusing to users.
>=20
> Fixes: 0df108237433 ("drm: Validate encoder->possible_crtcs")
> Bug:=20
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugz
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D209123&amp;data=3D05%7C01%7Ctsung-
> hua.lin%40amd.com%7Cad089e5485984cd0cc1f08da423d097f%7C3dd8961fe4884e6
> 08e11a82d994e183d%7C0%7C0%7C637895127184900879%7CUnknown%7CTWFpbGZsb3d
> 8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C
> 3000%7C%7C%7C&amp;sdata=3D0UcR%2BZszfxXaFz6LUqGq5eYgeqxDdrhySBL7mDmFPKc%
> 3D&amp;reserved=3D0
> Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org


Why did you not sign off on this?

And what is the git id of this in Linus's tree?

> Conflicts:
> 	drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> 	[Ryan Lin: Fixed the conflict, remove the non-main changed part
> 	of this patch]

No need for this here, right?

thanks,

greg k-h
