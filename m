Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387214FEABD
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiDLXbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiDLXbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:31:17 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CE640A14
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 15:15:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIopVLDYB+0NJr1rEVW81i6FcL/sC5cz0rWRnfm3clf4to/ledjkPM3pkv8rEs7M7I4h+gNprieDH3CY6fxYXG1Cm5c6vzd7ldrDDK6yFJUqbiWn4Rjmmaqu7O4TCtz1x1aXFtaDiuqOlhuBVc1165MY9S5tNjvjMgW2+XUNrc1n8M42J8rqLKf1occK4B0XdQbC4rooRVPscCiZ5P4rZ7gx6kmeGkgeA5eJUZdpv/STqUYzc8hlRgsad7irMhm7YuEF5p2Kwda3Qi/m3XhJL/r66Uow3wJW3yTj2y11OhoR3gRmEp/k9eSwFe3buvOSU+LNBF2lydHYJgB9vTDxgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mG93SGyLziP+7XzhP3ng2/mv+ytRcsxnCZn1qYuGxak=;
 b=UUEDPxfNm1u7rMiRogKHwDYi/ofeDmTJKtX9LYv+K0wJQ+e1UC3vxc9eFeKHi84qYMxAKvb8cAGAyUyQ2H5sTmmiP1oYHg0xyF4qqnCtC/k503c/daJbp97Bk345gpoHmW5gH4ney691V0M8dHei6RtQiEiERzxt2e5tS1g+rVwgjfDaA7pOGGjCEmAAShaSBKDV4L9x5lF1BJ4NUCr3XvStvsSzPUPWGvtTr2QxpdtVNVFxNCymVjCXDpAp4MF27mHd2F9zfAxE3CKJO2FOAHujOCFFzdpR98hS1ktxZxBO6oCDykVtezAI+K7DP7JgZTmtHDoTJuXJFw7N4Ff2cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mG93SGyLziP+7XzhP3ng2/mv+ytRcsxnCZn1qYuGxak=;
 b=nTQ6LCTk9IRzLC+wQNav1rcWAreaVfoJ3+Oz1t11e3l9AFTozITgDwVT/ybmBTmj4m5/tb88O2VoazY4mpiqx/sjedOpUhEK5ELGPN9kNmQyPlt268JMPE4BmGpr5GojjBChw1ESmN8DM9uu4bMlWcoxUDtynuNencqmyHZanaE=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by MW5PR12MB5600.namprd12.prod.outlook.com (2603:10b6:303:195::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 22:15:38 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%7]) with mapi id 15.20.5164.018; Tue, 12 Apr 2022
 22:15:37 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Gong, Richard" <Richard.Gong@amd.com>
Subject: Allow playing dead in C3 for 5.15.y
Thread-Topic: Allow playing dead in C3 for 5.15.y
Thread-Index: AdhOumxBQNQEbOKASjOWtX5oq9oTeg==
Date:   Tue, 12 Apr 2022 22:15:37 +0000
Message-ID: <BL1PR12MB5157E3D352FB769DB61E2D0DE2ED9@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-12T22:14:30Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=15b6839b-17ea-4cca-bf75-b59a86f25a34;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-12T22:15:36Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: ed3c301e-5be2-4721-8e47-cf21cf63c62d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20442aa0-1c9d-4757-5575-08da1cd1f91f
x-ms-traffictypediagnostic: MW5PR12MB5600:EE_
x-microsoft-antispam-prvs: <MW5PR12MB56009387047979688250D261E2ED9@MW5PR12MB5600.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PdzfJ0KJaAvgiV01qVdELzAPg+HcpzF2XUbjvIt6ukC/Pbrl+vhrJ2bdT1/sK93Ozr1nDpV7k6riGq1/Neal80bwItENg+dfu1dTNVOyIazz1p65Zm02JrFncCKuHCi9K7nzMsSxr5iPYO0Au/PRuTpUGauisIreSzb2SlA4GXS5lFwN2FWPig+s8UxU8rO58iVeBfMR25nqsA50eqPouHUbdHHQy6RZe28YuDzB6EnbUX5/DRNOxRqdDXttfPWCF3vj21LCqigYM7joIrap0YCSLfqU/Kp9CGZcAxMjGIF6nOTH5CyeXXe7YTPcbYfqtRHRRTlxSBY/bh3hTgezMeEi2Th8+cW4J9X60V0Vrxl307OEhSPuWezWZ6G42K5X6MalvMTummWs9KLTKQCUC8SFGIkhZMXWfRgql5Otblzstbe0Gec3FrIxnepgMPYHGOYhIgrx24AGjO9AphU221I6CrzHd55M9FsTaLmGlML/axkmQ2y73XL5gtLm2659NEi2LL3Tajq6axr2+RAc/Z8bU2JqqIQ3Cn+J9C7l08VGiyIhBkJtxjcVDSTJISlcq1+Aq5748hL3DShYG+xL9kVDfWjWeFThXobd0xTIWR4Mxmz61Odne3U6NmkxLHHJV/0TfOYB/aJ9Q0ecMnTB0rCDc2M07+oei1CQfMR38rhOYrxbGlAOZEgPMzS10qMeMh7NgYw0B35amDcFxlGz/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(8676002)(4326008)(2906002)(4744005)(66556008)(66476007)(64756008)(76116006)(52536014)(9686003)(66446008)(66946007)(5660300002)(8936002)(7696005)(86362001)(508600001)(26005)(186003)(38070700005)(38100700002)(316002)(33656002)(6916009)(122000001)(55016003)(83380400001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wWMMqU0TV+oqCR0/HBU4/FbcM7e292U0mXBXllkkU2V9tFGxg/8/5tGaHRr0?=
 =?us-ascii?Q?7e/9aXlGGhbrebvorrgse6ji+jxHDlGoasjscztbHxxGdPaLT7aeb4hpjmCF?=
 =?us-ascii?Q?wwBW8o73mk0f6rkTNst4kAei4s+9riyvcxkqHzKWqUYodqCXvdYYTsxY0MEh?=
 =?us-ascii?Q?pTbOku7nXu81zJYr8CMp24tMgK/JJMlJ/+FLLfasrYiIG/w1j6hrA5WZgk80?=
 =?us-ascii?Q?kgQ88DmWRZNjVUvTypB0WswUy3e5/+ad3e5bCXZee8LuRb0Ts8ozehrrpWap?=
 =?us-ascii?Q?f0jZqd+XVMsGbiAcI7uLMkrhyTANOBZjf74G6yhgXX0qVJC74ZykX3H2Hc4F?=
 =?us-ascii?Q?GJlgmVu86GZjy+97/OXHCD9Zoy4DmJxWFtd3ifsvJf9nbhyz1kpoUJMjICZQ?=
 =?us-ascii?Q?wDufy52lPwewUWMRfiUSOfy/nNWPy0zUU0tIgqnQdAOSquamjfwtb2uavhKU?=
 =?us-ascii?Q?CbfQcLlfTHgHqdw17g55ttXMOaCjiEdTgiy5VcnPn97fN1lOfwtYHHXoOQe2?=
 =?us-ascii?Q?XAFPA6hd7dY9Q89vHMDK19QXAs326jTFI+CrKfkBXX4xTfZVxoFdi3geSkei?=
 =?us-ascii?Q?noYkBpQP3lR6OtuzGGA3u4ZxXO14XjaFAGoQaTHRaoLHNxLuCWi/nLJTqlbj?=
 =?us-ascii?Q?hcVdbkvaxHluY2MiEeAp/DnGnPH9H9lkGfbzmc0FW/RUscXQI0WB7kxLXhMS?=
 =?us-ascii?Q?lqyGjE+Lrs5sqzUpo9/FM+rGKzo5sq80hDFgPMqJh5qv35chXOXIt3dUEJBU?=
 =?us-ascii?Q?N5FtsORFgp+kFf6XbW0qUpz6vSKbLDzzVavHx4Dc/do2VGOAMYn4Wxi0yZL+?=
 =?us-ascii?Q?v9Ze1vI9zvy2b6ZfdAZX4ROyPQSuV3j6o00qxKhQ0FcawzXTfoAQmBK3fGCk?=
 =?us-ascii?Q?TTSXUMItIbzpbt9JVPkPYXnoAbwqItTd7K1ut4YKKRESjK8wCZfNXSXGO6If?=
 =?us-ascii?Q?qwc0gOLKReg3iUV2n9mDuAi+IzHWdz63Q2DIpAsUzqXJUN4SDESpFiWlYqHO?=
 =?us-ascii?Q?Oe6S7p+ZQCd3Z+KqhIzW8ARerrhuvn4BrZTKAsym6BeRdLSb7dpZf57hhneI?=
 =?us-ascii?Q?v48iknxYH5zxZ3Qe5LDmZS71qaNwFwmuS8G/gkDpFll7glWQo3eRF/+JCUsB?=
 =?us-ascii?Q?F9Va77ZKYex36kFupZ65rZjsAhOqBqIJFMNHTvBo2uLWJe/ICalTVtXLXxfO?=
 =?us-ascii?Q?R6uF66D1PDp+04QhYUK1Y8LA03pSRyGK3U9Jyib853bb1/BGKF/Jr0hIK0n2?=
 =?us-ascii?Q?uF8XftrZ8e9GgG4yKBy6LPev5P33Zy9uWEWvdT1pyp/ff05uf52qUtcgYpIb?=
 =?us-ascii?Q?sz1P1uURQsc+yyvMcmJHFtWBX2jL0oR2PXEC6CtyWF4hlnrL1FtoYeBMWN3Y?=
 =?us-ascii?Q?VJgzNDFNpStqIm2IPwnm4obYqociolboDCP+wJoON17goKJgFox/9CQMBaNE?=
 =?us-ascii?Q?bMfu3sttJTd4+lf6ABxhFDT6h6ixWW1qqSgSeKDc3kBoSPPI6X2+h2hcIpWs?=
 =?us-ascii?Q?0+Hjb1XULMmd4XnJaC0AfG0FVV3s3VyeTgLeUWiL9IfPQa71S0F2cboyg/N2?=
 =?us-ascii?Q?+rHW5zxRGom6QEGIIqQABCd0mJwGmNtWEO6lRcLCIc3JqN1B4kMJIsAEmB9j?=
 =?us-ascii?Q?PiHVTg5UhtTJW+nTQaogRsyQWRBhHnVhn/uSZtmiGsDez6t3tgerYlcVy3CL?=
 =?us-ascii?Q?rJIchpKpWt47l1Kf9D72ofrovt9yLlEwmNKug1keLoAckMYq+TrfIqSfed1I?=
 =?us-ascii?Q?szqRyQUFsQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20442aa0-1c9d-4757-5575-08da1cd1f91f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 22:15:37.9200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LhDT7QuSRY4uWebx6SwZDwRLabxRaRkVPNe6uW3h8uHmNKGb4ur86F0vmlt7CCKkkOZMN7kfVntLCFUnfXWQ/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5600
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

A change went into 5.17 to allow CPUs to play dead in the C3 state which fi=
xed freezes on s2idle entry if a CPU is offlined by a user.
This has had some time to bake now, and a regression was identified on an a=
ncient machine that is now fixed.

Can you please backport these commits to 5.15.y to fix that problem and avo=
id the regression?
commit d6b88ce2eb9d2698eb24451eb92c0a1649b17bb1 ("ACPI: processor idle: All=
ow playing dead in C3 state")
commit 0f00b1b00a44bf3b5e905dabfde2d51c490678ad ("ACPI: processor: idle: fi=
x lockup regression on 32-bit ThinkPad T40").

Thank you!=
