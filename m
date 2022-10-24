Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251BF60AF70
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiJXPts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiJXPt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:49:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822DA39103
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 07:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EO3/LGbI2wHuQbEzJl0qkGOcepunTf9TI5ldO073OYwiPN2n/LbC1pyIG3vcidzKQkJ0W7CdKO1YsQO3x6pjpo2HZzbZlEssUsIdrCy8/aBqm0TO4Iwejw3X9DqdMwlGMaCb3EOgGMHTNiFGchLLuIQ1p30PCOARsV9TrkM9JGHMdykJxFkKY61gIi9LGQ28k5Kf0U6Ig2Hgs1v2wsrTvUL5Rv0o08XYtUPJbwlVS4Czho94hy9TsBAxBpi/ObgkpwFvV+2bw00GjYS8+Y/d78+UXY60xsxEvSft5hGrRa7/5aaZmbLPer9Ku0+3CIOL0a7QMWLJ8V5aExvT3rnn/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6KzKqGiMMYKXgWrz4X6tFrqwJs5Sz+JzYNaJuSiLPc=;
 b=RVv3ptKLYM3EFDv4zeFbhtoWuo/7hN4+1jdBKDm8svMiQAVuFTwJpG/fxZWlLzZQc2iq2ITpHRlqRZCm68urmJeM08OKj5rm6cIuoKg517J6D0NzdDh3PD6ytGljH69y8KugG7bpcypiuvmTCoaVCaXqC8xui4kk2U9N6RF1V6eitjMO3O2qihT1Bkky/fFDdWiWCvKVjF5NsKF9vS/tep2qOghFJQ0L/0elxvSfeaJokF5JLgmKWzYlZv2V/QUO4538DF5Zr1M5cIu2ARbvTJ2GeMKZslQfvvqNRBBwbjJtY/lytMAnIrRXGiWqsg6faD36UnZpuums9nVIyN8e/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6KzKqGiMMYKXgWrz4X6tFrqwJs5Sz+JzYNaJuSiLPc=;
 b=YbQgZ1oD9fGaEdpE/A5tuqV2TW2ZREWpSxeJVB0GOwLBEGFycQDfz66LzzungPUMV/UtxKk7fBk+EUTMqAPVz4ohM4Unl2gNJos1OfbC6COUSzV97RfUczMEcNcaOML1CNIOa2cQ+71TBuybeDIebWgHVz8SFFDZBYXRF6Dehz0=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Mon, 24 Oct
 2022 14:39:42 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::892:bccc:675a:6187]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::892:bccc:675a:6187%5]) with mapi id 15.20.5746.027; Mon, 24 Oct 2022
 14:39:41 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Salvatore Bonaccorso <carnil@debian.org>
CC:     Diederik de Haas <didi.debian@cknow.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Thread-Topic: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Thread-Index: AQHY5Joa01+sOpIgb0CXCB0zjRa6p64X/yAAgABgTwCABRGVAIAAMHQw
Date:   Mon, 24 Oct 2022 14:39:41 +0000
Message-ID: <BL1PR12MB51443BFF32835644A72F7A38F72E9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
 <2651645.mvXUDI8C0e@bagend> <Y1I4rC37gwl367rt@eldamar.lan>
 <Y1Z5Km83Rcc3W0PY@kroah.com>
In-Reply-To: <Y1Z5Km83Rcc3W0PY@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-10-24T14:32:01Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=754022a0-8d05-4b6b-bbca-fd78593497a7;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-10-24T14:39:40Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 15899447-fba9-4bc7-8c08-6753e8fdf9e4
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DM4PR12MB5357:EE_
x-ms-office365-filtering-correlation-id: 6cec5d7b-7aa6-47d4-beea-08dab5cd9628
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EBZ8u8eX5P+bJv0H60Xh2Y6xvRpVtLBk88YaCiBzYBSYDzDMK2HxEpq32F3XXEKdBWDFehW6uNGxZ/TQgfEYoxwktDuv9S8cja/XfbIr91vLXEBI7uOU5u5y8qpxQYrny4tMd/kEFmjdKRvt5D/rlsZ+/Cd3m27I/dXKAN1ekLOPlps+I/uYRcBnV5hvb8b4OhInpkHh8u2EClNUuNq32UqXyyW7D+FGYiiGkt4yk1iHlceSUlbtcL2D1GGLi6cEZWwLdYRCJPCJCVnhkP9GHbOKPLvGW6UyOb5p+w/noIoX7Mxb6ik/boz9g19J9aaMuwA3NbK4SHGjzYzrQ/Gmb0mciLW+gVOdB5Wd8NfnGpQAFVyvw0XmXULaswy/KGWpkpZDmFkaUu+z6yPHwAZ8aZFqolpBKN3sb8uWZQKBX6ZZPJXQOi8ajnN9A+frYcnzlIJf8ZdmhhfGNNir0l3zDBNXBWlWEkWgnbs43VmRhgQB98g1m8N5Pt5ss5t+wFFfcsoJPjFMJLtgCQues2w2ghL4TbMCme1EsCrVhb2xtif3/feonKeLTCNTLP83z8Qoo3s067Y0BWpBT1NEXcbuNExuk1rIxjHVqnOqiNJwBkytxtlmAuRdpaTZSsTZrri2QUlMCWuhlJ4ZH+VPc/4MYZJaf9wJx3CzOmpze1+xWf+bjbv83EK99kpDvts+4DlD319UH9MbHlYX6pDhnBojdk7j6dxBN/952pqhpoc5kUqTaeVLxp8ralWEuN/UFsqcl5nQl/MOuGzyxrUqi9ufo/mFrfTjC85ESp/Lrj06pis=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199015)(5660300002)(83380400001)(86362001)(38070700005)(52536014)(41300700001)(122000001)(33656002)(38100700002)(66946007)(64756008)(66446008)(53546011)(66476007)(66556008)(8676002)(4326008)(7696005)(54906003)(71200400001)(186003)(55016003)(8936002)(45080400002)(9686003)(110136005)(966005)(316002)(76116006)(2906002)(6506007)(26005)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?odMg1Vfgi2vnANQ2CNsVQQUVr6Mny/b5/ZFk6IIBxf50NHkGFB3/Qp967yKd?=
 =?us-ascii?Q?NF0eTOrgTH5PzOvvrCGY4qvAgcoImsvJBnr95gISMzN4RJC/1r+EEWYy6TTS?=
 =?us-ascii?Q?5pT7HvHcK0RpKpFz/I8YcaJ/5VVdxfs19rzssnxvbDDdR4GwCbF0muX83JzV?=
 =?us-ascii?Q?hqemz5h6bletOzfFJnuMs29OAAEY+veijolAB5wtTzScRHNNF4PUxlPMY569?=
 =?us-ascii?Q?4SaTHW8CbMqSoztvn8t7As9HfjBwZHh7DkotHdPHwp9W86IBuIR7QigyFd0a?=
 =?us-ascii?Q?b7zXvdLUAuN8nKukgafANO2YIuOwNzUCr/T/8G3ixjKxFgYimijhP+cwlYa2?=
 =?us-ascii?Q?RcG0vKFiTI6HnYUhxr/6W25hw3TPYWrbero9wfB8cdq+PTkvbWsKaIifmTtk?=
 =?us-ascii?Q?zdg6x/Q+JsHBmCdTH0syS4a+o/PXDKKtFlMFoQ164OC1GMoDa4sOvRLhZqTZ?=
 =?us-ascii?Q?p6QlBbkBVaNE8ZtW7A0BMpcXa1zcFwKxzueOhMCY7drXHZF1QsxtvmHgjOhQ?=
 =?us-ascii?Q?OPnx7SxBG2HcqGdLaP4DEbz+AhLpIfyLsinuzJavLEpRbOUsPU5oHNwox6EN?=
 =?us-ascii?Q?Djf9D+IAxb0nFGAgFwQOMyIiVfBQ3to3F3fapHzr7otNUkhdZAYOzJZygcng?=
 =?us-ascii?Q?Q34/PrdIWR3jV+mOcifnTf/TcfdJDyqWMsdzlvg2YNq8ZhW5mmyiOjF+7qxH?=
 =?us-ascii?Q?u7SRYfPZNqg3VVq4BITVYuJcyE0JUs0EuGfkTHr2i+tGs5VrgcqtTPLnp0Ze?=
 =?us-ascii?Q?fWw2diJakczEtg1jAeQ6GcrY0JvT7iCCo8oJsPoXYhpEwZUGVPKcnDfCq+o7?=
 =?us-ascii?Q?/HqjBu1ok5iArEmIHvVNIRx1ultmxlxkAVBTBfggpZnoHAoSHv8S0na9zwLd?=
 =?us-ascii?Q?HqhXsRPYkE0C9UGMAqySzHXCqioQ8s4rzgwiwSId6VWKV5CW2CNiOL/LmSuz?=
 =?us-ascii?Q?OVSaUgvEMY5h9k2bjr54KBF+63T7tNqSnprvwtKNdHqeX9/x74vpStZVQRrd?=
 =?us-ascii?Q?g1MhvMFZE8QA/bzRKO/z0SYeHdHkkPLK19qnMc3HigT6e9OCQvrxZoR8lpT9?=
 =?us-ascii?Q?xGY4J4X5AknSyTNSLY2k6HecBR2/8Dt6LwC1BwGT9ftGm74fWPKq575nlKVr?=
 =?us-ascii?Q?tsqM75eiRXzqoi5DQHA79MCRb5i0P2rCingvYuRVeeTFW7gHx8xBNeCipY2n?=
 =?us-ascii?Q?kdNcWOpKZ3x7pZDhWxL4LPqR37ZwptAz82UlSMdz3OD9WjN3kNPkSM45sAnb?=
 =?us-ascii?Q?9kU1qYYpawMODl7AGnWVIGjUPBGbHSTn+7Rf69+7zF7Sbu0WphyiKVtXXTu3?=
 =?us-ascii?Q?+m09JeyEc9Bfzs3PsdOzNXExdW95vnw1Lq8Hx8Tq01Ca05U/wkTLoDWpMDoZ?=
 =?us-ascii?Q?IQzuEa09d/bB5BP+BX4MzKdiag/HytfsyKt1xQaX/6M1xIXzjxrY8V13i0Ii?=
 =?us-ascii?Q?9WSlRRraeZUdPKAG2Cc6Wa+0cdS8ZHo/GlRBBhU7weyEyBd6yasK/gnZuYo+?=
 =?us-ascii?Q?iqH1/HU6CcycjDkU9z/5LqDSchLKHv5/bZRx9BPZZYVDPbOfIrixLhv38VX+?=
 =?us-ascii?Q?0DPflaUDlpTajkEf3vo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cec5d7b-7aa6-47d4-beea-08dab5cd9628
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 14:39:41.8209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uAI1kLWbLciO2EC6oQNRJMesNPQBeQlB0s8WeHYB8HkeclMghl/6xwmPOf4q+2MWIVlnuJchMiqfxYohxTN8Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5357
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, October 24, 2022 7:38 AM
> To: Salvatore Bonaccorso <carnil@debian.org>
> Cc: Diederik de Haas <didi.debian@cknow.org>; stable@vger.kernel.org;
> Deucher, Alexander <Alexander.Deucher@amd.com>; Shuah Khan
> <skhan@linuxfoundation.org>; Sasha Levin <sashal@kernel.org>
> Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio
> sdma_doorbell_range() into sdma code for vega"
>=20
> On Fri, Oct 21, 2022 at 08:14:04AM +0200, Salvatore Bonaccorso wrote:
> > Hi,
> >
> > On Fri, Oct 21, 2022 at 02:29:22AM +0200, Diederik de Haas wrote:
> > > On Thursday, 20 October 2022 17:38:56 CEST Alex Deucher wrote:
> > > > This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.
> > > >
> > > > This patch was backported incorrectly when Sasha backported it and
> > > > the patch that caused the regression that this patch set fixed was
> > > > reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't
> > > > disable AER reporting in get_port_device_capability()""). This
> > > > isn't necessary and causes a regression so drop it.
> > > >
> > > > Bug:
> > > >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2F
> > > > gitlab.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F2216&amp;data=3D05
> > > >
> %7C01%7Calexander.deucher%40amd.com%7C5f932b93d7154b20994a08dab
> 5bf
> > > >
> 354e%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C6380221300859
> 453
> > > >
> 54%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luM
> zIiLCJ
> > > >
> BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DD9Gkpt0
> zCN5q
> > > > BWoSngMY%2FiJyHWiaAC34eWr2UfYRIjE%3D&amp;reserved=3D0
> > > > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > > > Cc: Sasha Levin <sashal@kernel.org>
> > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: <stable@vger.kernel.org>    # 5.10
> > > > ---
> > >
> > > I build a kernel with these 2 patches reverted and can confirm that
> > > that fixes the issue on my machine with a Radeon RX Vega 64 GPU.
> > > # lspci -nn | grep VGA
> > > 0b:00.0 VGA compatible controller [0300]: Advanced Micro Devices,
> > > Inc. [AMD/ ATI] Vega 10 XL/XT [Radeon RX Vega 56/64] [1002:687f]
> > > (rev c1)
> > >
> > > So feel free to add
> > >
> > > Tested-By: Diederik de Haas <didi.debian@cknow.org>
> >
> > Note additionally (probably only relevant for Greg while reviewing),
> > that the first of the commits which need to be reverted is already
> > queued as revert in queue-5.10.
>=20
> Argh, that caused me to drop both of these from the review queue.
>=20
> Can someone verify that this really still is needed on the latest 5.10-rc=
 that
> was just sent out?  And if so, please send me whatever is really needed?
>=20
> this got way too confusing...

These two patches need to be reverted from 5.10:
9f55f36f749a7608eeef57d7d72991a9bd557341
7b0db849ea030a70b8fb9c9afec67c81f955482e

I did not see either of the reverts in linux-5.10.y in the stable tree when=
 I generated these 2 revert patches.  Where should I be looking to see prop=
osed stable patches other than being possibly being cc'ed on a patch?  Shua=
h had proposed a patch to revert 9f55f36f749a7608eeef57d7d72991a9bd557341, =
but I didn't see it in linux-5.10.y and I added some additional details to =
the commit message to provide more background on why it was being reverted =
so I wasn't sure if it had been applied or not.

Alex
