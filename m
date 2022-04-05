Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AE34F47F0
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348067AbiDEVXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452402AbiDEPyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:54:52 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2094.outbound.protection.outlook.com [40.107.244.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB6E4D255;
        Tue,  5 Apr 2022 07:54:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqDXUl2OI6eqSnL0Rsp3JfUnzpwgMkC/tU51c4If/Icflf3QxcG8+ctSNNoRYLLmQWX9niW+HEIPh7UyE9o4pIh5ZG7i/UFr141Q1mrrjYHwWDXqo9X/vPaHOoA5Ml7g9tq6jzSFBFs3Bcf9BqXuGdbDXg+MIJZf3GU+rC7E16iAORVjBdWJgF/r4usiCeIZ3EH68tnFSsP8O1j6fycLSotC3VRaMDAF52dzCECB5vZMjO0+55mUg7FPPkEUU7v6MPEk6vZYb0e36QvD9nVLILCZHHE+k5YSPw5uEKk9b8+EUUX9qlmImj5rwkqdBzy9oGZ2PUaVTG+etHfq+nfJUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OoiFZY6BL2Z71vAlxyTUjS95by3FXwoCcwLwi4k2+Hw=;
 b=Ck91TRmu/qUNM6VXCUJ23lN/CG6yd/GGUERWouxCPto7BcJE2DGU8dIjP5NHYnPxml6fwydxX0xfYU2cSQVRPRJ57IEiF9PEbVxO8QLOcTbLu1275+bZ/tTfoOI1ctG4d4UqCyTBl4BUOXc0BIAFxuXyVdtheCkOozxlps/jg/kptgGXiF1PgcGDN04cHC66WcB4yy66x0XRnX97ug1gL3s+aJ6QrrM+tyrJBUZzgP8pQ97ItLMIauMRoqyz/K70fZJCe6W5tWxBa+aoeEu7Bk7I31vnZdFxtIxH5ZYnp8MwC3eyjeK/uxqhNXUoOy41UXtJxoabOQrf8Herpe1MUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoiFZY6BL2Z71vAlxyTUjS95by3FXwoCcwLwi4k2+Hw=;
 b=eMbGDgskuUH9PCPDBi9+O9KJfdH2qOQ3f5PN6rt49BPwp8sechB34a8axC2F09ZZG8UeMaMEzLIkN3ZEFAkyB1S2+9npwcIUXPo5KWgWfxdXkRLgaa6JncN2eVhk0CbhI3VupFhRKYe+/47bEccNvunMmsflfuyo7dsMO4CiJFs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 SJ0PR01MB6512.prod.exchangelabs.com (2603:10b6:a03:299::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.21; Tue, 5 Apr 2022 14:54:53 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 14:54:53 +0000
Date:   Tue, 5 Apr 2022 07:54:51 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Barry Song <21cnbao@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Carl Worth <carl@os.amperecomputing.com>,
        stable@vger.kernel.org, Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v4] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YkxYOxXDfJIDtcte@fedora>
References: <3d58dc946a4fa1cc696d05baad1cf05ae686a86d.1649115057.git.darren@os.amperecomputing.com>
 <YkupgBs1ybDmofrY@fedora>
 <CAGsJ_4yUJXvLsGAmZ6fpHmccMLanFVVSiod_Agr+Uqzcu83h1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yUJXvLsGAmZ6fpHmccMLanFVVSiod_Agr+Uqzcu83h1g@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:303:8e::33) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f06102d8-2ac6-4eef-71c5-08da17143da0
X-MS-TrafficTypeDiagnostic: SJ0PR01MB6512:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR01MB6512EB2D0EF3D4996C4EDC72F7E49@SJ0PR01MB6512.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFwVIy/aiL1CXy8TpKW/9bAnpUP8IHPnmHcIw0jquapcOIE7+T2EGLJCBUUSi+F7umGpD70LLgELiD5F+4qWTPFs6i7LZRwAG/rQbfVcpVb+Ex6vtHnxZjJP6+4SzIzh4DHoEq4eBZOPviZyA9hCs1JVithIumVlnSfJjOdSOI7A+JEJhIsrEUZdNKjbypAVhKxdlV5O/Dk3SUhlsSx50V06JS1i0JAymo+GifK8Tom3PAsG4FThJ8V1eNIxlSZnjeYJjvOIXGBc3+vpzdYCV0pkYRNnAgCp2uUye0Jupg5An6HgNeLe5XDAJIOZQomug0sapJxLlbhEdxkAaofkRY2J32MLQJQc9wK271/oY/pL6t7bAP7joXKSFUSCmRKIEyugZlywA8dAu1aQhJP07y9BtRoDjcZ2UV4PLrsLDlxfR/TrXf4u8bB66tVMP23hSpIZNxwV4/m3T+gFf8cYsCOsigHh/b8GpTa2Bm4VjlqU8sPn85hATtiKt/UrK3d4v69jqKXWrau4aKHlZs8mCS0XjeHnOVROQVeBrMfYy+A6HpG9DCPiB2Ky1cQIK9vtJLoU/VrmuIrhSeB9gY5kgME6KRMuoROhqY2wk2tDSS2DGpJ44K7KW72hiG8QJtzu3IQ0Mvq9F/19X4ST7ba41mnIOEDeLhnGYjUBIuwZ68AQERIeaY1iSb5zf3pOYY8efglj5Q5KRFYoKyTxvwom7BWpgfai/v9zBAWDdXZQudrfbImse9FuzRwTbSH6SBrdNoyrEW30EDulM81GslbeXQwi+DWs7JeDacT624W5bfM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(4326008)(66556008)(5660300002)(66476007)(2906002)(8676002)(66946007)(52116002)(9686003)(6506007)(38350700002)(6512007)(53546011)(38100700002)(8936002)(7416002)(186003)(83380400001)(54906003)(316002)(6916009)(26005)(33716001)(86362001)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3hIeFZ2K3BDQTFTM3FjWXphYTkzZ1lpdWFTUmtqbWlldWlOeUVndkpCVUNa?=
 =?utf-8?B?S0VodkFsVFprVzJ2L3A0N0RPRHEva3lNNjgxY2ovaXBvTWZDVjRJU2t1dm5m?=
 =?utf-8?B?alJ0R1AyVFJPSEd6WUlJZUpRVENXVUtmUGIvbkhYVDBMZU5FTmMrcUdyT2Ji?=
 =?utf-8?B?NmVVUWhObkx2NExtOXhLVXl6eHVkODRQT0F4VkZTdmxDdXRpYVFjcXRNLzJB?=
 =?utf-8?B?dkR1TkJYd3U5Q1RUUGMvck5tdjl2bU02VGtMbXhLRDM4dkk4QS9EbkFLLzZG?=
 =?utf-8?B?V1BYOFozZXd2eVB1RDY5UHUyMzZvenRSTGpxeGcxMGlkbzE0YlNVZXAyK2d6?=
 =?utf-8?B?NWk5YTU2a09HN1RTYWQrbjhNMXE1Z1ZOTGRUZnArNW80WnZGa0FqTmRDSThR?=
 =?utf-8?B?TGZ1L056eHZheUFlZnV2RFFrVjJSUjNrMjZ1TmtsTFFNaFFDZ0hkc2pGdkxP?=
 =?utf-8?B?U1FUbEovNkN5SEg4ZElXWWJlT0Q0eGU1MlkyVUFjZVZNS2JFNWpaaUNEUndW?=
 =?utf-8?B?VllkMGhvMnBXVmZmaGgrRjZjd05LUTRTaURxVCtGK2IvS3VTek5mdlJRbFR2?=
 =?utf-8?B?OTQyeXlEQVp1K3BGRkNqVG14MkdWUFgzcmtXYytadEE1U0lOS2ZWaGFwclFi?=
 =?utf-8?B?eFhnR3ROS05uNGNTTDJPZXkvd01KZ3FqQ1RqK2IvYXhIUEh1Znl6Ny9wQUNh?=
 =?utf-8?B?RWE1eHVVMjMyVnZQb0pscXBDRmJ6dXlBMmZYbmRwZ1pGYUJHZUFXcXVsT1N0?=
 =?utf-8?B?bE05aVJKSldXUTFaYlBHTFJNbDhTWjVJTDJYblkvTzFjT0F5RC9WMHBYdXZH?=
 =?utf-8?B?dHBxKzVwcGNONFJ0YjEvYlBnZHJvRVdpbHJNUFM5ZUtGZlhtclc0Z1dyTWta?=
 =?utf-8?B?OTlQRU9MeHkwZVZGQTVmNjBWWFd5dUM5NXpXa2ZCaDBDYzZObDN5aTdnNzNT?=
 =?utf-8?B?ZHQvMm9IZ3Fzbk5WZVZNMS9jWkJ0L2xaVUtiMDA0VWdWenhSME9wUytPUlpw?=
 =?utf-8?B?VDgxUWdQZWI3djVHSG5jalREc202OUhFTlRmNHozRS8xRFhMczdoMmpXZ3Fa?=
 =?utf-8?B?WDMwTyt1MVh4NHlwOVg4U2NDUDE1M1RrcHJkODhIaWt0clVxcFBZUkhpMjhy?=
 =?utf-8?B?OXFhV01wdm1OaFpYOG81am0wc3NxSGFpR3NZeTVNeHhyUUFvS1JQTEZXNWU0?=
 =?utf-8?B?RkY5cVpndFE5TnVyUmttSDBuZlc4em9qZ1hraWNWV21HcWl6SEU4VzNBcEZp?=
 =?utf-8?B?MHUvbS9EaVA5Wk55Um1tOGc2b3V5czk5N2JHVjh6ZnZqNnNjUmZaeE91OTg0?=
 =?utf-8?B?ZGFEME90cjA0QWF3R3JWWGErRUxWdDdseDVIdzBzclBnaXRCNSszM0ZXc0s3?=
 =?utf-8?B?TXBlSWhLQk1vdXhkS1VFTUtXVUZuVEpMN2NRdlNyZlRYTHVEeTllL2JGM09S?=
 =?utf-8?B?bWMrWkZ5NE8rdTFwbXZBMlY4bXFPUlNROGVVRFk0VnBQQmkwRmpIWWNoYXZx?=
 =?utf-8?B?d3RvNzIraHNpVkd6aXF4bjBBU3FGZ2ZTQ0tabHgrNXdoRmdtY2I4c1d4R3lh?=
 =?utf-8?B?eHg0emkrU0thR0lWTHg2WlhTVE1XcFVTZWFBWndyU2UzWlV2QjJOTk95M2ox?=
 =?utf-8?B?Ny9iTEZYWDJSdEh1Z2FrbFBCbG02NmNmZmtCeCtzTnpHQ0ZSRERzeTBKVnVU?=
 =?utf-8?B?eWxKOE1GWmlWTmgwckR3Nzc5WUp1T2k3ZXNnbWRIcUw5T0dicmhWSUtUbENF?=
 =?utf-8?B?dGRqTUZndi9nQ3NET2kvb0tTVXFYU1d2NEdzNUgrRFJyVk1xMStBZThUSmFY?=
 =?utf-8?B?Z3IyV1pwT3RIeVBJMzdGSkNFaTNxVEFKWW51VGl4SVhDeVhXVHczTjgrWi9R?=
 =?utf-8?B?VHJUUmpFQTFkMVkzUlRUWFF6MzBOdmRRcEZkakczUlg1RGNWbUxYNXg2cTFk?=
 =?utf-8?B?Qnk0ZGUwZGQwT1hTcW8ydXJrMDlpWldXUC9KSUViRk42Zk1oZUJPQjdaTm1F?=
 =?utf-8?B?alB1STVWRFFiTmJuek5FZFM1d2pRTWtJVVJ4MldRcjlRRXlhK3ZYNWMvWlFK?=
 =?utf-8?B?TWVodVAzang3VkJpc0F4U0RsbXhHeVNjOTFSWTBISnlEQUJzSDBwVEZwMHhl?=
 =?utf-8?B?NWVzeXYwM2x2NWFmTE52eHB2THVuMlRNaVBkQTFmTWR0bGJDbkF5QTdqek52?=
 =?utf-8?B?cEJsYnh1cmtiNmgxTzZYNFJDazg2cnNjazF4UktGeEF2VzVaLzMvZjh1NXZJ?=
 =?utf-8?B?MFZheXFtNW1ZMHNleE9NRzd6dUtlZ0ZjMVpJWEYwVmJTSGZweEhlSllFRlV1?=
 =?utf-8?B?aEljaTFWOWRrZVZrdmN0UXZPYzQ4STkxQ1U3ZVdkZEhhUFBJU1FUci80VnJQ?=
 =?utf-8?Q?KghTSTZcitbWvg8t3/qCx6hYAm4bDQf6vnLh4?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06102d8-2ac6-4eef-71c5-08da17143da0
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 14:54:53.2692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtnQPrbve7BGutSCIi7jtc9htQxlEE+VXcULf4vx7NrZ7nc/bmqDsEGdWfz1PCrspCNinuIsXsxYhR8LmGYCb7YMtqvXd8JfB0Eph/Hl9UkDxNJ5+T1kq+QQWkU0wt04
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6512
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 06:38:01PM +1200, Barry Song wrote:
> On Tue, Apr 5, 2022 at 3:46 PM Darren Hart
> <darren@os.amperecomputing.com> wrote:
> >
> > On Mon, Apr 04, 2022 at 04:40:37PM -0700, Darren Hart wrote:
> > > Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
> > > Control Unit, but have no shared CPU-side last level cache.
> > >
> > > cpu_coregroup_mask() will return a cpumask with weight 1, while
> > > cpu_clustergroup_mask() will return a cpumask with weight 2.
> > >
> > > As a result, build_sched_domain() will BUG() once per CPU with:
> > >
> > > BUG: arch topology borken
> > > the CLS domain not a subset of the MC domain
> > >
> > > The MC level cpumask is then extended to that of the CLS child, and is
> > > later removed entirely as redundant. This sched domain topology is an
> > > improvement over previous topologies, or those built without
> > > SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> > > With the current scheduler model and heuristics, this is a desirable
> > > default topology for Ampere Altra and Altra Max system.
> > >
> > > Rather than create a custom sched domains topology structure and
> > > introduce new logic in arch/arm64 to detect these systems, update the
> > > core_mask so coregroup is never a subset of clustergroup, extending it
> > > to cluster_siblings if necessary. Only do this if CONFIG_SCHED_CLUSTER
> > > is enabled to avoid also changing the topology (MC) when
> > > CONFIG_SCHED_CLUSTER is disabled.
> > >
> > > This has the added benefit over a custom topology of working for both
> > > symmetric and asymmetric topologies. It does not address systems where
> > > the CLUSTER topology is above a populated MC topology, but these are not
> > > considered today and can be addressed separately if and when they
> > > appear.
> > >
> > > The final sched domain topology for a 2 socket Ampere Altra system is
> > > unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > >
> > > For CPU0:
> > >
> > > CONFIG_SCHED_CLUSTER=y
> > > CLS  [0-1]
> > > DIE  [0-79]
> > > NUMA [0-159]
> > >
> > > CONFIG_SCHED_CLUSTER is not set
> > > DIE  [0-79]
> > > NUMA [0-159]
> > >
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > Cc: Carl Worth <carl@os.amperecomputing.com>
> > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
> > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > ---
> > > v1: Drop MC level if coregroup weight == 1
> > > v2: New sd topo in arch/arm64/kernel/smp.c
> > > v3: No new topo, extend core_mask to cluster_siblings
> > > v4: Rebase on 5.18-rc1 for GregKH to pull. Add IS_ENABLED(CONFIG_SCHED_CLUSTER).
> >
> > A bit more context on the state of review:
> >
> > Several folks reviewed, but I didn't add their Reviewed-by since I added the
> > IS_ENABLED(CONFIG_SCHED_CLUSTER) test since they reviewed it last. This change
> > preserves the stated intent of the change when CONFIG_SCHED_CLUSTER is disabled.
> 
> Everything still works even without IS_ENABLED(CONFIG_SCHED_CLUSTER), right?
> Anyway, putting IS_ENABLED(CONFIG_SCHED_CLUSTER) seems to be right as
> well.

Hi Barry,

Without the additional IS_ENABLED check, if CONFIG_SCHED_CLUSTER is disabled
then rather than a topology of:

DIE  [0-79]
NUMA [0-159]

We end up expanding the MC span and get:

MC   [0-1]
DIE  [0-79]
NUMA [0-159]

This isn't "bad", but it wasn't the stated intent, and I prefer users can choose
between the two by using the CONFIG_SCHED_CLUSTER option.

> But it seems it is still a good choice to put all these reviewed-by
> and acked-by you got in
> v3? I don't  think the added IS_ENABLED will change their decisions.

I think Sudeep is the only one that wrote the actual tag, and in my experience
those tags should be explicitly volunteered rather than assumed, especially if a
change is made, especially for Reviewed-by. [1] reinforces this with "Hence
patch mergers will sometimes manually convert an acker’s “yep, looks good to me”
into an Acked-by: (but note that it is usually better to ask for an explicit
ack)."

Greg, since I'm asking you to pull this - please let me know if I'm being overly
cautious with tags here.

> 
> >
> > Barry Song - Suggested this approach

Can we add your Reviewed-by here Barry?

Thanks,

Darren

1. https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

> > Vincent Guittot - informal review with reservations
> > Sudeep Holla - Acked-by
> > Dietmar Eggemann - informal review (added to Cc, apologies for the omission Dietmar)
> >
> > All but Barry's recommendation captured in the v3 thread:
> > https://lore.kernel.org/linux-arm-kernel/f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com/
> >
> > Thanks,
> >
> > >
> > >  drivers/base/arch_topology.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> > > index 1d6636ebaac5..5497c5ab7318 100644
> > > --- a/drivers/base/arch_topology.c
> > > +++ b/drivers/base/arch_topology.c
> > > @@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
> > >                       core_mask = &cpu_topology[cpu].llc_sibling;
> > >       }
> > >
> > > +     /*
> > > +      * For systems with no shared cpu-side LLC but with clusters defined,
> > > +      * extend core_mask to cluster_siblings. The sched domain builder will
> > > +      * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> > > +      */
> > > +     if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
> > > +         cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> > > +             core_mask = &cpu_topology[cpu].cluster_sibling;
> > > +
> > >       return core_mask;
> > >  }
> > >
> > --
> > Darren Hart
> > Ampere Computing / OS and Kernel
> 
> Thanks
> Barry

-- 
Darren Hart
Ampere Computing / OS and Kernel
