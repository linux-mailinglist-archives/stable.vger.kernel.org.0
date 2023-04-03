Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9006D4B76
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjDCPJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 11:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjDCPJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 11:09:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189B64206
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKvKNaXgufFBCLOUUKBp55W0su405sqH/wOvSUI2BqkeAwlAFPTqr+D6Ew6r0cLugvkTZGbzWOzZEkKqlavLHHs525uTtQRbzIPJNpbdvmebnlbfY/b+JDOEZ+oU2y/HuxR1dNyWAy5Klzf09A0GjS3Nlqs6mhUVWTF2UmMX4GfgFrmh1GJB2iXMlbzGaFZKIcrlAHvURmmygMfCo+s+mlxow7tvYVvUGSmvFWqwXa9cjITm2DHc8JbrZ4apD6DMnOF/zMa5GQB3japke7MEIL+Wksf2cYXJEWUVDUvrmAXZmlP7Rhwz7h9o5zxHKPj4/fx+4wcYShBoqOXjcu4YhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58X9LEl1JQzmKmBt+h1kvZbcI85Mwcf6KQ3gjAC/Wwc=;
 b=eAKWAEnFiDtRgLbahrpa3V/dXykPMT6Ont2cntE6IcUHKQIqjhYE35QPCOPMPrj+8g7MHbOvNYImZxbdIDXD7Xlhak+YZkBhuiBVyK59kTq0xbndtB4L+oKphbtzyuLqQwuSKQ6L4OCN/GerzrBSdiweIY5es322K2az7+cPp4hF1t9DWVTJqtDkMsXWBWQfAG5DDCIykErOm6TS6lHCVRrE3abkFdgjRgko6FdruHqOgPtKhG2rHVzFlG4LOVGChLdQUx38L3nLyk3WSr4WnEFZLdcBtAfcQYGfgQ6xMJO1bWY8KDYklU56spfaBMlE3ic3Cmtd6OOOYg+TDL1uQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58X9LEl1JQzmKmBt+h1kvZbcI85Mwcf6KQ3gjAC/Wwc=;
 b=yJOSvhEMMWqHyZMYfvhX+SJRd6LCyHC4tSc3Y/p4YiFz5Awspf20FwnLH0leoG7Udrn9n1jXEvtzVKv3dX/co8mxRLRfXLLnIQISLrJJuybg/rO1uS1p8AhqXav/nUoy778Q0wi5UmXhHjAjZ6gHyNp5YMz8Rcgg8Q+KYcQNphE=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY8PR12MB8337.namprd12.prod.outlook.com (2603:10b6:930:7d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 15:08:56 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6254.028; Mon, 3 Apr 2023
 15:08:56 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Mahapatra, Rajib" <Rajib.Mahapatra@amd.com>,
        "Huang, Tim" <Tim.Huang@amd.com>
Subject: Fix GPU reset on DCN 3.1.4
Thread-Topic: Fix GPU reset on DCN 3.1.4
Thread-Index: AdlmPMmmqxwBcFLLRRii/sdkmdbaiw==
Date:   Mon, 3 Apr 2023 15:08:56 +0000
Message-ID: <MN0PR12MB6101408843E065F3442271A7E2929@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-03T15:08:55Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=3f6732f2-603a-4f0b-975f-210f557a6e98;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-03T15:08:55Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 6ecd369b-e06b-4b01-893e-d1156ee4ccac
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|CY8PR12MB8337:EE_
x-ms-office365-filtering-correlation-id: ea038b10-09da-4667-6ace-08db3455589d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7YCFrID25D96F93C9FCIsq3snwWzRnldIDvJC/ZrUel8txi99k16vP/I2WZfps5dsnW/slIgg69kishL+3OdbHh3/gTno5c51vcNQ6QuBPvHhFs5m2KQLS+mG3KlvVOyOTip4+4bzyONQA32HQd9ZHiPKZkovG3YmOQoBGgGHS7i63jrXxGpu3x1CLiPEMgRPAP/RGwCwgEshZnPw0TK65juqtQipsCn8FSWVI2no9AsqG0WnVjkiKwQdaHmeiZF1OzpfvFrzGgzJ8SGPzpAcxdrCdZBE9mVBcOANzpXVjJ5D2mhTTUM/lpaSlz1O2Byg+llKPWCQ/WqrEJKH/XSOMlqiQliKtkzHwKxT4Z7ZTt9IHO6v48UOV+ESTheM/kk3MSBxksDktyd3RTxLCm8eYIyRJIx8jl1lcPjb4bhGnnUgavN/ZUt/7/ovlu0CotbZLWEQmoiG8l5fAxj5DhlWiph7M5gYKakzsHeEF55igJGjU/UDe+LzTcACAn/VYs7fy5KI3PrS5JjpeX2Exwig32aRb5JqHD1s1Phr5A3x7nV428SWRe8spZWwr1ajjkwSG7OyZysCbSF9stTW2fuNT7eAkZh5RzIxiBk7QlIldFgcdtzd9tDjkgC2mIAxz6o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(451199021)(38070700005)(122000001)(38100700002)(86362001)(33656002)(55016003)(7696005)(71200400001)(2906002)(186003)(9686003)(4744005)(4326008)(26005)(6916009)(76116006)(6506007)(8936002)(66946007)(5660300002)(52536014)(41300700001)(66446008)(478600001)(66476007)(8676002)(64756008)(66556008)(316002)(54906003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NIymSWrtsb2bntDGIE+ts5g/IzxQxqQBUDfylQcD1d4cDGCm0ZoGEqjSWMIO?=
 =?us-ascii?Q?VaXFLiiGXufWHKW8dtOPvT6ZIdQVkuKIS6z2Tkm4xeG+sEdWNoKmudEXaEM8?=
 =?us-ascii?Q?BU/vKYtwoHpvP83nuXBeOCB2gFeZtmErjYCnouiJazA9HXZlKiWAFzUbBJvz?=
 =?us-ascii?Q?oB8q5aqKCyWgAgrMcU4eYbfF0QafTVVNAn/BsxZaoWxPFxCv+2LJW2ZrAooQ?=
 =?us-ascii?Q?qQCbUWHbZ0hjYY1bckgJd145S86ZgzY3MEMAD0qe6PVbiVrYpccXNZ3/kQsc?=
 =?us-ascii?Q?nbUVxXII0sLfaUBj3x4t5JZZ9dZcFDN/cXgvD8XzD+RvgIGaQcPiR7uSeTgY?=
 =?us-ascii?Q?/4GKCJx09b5vejkZ+fB+yZy1ghOgTzoAnKE8WS9BDO9a9CyhW+6nU2o7eH8R?=
 =?us-ascii?Q?BMpotM3fQdqgwERgeFLaOwu9RsGMex8VXN8Mto/U6S6xI9rfseSVCnmrbwoy?=
 =?us-ascii?Q?cESqHRUSwnsWLF2Qq6rRAuvjeX0iw6GwhX0zg5Ri8tsiVp/y0e/1Uo6wxyBi?=
 =?us-ascii?Q?V+NK8/mF8KYQoR7LctHXqtKrDBRR9D0Ka1Yv9g2MKGbzuujaiJ24w+1yBt4Z?=
 =?us-ascii?Q?LM+tr3m9SlMdCd+cYWyzSwpbbqP4P7AhfMyQsOmU1RAIW0lzYeaLYY3GfdOv?=
 =?us-ascii?Q?uTvyxp6JxvG/ifwnOAwj9QhbLY+IKsS+tABlFFI2y+xPEIoJHjLQ8PW0Ko+A?=
 =?us-ascii?Q?f1E3XXT3fXrZ2ws0tXFim/qzygDdbE+kjASsUU/ck8KGTnmFjdB2lFLEfcjm?=
 =?us-ascii?Q?AF8/vVfidkP7tU34iqLb0e/GtOZJ89QSQ367aOrQZ9H2CF4OirF2zMTxWHE4?=
 =?us-ascii?Q?a5tOTDcjEe+/TTkHVkw8teCfxJIzB9dsZSLrAkXcliS2eMjh7TfgyJufc4S0?=
 =?us-ascii?Q?+bevS3mmVj/YvzRfLIgXHWvgmGRpB8uyfANbdoiAw0deRac9pJIPAo63yjRZ?=
 =?us-ascii?Q?thdStVxdi6ttsm/0eXXO+FUYFUbZg4qY5D4sV+n9PiHGWSZolasA/i8ouEnN?=
 =?us-ascii?Q?wYyKcFExnmaIQq+MfdACtz/m3t/DnsCmTIr3TS+9j5jFjMLh42VYA5mgnT24?=
 =?us-ascii?Q?+O0ktwn0rQJDJzCo2s4mdS0daLHcAbCFsoTYRGCa/+sUQKM0uLcKZrSrj8ll?=
 =?us-ascii?Q?hyIMADHtyom0setLt+PFiBmk6PU/BLMdv2ocGDvmG+mIVWbB/BCfEif37vCu?=
 =?us-ascii?Q?pV93OaLquO2HdIb5UtsSRiAY+8ZuxDyOJFSyjikYJ+/wyffHMe+2eucyeW09?=
 =?us-ascii?Q?B44Tc2Ky+uJ7ZirvqdvdKi+ZuCcoD7d7ugQq9UgsYrZ8+iIzohjycR/g5G0K?=
 =?us-ascii?Q?i1D+osTt5rTqN1yUaj9cxmrNITMapzD+SrsqjcmUkIgBt4WCzQ7KIMkdxDBK?=
 =?us-ascii?Q?J4D0fe/Dc7G313raOkwzCLjpIIVYc2LJtCiICO0DAfcoPlqxcWsu5vH5837e?=
 =?us-ascii?Q?V9vdxOeZyDMZ5prg3mjp9KATk5tUNcmJFitNus9SDPARylbK1jTtbpvVEFZ+?=
 =?us-ascii?Q?IWLqv4uYqh+JKNM+IfcI0An4vDM3cJfgRyKYgDtpxr+wS3masEd4/ScnGl/3?=
 =?us-ascii?Q?Wauxl5j5iI3+pvS3FH4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea038b10-09da-4667-6ace-08db3455589d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 15:08:56.6239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hxBwuGtM7jFkC8KZlJdKxl/yjQp9NIo0pyW5nKOUWwXt6Mu2hAxV+cbeKNdIB+ZGUrJkE/VtIcQo/gCgAmBgbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8337
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

Rajib recently found that GPU reset is failing on DCN 3.1.4 with 6.1.y.
It's because of some missing commits in 6.1.y that skip the appropriate fun=
ctions to match the GPU's graphics architecture.  Backporting these and GPU=
 reset works again.
Can you please bring these back to 6.1.y and 6.2.y?

2a7798ea7390 ("drm/amdgpu: for S0ix, skip SDMA 5.x+ suspend/resume")
e11c775030c5 ("drm/amdgpu: skip psp suspend for IMU enabled ASICs mode2 res=
et")

Thanks,=
