Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27064FEB53
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiDLXXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiDLXW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:22:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8B7CFB9B
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 15:09:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eie1vbBLSTlxSW3twsPqeSShAiXbq7r2hIG89FrFUGbe9MdCY9eUsCtO2dTaeWEhmrfJhWzrDv1Qft3LITF/b+bOtD97OMMejwctSjU8T+EvuMKUPVK2j6pvCCgunQ1nTcnCw7rdjtQCv0P/3o+GXj7i+8vq6Z2Wtmz/8URP8Toj7mJLUMvELXJtEOYEMKD6OK7M55sqktv6P42gc1rvGEv05Oo0q+/dpmdNCQVdel+PsboFSUDHGKdGOMiDIhFzQ6Hitov6uPSDyrtrEjkOr9Y0TWqrXrA9B/zZr3OGxiLs0Ep002i0sHabSMD3HUxIxi5IE/IbsziqGQgPL9XiKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8QZ7hFXVNp3hTLDziPeiwhUJQkQyz31Q3fIIUh7xCE=;
 b=L8jwYp0Nvp8GmxfrlfWEpdtPn5VJWGbM3BoGR2pnYEDY+Nm+v2qk5zTxb006T17FKiogJG4fJt6dxm3OPSvKe6nKyIjvm+JwysKdVsrJ2cnWxPW+WyHHN6AFNNKfdwRVNviiSZ+wiDGOtacRLibsFZXEfUw+KyFICgE798ovve58uvcaW9fEoAStG2fugMaPhNfsPuX6JmBWplLFKc2F7cVq0jhZDXArVH7msJH+eHdDTixPnvRLPs3HWZBBKTzRw77PS1k4yELkFcK1kFcTtr7ECKumdHTJZZ0jrv48a+UcgSH6V1xKUNmWbbC6888fiTsTaiEiClv1bYJHntAh8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8QZ7hFXVNp3hTLDziPeiwhUJQkQyz31Q3fIIUh7xCE=;
 b=c5IUHTZGoHNyHXRAWyIlW3UaMAIc/+/eiltgEDcX/FUS1yhJuURWW8AzwE2Jm+xYBZXNJimnTSGHRe880DmPjk2OgI/Y63nCupUDQrs1UE8jlUtwZheshI0chcSDKO+uZv+5h2Sweif7I3k01j0JSRKPXjHeXsPGWcQ+ZkmSvs8=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM6PR12MB4481.namprd12.prod.outlook.com (2603:10b6:5:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 22:09:30 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%7]) with mapi id 15.20.5164.018; Tue, 12 Apr 2022
 22:09:30 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Fix issues caused by lack of x86 LPI support
Thread-Topic: Fix issues caused by lack of x86 LPI support
Thread-Index: AdhOuWm9xOztJ/yUTdWY31MHIVU76Q==
Date:   Tue, 12 Apr 2022 22:09:30 +0000
Message-ID: <BL1PR12MB515758FA1BFA7C94812B88A3E2ED9@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-12T22:05:08Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=25a1e6ed-86da-43ed-95c4-fe54d54da416;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-12T22:09:28Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: dc9fa016-2355-427b-a364-904a79bf7dad
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9bf7116-b343-4e0a-cbea-08da1cd11e05
x-ms-traffictypediagnostic: DM6PR12MB4481:EE_
x-microsoft-antispam-prvs: <DM6PR12MB448160CEAF3A05F1855DA621E2ED9@DM6PR12MB4481.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +JfJ/sEBSapcchuPYvjKZktyIu8XiSyypgleTytkDre00GRmj8uZ/dcyu97il2ywoNOtMRZZn8g3M0GzWPf5Um/nNDtdc0OA+dPADROy3eErWwzGkAArefI+FdXNQt+fE2YFwIje1JKB+U/XL8k3ULr6JFqHdMs0D4qgLjjCIREVGCzLQRGBlTG6PFvFHOMRtXTu4/vpA/cyabJzp+Tw4nvUK1hrCIr9813blAq3oC2d8tSKK1XIsmU9aHDVJAEJTHsYHgVamZczPNJVT32FDQldE9EbQfHQdovxvRdZQnEnUiMV7RslxUQphrB0l7VXGGeKMgACkFPSBddlL/3QayNWpoEB7xcLt5MVGrI5rj0KJEvwQpMl7HA/7Jtc1R+EuncOwk/28elmPj5jbu3L+0izykhb6WmrOsrGv3STgH5qtnTTiMUdVMtxRCi2FKDm5v1EHEClP6id4y1kAy9GrTZbHVkaovKy08Ph6qDHZawx0pBcOx3INEooXf3AS6E12bJvhBR6fwmgu5bIGvszTw3m7dyQnRhq9zmBDnJp8QV4iPJKEJ3Gu7zR2zMZSRYzYsJa1CVuv+001AEdbHrqjbp6DIn4xadU98QIRuzKYAYJEZ77PCyCJqCY2Q6hdA6fuvY3o02o6Zd/yg/qSW2ztlRELIX8j7OptKI1Ss05c2WId8ceeEor8ySjHMzx1WFgBrn+HBIuU1YsmTOkybbhWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(66946007)(316002)(122000001)(83380400001)(5660300002)(71200400001)(6916009)(8676002)(7696005)(64756008)(9686003)(6506007)(76116006)(4744005)(66446008)(66476007)(66556008)(52536014)(186003)(26005)(508600001)(86362001)(33656002)(38070700005)(38100700002)(2906002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q5Jrsfjb/RssXwzvForgQMT2G4sH8soIzNygsEoVpz4v6FDVPnYvOfnLwtU5?=
 =?us-ascii?Q?Ov9amSC+sLtvBCIuP2UDXXD+cpm8dHFqavS2GfMFdrEcGhsDsRU9dBDL3ZaQ?=
 =?us-ascii?Q?rgRt4cRHHGY7dlqkotI2/M3i43fnNL6tb5o6nAxdsBb6ys5wm8h5KBRoFrxx?=
 =?us-ascii?Q?pyTAVcUN3TBzbDNRy6MhFEQydqLY7ksUVSCTm9gSLqBvjaD45S+DeorK7dNQ?=
 =?us-ascii?Q?ooe8M4QnpeZ6RgY95ya2u2rHxWH4O3LelCYgkRFy1S3F3KcGDKfnBcUaZzKR?=
 =?us-ascii?Q?MXt71aColAp49mW6l7HL3a1E4UxxC/0RS2P7WSTsk58mY+uZz9PvMResJwr2?=
 =?us-ascii?Q?sYfVq+X8HQ/0bI65bJFoU1rGxlx8NqBV6Q6sD5Hhsc2xuql13Bh9u/mJUmuE?=
 =?us-ascii?Q?JRY3w0GFib6DEj4G9i322vUntw6XMqhBeZUHf34zgBY/Pu9VQkfi+k9WnoGL?=
 =?us-ascii?Q?pY1u1afbeQlGp7GEU5NpiO0sAFkPcv2g4t9o15QR8q63EFvtP5/dbvSLVQbP?=
 =?us-ascii?Q?TT8HwrgdlH+RlUKv1CN6OYKeBF5mytC9ygMdmIxRVS+T5pDUYxkSpsKvLfTt?=
 =?us-ascii?Q?AwRXzEIGGhPjSjuAO/YOkFG6ZC6T0Ha/UMHxJUG/ytCYxuGjlhT0kctE1T1W?=
 =?us-ascii?Q?9kKOhlVmDGF2FuaV8shY2o/JUTwuaBL/4S4hP7WWSXoCaY3anXL+YkYr+Ri0?=
 =?us-ascii?Q?Z17zJEuNcZbcNcTiJHt7o0ETWQoR6MewpTakreReTnywNySmWEUoDwMCFRvo?=
 =?us-ascii?Q?HVfsSr8OcrfEKT5b/smwnf0kDHcHv0DaO0veTCkchiGOjzYJLqujl49bYZts?=
 =?us-ascii?Q?uV11ix01u7jhcBXLtMNvhfVqzITqVf7+0rzp+s67RPg5VaBbZ/q3Azi+EQK0?=
 =?us-ascii?Q?65R/HQxXCUvFjFBUt8Wg6AakGnfIqOhiLg64dBl0NA/pa/nclChkEUnMoGaT?=
 =?us-ascii?Q?gmrgIQ9oOwWhe0QcW9apZIejrn3q3FxT1uWLd3i3EryLNyi/surr9PeMtyso?=
 =?us-ascii?Q?7HZ2Mn3VDnIoWxuO8mzMc7KdqHmtNqXb+AxVdX4Al7UeW6egWTn4lkKJ2Ppy?=
 =?us-ascii?Q?2zhk10TynPXLSLq3x/uRd339IHPRsHypC40vmPtFcStgTySTQfAN0y14ePZg?=
 =?us-ascii?Q?qhk1qdOzxaBRGBH6g9twdWOF9vATcPxZpaY4XCcacPdxZ4r5CQKGpuAh6GXc?=
 =?us-ascii?Q?upxdL9b5YR/cfQLhoqm1EgAWH1dEfupO0lsTc+IGEtP2yBCI4Q/WFNvWzxGr?=
 =?us-ascii?Q?ZQNZwnroIKFpi3IFpbfQRtwaIM7fhHafbKz5ve+BymmJsWOYCL+G2CtYp+s7?=
 =?us-ascii?Q?UWDczAvGFkcgVgMy4+mveHskoesp/DQ2ESYf5nxED6C6oEHis2yv4mGiVyEO?=
 =?us-ascii?Q?xz/8k1PDesNzvkZZcp4VePHl+/FDt1+kMxIjsGgsBsmOtLrCzarPYvs5iB92?=
 =?us-ascii?Q?X3n20PvjdWAGsXYfUy8QuOMwOo4/kQKSXKRpgXXaKPQz5+F/QuIOanhbAj8O?=
 =?us-ascii?Q?CCl2fh/jnYjB1quaf8HgFGyvNqCN/PNvpnNMUXaet+aYozbAkwnM5uJgS1m6?=
 =?us-ascii?Q?pwuGJAmvTHwMXDCBReQUx1bBq/vwjjA864nLJi3BtUJR4NobfUshlfNf5Puf?=
 =?us-ascii?Q?E2WNjMYLNWdZ1k0aApXlN9//eQUjQeeeOVO6+4TNScikp8u+ROeLTLGoPfc5?=
 =?us-ascii?Q?1z0IZRZUTOBZAeq1uppiPD3x2FkYVzr88XZ5Fvllq+KNck3sOLgYBZNVKz+8?=
 =?us-ascii?Q?SbkbQhCIXg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9bf7116-b343-4e0a-cbea-08da1cd11e05
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 22:09:30.3003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2rqozEY+ufIUysKsXzVKWD8Gucaj+10lulEhqoePm6xZ5wfTaFiPuauu++lE7hbdLc9l3q27QNR8paHb/wZNlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4481
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

There are a variety of x86 systems that advertise LPI support and as part o=
f negotiation with firmware they don't end up using C-states
in certain circumstances.  This leads to higher runtime power consumption a=
nd also failure to enter s2idle.=20

In mainline there have been changes to block that behavior.  Can you please=
 backport these two commits from mainline?
commit 01f6c7338ce267959975da65d86ba34f44d54220 ("cpuidle: PSCI: Move the `=
has_lpi` check to the beginning of the function")
commit eb087f305919ee8169ad65665610313e74260463 ("ACPI: processor idle: Che=
ck for architectural support for LPI")

This should go to 5.15.y and later stable kernels.

Thanks,=
