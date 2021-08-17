Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3C73EF587
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 00:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhHQWMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 18:12:01 -0400
Received: from mail-mw2nam08on2085.outbound.protection.outlook.com ([40.107.101.85]:56896
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235617AbhHQWMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Aug 2021 18:12:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NswLIZ6GpZsWrgcIEZOA1ZhGryPjl6tjmuYWjAwD9s0a0nV/KdxEhIEOt9ADmj/j0K5KC3UbyxI4LoN/w6s7QEyU5m9pMYmfFjdFjiYBEBJviW2XE+JLsnvW4cGJuVi4l8bUOWByW4eHc8tUA5XzIWPOZW3HbunEOEHhvekX+fVSu9BKhl8IzPtoV///ePDSaMCRZwvVJboHC/wI2ZtXLTj4m4rfcUgmrJvQYH4oV1MMbAW9NEm08JUsjrG4kuGY0mfg9GwMsDEmjHX89wcjlOyMvIdHtAZeAS5VOji8d/h9Ps1vHWvlRdFHBjJGw5beFr6hO90GIU3xbNMuSW+omA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aS01TcEIYdJeLp047GxCrZbrOytXpNLS0CcEa9rgzEY=;
 b=H6uKGjsyyalW0Bt7AX7P2V3H1/h3Rq35mDNGa7fHzPwOzQiiMniZ9+xPVlFyfq4Z1VLdJijConPYfXivhJTqb4WfEz76nWKXbE/HzEdqEbq3ijwoCwVPRVqj7cgJBv3xahKLB1xqpOooLPpf1t4+j99p9U2uox9e+ppMop8Mf6sMOEYExMqFCYa03HgYUkptOSPvqEp2vrM225RcmcawIz5ROp45IarYTASm4Gi0HPGYP06Ud8iFLM3+o6baq7aKWS/4+LQdBfSamldbWaa5mz2GGyx2WTTp8t/w27W/d5T1lTBwrQ3cLNuRY6S1/rQjKMOS5gEN3LkXy/f0K/sSbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aS01TcEIYdJeLp047GxCrZbrOytXpNLS0CcEa9rgzEY=;
 b=b7ECz4IlqQkE7j+dhliDH6xh/hCEh0pWpRoLvpuWXt2AD19VI7evaikNq1jvvmD67NoFUmvZ9D7pnoYlel9EPHtfPxGV3dUwH4Mhrvg4QfI+7jMO3PNdexi8lu0CmZr3FWGLWIIAz80qd0WmnPyC4H1HqiBSZ2iDnlje0ATyplY=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3505.namprd12.prod.outlook.com (2603:10b6:408:69::17)
 by BN7PR12MB2611.namprd12.prod.outlook.com (2603:10b6:408:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Tue, 17 Aug
 2021 22:11:25 +0000
Received: from BN8PR12MB3505.namprd12.prod.outlook.com
 ([fe80::8836:fe8d:8e90:a420]) by BN8PR12MB3505.namprd12.prod.outlook.com
 ([fe80::8836:fe8d:8e90:a420%6]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 22:11:25 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kim Phillips <kim.phillips@amd.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ian Rogers <irogers@google.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        x86@kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/8] perf/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op
Date:   Tue, 17 Aug 2021 17:10:41 -0500
Message-Id: <20210817221048.88063-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210817221048.88063-1-kim.phillips@amd.com>
References: <20210817221048.88063-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0053.namprd16.prod.outlook.com
 (2603:10b6:805:ca::30) To BN8PR12MB3505.namprd12.prod.outlook.com
 (2603:10b6:408:69::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fritz.amd.com (165.204.77.1) by SN6PR16CA0053.namprd16.prod.outlook.com (2603:10b6:805:ca::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 17 Aug 2021 22:11:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27fc1af7-a59e-49f0-211e-08d961cbf440
X-MS-TrafficTypeDiagnostic: BN7PR12MB2611:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR12MB26110F658EC0FC2D3CFA22E087FE9@BN7PR12MB2611.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBvspWXrQ+JaSkvC+0Lw7KHNq/JGy2S9ewrRx643IJKg4uLux1dpLXKCdSDhaTFKJsjhGOrwqOFeI4LUyolDV8Sjk4ESHs9Rpe2ikiV7dB9P4PnK19lS6ct5E4iFR3W4fBvnCM73Lio4qfAqcLfHmkq4BRMpjojnpF4RNoJ8GkAJ6jXhqwLz8EucTWtmilOyZdX1cw2nMC3kn/HPCC2hvBo6uev4dIiXb+Sf04QLYgs81v+B68uhv9uFLBxUZbhesu/lUi5cTxzsFZvHaQNDkOyHLDzxX8dvTw9kya9E1N8dif2k+Fg9TPemt2VAglOGd2REfsxFaUEdwu7HErwNpHHKWilN3mkRyzoK10THKX/i/xCmb+x/+4avJTyI3vupESTXDyN4eG36diqIWkBmSSPbpXd7FEq5YNY9HULNrhIDRrPNj+c95fYBFx58hnpH8q2ial+5xGPBoZlkXyeBSEpz7zv7o/E/UbSDXjDmakkAeRyzRCrZEf5wMLEZNxIKhc8CrPLkI8XQ6kBDaLG4GzeZ6/3ODKKPaSYfDb7aAsORaoKAOOzcOrkJWShBL855RDV8K2TLfPwPOhueAh3SgUhr0NKdZbWLFQSFcLQZIkRINQCejY7FGrbnGg4OOG0I0gigT2vd0UFR8+ivgiEY3BWh8DttayY/HE3hs9BeYVCQ+Ikxrdi+V/KYNLY0Q4BhIYti5h2BCS3r1HG4FK9MJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3505.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(110136005)(54906003)(36756003)(38100700002)(38350700002)(66476007)(7049001)(2616005)(316002)(66946007)(8676002)(956004)(26005)(478600001)(6666004)(6486002)(66556008)(1076003)(4326008)(5660300002)(2906002)(7416002)(44832011)(86362001)(52116002)(186003)(7696005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N/QI0JhJuipsxD4FAOWbdLlvfamRUE5CEGTBwPP76zgoMf3k+y5b84eDeCIB?=
 =?us-ascii?Q?eul5BMfV4ibEnjfmaGbQGGzd/1DZHl5sG2Nwh6xt3//zVSCLYz0e8oxeP/Z3?=
 =?us-ascii?Q?5Vy5iHTD/cF6yCMpECOEdARSbCczE6LVin+4GrUflW08xpW6PEcno0NQR7Hs?=
 =?us-ascii?Q?YQeIWTVG284rrhd7N1pRqTQ/cuKChbexfI/yUkEQEKeSwX5aX8MQpsaC/h4y?=
 =?us-ascii?Q?8rzNwCpW9qHsrYzky8hja4b38uoDEi8Hb7dPMnaUFW8Ch4E7Nn1YNaAcvEFD?=
 =?us-ascii?Q?UanC+opFva+cvm7gzhlZi1g/RBY16FAoMkevIwQ11lcq4gWW2rOTVVK2rUtn?=
 =?us-ascii?Q?hVJEKsLU5TgjJ+fTU3rz6QLaFvyRKp/qTXv4JdNsLGoKjECMHwsiSHaGhmhM?=
 =?us-ascii?Q?QWMgycR9exaU/7QoAsPOLQB9/T5rZUDl6R9QCXrmtOHYXWI/IAZAoeneJKGY?=
 =?us-ascii?Q?rTXVuqxhjTY8gtXZLxQwWlVGzzq1PV/qOd+5yIASY3MMY1yjOsyaGCwNzZvu?=
 =?us-ascii?Q?990cQLXOtt/4f31xzxzitiqdpiJwMslAnipQlr3u06Lse2dxNeajg0SYeY8x?=
 =?us-ascii?Q?AVWZtMuGtUDVBbeVPuE/Sj083mJMXmJ+JIixDKL1PdhMJX+zjaOxvhePxIwm?=
 =?us-ascii?Q?dXknmNA+D/1tXW2FYNiVxC2YU31/6idohW7UaJxpfGpdGkkX3GkR0IfaoLMy?=
 =?us-ascii?Q?DBj5qz1QQv/j/bZBpMxNFU5BiSpM1kA072/448mXTWT7y71NKFwyS71haGJL?=
 =?us-ascii?Q?cmgBvGAcY5WjuvIHvpV2uCjGKLT6YspdmuoJLHrw0IYxufNE/Coo2rn3iuev?=
 =?us-ascii?Q?AEyUDCeoxO88TKn42u7MZGM3czMz5bjckZptMpcImbDeV3evcwPs261WT+Hz?=
 =?us-ascii?Q?Oo0Gg7OCf/Kp5F0AJeA8/BhnCVtekzGbL92+084YQkhMi3EW8qgKYqlNNMFF?=
 =?us-ascii?Q?bgPphFmPsyFXHiznGXd+2a+L1sChG5Zl7A1V1UiBAD5AzsCHvpkgMdQI5EVF?=
 =?us-ascii?Q?qYfAmBXV4Vm24KvDAk7dFTQJ6SA54QohXSsJexvlkydhQN+tPltZxuLUSpNB?=
 =?us-ascii?Q?LbC8he3KhLKWrQnnPDVqNfMqZUQ2Rn9xpS3UMQ0U2kCxwUKgMtvTOyEi8EO2?=
 =?us-ascii?Q?/ON3RT8PD39hK6hFGmCj9eDtkZZaiNpOmy9e8a35VWj81HLiXdZdVP5Mzd+s?=
 =?us-ascii?Q?ecl+8SMJx6YXItrmtYxItfjvmfFqi0HB4Jl5jjKvHnJ4/0iG/fFwpjC4JJwQ?=
 =?us-ascii?Q?QUVGrEr5ddJPtfeLKBt0ulsHiyCYOjjUgIRud3/wUyIkDhlIunP7VIM4QWic?=
 =?us-ascii?Q?bU4K86MGt4JLsWj5ZqdcHiBs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27fc1af7-a59e-49f0-211e-08d961cbf440
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3505.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 22:11:25.5303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HOXlWaKxXAW0DcdkFD1eD8iwV2WFJgWlgyUDPWhcxRrZjA2SSLscXO/tDh0TBSkT4md4GEV3x0CCC2agOSwfEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2611
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 2ff40250691e ("perf/core, arch/x86: Use PERF_PMU_CAP_NO_EXCLUDE for
exclusion incapable PMUs") neglected to do so.

Fixes: 2ff40250691e ("perf/core, arch/x86: Use PERF_PMU_CAP_NO_EXCLUDE for exclusion incapable PMUs")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrew Murray <amurray@thegoodpenguin.co.uk>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
---
 arch/x86/events/amd/ibs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 40669eac9d6d..8c25fbd5142e 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -570,6 +570,7 @@ static struct perf_ibs perf_ibs_op = {
 		.start		= perf_ibs_start,
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
+		.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
-- 
2.31.1

