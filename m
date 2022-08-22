Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9DB59BA6E
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiHVHnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiHVHnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:43:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8F82A72B;
        Mon, 22 Aug 2022 00:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKG5+5WQ7+xfaESbBSoIJRHtr/5WZ8BkTjER4M+Nb+IsKK7LQ7VtnPGhsyqhQueCN2hbEQd7eOFcwvf3zvIkAf1Usxww8Gmf/tW6uxz5Hn1BH8oaZdiV61y9c3QpdvHOqO/ANIiYXBRYVuRHZyWYLY0OsCX+JIvGgbxhfZ3RGaPAUNg4+ghVRkGwKGSbL+c5m4k+bl3g2PX7nguRap4RNHpJugSu50cYlx0kJEChg9fC1lMuyqdTs35+Tq3LHu5xKNj7lmDZNdBh2kG36d3BAYuz5fwIpE3UzpHxNqPM4NqmuWoJQXU/9eKXzHrmpFlkpx5reRgShwXqFoREUJXTVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ojqx0pKaDDZnV7FrfCxdjcQJIAId5CzjhD37hCIBrXw=;
 b=eEyRtvDroRifPhFfrl3PjlP7iJtZG+fmzTLr5XirvdsfdT37wL0BTQBMGIgabUzdNY/hce4FiokiULFTJtoDkIa3QTAu8fmZRGedN3EOXqioroQNLnZy4rSmqAskX9Q9fqbu8lxR2d7ixeyCGY2A5cTScbyBhEPemkFQoRb3KEo5gftqXagZCYW78ehEx4SHpXuFoXX+t/UdmWwpXjhDM8IvJ6AxcoOZi5neCL+hswoNyu6IJvasCQ3eDhxtustMnpAjcycdwEhfaHNP7WN9lLF6h/EzISTrOVszp7H0hzKO8LMw4knxIWFsG/wzW2KpvmNEqLH4LmnrHhpilBtNAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ojqx0pKaDDZnV7FrfCxdjcQJIAId5CzjhD37hCIBrXw=;
 b=OgcB99pMXZDDVrQ1JTSsQlETXIsUyV28Taaxouj+6x/y94lRmr9VH0U9u229ghHz1VltxHaawuiPEG6kGDVBwCKO8MMfYxdtlQ8vYdtRktL4A9ZjVppsEgMQks17+iJ7rrQyG4hbZMV9+poH/hIw0MpLQoF63SuaH+flQwtkR2k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:43:08 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:43:08 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v5.4.y 0/4] sched/deadline: Fix panic due to nested priority inheritance
Date:   Mon, 22 Aug 2022 13:09:38 +0530
Message-Id: <20220822073942.218045-1-ankitja@vmware.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To SA1PR05MB8311.namprd05.prod.outlook.com
 (2603:10b6:806:1e2::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c1ebc11-2a66-471e-5786-08da8411f471
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RHT89EgkHjFuyMq9pZMWb63hp5Ol8wVmQZMk0Vp07uwbniKM9w9XZ24SY0hKk711VSOsFT3iSL0SvWZcyi9ZMAaSg4oarNgeD9UZ7dCLpezFulVEOwmQJk0ylOkJQQjaUFeAaNfBaAc/VBHEd2hC/1fSjxd3l5fPlRVnoZXylDmws8AzauSY88F1alpX6z/Hy9nFmO/2HyyAqSOQjBwyaJrI1CZc42veJvQHRX6+RT9VEOVTTIGmxImREvZBqRY8R901E4rsA2NLoir7GynrZLPRJ0k6yrxbqJNcg/1+ddzNFeprgq0i1fod3jbraSzyMXuRlGg4nwo/ztsMKqtIL/5XDSTHr5M6JmBRzQC2Jv1GOEZHv4fvtMKTKY0nTt0Dqp/OsqfP1N7pePjktquM3KECmlK9HHOIedwiWVw1q2dszu3TwtE5WqsQSSr9EiFgSR60YloBFLzUg4ceuCiyxPIL++PqBd+U8R3RhhRjXLBfIvIOWXINB7i6OrCcdJleXMZX4ldbijuI7M7BBxMSOvT33PhbJUvmemzWtdYXqlK8wfi0dpD9lB1oMMRK+8EC1PnJ1IVBAJunPodSWTmH8ShzXvIlo93/44uk/yjEvnlP0qs08UzsssrCto5rQMGS904isLm7C7hXlIoTUo1HxPICigJiYX4+tzETjQN39UD1RR1D2hn8l4srQ3xuskq9w/Lry+zE1+Ifb6khlEr7shP6nLMNpoKvV2Cguo6XLzRm2G1YObXz17Z8r3Viy1Mrzd03DuGWt7q8Re8CDTDa0kN3lQSxgOWzMPmHG1EwzCbqwdYqix93/Qv4xpCmb8oIWJs1WH7kKfF64mV3aSwBYk+h818nYbp8Bd/bPdmHq40=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(2906002)(4326008)(41300700001)(66946007)(5660300002)(4744005)(7416002)(66556008)(8676002)(8936002)(66476007)(316002)(218113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S21OdExqcDNUaG5CM2pFUEdCQXBlSStlQlovZktWZWRreHhXYWE2eHNRa0xO?=
 =?utf-8?B?VjlWU3IxSnVyVGg2Mm8wc3VVb2FvR08vb0tMa1ZyZ1VsdG9ES2RrOUNMN0Fs?=
 =?utf-8?B?cTRzbWlEazJGTjY2NWNYc0tMZlgrRVFPQ3IxKzFvMTNnMkJEZjJYSEEzcVBL?=
 =?utf-8?B?Zk05dThWN3FBNUFDZzhWWGcxbHBtUm91OTFFcXBiL1JtRnkvaWdpK3hXcFJi?=
 =?utf-8?B?c3hxSDU2NWpqWllBSHBud0xjRDNmVmxscWJNMTRaOTZQazM5STk1RXRvNFl1?=
 =?utf-8?B?RGdhM3RUOGFTaVJWdVNiSDBwcFAwQmxoU2FJNGpwd3Vod2RaNW4vV3BHV3A1?=
 =?utf-8?B?aklFQmNjZDh5cXRVVURpa1pvMFRYRmp2bXpzcWxyYzdKd2c3ZTdtbXRPMWFn?=
 =?utf-8?B?dkZTSWJEa0FMUjNDL3krdEY2d0xOd0dUM0xhK0psdjFNa1lWZ1NqR1pweXpx?=
 =?utf-8?B?VTk4ZS94OHZxS1ZzNzFLNlYxMWZuckt5YjVXSGUzM011emxWTkQyZDljWnhh?=
 =?utf-8?B?bkhhNmV4N2ZocHhvNk5xMW50OExGam1adUZVSTZOczYyQ2tjaVpzUlAxckVE?=
 =?utf-8?B?T05ta1Y5Y1EyNkRoOWRianRkSUhNQVlyWlFPVDhjaTZnUmRhM25KMHQvdElQ?=
 =?utf-8?B?cXZxZGZ3WlkzU3czUDlNTml3ZnZPOGZmaHlvZjRXV29yOWZ4bDhGcTNQbjFu?=
 =?utf-8?B?Z1M5Ymh1Vk1JZ2diZGhxanUvSTVGSFZDUHdzK0p4Y3F2Q2toUGNQUEE1SGRq?=
 =?utf-8?B?SXhZQmJMK0pmaFZSTS9NSlZLSldBdnkrSzhWR0k3L0RSS3lMVlp2YXZhSEN0?=
 =?utf-8?B?dDI0NiszU0wvczRZaEpnNnBWajhqRkJ6NUZORUhOSU9UQkZabitTNVFHQTlN?=
 =?utf-8?B?d3lrK1VESm5uc2dpWWVWUS9xNUFOSTJvQjFVYlNaMUtsTnZDYVdCcGE4anNw?=
 =?utf-8?B?cTJMUjVRQysxVHA3bVJCMWg1bytVQjE1N2w5OFVFNWVJNUNHK1dNNEhzUnlG?=
 =?utf-8?B?Mk1sVWEwSHVHZ0t0Q0hTVFRnbnNlT0FLWi9iTVRETjhNcnZ4UmtDbGVGaldh?=
 =?utf-8?B?cUtXTWdUTndPVlArd3E5N2Q4ai9SVUltYmk5RmFYc3J2cjRKSnErNTBCYzY1?=
 =?utf-8?B?ZDhPUENBcW9GbHpTUDhtNk5vVjJqYUgwdVdKRjJYcTZ1TG52MEVkSFdmS0VG?=
 =?utf-8?B?TUpCanBLTnB1ZWlKTjh4KzY1aldlekhOR2VoVnhpdHpDb3hNTlpPSWFtcmE0?=
 =?utf-8?B?NC91U2c4RTBPTThKaEp0MlVkWHIzQWZFZDJUZHh3YmxJTXZESGoyQS93TG5k?=
 =?utf-8?B?TjZjRjFGQmozd25xaUtlNzNFL1RRVnpjMjFFLzE0SG1MM3ZiamtCNFJ2TGdu?=
 =?utf-8?B?dUFpenAwV0w2bkFMM0ttNE1MYTFOVlpXcG1XUkNGM1dMK2xpSnFqNjZnM24w?=
 =?utf-8?B?bFE1d3VPTkdmekdXV3p0U2oyTWVTWjJOMi9rKzBvQU1tVlFwL0cwd3lmdVdl?=
 =?utf-8?B?dE5jYXVJUHBWNjNmdndGbllrMVFma2o4SzJ2RURRUmwrendtNkxGS21Ed0FF?=
 =?utf-8?B?cUhxajB2NExEbWk5cnFOMmsxRlY3RU5DcXlNN1dySUEySmFtdHNkalpCV1NY?=
 =?utf-8?B?RGJIb2h1MmlJdmR1UUFwd2J3VjlLRmhUOFRkMC9URDhxVmw3S1Y0REpkY3E0?=
 =?utf-8?B?aElOQm82Z1c4MHNTcUs3TjYxendoQW9KVzkxSUgzZnIrd3dKUnlYbUh6eDFm?=
 =?utf-8?B?akhEeXFZNGEvT2VhMzcwRXlCdXBIZVZRRERBR0JGNFdIY0pONTZlVkJIRkFz?=
 =?utf-8?B?RTQ1ZEVVcUtWTXVMTHJCbmk1OGNuRHV3cWhOTFhEZ0tTeVJxVGo4dmJvK05Y?=
 =?utf-8?B?cDBlK3ozd3J1b3lKMG0zM2U2QmYvVGpZd29vcmpoa3hkQTJzMGdvS2NXODJQ?=
 =?utf-8?B?amNmSkp6TWhxQnVXdzA3ZnFxVW9hOEV2ejNwRGtmU1dTc1A3bUZDWUZORGZt?=
 =?utf-8?B?Qlp0TGpEWlJOL25pYzdzNHRQVG1NMkFjdTlNQWJJY0ZUNVllQ1VOcVh0Mkdx?=
 =?utf-8?B?aXNYbHVCeXZlZTJPUEpHdWFGWmdZdXhteVdUWnE3OEZYZjBaMEZNSVMyT211?=
 =?utf-8?Q?XhpxOURLL5viCYC75SGP7K1+u?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1ebc11-2a66-471e-5786-08da8411f471
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:43:07.9381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sz5qPRMhfFCDy19MVqg7Be6a1X3AaLYHTLRiWHLjIil1afgZs5xJF3vEWjsCj5bejIiP1D2YXQdghjyj5MZguw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR05MB9253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a CFS task that was boosted by a SCHED_DEADLINE
task boosts another CFS task (nested priority inheritance),
Kernel panic is observed.
Fixing priority inheritance changes the way how sched_deadline
attributes are being inherited from original donor task.

Additional supporting patches are added to fix throttling of
boosted tasks.

Daniel Bristot de Oliveira (1):
  sched/deadline: Unthrottle PI boosted threads while enqueuing

Lucas Stach (1):
  sched/deadline: Fix stale throttling on de-/boosted tasks

Juri Lelli (1):
  sched/deadline: Fix priority inheritance with multiple scheduling
    classes

Hui Su (1):
  kernel/sched: Remove dl_boosted flag comment

 include/linux/sched.h   |  14 +++--
 kernel/sched/core.c     |  11 ++--
 kernel/sched/deadline.c | 131 +++++++++++++++++++++++++---------------
 3 files changed, 97 insertions(+), 59 deletions(-)

-- 
2.34.1

