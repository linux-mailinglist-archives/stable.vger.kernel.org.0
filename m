Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9A6500396
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 03:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbiDNBYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 21:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238784AbiDNBYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 21:24:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C8F51E51;
        Wed, 13 Apr 2022 18:21:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNT81wtmlMlFaNiAXSPqLj1P9l8/POWvQqc3sujG9KTfHyku7AjZe10nO4YNJdTQKUffniYLVDJ6GyugoZ9vhQrv1/UXKIERpnhDxnuzNU4pX5S8zF3uPXfX2xgp74LU46txxtBGDj3K8jCI5ivAjFpYnU4Pinwbkr3hemNSKSqo3Gb+Wz5Ap0ckpmz0zap+v4cwDXhtS1pTR2FiaTtlTrzRCe1eMUweYCTfLG9eMsfnIaxy8tH0n67qjLwGoTY8RThz0gwFZrEtg/F29tXq38Lhk6n5e4s/dNvt5a20gpTqNCe+N/zBc4c0YBtYzTdbu/dodX6PPdSoCU8JQryv6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkqDciSDGRJeL6LqccwE27eT6q+ke18Dm26rzfPhirQ=;
 b=AsnZyjDk8PVXDjMxn7NLQSgDbXtGjXvGgX9nSFZIculNsRa+9p0w4BLwVQSGiZihq8rVTUDKnyWo9nedTG4QJCGCOpy5dkGlrE6pO/FhCa5UsxuBc83RKCqnHXLF9p3JpQDBBzH4ZXy/1RFibvY0umCRMAw+nEHmWu9wSxCHxpZlVCbxuqm/nliqa14B1zi9N3p4boVbkuKsbSsQb3CEE6eS5e1/zgcD/emtdGuNmsDntdZZYxQylQtS6vd4pO/yGaINfWii9cWyhZbYwm6A92RsmecM9ViYzSxa11M2rYxdC4qsM7AGbxw9TMtLPGNkoLi/7rB0XrUai48TSB93wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkqDciSDGRJeL6LqccwE27eT6q+ke18Dm26rzfPhirQ=;
 b=iyuMrr5Y/tX7adwrsKELrv8Kh90DV21z3liRiBwcgw+ui2MjqdOriif/D5EZQq1xfWyMhQTYLxD/BBfvK5wbW1TotqDQmC+U0CNP0jouC3Y0dFi9H9xv222njYqDiZbdbEPKB75r4FPfsolhJI877SdCN+/k9Lu5UMAZc3pamdc=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 01:21:51 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%7]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 01:21:50 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Shreeya Patel <shreeya.patel@collabora.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>,
        "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>
Subject: Broken GPIO IRQ mappings in 5.18-rc2
Thread-Topic: Broken GPIO IRQ mappings in 5.18-rc2
Thread-Index: AdhPmoYGuKdCoNM9R5SwKUX4ClBqjQ==
Date:   Thu, 14 Apr 2022 01:21:50 +0000
Message-ID: <BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-14T01:06:14Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=a6b8f580-8e38-4b4f-a1b7-2f3fd85687ae;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-14T01:21:49Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: eaaa4017-8929-4634-9c0d-7d5706e5779b
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a829e304-b6fc-4ca5-f74d-08da1db5270a
x-ms-traffictypediagnostic: DM4PR12MB5818:EE_
x-microsoft-antispam-prvs: <DM4PR12MB58181F8D33E834A3D785D18BE2EF9@DM4PR12MB5818.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SkFaxp1lNGQ3YFkhF9YJjpmZgS8wFweUdDvC4PaNqSbmTAFL/T5QLZ1i9Y3GX2ugvH1F10aX1FSb+4w7yikRDp6sYhdS3DlbDDnWjZdgvEvohFITCrTAM0f/snlEi0nXQhlOFoExWvg3EsLUm/HzUck9HXw59KPgUOuo5Cm4BCJUyYQ/+JMpryN5lvfPtS8MsmOE4EVhGwvKFO7mNgEQOQOpFZcy56CZ6e0QvId8egW2t2RF8vqqNtM+QuzGGYURXPMk17n4Ld9EAQeargwbprAKz28/Xohdccp7ou2FNukBqjiuXI02vQ4U9Xza+U930pMqjsA3E8+d0+ZDAysbjxMpS0mjTpx6olTu0PdRxFx3ileR+6sqNmUF1fkdzk4+Pxe1oV3cSSwB+eSCc7xxQ17rhzeuFXDRNTM8FgF2WGp0YmkDZYMsHPWORrppMnLug53zB1RVu2ZNsYtmA6Dkxs4vDLwbPYYDiPspk9rML0FQSfM+rEzWfEil9jXA+RdvOT8P3dZtjXEHUlWGJc2k8pD3uSelFpvGLkPi79OfI734aBx8AtULxi9QS5+2PbP7uYPMx4ghDYDopKfpwOcAUOBNF7oEY3PY/OKPJzN6vEO4Ma3110sNgedyrFzxySOFo+B9+kzN7OS7AP5EY0t66nbxwoBN6vBXIq54tE+XvwM3RlDjtcEvANR/uY7Yher7aGMCF5YvgeUNbuql1h1UTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66446008)(38100700002)(6916009)(86362001)(54906003)(52536014)(8936002)(38070700005)(122000001)(55016003)(316002)(5660300002)(9686003)(6506007)(7696005)(33656002)(186003)(71200400001)(83380400001)(2906002)(66946007)(66556008)(64756008)(4326008)(76116006)(8676002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ILYGonu1L7KNlvGgvHe34XAIwdFFRjdCih1h4WwycANy/mNa7+FRqbFcSZsT?=
 =?us-ascii?Q?pCblB+K6glR+Uvz75mr8xYdjk6nfydYr1EMRMz1qlRhT2ZAHnr4nKiphCaoM?=
 =?us-ascii?Q?7DXEaq1QcBbILlmZU2uunaasN1VPdbVMHL80VvUHG8HldjHgMBtuLwaBZEmD?=
 =?us-ascii?Q?IOmuINTkkXbRUx/jnUZfpfITBY7pr4/FuYQ6c2GlKWpv70RZSVO9557mYt4R?=
 =?us-ascii?Q?+5lIRXaUrR3GGZEwYHxafcpyxDBGMGbHwdXhrf53QC5W5M28SNFzDrasUhpZ?=
 =?us-ascii?Q?dWrYpzax36In5Okeh28LOv33QYTPvYr5sJCsEDUaAUtqckKCH6E5mWwDAkXu?=
 =?us-ascii?Q?4jlKY/S/7UBbKu3KXJvFD+icjGKE8ZHM1zKbfacSQhWjFZHCDbQJ42U9jda0?=
 =?us-ascii?Q?5FzxMV/tYiep6xmEakDU7DKfsjdOihyMp5Ij+kGRl5liVA7rslgBtoYwXVxc?=
 =?us-ascii?Q?8Qfi+V6USgtmueTEJn7SrJJuFb1Ym3tPhXHib+U4xbrrF1Hioms6AmPI7/K2?=
 =?us-ascii?Q?O1pvGGwt5SkA0rlebMCsdYbU298irhZdVnML95nyB04i8R6lGq/qGO9mRoNd?=
 =?us-ascii?Q?GVo685UzYnmKMSszFt4t2xl8tFydlzRay7fUVaEb5hEqR2byuv6Q4c+Z7Zof?=
 =?us-ascii?Q?FgDwwHDG81n1W80sOpoSI77tT4LXCQvYEzrl6jA+tcM1xKzRLShPpPdIFQUC?=
 =?us-ascii?Q?il917DzyrGxf1BgizVHvpBKYBJ2cf3EjjYsova9Dxx1PeUvgb0qFd/beEG+9?=
 =?us-ascii?Q?qROZE0NAXjVLxo8ajCPE96zEtLyL0Vsza8+MvdcjgP6XejJB0rXnxVR1ykav?=
 =?us-ascii?Q?MpjZ1s+HsT+cutlFCX1WAOdEPi6q+06xZtA694Y5rOuYHNcXNrVMKEipPU8m?=
 =?us-ascii?Q?gCRannXL80A4MIW0Qhtke0UhUUUkTZ4XJibdr8Rr4cPRNCrtNvPtnnW15CKx?=
 =?us-ascii?Q?jMtkv73P/RoPNbwrfL5GvX+69N6k4qAhzsvl+ZcYHArLYDCsALIRSw66F/w8?=
 =?us-ascii?Q?KdYDivexfFK6Hs5F0vBrUfGU8TMxlDXt6lVDwe6QbdvORYwI1omdKajVHKAz?=
 =?us-ascii?Q?hlfmum2CWDCFBQ9yOgU/iAe/KdiVS/7EBIlovCFNTaRaSk9/8/qkAca5tWyn?=
 =?us-ascii?Q?aj3gLDd+5Kp9Q6/eP9S0pwXwJOOpolTLydy6w3ZeIwZ0dJgj5TkM74xGG+Y5?=
 =?us-ascii?Q?PzGVRPHjPB5TjV2LVtqf8gQ1DV/mZ4F1pNhjPwHDgf2Fyv1A9V2Ii0cJzuNd?=
 =?us-ascii?Q?/UKKr4RDWaKng/j06bJMV25SQEcFaD2onoj2tvr/n1uN7yDwfVPJo9tagDdh?=
 =?us-ascii?Q?80Eco3v9FBBC3+9oRbJdplH101RMllbXhyosYd4Co7D63bryLLvbqzhXiCKo?=
 =?us-ascii?Q?JS5NwKSRNQytoXRApCYktH6iqxPa+fVOcYeSoCALATRnjJm/c06UOD/pw2zL?=
 =?us-ascii?Q?x36PMPg64XZtiL/KU6kZIwYQekHgdoP9qIY7xIt4cCMSucj6Qf2ef8IIS9be?=
 =?us-ascii?Q?1mxggv9xxm+/9OJ70oSjuceqSaCX3ESyB0z+FAnxx7BgtUetcnKS/63S4W4j?=
 =?us-ascii?Q?25zVbjxMlYl2HiHBwAcA+1UmHtocgTdq4HowAQ7AfhcG/E7oxnClYMOaMX0F?=
 =?us-ascii?Q?x6WsqyAre5VsleIk2LgtbLWiyEJLi6G7T8xOkYhGgWDPFAcuxElmcBcmZ8Oa?=
 =?us-ascii?Q?aPDDLag0BM0c76HVV2Q5hC94BDkaURLY4GmPuRjc6V4IPZMY+pcEfBG/TxPq?=
 =?us-ascii?Q?wjr5xw6ASaZx7/JABIgcNy8spW3o911ILMyudYqCrZC0Q96fSeuxmAbP9Sn7?=
x-ms-exchange-antispam-messagedata-1: UT8/h16u3VfyhA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a829e304-b6fc-4ca5-f74d-08da1db5270a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 01:21:50.5944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PVvyv0vtSLjaInZgDj1CCGYQm5dBs7jfYCjUZswhbhIxdD7T3rI3DxjC09jGKHc/hR0QnfsINiXkRJlQlA5NXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5818
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

I noticed on a variety of machines that power button wasn't working anymore=
 starting with 5.18-rc2.
In digging deeper, I notice that a new error is introduced as well during b=
ootup:

[    0.688318] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0000 to=
 IRQ, err -517
[    0.688337] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x002C to=
 IRQ, err -517
[    0.688348] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003D to=
 IRQ, err -517
[    0.688359] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003E to=
 IRQ, err -517
[    0.688369] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003A to=
 IRQ, err -517
[    0.688379] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003B to=
 IRQ, err -517
[    0.688389] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0002 to=
 IRQ, err -517
[    0.688399] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0011 to=
 IRQ, err -517
[    0.688410] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0012 to=
 IRQ, err -517
[    0.688420] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0007 to=
 IRQ, err -517

It looks like IRQs aren't getting assigned to the GPIO pins anymore and ins=
tead showing this deferred probing message in 5.18-rc2. =20
I bisected and confirmed it's caused by
commit 5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320 ("gpio: Restrict usage of G=
PIO chip irq members before initialization")

I don't see that probing ever gets a chance to run again though as it just =
shows the dev_err and returns AE_OK for the
function that walks _AEI (acpi_gpiochip_alloc_event).

FYI - I'm CC'ing stable because this commit went to stable too.

Thanks,=
