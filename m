Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD6E59BA8E
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiHVHre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiHVHr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:47:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B342A732;
        Mon, 22 Aug 2022 00:47:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvx4JZ/KUuI1XVNeie69qx5F8bdZ+Oq0rymVhkLs9RTkvNKL2bPuyvwjAKRu608BSsbYRT5HefwAXQwH8KYElGXA291gAHbTFmfw8ui/tIbLGrGqrqUhfHpry5P3KjhtqWI+aCzX/csTULbKz8exO2gBg3umhxWy48Q32aJfMEs30rhEiAEEb9+UX/sg0elIQwohy769rMJHuV4IuaVzGVf7fU7lDdF0uBeOV9KjtqaARoluLGeG0NSDrL4p0ZjX9RF91GiWBhVbiYAqQpsA3VGaDouixtFSyfNCPkUxV8ifou7HzDEk2KxFACeOhVamyB9sve7nInwpwRp03TiFgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mQhs2Z6QUSdCTwG/TB/0DHDCP0hRR6F5I9+elfp2Q4=;
 b=Us2EP34HTKslfYoLEN3bMa8CzNCp6L6LQQFZQRoJinjoxzfH6OgiOxx32ckewZbTjNrBdibqI9koAD4WaKp8Jk097O0uFXlf1sZbmdmmvTyJp/GpNv3rvFRag43YNo/1pyE8I1kzumWRVqhM1EDXW3Qj+k2vV9khkEDJWJgvmIRN4ZVpMcPUuql7ro2hoaVe5DweZMAEGWNsKHNBj5axYnSzD9Uzd1XKE7aXGOnlhPfHs1s7qJ/PkeffhRABCgNsx2gjQW0FU3IbTBk5YsEpZPBFxrf3kjFKKv8GaPQ7I0VWi+YrGu9z81k667XWDKaQLJppPQycITe99AInVE1HvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mQhs2Z6QUSdCTwG/TB/0DHDCP0hRR6F5I9+elfp2Q4=;
 b=aXiz2WIVcbEvaJfvq7TcZM1FpzEwzDE+42k802mx070AkaOxBtDGWqNg7qZ6JX1HbYkXegdXmj6PzPQqptcEb8ZWSNI1bnMy5dBRQsA2MpE0FcYH0rhy82PTCZ4KWQtJtIyi5BqWZjGd3GPc3PdNDmm1QpCL1P2nD5QQ/2EYjNQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:47:24 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:47:24 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v4.19.y 3/4] sched/deadline: Fix priority inheritance with multiple scheduling classes
Date:   Mon, 22 Aug 2022 13:13:47 +0530
Message-Id: <20220822074348.218135-4-ankitja@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220822074348.218135-1-ankitja@vmware.com>
References: <20220822074348.218135-1-ankitja@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To SA1PR05MB8311.namprd05.prod.outlook.com
 (2603:10b6:806:1e2::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b80c5164-3be6-4302-92ee-08da84128d30
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IfQ1QuQ4b4miXVlXfDjozqSqXQFRSusProMAwmcOxMXf1tgItCiAJ3NCkJFFDV0XeFug9vfLz0DumJ7z986aBYD42wlzZHcs6jZIhuXIreM2KkvPfy8dMaGY6gyTHwGHxPd2rETPqxQ4TPhFKb09817EGSAcdK3TS0Iqt+sPlbeqWOhCGXSEr8XhF+qDhyrQyeklQW4ZMMaWgBCoDdHfsDGw2RQFVwjxNe+jtcUGImUKGoZnI26YPM+COv18gpmFcnWTU2EGBIo1+xLqCg6y1wpo7/ykhGUUXLiKSTMUIbi1J/Ffa3xwRY1ufUowsRiY2z1hqz+QgyhXm5ZDtWsGkLnoVA4Ph83+8HqiEQgszyv5xp9IxaiuDT1RVv5SCiyqtIE7B5aIRKNp/4MH8j39nt+tXvtqWljE9mkarYqY8jPcdbBGV1Vur0lDlfdZWWCmQN9B6l5Clwa0xrA3lhe579jyrg9b1MJ56ZWrEintrslOqAMUPU3P3dbvIy6TdvqkKGGd1XCLzWFO2PpYHCLiV3xrzdylw6wxTC7xmESGDsmATZQOQV9DzisjzHaqA1GlSzwKzlaMFIaBEuVlE1laWU6pZAVqZHb8UMYCkO2YIGheTGg+oXgLnDeQPatRtt+mFcT7qCaT6aqxuxhzb1me2Pi3xfZmsPytaH82URMzIHKbpVb7BcqVAdMcTxMcivxC6ixwdp6uhxeaDrgFEvc7s2GoynpgWJXzcwCI4ELjOReazxm+ldbuJgROAitJZO2ydd9S9sI1ivv9TIzl+siEUCW2h58mHdjTn2rhmyRL4IJwXUEhlu6jVKVbn+yYv2VGHRnwFNUn+cqqzaKox1BSTU6Y4NQgi6F/kEypIJzijOGrXt0E5LCrfSble8TZhNxg+pfu+aUFMN+D2++rh1oa8YKF2iSUY0xAmEHiJXQ2nBAl/JmMgTTGTYDUfmNIbmwN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(966005)(2906002)(4326008)(41300700001)(66946007)(5660300002)(30864003)(7416002)(66556008)(8676002)(8936002)(66476007)(316002)(218113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aStDakhKZWsrVklQVzVlZ0ZkY3dhSFBrTnUxUGVhUE44ZW9rdzYyVzFwQW8v?=
 =?utf-8?B?cGI2WjAydnBnUytuYTVsZjMvUEFTTlp5RnNEZ3FINVU1cHd4aHRSTDZXVDZ0?=
 =?utf-8?B?eFhTb2RUL0NwNGJtU1ByV0FSd3J1dzJWaHlQenowbE0zS2VpWXJFVGRWOUNX?=
 =?utf-8?B?dmRtdEJEL2hGelU0c01wQTZ6R3AzMS9qSWMrR2NzNWJFaENOT2l0dm95dW1L?=
 =?utf-8?B?WDdQN1dWbktLY3o2UHcrbFcwQnVqbGl3UElJeThQdlVVU0owMExxS2Z3S2pB?=
 =?utf-8?B?NUxsbllIb050MzBkcVFuSU5pQUNSaFgvc2hCNGlyb3RzZHBHZk8vMVU4bDBq?=
 =?utf-8?B?NkpFdDh3MHpxYkIrRHhqN2dHaTkzSFhWVWphdmRvbW5jUTRyMVZ2R28vaVdS?=
 =?utf-8?B?VWJtUlV6N25CcXIwcmNZTjY2Z2dwWTJrc0pGV3hER0Y1Q1htMHNIZXAvSjNP?=
 =?utf-8?B?SXR2NVZOZVRSWG01TjVEbm8yZzE1NHpRYjV3bHA4aGtHVlV5QVlRTmdHbzNQ?=
 =?utf-8?B?WE5oa1p3UjdYUHhoMFdydTl2dnUrRmtWWE1OWERKSitnZ2Q5RFMzTHFiOEtk?=
 =?utf-8?B?ZlVrWHJ3OU5vT25qRCtKWUhmRmpTVlY5Z1M2TU5HZFhjdUFPMkc4a3h5WjNF?=
 =?utf-8?B?TjNTTFE3ajFzSHN4SjhiZ1VtWG1MTndjcjBtTkhDa3N1dnB2QTlGRjZOeC82?=
 =?utf-8?B?alFXS1gvYTBvdGM0V3NGbTVBY1dJSXhVTUdDeGZncjZWV05obVMvcmUwMlZh?=
 =?utf-8?B?WTJlVE5pNk5PTS9xYXZuYmgxWmdCNVJuelM0cTZwME5HblgrSFd0SDB5MVdG?=
 =?utf-8?B?UUNrcmVqenlWQUxGZ0FmOG5hbXBXclpDekI5TGF2a0ZzcVlFN3FyMU1ielBz?=
 =?utf-8?B?bHIzZTZNYkkrSWY2WXFuNmgwUlVEc3BIL3g3cHBKK3R0NHZvNUo4ZlM3NEJV?=
 =?utf-8?B?cWJpcmp1TER3b0Z0eVZLS0w2bmlXa2RKRXB3TmY0TERTdDVEcWkyZSswTmVM?=
 =?utf-8?B?YVZ1QkdVT29VbURqb1IyRnhDNU1ob2kvN3pNTG1oNDBGYVlBRVBRU2VPV3Jm?=
 =?utf-8?B?aUppZ01aOFZwMmtnMUdMZGg0RlFuclR0WkFwbmdwdlN0NVE4N0YrbjBZY3k0?=
 =?utf-8?B?SC96WGlmM3NmcDJPTlNha0xPNDhxbFZZeWlPd2hGNk5OSlJ6OHhQWEY2OVg1?=
 =?utf-8?B?UjlNVTJFM1dIVEw5SEI1QlFEenNRUWtnZVZValhWaWQwSitoVnpTdFFKUXZF?=
 =?utf-8?B?ek03em1HSWZuc1BxbTBuUmpTTkZPYllRRjV4Q01jcjVwQWNDaHYrTTBGY1Zk?=
 =?utf-8?B?ZzFMd0J5cmRZa3JpVURPbGU4US85WEpUTmUySnhQb3pPRnFKTm5qWU1CYk5J?=
 =?utf-8?B?bTRoZm1MM0VYMzRqY1hrajBmZ1loYzA3dlV1RTF2NWFMNHFBYXA2bTV0VzVZ?=
 =?utf-8?B?V0FpaVRTSTkxVCswRkJpeksxZE9WYmVvbnR1T2tBSTduZjNVSlg3clUzUVNQ?=
 =?utf-8?B?d0xoUWZpcHZIK2pNZUlNeVdlckNONnpPRzhkbXBwVFZBR0hQWitkUjhWWlV3?=
 =?utf-8?B?RHg0K0tEV1NGVGNqdFQwVnZkMWlUcEZUQUhBMTdlZVVKT3AvemRGZVd0MWlI?=
 =?utf-8?B?THQ1RkdBOEVyOElqWFNCcW9WdjVwQzZZVXZVQzV5RStzQklTdlNzR3dDN0F4?=
 =?utf-8?B?dlFFYk9CbFhDSDg5RU1yZ2RTUlFCSXFkUE5QRGU4Mnd2aFpIZkRDZjdsTFZV?=
 =?utf-8?B?dmtSRCs2QzNuMmNZU3dLNlNTQWZ3b1FocFo2YlRYM2Y5UUxacFNtN0ovaERY?=
 =?utf-8?B?aTF5V3FpUDU3NzlxVjQ4ZitGRmFieVlFTUJFeE4zYnhrKzcwTHhKeWxwOWJi?=
 =?utf-8?B?c2VLUURhcVlFT2pQTmxlZ1dMTW5mWnQ5bzdRck5NNGlvTlBqNnoyNmRmeEUy?=
 =?utf-8?B?OWxCTlNueG5MNTB0Z2F0K1U4aFVGdDg2SGkvR1hQTzl2dzBRaFNpdjhhcFlu?=
 =?utf-8?B?YWQ4aXVaMGRqZ2t2anhHVnIzUHBOaGtDSm8yUnZiR2xJNWlNcjVmRnJmb2ZW?=
 =?utf-8?B?THlaZ3lROXM2LzFCMUFyTWZDUzJVekdPK01BWm1sdzNKd0x3Q0tzTWZ6QStS?=
 =?utf-8?Q?Lb1GVVUsgzspzLVpmi571rUdX?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80c5164-3be6-4302-92ee-08da84128d30
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:47:24.1114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8k/zeHCuif1E3xG41bd9ToplBc4I9m3z/XpmTp9OwsYppJBCFjJk8jUSdBNsACJC9xHFClQp/WhYnjDc1GkXQ==
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

From: Juri Lelli <juri.lelli@redhat.com>

commit 2279f540ea7d05f22d2f0c4224319330228586bc upstream.

Glenn reported that "an application [he developed produces] a BUG in
deadline.c when a SCHED_DEADLINE task contends with CFS tasks on nested
PTHREAD_PRIO_INHERIT mutexes.  I believe the bug is triggered when a CFS
task that was boosted by a SCHED_DEADLINE task boosts another CFS task
(nested priority inheritance).

 ------------[ cut here ]------------
 kernel BUG at kernel/sched/deadline.c:1462!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 12 PID: 19171 Comm: dl_boost_bug Tainted: ...
 Hardware name: ...
 RIP: 0010:enqueue_task_dl+0x335/0x910
 Code: ...
 RSP: 0018:ffffc9000c2bbc68 EFLAGS: 00010002
 RAX: 0000000000000009 RBX: ffff888c0af94c00 RCX: ffffffff81e12500
 RDX: 000000000000002e RSI: ffff888c0af94c00 RDI: ffff888c10b22600
 RBP: ffffc9000c2bbd08 R08: 0000000000000009 R09: 0000000000000078
 R10: ffffffff81e12440 R11: ffffffff81e1236c R12: ffff888bc8932600
 R13: ffff888c0af94eb8 R14: ffff888c10b22600 R15: ffff888bc8932600
 FS:  00007fa58ac55700(0000) GS:ffff888c10b00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fa58b523230 CR3: 0000000bf44ab003 CR4: 00000000007606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  ? intel_pstate_update_util_hwp+0x13/0x170
  rt_mutex_setprio+0x1cc/0x4b0
  task_blocks_on_rt_mutex+0x225/0x260
  rt_spin_lock_slowlock_locked+0xab/0x2d0
  rt_spin_lock_slowlock+0x50/0x80
  hrtimer_grab_expiry_lock+0x20/0x30
  hrtimer_cancel+0x13/0x30
  do_nanosleep+0xa0/0x150
  hrtimer_nanosleep+0xe1/0x230
  ? __hrtimer_init_sleeper+0x60/0x60
  __x64_sys_nanosleep+0x8d/0xa0
  do_syscall_64+0x4a/0x100
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fa58b52330d
 ...
 ---[ end trace 0000000000000002 ]—

He also provided a simple reproducer creating the situation below:

 So the execution order of locking steps are the following
 (N1 and N2 are non-deadline tasks. D1 is a deadline task. M1 and M2
 are mutexes that are enabled * with priority inheritance.)

 Time moves forward as this timeline goes down:

 N1              N2               D1
 |               |                |
 |               |                |
 Lock(M1)        |                |
 |               |                |
 |             Lock(M2)           |
 |               |                |
 |               |              Lock(M2)
 |               |                |
 |             Lock(M1)           |
 |             (!!bug triggered!) |

Daniel reported a similar situation as well, by just letting ksoftirqd
run with DEADLINE (and eventually block on a mutex).

Problem is that boosted entities (Priority Inheritance) use static
DEADLINE parameters of the top priority waiter. However, there might be
cases where top waiter could be a non-DEADLINE entity that is currently
boosted by a DEADLINE entity from a different lock chain (i.e., nested
priority chains involving entities of non-DEADLINE classes). In this
case, top waiter static DEADLINE parameters could be null (initialized
to 0 at fork()) and replenish_dl_entity() would hit a BUG().

Fix this by keeping track of the original donor and using its parameters
when a task is boosted.

Reported-by: Glenn Elliott <glenn@aurora.tech>
Reported-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Link: https://lkml.kernel.org/r/20201117061432.517340-1-juri.lelli@redhat.com
[Ankit: Regenerated the patch for v4.19.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
---
 include/linux/sched.h   | 10 ++++-
 kernel/sched/core.c     | 11 ++---
 kernel/sched/deadline.c | 97 ++++++++++++++++++++++-------------------
 3 files changed, 68 insertions(+), 50 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f92d5ae6d04e..2d77bfbac595 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -546,7 +546,6 @@ struct sched_dl_entity {
 	 * overruns.
 	 */
 	unsigned int			dl_throttled      : 1;
-	unsigned int			dl_boosted        : 1;
 	unsigned int			dl_yielded        : 1;
 	unsigned int			dl_non_contending : 1;
 	unsigned int			dl_overrun	  : 1;
@@ -565,6 +564,15 @@ struct sched_dl_entity {
 	 * time.
 	 */
 	struct hrtimer inactive_timer;
+
+#ifdef CONFIG_RT_MUTEXES
+	/*
+	 * Priority Inheritance. When a DEADLINE scheduling entity is boosted
+	 * pi_se points to the donor, otherwise points to the dl_se it belongs
+	 * to (the original one/itself).
+	 */
+	struct sched_dl_entity *pi_se;
+#endif
 };
 
 union rcu_special {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 32af895bd86b..a03464249771 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3869,20 +3869,21 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 		if (!dl_prio(p->normal_prio) ||
 		    (pi_task && dl_prio(pi_task->prio) &&
 		     dl_entity_preempt(&pi_task->dl, &p->dl))) {
-			p->dl.dl_boosted = 1;
+			p->dl.pi_se = pi_task->dl.pi_se;
 			queue_flag |= ENQUEUE_REPLENISH;
-		} else
-			p->dl.dl_boosted = 0;
+		} else {
+			p->dl.pi_se = &p->dl;
+		}
 		p->sched_class = &dl_sched_class;
 	} else if (rt_prio(prio)) {
 		if (dl_prio(oldprio))
-			p->dl.dl_boosted = 0;
+			p->dl.pi_se = &p->dl;
 		if (oldprio < prio)
 			queue_flag |= ENQUEUE_HEAD;
 		p->sched_class = &rt_sched_class;
 	} else {
 		if (dl_prio(oldprio))
-			p->dl.dl_boosted = 0;
+			p->dl.pi_se = &p->dl;
 		if (rt_prio(oldprio))
 			p->rt.timeout = 0;
 		p->sched_class = &fair_sched_class;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 29cd4c0a92c0..29ed5d8d30d6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -43,6 +43,28 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
 	return !RB_EMPTY_NODE(&dl_se->rb_node);
 }
 
+#ifdef CONFIG_RT_MUTEXES
+static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se->pi_se;
+}
+
+static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
+{
+	return pi_of(dl_se) != dl_se;
+}
+#else
+static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se;
+}
+
+static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_SMP
 static inline struct dl_bw *dl_bw_of(int i)
 {
@@ -657,7 +679,7 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	WARN_ON(dl_se->dl_boosted);
+	WARN_ON(is_dl_boosted(dl_se));
 	WARN_ON(dl_time_before(rq_clock(rq), dl_se->deadline));
 
 	/*
@@ -695,21 +717,20 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
  * could happen are, typically, a entity voluntarily trying to overcome its
  * runtime, or it just underestimated it during sched_setattr().
  */
-static void replenish_dl_entity(struct sched_dl_entity *dl_se,
-				struct sched_dl_entity *pi_se)
+static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	BUG_ON(pi_se->dl_runtime <= 0);
+	BUG_ON(pi_of(dl_se)->dl_runtime <= 0);
 
 	/*
 	 * This could be the case for a !-dl task that is boosted.
 	 * Just go with full inherited parameters.
 	 */
 	if (dl_se->dl_deadline == 0) {
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 
 	if (dl_se->dl_yielded && dl_se->runtime > 0)
@@ -722,8 +743,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += pi_se->dl_period;
-		dl_se->runtime += pi_se->dl_runtime;
+		dl_se->deadline += pi_of(dl_se)->dl_period;
+		dl_se->runtime += pi_of(dl_se)->dl_runtime;
 	}
 
 	/*
@@ -737,8 +758,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 	 */
 	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
 		printk_deferred_once("sched: DL replenish lagged too much\n");
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 
 	if (dl_se->dl_yielded)
@@ -771,8 +792,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
  * task with deadline equal to period this is the same of using
  * dl_period instead of dl_deadline in the equation above.
  */
-static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
-			       struct sched_dl_entity *pi_se, u64 t)
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 {
 	u64 left, right;
 
@@ -794,9 +814,9 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
 	 * of anything below microseconds resolution is actually fiction
 	 * (but still we want to give the user that illusion >;).
 	 */
-	left = (pi_se->dl_deadline >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
+	left = (pi_of(dl_se)->dl_deadline >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
 	right = ((dl_se->deadline - t) >> DL_SCALE) *
-		(pi_se->dl_runtime >> DL_SCALE);
+		(pi_of(dl_se)->dl_runtime >> DL_SCALE);
 
 	return dl_time_before(right, left);
 }
@@ -881,24 +901,23 @@ static inline bool dl_is_implicit(struct sched_dl_entity *dl_se)
  * Please refer to the comments update_dl_revised_wakeup() function to find
  * more about the Revised CBS rule.
  */
-static void update_dl_entity(struct sched_dl_entity *dl_se,
-			     struct sched_dl_entity *pi_se)
+static void update_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
-	    dl_entity_overflow(dl_se, pi_se, rq_clock(rq))) {
+	    dl_entity_overflow(dl_se, rq_clock(rq))) {
 
 		if (unlikely(!dl_is_implicit(dl_se) &&
 			     !dl_time_before(dl_se->deadline, rq_clock(rq)) &&
-			     !dl_se->dl_boosted)){
+			     !is_dl_boosted(dl_se))) {
 			update_dl_revised_wakeup(dl_se, rq);
 			return;
 		}
 
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 }
 
@@ -997,7 +1016,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	 * The task might have been boosted by someone else and might be in the
 	 * boosting/deboosting path, its not throttled.
 	 */
-	if (dl_se->dl_boosted)
+	if (is_dl_boosted(dl_se))
 		goto unlock;
 
 	/*
@@ -1025,7 +1044,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	 * but do not enqueue -- wait for our wakeup to do that.
 	 */
 	if (!task_on_rq_queued(p)) {
-		replenish_dl_entity(dl_se, dl_se);
+		replenish_dl_entity(dl_se);
 		goto unlock;
 	}
 
@@ -1115,7 +1134,7 @@ static inline void dl_check_constrained_dl(struct sched_dl_entity *dl_se)
 
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) &&
 	    dl_time_before(rq_clock(rq), dl_next_period(dl_se))) {
-		if (unlikely(dl_se->dl_boosted || !start_dl_timer(p)))
+		if (unlikely(is_dl_boosted(dl_se) || !start_dl_timer(p)))
 			return;
 		dl_se->dl_throttled = 1;
 		if (dl_se->runtime > 0)
@@ -1246,7 +1265,7 @@ static void update_curr_dl(struct rq *rq)
 			dl_se->dl_overrun = 1;
 
 		__dequeue_task_dl(rq, curr, 0);
-		if (unlikely(dl_se->dl_boosted || !start_dl_timer(curr)))
+		if (unlikely(is_dl_boosted(dl_se) || !start_dl_timer(curr)))
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
 
 		if (!is_leftmost(curr, &rq->dl))
@@ -1440,8 +1459,7 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 }
 
 static void
-enqueue_dl_entity(struct sched_dl_entity *dl_se,
-		  struct sched_dl_entity *pi_se, int flags)
+enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
 	BUG_ON(on_dl_rq(dl_se));
 
@@ -1452,9 +1470,9 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se,
 	 */
 	if (flags & ENQUEUE_WAKEUP) {
 		task_contending(dl_se, flags);
-		update_dl_entity(dl_se, pi_se);
+		update_dl_entity(dl_se);
 	} else if (flags & ENQUEUE_REPLENISH) {
-		replenish_dl_entity(dl_se, pi_se);
+		replenish_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_RESTORE) &&
 		  dl_time_before(dl_se->deadline,
 				 rq_clock(rq_of_dl_rq(dl_rq_of_se(dl_se))))) {
@@ -1471,19 +1489,7 @@ static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
 
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
-	struct task_struct *pi_task = rt_mutex_get_top_task(p);
-	struct sched_dl_entity *pi_se = &p->dl;
-
-	/*
-	 * Use the scheduling parameters of the top pi-waiter task if:
-	 * - we have a top pi-waiter which is a SCHED_DEADLINE task AND
-	 * - our dl_boosted is set (i.e. the pi-waiter's (absolute) deadline is
-	 *   smaller than our deadline OR we are a !SCHED_DEADLINE task getting
-	 *   boosted due to a SCHED_DEADLINE pi-waiter).
-	 * Otherwise we keep our runtime and deadline.
-	 */
-	if (pi_task && dl_prio(pi_task->normal_prio) && p->dl.dl_boosted) {
-		pi_se = &pi_task->dl;
+	if (is_dl_boosted(&p->dl)) {
 		/*
 		 * Because of delays in the detection of the overrun of a
 		 * thread's runtime, it might be the case that a thread
@@ -1516,7 +1522,7 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 		 * the throttle.
 		 */
 		p->dl.dl_throttled = 0;
-		BUG_ON(!p->dl.dl_boosted || flags != ENQUEUE_REPLENISH);
+		BUG_ON(!is_dl_boosted(&p->dl) || flags != ENQUEUE_REPLENISH);
 		return;
 	}
 
@@ -1553,7 +1559,7 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 		return;
 	}
 
-	enqueue_dl_entity(&p->dl, pi_se, flags);
+	enqueue_dl_entity(&p->dl, flags);
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
@@ -2715,11 +2721,14 @@ void __dl_clear_params(struct task_struct *p)
 	dl_se->dl_bw			= 0;
 	dl_se->dl_density		= 0;
 
-	dl_se->dl_boosted		= 0;
 	dl_se->dl_throttled		= 0;
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
+
+#ifdef CONFIG_RT_MUTEXES
+	dl_se->pi_se			= dl_se;
+#endif
 }
 
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
-- 
2.34.1

