Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDD060B63F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiJXSwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiJXSwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:52:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E556D841
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 10:33:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8k7Ys1weqW9nBpf7UtFlH/so6enWGxbKFVMfPMHOOs4I/KHrhE7qIWC6Rdri4KWIxIC4kvuNo0UVdiVEkdF9+I98TMh8m56dPl2JX/DSBGv+fModWEyXBxB0MMn/hgPoRdRRC5lVWqWqfLhvbbiWIvdVqKGTSKMK5aR7G/B54KEYwzf6sv5nIxL0FYEDRtlolozFCe2KSz+VqHYRobww773S9VB2bt4mrc0ECVM+BSaPSFHxCuFxniBYK7Yl/BJG+k9ESaN9F+kClLR1PAkkvw4rejvgK/U09JuuwwTv+v76+s96LG27KkWOLzdjSnb9csbVwgatJVYPJWh0C3Liw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jaZ2oHYT1HMmC0uNun1gA8w2hEUNEUKwkW6pDZ+I0E=;
 b=FqNTc+ZR+SSTJujWY+MhQF5s4RVixhxIT5Zei6KEmgPRx+3WAKiZZwrg9dF7/VBuPRKX0Cod71zomyJ+Jh2YhlxyLQIGCL2zPryoThlEA6cMGXqz8bPs8RNwz73q/BO+BV4Jtkv3GUu3nFOsSc6KQVXa0JCYFc8w0XLsHmPq+2deXCOZ2rNx9lwK27YdpfGFLIPq5MVxN15b5zSXT/MCJ9ExX63zT6o0ORPTnU70sPhPQYOhHDyfp5PPT0EE7Y7unopjEzEQ2zVmjBbYkfqJwMSf0LBKmC9dXgGDaAV6DSABVIDaKFXaU5hrabCw0Zphc9rtxL7/xFoFAhW9+UPMaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jaZ2oHYT1HMmC0uNun1gA8w2hEUNEUKwkW6pDZ+I0E=;
 b=YhRzYIN4l5lH5N6pERcvfX2YYxyAGMcJy+LmIrjvb0Bjn/1vkGEX6sI/nGuzmWUkZmoXSsIJnOeJZoDHXnASaW9310fX7rEzhKBvidBwWF7NmptihPs6NlRPzyxr7UaI1rZfK4PSfwLoCQzFPULVTsi+cDpYuI3s8YjcUQ7TdcI=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BN9PR12MB5113.namprd12.prod.outlook.com (2603:10b6:408:136::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Mon, 24 Oct
 2022 17:31:53 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::892:bccc:675a:6187]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::892:bccc:675a:6187%5]) with mapi id 15.20.5746.027; Mon, 24 Oct 2022
 17:31:53 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Salvatore Bonaccorso <carnil@debian.org>,
        Diederik de Haas <didi.debian@cknow.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Thread-Topic: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Thread-Index: AQHY5Joa01+sOpIgb0CXCB0zjRa6p64X/yAAgABgTwCABRGVAIAAMHQwgAAGsICAACr34A==
Date:   Mon, 24 Oct 2022 17:31:53 +0000
Message-ID: <BL1PR12MB5144F3CC640A18DF0C36E414F72E9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
 <2651645.mvXUDI8C0e@bagend> <Y1I4rC37gwl367rt@eldamar.lan>
 <Y1Z5Km83Rcc3W0PY@kroah.com>
 <BL1PR12MB51443BFF32835644A72F7A38F72E9@BL1PR12MB5144.namprd12.prod.outlook.com>
 <Y1ana7eNFN/CMNOg@kroah.com>
In-Reply-To: <Y1ana7eNFN/CMNOg@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-10-24T17:29:30Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=0bebb713-447a-4928-ac83-e99e80fc85d8;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-10-24T17:31:52Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 17748a5b-edd8-456b-8159-a2739a145c7c
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|BN9PR12MB5113:EE_
x-ms-office365-filtering-correlation-id: d7448b9c-7467-4754-16a0-08dab5e5a44a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tAJ2XtNKPteLANfcYJ+VkwGJL7cK1bFDoQzUMs0rZanNlyM4DCEiStepD84cN0Sn/BPFquoMlv2I7GWedAvUlhbkEAfSuBEtt3UEo8sJuWHfuclCGujTtyzLXAZtXV125zRphMoO6MD1CZmAHC1eIUPNahnYwUlWdICRfhY957lk1Pwo/xz/5I2WGUJcHOcm4Tj2tgZ8jf5ApHLDadH5VJ6ND+1DF3q/gTz5PLb5EN6QzwjzSWkB8bDBwdwuAvYbh5Cuw3io7bpgJBz0iRDhKB/bf8yHPzEyIgG7ofCJ5/jwc4fAj5MuNEA/tCYzgf8ZqLDHq9mCthWwLa3F84imMa/1vT6kDvT38KN9rEvFlDAMpg3FAItR3jYq+GxaJMXbEYNqWfR/dtnR/f9dUW6Yu+VFe0VkVfXTgRZTv7cWI30PEblTWAiFkDS5FwWQkpEzoTGWApI610BGBi+1AHWT9sCKF5DJnL/ADtsV7HhFiq6ejA7JGxS+cMn6G/eHN1F9pO+QB5+TirNa2BVxbkPSchdf6lPTQ6CmIm9Y46SPeQgS/OR954TL3I5MkkDN2fFw1LyqX5R3RizcNxVtaUNvR52xWuVvHBSt0OG7CAyGyLwKu0Ru8tu4+5Ut4LZVk5I/kAKPo6puW76WLQ7/1q0RLIgKpgtB2iCOC4icY2KLuZEuJn2EJmLh18cp0S0U21ZRHJLfLrxndHBp9CbIpcyhQKpDJNI/T/9lX2KjIgTjBMMkG8T2oBFQt09SG5Z3QezF5DGV8On/whmiPtiC99b9bVMGnrXTS63QQA2v6uKF88M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(83380400001)(38070700005)(86362001)(33656002)(66446008)(8936002)(52536014)(38100700002)(122000001)(76116006)(66946007)(66556008)(66476007)(5660300002)(64756008)(8676002)(4326008)(41300700001)(2906002)(53546011)(7696005)(6506007)(26005)(9686003)(54906003)(6916009)(316002)(966005)(478600001)(45080400002)(55016003)(71200400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EUROCY+NwCarhtgSFwOtPBi4PKpaPpCngHvRx0lHhSb1Tey8X2Jl6WmNNnIi?=
 =?us-ascii?Q?DdgZ9XX9QgXrx9Wxpd9QUiTAVYlZ/4PC1X5WFLkN5DUlxIPEAGlFmF6Gx+DV?=
 =?us-ascii?Q?10KXPwbJF3zCSNHzj2J4khlbwxyj4xovlTJjuFQzmhGNKi2HKam/qdrsnKUD?=
 =?us-ascii?Q?xePRk3W3BcrljxzOSUo0auInryYo7aX3ziikOB3nWGv6WJcMn59L4VDQ6atS?=
 =?us-ascii?Q?J7oJ+PAugZXmm8WEAfnCjHALGGhO5b78N6EMMH+mMAGSGviyKRIbYPWnyccB?=
 =?us-ascii?Q?BbKoMTFqEi75yl7ldS87dQjS254ZuASYgjOlAJ8oD64DkOsrh0hNzr3Msb/B?=
 =?us-ascii?Q?qlEN/UJZGDZ1Sdd/R/Z5nEYHzbANjQm1HqgnvQgkHBg2RsStSyB4hoTy3rNr?=
 =?us-ascii?Q?1U9byTjWauNX0eHukCQ0OHVCJ/jv++oBKnXyGWGpQmMN7+6Edp2Cw0DxLp25?=
 =?us-ascii?Q?Cf9WJe56wGpiuU3WuyQMkyzk0jHo74+zMi5Dd1BtcwFTpSLxVZNP/hsc4TZV?=
 =?us-ascii?Q?vy/NeW/IaykXuK+DRLuX8R2WnVNIqVzwMKoCBYjTtRts0f/rePxSTrcEvnLI?=
 =?us-ascii?Q?d8V7MF+GePXG5lRUzp7qbNE5kjnDAMCRF1fo5qhKToKD2uSXfoiHwJt/F2sj?=
 =?us-ascii?Q?u+8puwIoC3bpIWrzEKfyeztblZE0IVtDPg6YAhL5ghaT1smGqRlviBhFA2hK?=
 =?us-ascii?Q?b3LeFGZn6il7venOponLjuPoWTQgZWJLtpY1h1swNASWtMB4dDEZji3qHce/?=
 =?us-ascii?Q?Q74I1/DK4tkj7MVzFADzNEDbuoNV82ef260YXTw6PUqxL2C7z77ItiiHo3yJ?=
 =?us-ascii?Q?GCW6W55uHfT8iyCujBo+mJ1wfZtcq0s23voeEEaSsMgrYQCCv4fj8CZV1Ns+?=
 =?us-ascii?Q?J6bHtAyp5nYvXxxTGpPcREQCD2lKYHiebj1SRJvHkaTqYpICCi7UHKrLqJbY?=
 =?us-ascii?Q?XFgH0bv13PgDhr1Rdk4DnBJkX6BfmAMf/sGrqoKitLyZU3hOfBpfJS0FhLRw?=
 =?us-ascii?Q?Zfr82cP9mxklVQj949yTUfCirmd/2LqmSpzk1ttrJVph+9K/v0HEVrRd2DlM?=
 =?us-ascii?Q?IcE3Rj/3QA9FC98XrAmajK/495gFwupZO+ZHlbd2vEPYy8MDLscFgEWyyobN?=
 =?us-ascii?Q?pDuG0H2JU7bAPFGYG1yXDg99isrl/v2GAlhosZrUstb2DxCpNmEDDrxSIK/l?=
 =?us-ascii?Q?oFwdqPD3h3+oR62jGC1+KrMG6dMCjCaTV1KudD3S+rCn0uFY1yBVT5pmNDYJ?=
 =?us-ascii?Q?HyM8zvI07eR5/qinXKgwcxERiYqN27MxOzZnQmoIkLgp5AoIlGHy83BadsrW?=
 =?us-ascii?Q?tTBDtosCxrb4ao0fxKRyhx36B5/H8ks6xgtCVLRzzcN+ElR8nLlzgV+ctuUp?=
 =?us-ascii?Q?JLs/d8yAZZ+qugCAXMTj2X5D1a//7/Hcb/9k2KLg2xfUn8m5aXkTtQepP7lI?=
 =?us-ascii?Q?A/au2V5Os3augblsea5lg2OQGXrBr7cEgxZ/tZ0MCHzCqKOcuhNJ0wef9sru?=
 =?us-ascii?Q?m6OLm8pVxpHEIPyVpRiNkHX2JC6a5Bec3VSEXZ4Gppbz9jmjd6+9iYsFcn+5?=
 =?us-ascii?Q?McLX5hZt43yjOR7fcpPFBMosC8cVGvVjefw6FNEx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7448b9c-7467-4754-16a0-08dab5e5a44a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 17:31:53.4178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XZg8y09qITZ6ICZcLlV21kECGsQdTe+uQ6Nk54bM545tEFeEGfOmMxlX8vpwv9gEdR53DrrlwVUREEQWmtjvqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, October 24, 2022 10:56 AM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: Salvatore Bonaccorso <carnil@debian.org>; Diederik de Haas
> <didi.debian@cknow.org>; stable@vger.kernel.org; Shuah Khan
> <skhan@linuxfoundation.org>; Sasha Levin <sashal@kernel.org>
> Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio
> sdma_doorbell_range() into sdma code for vega"
>=20
> On Mon, Oct 24, 2022 at 02:39:41PM +0000, Deucher, Alexander wrote:
> > [Public]
>=20
> Of course it is!
>=20
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Monday, October 24, 2022 7:38 AM
> > > To: Salvatore Bonaccorso <carnil@debian.org>
> > > Cc: Diederik de Haas <didi.debian@cknow.org>;
> > > stable@vger.kernel.org; Deucher, Alexander
> > > <Alexander.Deucher@amd.com>; Shuah Khan
> <skhan@linuxfoundation.org>;
> > > Sasha Levin <sashal@kernel.org>
> > > Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio
> > > sdma_doorbell_range() into sdma code for vega"
>=20
> This is horrid, please fix up your email system.
>=20
> > > On Fri, Oct 21, 2022 at 08:14:04AM +0200, Salvatore Bonaccorso wrote:
> > > > Hi,
> > > >
> > > > On Fri, Oct 21, 2022 at 02:29:22AM +0200, Diederik de Haas wrote:
> > > > > On Thursday, 20 October 2022 17:38:56 CEST Alex Deucher wrote:
> > > > > > This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.
> > > > > >
> > > > > > This patch was backported incorrectly when Sasha backported it
> > > > > > and the patch that caused the regression that this patch set
> > > > > > fixed was reverted in commit 412b844143e3 ("Revert
> > > > > > "PCI/portdrv: Don't disable AER reporting in
> > > > > > get_port_device_capability()""). This isn't necessary and cause=
s a
> regression so drop it.
> > > > > >
> > > > > > Bug:
> > > > > >
> > > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2F
> > > > > > gitlab.freedesktop.org%2Fdrm%2Famd%2F-
> > > %2Fissues%2F2216&amp;data=3D05
> > > > > >
> > >
> %7C01%7Calexander.deucher%40amd.com%7C5f932b93d7154b20994a08dab
> > > 5bf
> > > > > >
> > >
> 354e%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C6380221300859
> > > 453
> > > > > >
> > >
> 54%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luM
> > > zIiLCJ
> > > > > >
> > >
> BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DD9Gkpt0
> > > zCN5q
> > > > > > BWoSngMY%2FiJyHWiaAC34eWr2UfYRIjE%3D&amp;reserved=3D0
> > > > > > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > > > > > Cc: Sasha Levin <sashal@kernel.org>
> > > > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > > > Cc: <stable@vger.kernel.org>    # 5.10
> > > > > > ---
> > > > >
> > > > > I build a kernel with these 2 patches reverted and can confirm
> > > > > that that fixes the issue on my machine with a Radeon RX Vega 64
> GPU.
> > > > > # lspci -nn | grep VGA
> > > > > 0b:00.0 VGA compatible controller [0300]: Advanced Micro
> > > > > Devices, Inc. [AMD/ ATI] Vega 10 XL/XT [Radeon RX Vega 56/64]
> > > > > [1002:687f] (rev c1)
> > > > >
> > > > > So feel free to add
> > > > >
> > > > > Tested-By: Diederik de Haas <didi.debian@cknow.org>
> > > >
> > > > Note additionally (probably only relevant for Greg while
> > > > reviewing), that the first of the commits which need to be
> > > > reverted is already queued as revert in queue-5.10.
> > >
> > > Argh, that caused me to drop both of these from the review queue.
> > >
> > > Can someone verify that this really still is needed on the latest
> > > 5.10-rc that was just sent out?  And if so, please send me whatever i=
s
> really needed?
> > >
> > > this got way too confusing...
> >
> > These two patches need to be reverted from 5.10:
> > 9f55f36f749a7608eeef57d7d72991a9bd557341
> > 7b0db849ea030a70b8fb9c9afec67c81f955482e
> >
> > I did not see either of the reverts in linux-5.10.y in the stable tree =
when I
> generated these 2 revert patches.  Where should I be looking to see
> proposed stable patches other than being possibly being cc'ed on a patch?
> Shuah had proposed a patch to revert
> 9f55f36f749a7608eeef57d7d72991a9bd557341, but I didn't see it in linux-
> 5.10.y and I added some additional details to the commit message to provi=
de
> more background on why it was being reverted so I wasn't sure if it had b=
een
> applied or not.
>=20
> /me hands you some '\n' characters....
>=20
> Look in the stable-queue git tree for what is queued up next.
>=20
> Now you can see all the emails for the 5.10-rc release on the list as wel=
l in the
> linux-stable-rc git tree if you want to look there instead.
>=20
> Can you check and make sure it's all correct now?

Please also revert 7b0db849ea030a70b8fb9c9afec67c81f955482e or apply patch =
2/2 of this series of if you'd
prefer, I can resend just patch 2/2 by itself.

Thanks,

Alex

>=20
> thanks,
>=20
> greg k-h
