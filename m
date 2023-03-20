Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1F46C2367
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 22:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCTVKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 17:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCTVKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 17:10:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E655D25286
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:10:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2Xwtz+YcJ6rx5dXT3RDQ7orQ8rDsemqL6ojH/1AlmNgqmQFEMes/zaOJPIQBdPFFKZyebUSOA4raru8mTwZX49merhENDc0TH29MKlseIEcMjvg9CTI06VlMaJ4UFiclVrvzh4YkZuWWEmHYdtjS37lJPy1AujkGGEP/R+6c6czr1k8fRUrxP8BAJErp5gjoV07QAu4xmOJ5WW14+Tiwr+e+LdeSnOeqixmXt0NtxlhbWsYcWlRHgdceEslzsMtF6uvPuNWEzMILpo/nCzrgmxfACBoMMY5IYQ9mTlToKlzoUvPET1YWWV7WAdLLPkpjnH0g9+MmwVeiw/eLZ2JMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHeqwb5sjAtf5umuZ9mZ75GHHnwIodxSaisxQ7MzD2M=;
 b=CKgYVUYnmRYv3usEiTmqNQPjtE/5YkbTSAon0x2B08DmtIU8AC6LK89QFjJ5+GZlgGzYMTow5INngHjkN3cUpSogi7b469+xA4hL/GqtyOmDUJ9klaNNYZFCgPeiYic69G1ID49ryj3/xFppwm858F+8uKEp2Hhehf0noa6RSRtMl62Qn04u3xNtnZGnYKueBLMdu2sPd6FKd2wsyilSUdbRhBLQyKNO+jvRl1ItATp5Jv1ln4/uZRNCPJDDSLHxH6a6u/r4aq/H/mWp+j9h2zwMrhk03grXK4s3ENlwLZA3KSQc/bWnIO0raSHyGljnUj7RUHCZK4n8J5XUzXad4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHeqwb5sjAtf5umuZ9mZ75GHHnwIodxSaisxQ7MzD2M=;
 b=Z6pIPyVUJ6evYu1WmO6EqcKQmhNpHwh8V79JGSCsYwusswzjXV1LTbys5Sn8EAd8TXo612NlEFrc9dUXRnaZbvjDID3Cx6v8kd2It/VVEQF47QxSTaDxeOYpsmg+VPffd+apIVyS+48KasdPsYkYQxImA+GUnAC3QjXXnHfORfo=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MW6PR12MB8834.namprd12.prod.outlook.com (2603:10b6:303:23c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 21:10:03 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a4e:62dd:d463:5614]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a4e:62dd:d463:5614%9]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 21:10:03 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Gong, Richard" <Richard.Gong@amd.com>
Subject: Fix KFD support in GC 11.0.4
Thread-Topic: Fix KFD support in GC 11.0.4
Thread-Index: AdlbcB4DWx9vxPPBSCK8kJIDQlNwDA==
Date:   Mon, 20 Mar 2023 21:10:03 +0000
Message-ID: <MN0PR12MB61016FB7B6F4C8AFAE2714F4E2809@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-03-20T21:10:02Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=d5644d30-9d2a-494b-b9b9-d650c0a2f26c;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-03-20T21:10:02Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 2e66a42d-f32e-4ec0-833d-5b3c58ccff2e
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|MW6PR12MB8834:EE_
x-ms-office365-filtering-correlation-id: 7a21edc8-42cd-448c-7040-08db2987793a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QdKS/d9OqusT2MJOcP+2dD3IPXX/QVvNUZaTiNAvvR2JAe7OsrD1ottasMQEQSDhGj145rDqeS5jf7BhHUP/VaW5tNQK6RlLroCkntXiZ5vPrjMbvNFtun3X0uEOi2lrS9yNNsvmkczgPnII0/q1I8pbHGyhDjKrSkrG+hy2Y0SwXs7ApOlrAU9HgLvJQOhEJRBoljsDjXEDxK/Sg1LV/0wSj/Em+5Hf7zk+PjHC5JgA0ToPV+j7NNXxTHC/PO7daCFY8uKc5efQv8+jnVyaOWMsUgIFoQQFI3Fn3VIs4679rK/SLwy99dRoJ8iOblIaCVnJ+/F3A0DpdSXr965l5fWB22KjSAwkX46p/fTFSwMIJrEiQcMTI52n/mK8mmO0GxXA6wRZjCtKIqgmROzWCa+Zpv9TR2z6/k1Fbwg/qnTg2YiF1QQnLGs5NemcXUHlZ886QT4JYwQ+jnp9GkrdNwcsM8UKuI2yFbdyAAwGNRkz+czxE5X+nvpCT4ZnY2uUtavZcnEry4R/LnFg+9n8ZobtVty6n4d39bZqOaB3mgkpF60H1b+eP8jcM32LL0iwgNcjptrpbpPCBZcULLTl2+Y91m9/9kA2xjW/ZSETCzJYdcxY+yMqc7ei8WEHmzw28QV9uiJZYXR/A+aGwGaOCVZilxwDWEeBfwMIdkz5ZOG2FW1YAEW17RyPMo6QUH7hIbXFXdg2zYJ7WRuodI1qRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199018)(2906002)(38100700002)(55016003)(38070700005)(122000001)(478600001)(71200400001)(7696005)(26005)(83380400001)(33656002)(186003)(316002)(9686003)(86362001)(41300700001)(66946007)(64756008)(6916009)(5660300002)(66556008)(66446008)(8676002)(76116006)(4326008)(66476007)(4744005)(6506007)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c6WpUoEgNYkZUGQDShF4wOyp5obFvVJuTBmnrE7mpAA5P6ye/dDb9S925gTt?=
 =?us-ascii?Q?qfGOf2lFhIQBfoL3dlHOuOdSr6eh2yPWrmZrJPFfNTwQ2DfQKYu9iuclFZWI?=
 =?us-ascii?Q?7Oy0Av4ZEMIaZKtd7Phda4fO8TXyLsPCkY2EcplkHVh4FAcj6yqLXUxx3lyz?=
 =?us-ascii?Q?0f8jUmjCisETFB5AXyJ8/XRZK+WNuy8uOilGI1A5Nfn9obDGfhzYL1Vjz3BP?=
 =?us-ascii?Q?Yd2RRuf5RLja0kpGKZjY4lU8Z/lkiQxbq/r1P6d33bDnBiRwn6bFlq37ZfEi?=
 =?us-ascii?Q?DG4gyq8ZydxGQ/Vah/zXJGM249SZ3BXNZNA9r/EN3UzpPCU+1C4F9+TfB7X4?=
 =?us-ascii?Q?NXSYnm6JLb/GiB21jjDUH6v5z3Fd+LmXgm9Y2L9Hz6U2ermbkAEOi5wvLz1I?=
 =?us-ascii?Q?d4/+K0oae87fnyzPCEMZ1oXtzzlOu7dHSQq5yxtm2rj4N7zRV6W0GDhNLaue?=
 =?us-ascii?Q?40deld/Vxe4kikNrontdpapcw6l9Gr41fYYni4mi7R/GdWvmH7WWir6l0HvI?=
 =?us-ascii?Q?v5AMklj1ae/js7f0+xcmn4NiUNrD9YjuUMfN/gprMejXf7ddFMQYo+Q2qIJB?=
 =?us-ascii?Q?ExYg7LYb8kelcnB29hWxk3h60N+atAwpugStmMlOY6lQ0/8C8zVkgSvOqwxA?=
 =?us-ascii?Q?YwvF4JLHCUpaPfTNeRM5H+5i3NxTwK6aAa0TL3x87GQcD0LvX8cGRZjm775h?=
 =?us-ascii?Q?SL5tda9n//RDignlJtJOnTXLDXyeq8Jmf1IWT7R8M3NyPug6VEJ1PUJnSXlx?=
 =?us-ascii?Q?4IHU2LifGuEacnrL6rtOc60dFusOKLkP5CCzERvYeZ+/udx/uDlAmhutiBsq?=
 =?us-ascii?Q?endxy6sntDsA+SuHx3CKQdtAVkCjiU3HZJ/nR4Qu/fGfqTVzPf1tW7SJAADG?=
 =?us-ascii?Q?WGwxO+I9ztb6EXiAvCsczHKMhpLhVj2//zazsjjd0dm63vEdIwLdIg15upfU?=
 =?us-ascii?Q?DYrjIxPhGUYyCTJfCbJb9DnBk/SvP6lu6SJX+NL8q1Ieh/TaLD58mh/C31rq?=
 =?us-ascii?Q?5clNrp6rwLkTgeGeNqRhtU8HuS1ucGCoXEWBnkDdL1rOvoiga7ytLpGihZ08?=
 =?us-ascii?Q?clwIvnL8LlPT7YxTd2e6VyoaU1PBC+dFttxhI5O2zzmaXHaG53a/GbrK7XD9?=
 =?us-ascii?Q?cgATkwnl/KpxHNgeXDvE04kvQLxF9TIVvggVFdqCwI/5UsBNEOnSyTPHa/Nd?=
 =?us-ascii?Q?KVZhXBopfnPV3gejtHo608ppWxDY0V219aaXhloYudsf8DKx+mnzq6KpOq/U?=
 =?us-ascii?Q?Wp0865AYS36YnQr2pkg1fmk/C+5umRYA4og00IgR9P+MWHLM/7UhdkngKAS7?=
 =?us-ascii?Q?ZHmqzLpqcQcqamHOm/9QeP3BCTiShpvN1NptbF5zRyfzEPAJ8HClPFNyGD9V?=
 =?us-ascii?Q?doCr7zIWAr6TiI4zS2RwsIv+FYY68xCnU4nMXR2Ry+02zgmKwAm2cqPSzBtJ?=
 =?us-ascii?Q?3kJOoICMKZoo3fEG/TxxQvHia1MuNQYY+5s7eYOCmL1nTdmfKkj55KNQSpdA?=
 =?us-ascii?Q?OOjXizugqAsj7AWqYAdbrGduwUzpjh8glKOzg9hoMndAzzkknsBgW38soqNA?=
 =?us-ascii?Q?YguZzoHIMG2uU5V+5kQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a21edc8-42cd-448c-7040-08db2987793a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 21:10:03.3941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H1fmsDKjRDm5VfWPMaF3gVJLw0QEgVr/+Ahkea1eEgsP0JMwiecFpaclBcZDVgR+H+ITpq2zeuwSWQXzkcI5Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8834
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

For a product that has the IP GC 11.0.4, there is a lone error message that=
 comes up during bootup related to some missing support for KFD on kernel 6=
.1.20.

kfd kfd: amdgpu: GC IP 0b0004  not supported in kfd

This is fixed by this series of commits that landed in 6.2 that fixes KFD s=
upport on this product (and also fixes a warning).

fd72e2cb2f9d ("drm/amdkfd: introduce dummy cache info for property asic")
c0cc999f3c32 ("drm/amdkfd: Fix the warning of array-index-out-of-bounds")
88c21c2b56aa ("drm/amdkfd: add GC 11.0.4 KFD support")

Can you please bring to 6.1.y?

Thanks,=
