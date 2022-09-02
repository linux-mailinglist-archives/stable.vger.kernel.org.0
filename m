Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CEF5AA61A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 05:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiIBDAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 23:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiIBDAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 23:00:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0955A15B
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 20:00:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E860vNbDc7VrtQLeR/XB1XvrUcOaqHzSaXemL/XaVkDxOP04qJRZOrQLfYwoSLu86Er4VQx/yVll/6pCjKgkImg+FZ9r1uoSuDy4gEkPYLh3eosfNknJiXm3X6dK5bV+m/SSdIJPRonWv9uebbBpFuO5P6B5xifgDTCU9cgvo04fTDbT8oMPuue5ZZrwsjV8jCcVbNzOeDHQvil4gsSVkCMuIu8v4pXHHDZcplu96xhulRJUJB/wKtaR2eFFvMVbBIxzgvd09wCyuHAg8ET9MUf5WlXFOHX09FxNTVMUBz4tJDG6zqtLnjn1hmtY89NTh12Iyxjyv9guaUBntRdz9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlTyAdbJ9pjSFLpRd2GyvjD1oA6m18dyA1Q2bCEyAzk=;
 b=E7WnFuFbvt33XgOH+7qwUaCKv9IlJs3z6WU4rxsU6LHbYrrr9xcIKWGdujgHMM1/3+qCVJbsV4DXTfcg9MrlxEp9EptNq+woKm/zy/ORGKei4AaVjm0Dry+AiLePqLI7yLaU63DGGGeWawWTXaZUtXyIUk81B0qrxm5CGdUmTdbNckLT395nfUKUQB5QK6h1c/SDkecgJoTLr1QNl7vAveTdexVSuIhUH2JtQN6boEf+Vv8KT+DYIdBPF/lZ0pqqXU49NP+MP0yR+asQe/liXbF/YA5wYtwxK4L+Vo9XqjBL24feBpwF9LNfJCnspkIDq+af9JMDvwm0P00NuiPWcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlTyAdbJ9pjSFLpRd2GyvjD1oA6m18dyA1Q2bCEyAzk=;
 b=cqwewu+bXFWY2kHYoyOssx+Qc1KPK/SQd0Nbo3EauKnKuZpyRhCe/IFN/35t845WDrNeGeFo6c8hcm5gR7nPuQn+UE7fH/P3nCIc+wRBakf4NcWJIwTJ4FqrLdQbQJnDWieAm1thPsaW9I0MdVtS7sBaAFYfKc3by+aj9ROhLuA=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB6493.namprd12.prod.outlook.com (2603:10b6:8:b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Fri, 2 Sep
 2022 03:00:26 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3%5]) with mapi id 15.20.5588.012; Fri, 2 Sep 2022
 03:00:26 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Properly reflect IOMMU DMA Protection in 5.15.y+
Thread-Topic: Properly reflect IOMMU DMA Protection in 5.15.y+
Thread-Index: Adi+dusGcHCqfi88QxGW0FD5qbxJDg==
Date:   Fri, 2 Sep 2022 03:00:26 +0000
Message-ID: <MN0PR12MB6101D6CA042DB26E76179482E27A9@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-09-02T02:43:19Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=38d9e81c-5130-4619-a296-192efe896120;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-09-02T03:00:25Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 99a0ca76-f604-4559-9869-5e58ab634858
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e41ee7ee-a974-4dde-ac27-08da8c8f4940
x-ms-traffictypediagnostic: DM4PR12MB6493:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s2tNpuM0dmPpoBiyfAHlIgXrMkNLrfB6qzfi7IE2Cv99yQD2k74EmfTtWSDBAr3PkxIKK8WztgVyozjgQUJHgsQwxR0+M/uwHKRhi/M6ufCsg9uiJbsDih1Yj3s+g3CwF6aOlqRGezgWuDRvYW9ROvGpdp1iRMJQFEOgZmT5lhAlmA4HPVF+xqd2O1ntBQ2EMsOLk1KLdmWoJFQL0vZrIdWZTyJxAGNZgpIg3+LF7ohU5WakhYUwZ8UssPN1EbcizUT87/IjYNjHO+VLLgPFkI8EAFCiXNQ7kVwplVufhZPl7C3m8pTP5rJMzdAqUCWdtgzOQ3M6VskAfBkq2MNH61p/Hx8rz6UecED/NiqtpVL6VBVL8OI1ZkDf7x5oQCQ4TCEugqvKSDm192wbMYfb4ww/o6tlwX3RS/tDDb2MApYcN0mJKOw6ExgGB7E2o6yOk8b4+2EppjZyiHQQZQJ+4duhwtYMlJN8JUUYghnTQhBSw2wCzUv/Xf2Yn5xNVlXKzmaHs2OFXASZt+y2lSeV6QvBeWvuywyhfSZbp3ceP75lvkvLFOMTlPs0X3ARv7hbsVNv+YQXL7cVxgShDubjFBpWcMmexKiOFwg7xe9aUq9nJm9dYmarJfM+6zNC3YnJcA/ldRVMUmceM5zTpnhNiwsBjwqbgYQ4utBFh02ejXSlQOmU1hXCIpPcAmu4gwFKX6yp8tb6S3Y++65zl+UHExxLTljX/XWlsC7SrN/n6ABSZe37+IXDgp9Xdzv+W8A8FmLtR6qg++n8IIlBjiphmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(8676002)(66476007)(66556008)(66446008)(76116006)(66946007)(55016003)(83380400001)(2906002)(6506007)(5660300002)(26005)(52536014)(9686003)(64756008)(41300700001)(33656002)(7696005)(8936002)(478600001)(38070700005)(122000001)(316002)(71200400001)(6916009)(86362001)(38100700002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pff1h28ltG223/s2xw5iU/hFO6PtpTCsPlWOTL4ebQFQ1s5RqzNw0yWtZ8OJ?=
 =?us-ascii?Q?o8fQxs+tD+c1894rvMjr0PMopdZruo5cxYKk4brgTPVdXktk37WwfimxvoBE?=
 =?us-ascii?Q?dMxT1elggxY6qEi8SDi/MRa3G+iP22abVaQqGhknPzVEibK7MIpGPYN6nLvy?=
 =?us-ascii?Q?P2yj+50gs+mzWDp4r3AGdcCeYO30vlz3i6bvnYUShayfNuWgkvN3kOM9/4DR?=
 =?us-ascii?Q?VVqXSqL0gqgw7v5/C4WFL/7SIlz9SmhvN30WjYbox35UgxRTAGTWVYo3fyn1?=
 =?us-ascii?Q?wOF9EX8+ojZ+8LuC7j2EhXJ4nFsVsf8d/8Y5Zs1UgYdU9vDh4GMaFUnqJdDM?=
 =?us-ascii?Q?jLAO6qP+GzSX6z9sIiHXRs/ZBugNCsFgh+yhQck0/cXSIpNLZu1yW86Y+Sts?=
 =?us-ascii?Q?f9KZ9ezbVRDbKg4AhPR/nVEyjW6anlu0Hoz2gFcste95H6mym7ewvD7p3ABv?=
 =?us-ascii?Q?hfY5pwKlqPYtgMdhre6JHKVNEKLm/xXbdUeOZXQabKb4iGYODZ699VGek6jG?=
 =?us-ascii?Q?4pkKm3d5K9Ppwqe1isKw7FCWwFLq3abLVu7NBrOJQG3Wt3DuomC0Z58UFI+K?=
 =?us-ascii?Q?NGNIjvvBglxLxD2wO6fKhyWtVobi+yWZCt8bqN2CUPze+heSwmO7BsOTzWMO?=
 =?us-ascii?Q?fX+HC63YQftA/NUvCIQd/NoDVpbkzIRnGg7sXrRM3IMKmeweN6lXY02IuuWq?=
 =?us-ascii?Q?CbCjklPTlb7Fq0VHp+aDVhZ0+UjWA+7Dif6wSw99IZuoK5Zn5Ivg7y6C4TDf?=
 =?us-ascii?Q?EfrdZmX04CgzpoN6Lty/IsR5QsJHR3sb3LXYZC42xPaT7Zuf25llhiQag4gk?=
 =?us-ascii?Q?TcQ4ApNh6pQBehFxm7AbcRaiHzfLbLDpOsG9DiZhGusuCck0muiXx0k6Raxm?=
 =?us-ascii?Q?6XTBE3p45ZaW5d6hPL+/1u3TeHIdG0UTckNYJ4OvrRlksSf0JVH8rhXBcxod?=
 =?us-ascii?Q?nZ7oanBCfZjU2L0fB/g1veHzBlB522VfkCd/gl6JwPt3I1oBgeBs0w7R/AFj?=
 =?us-ascii?Q?Gv64wW+2ErixsOG586Q1zuOMn5KOsbn/YGO8Z+0QgvV+RQcXWZE2xEqCpN1S?=
 =?us-ascii?Q?QVUQIxzNA7ZjcCHOlwAzreZ9c4FTa3g0oB8+z9JQnMlByX5LPHloEn90elfz?=
 =?us-ascii?Q?y7XUkW4OQm57j8SDEhzQiyCmxu81U6KEYmPjrKBTvhXIXTZgYxum6LH35JDd?=
 =?us-ascii?Q?zjMlOBJGJ4L+GecceKbmPwWquhrbXWcPeqZz3dY+R2oAOue/BM2ZGznFSefK?=
 =?us-ascii?Q?GypNRMPF//Y6JXQULAICrlAVPHsjxlTvWPBpoCgRTyZvTH93s79YLcrxa6pI?=
 =?us-ascii?Q?navoVgboRxuENqkIZ6cO2ydf7mYRmQV6rOo2Vss3Kpvp04Y+0i5YUaLkw6lR?=
 =?us-ascii?Q?aFheZMYtk5gCbAmRDP63XZFt7l9HBfNMk2jCH0yX25Wh9PPXqjXicIkP/pVW?=
 =?us-ascii?Q?8DQLWONd4yyS9iW5musrq1M0tph5gusvUX5Xqg3IcyXGV3TNa8Zb8XX+Jhd5?=
 =?us-ascii?Q?h//Yx450wA0WwBWEoi5BlykT9El6ecnhwNM8Da+2Dlc+XyMAKvoZUflxK4m2?=
 =?us-ascii?Q?/hQ8gxdx+FrNhu4a3kg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e41ee7ee-a974-4dde-ac27-08da8c8f4940
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 03:00:26.3377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pqCtNsRDlZ7k2IwSFxq4VyXvu/2hQd5Bo5xvwWFxc46bJDgPE2HRdBUpDNl9saU32RlbcI1BACbqUdRD+OD5ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6493
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

Hi,

A sysfs file /sys/bus/thunderbolt/devices/domainX/iommu_dma_protection is e=
xported from the kernel and used by userspace to make judgments on whether =
to automatically authorize PCIe tunnels for USB4 devices.
Before kernel 5.19 this file was only populated on Intel USB4 and TBT3 cont=
rollers, but starting with 5.19 it also populates for non-Intel as well.
This is accomplished by an assertion from the IOMMU subsystem that it's saf=
e to do so by a combination of firmware and hardware.

Here is the patch series on top of 5.15.64:

3f6634d997dba8140b3a7cba01776b9638d70dff
ed36d04e8f8d7b00db451b0fa56a54e8e02ec43e
d0be55fbeb6ac694d15af5d1aad19cdec8cd64e5
f316ba0a8814f4c91e80a435da3421baf0ddd24c
f1ca70717bcb4525e29da422f3d280acbddb36fe
bfb3ba32061da1a9217ef6d02fbcffb528e4c8df
418e0a3551bbef5b221705b0e5b8412cdc0afd39
acdb89b6c87a2d7b5c48a82756e6f5c6f599f60a
ea4692c75e1c63926e4fb0728f5775ef0d733888
86eaf4a5b4312bea8676fb79399d9e08b53d8e71

Can you please consider backporting them to 5.15.y+?
I've confirmed with this series of patches that a Lenovo Z13 will populate =
the sysfs file and automatically authorize docks that are plugged in.

Thanks,=
