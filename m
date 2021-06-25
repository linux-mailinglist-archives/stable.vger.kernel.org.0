Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09BF3B3E16
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 09:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhFYH7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 03:59:55 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:60385
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229454AbhFYH7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 03:59:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0tuRzMZ2s5uEoc8fivt0X39ZPC/f1a4cL7U8rG8hQ8LUAxSTJYPTaTHvm5ICfL0bS76S8M2jFCeKKFo7djQ6CLfa/Z+m+tHQJgsI6AJzz4aOw9nlQ/Hs5pbGpYijz+mdZ79OgYHxrDZhPZlSBOyLPQiIVfuxKlf/qXj4+ZNwtvHwHwBIulVgdSGfdfXgqzxeq0FmcZGKASgkmJH7ANJa1PD44r4VJF1HexnwWP7e6eMZgvc6nhOAZnClblOEoyq43kW9UK48F+AZuZPvrsoqeZt2+pb/qLdJ+ULELOjkzlt87XtZKLQ35P6Zd8Nc3E68Ytqs/gkzP5kWDh0jvkZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXwpmuvs8V+tqz+zrEd4Nv0UOZaFZ0xuycRTjfjsDXo=;
 b=kUWBVgN4fw4H1hCLRpkajSbut3kytzMCudXS5d2uFPNAs8o/ivoW+cnkh++RMJZLNZllG0Q4Fp7pmDXZvDe73bu3ZVNbMK1Yuf/Iiros7gbmyuFSo5ARD/KwmYNZjouNgTcI+vEBdQ5L88QvGhGhqI/q2dOULtexSAAwl+3Ieq18SlI+yIsYttk/6nZD91jlenq1wb9fmZN9T8+2L5j4W1eZSGobDo4JfHxIzZuusRLR+h08OWRimirLvODs25j9noT/tRbkP7ZDfI7R79tPK3JgOgNy5mJws/UMACk32XULBc4CRCbaJWMrBpuU9OwGpfoD8k9O1DJ9xnRU+DsxBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXwpmuvs8V+tqz+zrEd4Nv0UOZaFZ0xuycRTjfjsDXo=;
 b=kizPdot40ZgzBVpOg4GZIsfqUdg/bR0+GdGMroaeuebAN9TS36A2mTiPLwJL3srLCqw+kScpamWApAtVgusBgYBp/6dhnc2lkCI07KJOAAp3FmopEe+UhqyLi2qcwCEUPAFkcEia1EV7BuAatNcV0ky9wP+Py68f0PaswCpvN60=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN9PR03MB6137.namprd03.prod.outlook.com (2603:10b6:408:11a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Fri, 25 Jun
 2021 07:57:33 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%3]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 07:57:33 +0000
Date:   Fri, 25 Jun 2021 15:47:37 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alan Modra <amodra@gmail.com>,
        =?UTF-8?B?RsSBbmctcnU=?= =?UTF-8?B?w6wgU8Oybmc=?= 
        <maskray@google.com>, Quentin Perret <qperret@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable-v5.4 v2 0/2] properly cope with -z norelro
Message-ID: <20210625154737.3d64a434@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::46) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR06CA0033.namprd06.prod.outlook.com (2603:10b6:a03:d4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Fri, 25 Jun 2021 07:57:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98a6cf4b-41ab-4eb6-6597-08d937aee393
X-MS-TrafficTypeDiagnostic: BN9PR03MB6137:
X-Microsoft-Antispam-PRVS: <BN9PR03MB613795778964F5805D60EC3EED069@BN9PR03MB6137.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuhxy2pZZffxcvXeGYZnh8B8Afz4ygi/N0OGDNjib1pde19uRr8DqMdNkkDDhVMBn68N/5r5HKnubR93I5ly39Vo2qVCtEa0Jfbd9HnE+W4+rBBD5gA0tfd7DWsFgxyQ77C6G8F4CK7zzry8vui5pPgYZ+eBfqaOYBmeV02weXKISR/wFbt/6dPo6HCT5nZXhzSjoMds1/Ij54Tftjoous+SNMnqmtMzZd1qthdzrjR0Ky41xvEF3SqnlPk2byjKeiDKH/xyrfnTjLIhP+57FKYK49+9NQYRM1/yRvbcNuyxAG2lIJy5n1UL770amFaYRGnYWb7w+Aw1S0fQUe4RLarIjrnfi93uKyx+0uoLA2yHMOVYKHthYuJIdLB/amrNI2DOVUGmDMU9OAK11rA/JTsllg9eCUYBBZkVmNuL9elvNyFKrtp86P1IMkrO/H2+wHZ9mae9ndIHfBYgaQ+OyFpjeVS+hylrc1RTruHtw8XkC8BO1G3aMAHx9YbkKs5ivEPCehhSV0ZADJ+qxz7aBN3M0TgDiocfQIik2j98N2rUj9Czmqywf1Hy1Kp9ZIQBmN1+wfqTYQ2KaL5apWisBPfyNUmefSr2+TSaGTFmYJgCIOD9mFyb9n+T41SBijysMKOYCPaHpXX5ZmfRfYcbT5gPtgzd2xEVwp11XHN0KzwknceXGoX0zxELtvLSqreHGPH/vog3ZkwLL+RCk43dPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(39850400004)(376002)(4744005)(52116002)(2906002)(186003)(66946007)(316002)(6666004)(66476007)(8936002)(66556008)(7696005)(26005)(478600001)(55016002)(5660300002)(16526019)(9686003)(110136005)(7416002)(1076003)(54906003)(86362001)(6506007)(8676002)(38350700002)(38100700002)(956004)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N//9Hyiv7sme01rnuU8Uu9Z6oH9pS8AdK4mk6M5V2nFdns50VuSscuEyZ6qX?=
 =?us-ascii?Q?atXdB94kGW1V26AefLnuoD5KrGESoLvwt2m3y4/gTFX6yo3PNUq/qof2OGK6?=
 =?us-ascii?Q?D0c2BOVTT2CnW46BOF60TDSxN13zY00Ut5eKR2qYmCPLKionCIufELBjaqKX?=
 =?us-ascii?Q?J1hPUCG9mSzU79A7uel2g/8Cxok4XrVLe5iI6QsqJs3NoYeovzvR59oh7eOy?=
 =?us-ascii?Q?7zT/M1bA7pv3vSFc+g1weN0uvRXrgcChkXdQ+yn9kJEhg1kFwMKoZH7wjOA4?=
 =?us-ascii?Q?CZY64WJ5fWisSROf8Nxegb5j2fywrTA/Ptz/HcuwAK/ALvL2VB1sPn98cm9C?=
 =?us-ascii?Q?7gS/Z4wH4x7plw/+EEfN4hOIbvtRveegdg3OYLYmO+El2d+mZvO8x+ahbAef?=
 =?us-ascii?Q?mBIzWEjRALTMR1xMS840iGq6JdYEP7l8kTvcXwy8CXzOIrCSsCXxp3lBaq7T?=
 =?us-ascii?Q?ryj89O0lLD0pqv5lbiafNk5l4gztY92yLBDvM49YbbYTHwrrSRHYpFsCkYNv?=
 =?us-ascii?Q?lPrwAU6Gez8p/kfTRPO/b3olTKENF7bbZfWbX4rNUlf0A7ip1sLGZh8sSnRZ?=
 =?us-ascii?Q?EsF+72I8/zbgi6sMLT3lt4wOHFx5STYisxxYlwyj6cq6y4Ot77r7mO3ugEoe?=
 =?us-ascii?Q?HorPfw9d3GRREpKBGaX6CYIhL6yv+xqWKNeq9Kb9whcdtA+Vu5TfW9LfvawL?=
 =?us-ascii?Q?1gVvS2kvtV72kZ354hjzVFh2TuYOYOHGCBTXsGnmjl7qRJI7AoHSVrC9rGJ0?=
 =?us-ascii?Q?vh24A/WP4gJPOfBFFmBbRpH3QabsO9dfG3Vvy/ge1ibeEioDQ2ECNDun14WO?=
 =?us-ascii?Q?fcCKoI67UK2bJMy/+p9+MIk7oRCMRMSZKK7HpjCvv2zFRaUCAF0O6FvDqgg7?=
 =?us-ascii?Q?HpViIOZ/8q2XkX42oQUm795h5NSauEqJlF8d+RXovb9SRfaL3cZRxgYIHDlk?=
 =?us-ascii?Q?sEpi+7KzUAKv1uEEBZgWpFOFRIfbUbb8Mn8YYe04IgOR2pF90weYAKpaybzs?=
 =?us-ascii?Q?3yIrTDQPaHl7C4W26vqf3tMz8hLI9tnQeP6UPoyrT7CwfAc32MXdXf/qhF80?=
 =?us-ascii?Q?ZI0edPM61bpTUyQdpKccrU7F2sWh04ucdCSJeikOQO3xQSalnW43WvqnrFHh?=
 =?us-ascii?Q?t+GXDx2/b+uinGirUP/673FJxClN7LknghCXxQL53R3wWj3KilPOmuDGAEQu?=
 =?us-ascii?Q?9hFSkrRyJDYlpxmD5lildPMGqPlImZHwB3hVRqFOX+XsJJqqjl/It7FTP12J?=
 =?us-ascii?Q?p3+90oLfgV5O0Kx2EjCNoF0vD8RP1pyK7ibsJ5+QYayR+5IIlFRYCP5lOco7?=
 =?us-ascii?Q?MH76210M+XL9+omAu8HJshSd?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a6cf4b-41ab-4eb6-6597-08d937aee393
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 07:57:33.2745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gO6TJWx+tNnUkeRNZZgEpiv/jIkr1zcna8N+z54FydnAR7dJgP9fAiMYm+v/LDwgV4JeZcmvnnUMPznWqZs8Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6137
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix below build warning:
aarch64-linux-gnu-ld: warning: -z norelro ignored

Since v1
  - Backport a preparation patch as pointed out by Nick Desaulniers

Nick Desaulniers (1):
  arm64: link with -z norelro for LLD or aarch64-elf

Sami Tolvanen (1):
  kbuild: add CONFIG_LD_IS_LLD

 arch/arm64/Makefile | 10 +++++++---
 init/Kconfig        |  3 +++
 2 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.32.0

