Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086905201F6
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 18:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbiEIQMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238891AbiEIQMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 12:12:46 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850EE274A3E
        for <stable@vger.kernel.org>; Mon,  9 May 2022 09:08:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4jYOl4D7gpZBSXEjWvUGvZ/6Aq2wXDaNCdkkry248yVffVE628fHK/CU/PRR2iX314pzq/dK1OJsg66FJam3s9Qk/QiELLHigxYRxQ2+8dTycqxJ+RgHfgBvg+0j2DzFkdJA2Lr5/VM06Am4cjMs84hCGDKAhi7H5TUhhtE1epzN27wjvHqyKcG5yFa+B3l2yB9JXW+JcQBO8eYTVhY3ow++3A0F1hNs+mrkeM5ZKDh0kCqPCE3wJ7BwhEIFk3gX3p3EOy9GL5QVZJJr/3dzvsI/lRKcvIprJobkINZK8m8kqSRy0X8HjAgRfff3PnNQx6PV7KpPRnUiPdDMCCBUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JH77F1wEP4VP6cx1LRJdEK30aoP0tqKU98ekErD20lU=;
 b=gMB0k6gqneV21c9INvqPch9pCIsRs9Tb9vTThSUPKTKpxFspiS3SnV1ESDqBYjrzaA4+6WoUu8n4JclrMILRXrY7qgyRh8qgS3iqMdzq00MBF90Qyh2F0UYwbLFhl5+Na73uZo0R1mO0PS6hblui5Qv0X8QqyAvSi8LiOazplXr8Fy96jhEYHMV382TmG6lX0ixlI2j5ikHRL0bkkuGR0bTAxLcr9l736NlCH6p7P38qfp74LWdDGezepGZIJkqxEE0JSPVIDTMZAb3QupFNfsWMd0NpmUW24lF/xagHOF7DMjHZienpstUEhafh/A6QFQyS/rylfGUmIga2frwr0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JH77F1wEP4VP6cx1LRJdEK30aoP0tqKU98ekErD20lU=;
 b=HxjP52t2srMxidCqfq3AYPwjquyx4i59cwHDUNE83k9jFCZ2bhrXqBUMVOTHqV36Brc+q2+a6OxdBPBjnSlcxtG6wsD8jYaH5I9vO9qP+MIrbfKtEWIRzh8Ut8qPVQ2xi+HCmXkrPd17uMuKDwzo+8Kj14q3cL/VpVoFYvLeaQs=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by CH2PR12MB3813.namprd12.prod.outlook.com (2603:10b6:610:2c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 16:08:49 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::1134:e908:ed64:d608]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::1134:e908:ed64:d608%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 16:08:49 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Fixes for amdgpu audio on dGPU suspend/resume
Thread-Topic: Fixes for amdgpu audio on dGPU suspend/resume
Thread-Index: AdhjvnXBNNxaqhk1Q4ql5HExoSqnDQ==
Date:   Mon, 9 May 2022 16:08:48 +0000
Message-ID: <BL1PR12MB5157776D00DAA747EF550CF1E2C69@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-05-09T16:03:35Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=d7036a2d-9393-45ba-933b-cd7beb00262d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-05-09T16:08:47Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: e5eb8eb5-f192-4e86-8355-f1bd5d7c0d86
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6c99f2f-ce5b-4019-cdd5-08da31d633e1
x-ms-traffictypediagnostic: CH2PR12MB3813:EE_
x-microsoft-antispam-prvs: <CH2PR12MB381303D32DB6A012FED79C7FE2C69@CH2PR12MB3813.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: clruubBCftmzU/qH9XIyezM2iwZ3DBiaipCKpPyB/9RIrFBQ2BhJddf8wQ9BwueNrbbMJOGZVptlavwn9vLMiN0/GC2pvh1tdk7uinDf7xjWLa+mAhN74XHLQRA+k4l3XB4geGPiBGO1M849C86mlFBOQODStj7DqckUyNOEQXI26m7y67Hu+395gw1DCTbkHM9IPMzk3nrk5L7WZUlNAoIntrsjhbuIaDjqE93q5kIiDZ0g9WrVuFrQrDFdZ16IrfkOTp5ikoAxMLYq2AJ8YzUN6xeZUiN0P3Uo7iIukZcGwmVATxFYwRtGSG8X9vqgwZMeZhoxSUOdqXfD2QX8rveNZ5Qf/Kr0VEMWJbBGKYvZyEG3xDm8YWREDU3N4rW7bj5SwQFunIpCKsAqlyZR6LHqLh1WevhP1hHi8ec4v09nFxxAg0VY6OQTEUCcyw+Aki+YTaICoU8yCSIpQNzffyEv0+R3eVop+H8ft5tkXMBoXdEEo+gqtLOMErZSBERb1GHm04Nn+LYc2jwlNO/JuRZiuvdxC7NqLzrZ6MVYaVoT3KrJM0PrGUzLrROElEZMue/FbghcNhjWWT4s+UVa8bn6V2ZXKj27nj32wX4g5Vi49ZKiZeq39egewb1S/lEmjfLkvX4c/VBT+SFCFVLzrs1JWsE+aQfWDsJDHZeCVl36DSkSAe2yY6mxs5bIQ8anTEaSS7LztGcU5KbnWRpmQZXYtE9yixiu55e8PCaOw8p25Gv84EFwPLh+ovfWZfUkLxzLLYzJgOyj491MOwacQTYvXLx6kO5upf03/OTgU5M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66476007)(66946007)(64756008)(66556008)(66446008)(76116006)(83380400001)(7696005)(15650500001)(38100700002)(38070700005)(71200400001)(186003)(6916009)(55016003)(966005)(5660300002)(122000001)(508600001)(9686003)(26005)(4744005)(52536014)(33656002)(86362001)(316002)(6506007)(2906002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xaSy6JjUnf/tpI4401q/R9ij3CUfX5V3zROCf0lOywdzWsbEE+u2SJwi4/9O?=
 =?us-ascii?Q?u6vaYEbzPKOu7OsrKwpygq1Ku/r5zNgvRbHVO3HAtFRbLIa4ANUqbyf4j8lh?=
 =?us-ascii?Q?COwqH+p4gRLhGzZlBkncZkkQ98RglEtU6Gscm+F3tTWZRwmuYZUO9FHq42u7?=
 =?us-ascii?Q?6umqKt9LfJYnWRKXecstClbLAbH9MlohHrfvnolQloCS9YXURKDepfH8xdqO?=
 =?us-ascii?Q?e+kWbWMpLeSVGT6lPg6UHh7SCJorbuBmcxpny40QkpMbYo8pBzpMrW4tJQ09?=
 =?us-ascii?Q?PVdNfdtLxsJ0gk+PkYWfMfi0IZ10y5RZMXrjtJ+97zV182ctPMfRyJdHF9HX?=
 =?us-ascii?Q?8hj7UmlThOLh3VKFp2MGPPMT2G2lnDIR/s+md/zO9Z3vT8YmCif/Ee7jbwuc?=
 =?us-ascii?Q?9C1gRIDqtpM8/3z0ZFKo28zKacKy7eb7sA8/OLZgtehgXuS5HM57NEW1Azrd?=
 =?us-ascii?Q?f0UKGGHKlcBnBS0t9SQjToD7GWoNyxRVjmc7vBe/33tDcX+oT0/FjgFwQroM?=
 =?us-ascii?Q?f77xh6OsOwmEMi0quYIzDlRddDXZ+Lccnl+AOquYiJ1/lBAznT+GDogejfMj?=
 =?us-ascii?Q?EmgvyUB3W5ZylmePMwPGp/Rf1sx1TbX/FPssuJBMRCtJOyYnp9ctbUgcohe7?=
 =?us-ascii?Q?L1198mwAsFYkUBxc5iiIpLWKJ7LkpNk7obDPiKKIRCV2Tlbge+Q8Q6IPAQYf?=
 =?us-ascii?Q?i2Pp1OC/LR2pApLLsZUILVbIBlPcK7RhpSlVrlPCdIj0RU407dqr2WY9CwF2?=
 =?us-ascii?Q?o5h/H6u1vCPTnnMK29Io18I+qIH7RDqJiC9gXrZzTDKX0OjEpXUfdhLhTcIT?=
 =?us-ascii?Q?A/OGEAggVqrammmmYjE9Av1QjGg5ebR1lpC6bAeQSh1P1ncvz/SEoDVjNN8q?=
 =?us-ascii?Q?E91qcnWHvEBOSugfiCT5JS3D1xhPHM5CHS5nWmJXsiNcjQPhfNiT+tY11o2g?=
 =?us-ascii?Q?b6QjBuXXAXDnFARZTNTNNXkm3jQg1OIZOCWIgjj2N05LHW2WArsTZ90eV5pG?=
 =?us-ascii?Q?VOA5FsrCCdZCiNAN0eYYFvTI0XphHnl744mFCPNO5m21BNGYzvOa8DF9FuIG?=
 =?us-ascii?Q?kXEaIl22grCkzuKReXkejC7pmxkDjDz2dTrQl1W5BNKbwW+WHO8nvKEcEz7n?=
 =?us-ascii?Q?b6zs7MNxKMZ70Dp+w/KC5igiZYFMU+uaQBwrJM6gGWhaWx/TcK2qCv/rXvHw?=
 =?us-ascii?Q?M/AfWY6fA2sirMIx0Nb6p3XQYZnBPrwFscAux4+9mWPrJU3X3QUNdKBpDSNY?=
 =?us-ascii?Q?9cSrTvz5plhqYdIcs1wA8KYuKlSzNJt661sh6JLgRpp81C5cpsNZ+8MT6KOg?=
 =?us-ascii?Q?6IXauyhjOjqtW5gy6+0zXMtz5DzCIQXi+TD2itOjWPMR/WRJ/8/9FdpS3OY7?=
 =?us-ascii?Q?CEQuV6KOnIROb3CLV9qvPdhCt92g0PnisXBbrepnJ+E4Gk/bTDIqlG32BxJQ?=
 =?us-ascii?Q?+raAdPoOx61WkY8c/pYazsn7lDdEghlpvD3Og+A4+0ut/3MnCIU9IuIJ9gOh?=
 =?us-ascii?Q?x99oxWeXP1ND3t5+OTfraSb0pPX2mqLjwo6W4ouF8IB3ksKhg48w/Tjojb1b?=
 =?us-ascii?Q?ZdMRW4OZ6qb4tEoqQ7u/bgF0xBwRSf9CiPhDPId8CGa9DfyMlM8zhSAfUCk5?=
 =?us-ascii?Q?BI4dEs5AGnvAtrHoT6Gwz8jUzTunUH27QaZfgXk8OYSL1Vbig7ytpVnyn7w1?=
 =?us-ascii?Q?l50qgthidrAPoHqPnvphrU4vXhX+PmGsmMMcx1Y8Qq3whyhp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c99f2f-ce5b-4019-cdd5-08da31d633e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 16:08:48.9389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3cgsaF/vpA3qH8F+YFslVHs2xYuIkJKJY5FMPid7/5+pAXHVafr5wJ5apBKiy2SgDdqcf5p1+gE8yCq0C7qWSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3813
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

The following 4 commits can resolve an HDMI audio issue with suspend resume=
 on AMD dGPUs.
The last commit was already CC to stable, but couldn't apply to 5.15.y due =
to other changes that had to come first.
The issue below link has some more detail:
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1968475

Can you please bring these to 5.15.y?

commit 58144d283712 ("drm/amdgpu: unify BO evicting method in amdgpu_ttm")
commit e53d9665ab00 ("drm/amdgpu: explicitly check for s0ix when evicting r=
esources")
commit eac4c54bf7f17 ("drm/amdgpu: don't set s3 and s0ix at the same time")
commit 887f75cfd0da4 ("drm/amdgpu: Ensure HDA function is suspended before =
ASIC reset")

Thanks,=
