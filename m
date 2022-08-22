Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7556F59BA77
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbiHVHnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbiHVHni (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:43:38 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11013011.outbound.protection.outlook.com [52.101.64.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A475E6565;
        Mon, 22 Aug 2022 00:43:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/enz6zT8cVk6cQIFvW26+vNrW6XZaCBt8ADlnJJWCiNWh9C2ENmB0yrsB3cen7VSlWGd1QBWbuziDNUeIs+LL7Jm2Zmsoc4EsqG8hvNE53NEChRNMm7EI28Dp1rKpN5S8kUXcLX8xLNoxV0aP5pOplpclKxkJDgqkeGibOmUjTnMwMxadsWANj+gAur97thB1ARoYz5RMGM7bGQMDfLI4iPr/YAz/MFkAqXtgDgoZ3MUkNjpUZyZ5WcO5OclIkezRH41SdVSAVochZ1gBw24sQi2kqgNA86Qlhp3+92Wm2qXR/eqjwRxCf7Z1vUcFIWCUPk/mDhk3LG6H3GhWLzaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+voAwuqbyTFEqOA6zfg6fhcx2q2WINWQUthJnxPnA8=;
 b=VxcRIMv4EndvJ7nrWgvGsqCe5SCTyEg5sV77ywwkZPEk+mKDgKq7FBk5o8V2qWCQuMyiHExFXRp62NjxusKGaHkaxaKs/4F+jLuVwjDHUZktOf2B0gxaWA3xzHx2nTEJYMc/TEyCzFrRpNxpUzqBrWMQzLypVExWrEmh+qss/9yB9ocn1Dn+cnKX1mvVOOXSWN0hveaaxlY1FOVBAS0NDVnGSh68Fdn3iReFf6Peqp4HIWnzNGLNW+16XgtXyGNnMonZ59pbEo3g+2LLjtDIG/qm8MG6GrDuDwOlOfhQh1Lj5eHQEMKn5wdzc4ltEGMjKmw786JX5pzXKOvDSZX+2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+voAwuqbyTFEqOA6zfg6fhcx2q2WINWQUthJnxPnA8=;
 b=VQA+dyHfVKqxpKZNx2iJWoAYS0nzLJonIqUvdeXwH0iuNO6DC20J5ped+V1x29zi5Tm0IwssWqotJ5VC1Rkf4yB4XYIcP+APtPpqsxMfzzx9ouR5KLEgwy+Rqms33BVgeYmY6KK1NZgbpwVLRJXKJaquNUKrQ92KkQPhebgIiCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:43:33 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:43:33 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v5.4.y 3/4] sched/deadline: Fix priority inheritance with multiple scheduling classes
Date:   Mon, 22 Aug 2022 13:09:41 +0530
Message-Id: <20220822073942.218045-4-ankitja@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220822073942.218045-1-ankitja@vmware.com>
References: <20220822073942.218045-1-ankitja@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To SA1PR05MB8311.namprd05.prod.outlook.com
 (2603:10b6:806:1e2::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d5bf79e-8788-4db4-dac2-08da8412038d
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99g8LgAln7vzJVh0TMARp4sedWoSc4kSf4nf34+vRLGtPP2hdkztUhDNQOT5rA4hu10y5NW7XVDfhGUTDLsVD7GqDaLGoss9DTpXnVMVM0dJYWrEP/+HuSJXnVC3vLpAUSqMC56hVI1GXw5ySYh5JLlK1sVWsJVYpf2E2HRG0T8YJ43WsXXnio/TaGpn1lkyY4U27optRDIQwAsXaut7o46wkGIu5HJO0FRuYjZitVtMs2OoZHukMCqh+YWWsjh04RY/ie2xzrdloj8ILmjfA/jIrYSC0IMUHVwh8RwMkeeMeMTUXWORcIEr0Fxo9gKDCE7JKBzihCHg743uGW2NLeV4fFkhjcETBbi3HtuQo1v4kdD63HJR4E6pqz0Y3hJbESgsN07R29Od5D2np9m91LS6CPL1RbONh/dvnauNF3tACGCXhJe5BqaQkHMoY3qOH9wxlNgv4aDYcS/miRa1v6ckhEqf07U5WSOTis5sU5ctmIEj+m4TIhIHeqa8L95l0rPWj12KltWILxcHaKFRPFpeeelx0TcBPNw6k+FOspJ3CQJyf60gGkm0zDrD/xDwKKcS9cSdlKZQpY0kwKlfQuG2y45N1vmtiXdvCmpiZHZm+Q18QBetVK9uD0qWrVI9M4TFaOaUNB2IhDOunqyaTLSQ1jK2IfvqmAbDLtYGWEs12D2ElrVEFwvgg33QDkw/GDCCkfAtSAK34dnhr1ydcQFcDg+uHMf05+1aw7hXyj69dQa/bW4iHRH+DQ+34tussr281VhbNKe7Yu7+un/Y+gi+W30hu0RqJEdWpaK3VXXGpskLACxr/nMf10U+kfSFo0sHSVQx2yeXwA82AhZ3BMKBE2DSo+SYD9ZNc2kXvxaE5Opd37oZeRNATTX2zZwOpsqfTIIhS/szEhktM2GqWsYPQ+RbjUiBEx+dxa9nGVWDm60QXXmz6pHXwr1GP8gp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(966005)(2906002)(4326008)(41300700001)(66946007)(5660300002)(30864003)(7416002)(66556008)(8676002)(8936002)(66476007)(316002)(218113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlJWV1A4WnlISkpIOTlVTUpnZTJMT1dWZW1jQ1l1WTZ2SkRNSjZ0TE1Fa2tP?=
 =?utf-8?B?S2NhWk5zR0xQRzNYMHpaMENaVnhQUU5HNDUyMkJ4d3Y0c0Zwc2ZQejNESlNF?=
 =?utf-8?B?eVJFZHFadWpyRStnYXdQLzRPcy80U1kwc0ZvWUsya1BxNU5MK0ZmcjkySy9K?=
 =?utf-8?B?RXpBZ21ncEpRd2hHNkdnMzFUSEZIejd5Skc4Y3l3SXE2VUsvN281OWpzbjNt?=
 =?utf-8?B?R21LdmZqUDNHZ094Q25UNmVtcVE3aThmbWhCUzd4RXZqWE5oSEJjUTgvVUs3?=
 =?utf-8?B?ZVl3elRDTzlDOGVwRXJBQ2JSUGdlbnFBeVFUZzdKSFpEOFBlWUFKRTNKNlp2?=
 =?utf-8?B?THdTQ2xvVy8xc3dVbm1HdDVralRQNW10T2hXQ0N4akI3VldmSVdGWGF4OTVL?=
 =?utf-8?B?Y3NCRGhGTStXSUxFaHpva3lXclZ4SlZBaWxtTU02bWp5YkFHRGNZNXdBVDBt?=
 =?utf-8?B?WDRmbVJ1SVpQKy9iZjhIYlRlY1l4MkxnbVFLbHluMWx3ek10WGNvM25yVDhi?=
 =?utf-8?B?MTV1Q0xhemlNcXh6cVZyVkNNS1lFMU1yQUxDZWNrZGlNNERKckFWYSs1cnJI?=
 =?utf-8?B?dDZ6MnNSZzZMQ0RDMUtKUkxvTzZ6N0lwVnFyVkxqS05OcUFuRzhTVVVFQ09Z?=
 =?utf-8?B?RWtYSG8yOGc2WFZSejZ0NXJYdzZTSnVlc2JMTmxRZDNkY2JOd3RvSEtScEFU?=
 =?utf-8?B?WnlZTjlOMUkwSW9CQmExeWFzUnlYWEZ1SWxMRzNKaXNZQW05TXN0RmNZd3py?=
 =?utf-8?B?bThsanVReGRGNXVXQkFpVDdNUjB5Wk1tWUVqK01KUEU3YW15K1pmR0ptbUk5?=
 =?utf-8?B?MmNjOThGMGxjemFyMkFMaVRZUkFWL2ovbGxnQ2lRdDhZVzlEOGp3UWNRLzVC?=
 =?utf-8?B?Si9LdDVyZkw0VmNNdnZDYWRhR2Rna3RwQXA1bFJvWkxRTlAxL1pUSWZqa1Va?=
 =?utf-8?B?bFNLWkRZa0RqUVFWUFdNZEs5QzhWdnM0RCtzSHNFTDdud2E1R2J3eWpwcHoz?=
 =?utf-8?B?UnhrQ2RIekIxU25JQkJlbm1HOTdSMUgzRjdBenVVZXhDSisrUzFraGtsYjRV?=
 =?utf-8?B?N3U4T0VmaytqdG9ET2lydEM4Z1JVMllUZHVaVzg1N3ErcGxKQjl5V1UvN1F4?=
 =?utf-8?B?TG9GUEpsS1FiNnJvaGdwZGVMSHZzVTUrWGw2UDdSYnFycTFZMEtJcXgrVFBv?=
 =?utf-8?B?MCtCRXNJYnlUSnIrU2tZYnhqZ2pncVFJaXgwMDdJT3hqd3lZQmZXQ3BiK0FD?=
 =?utf-8?B?MFZXU3drMERrZ2QxMjhZWVdGbTEzU0huWEhQWkQ4MEJpRUZqZCtKVEF4NERt?=
 =?utf-8?B?dTQzKzkwdGduNzRZU3FENVdob29ReEV0NVdid0t0d2tNb1orcEFObk5aQWZO?=
 =?utf-8?B?czR6TmFOZkhkVjR4OGV2NGdwb3NHL2xSUHB3enVyU0ZPNVBXVDVralJNSmQ5?=
 =?utf-8?B?dlRMaTg3N0ZYVEtmYXBHdHV3dkxuaUpRdXEzTGxubzY4cmJoWW1BNUprNE5a?=
 =?utf-8?B?VEd3K3JwcmRKd1Z1L1IrUy9PRnNBbXBtTjJaUmFJUUFRS2VUNEJrZWNJU2Zz?=
 =?utf-8?B?blg3eXR2ek5uME9zcHFGL29KQytDcWNEQ2E1ejVVNXV0UnZXYzNuYzZNUjBK?=
 =?utf-8?B?UmlXYUNCZXlqeUZnVFNZL20xK2ZwMlJPa3Ewd0VnMnN2OVk5ZWtZSHphYnox?=
 =?utf-8?B?eDh2KzZJaWJTN0FWU2Rma01DQk9sbU0yZlBRR1VualNRTW4xaHVqMUhQUGsy?=
 =?utf-8?B?SUpDMHUrN012c2tIYXQ5eFhpamhZY0tPWDRzcFdybjFkSmpDZVpER21xSjMw?=
 =?utf-8?B?U2J4UHRXc0YyTmRKN0x0TmJqTWNCb3NXb1N3QUJvcDBmTGNQM043dTZXM1dq?=
 =?utf-8?B?WHAzemtLYU5KSlJoSy9JTzBvTzRiVE5PU1U1WUFET2hKMlVrYm0zeS9JSFlU?=
 =?utf-8?B?Wjd0VDE1UnV5eDZCUUZiSFh1RjJScW4yN01xNjdoaiszNDN2UWZJQkRuWkky?=
 =?utf-8?B?MG1LdEgwanJtT0hQSU9TeGhVUndsT29lVEJBTVFIL3lWeXhqTDE1cDl4TExS?=
 =?utf-8?B?bE4xYnJzb0FaMkpNUWloWVlJbnYrM0Q0TklRUkxacmFZMU43T3lFamZ4dDk5?=
 =?utf-8?Q?6xoRLqpmY5ck8mAOTbUSKP6fl?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d5bf79e-8788-4db4-dac2-08da8412038d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:43:33.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1BQ722eZYid+kAMOsexQWdtmF4OfCq2JhVhW696KTuiVohf6z+ySvr81wssHA5oUn79YGvNBxgoIFrQmiVg4A==
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
[Ankit: Regenerated the patch for v5.4.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
---
 include/linux/sched.h   | 10 ++++-
 kernel/sched/core.c     | 11 ++---
 kernel/sched/deadline.c | 97 ++++++++++++++++++++++-------------------
 3 files changed, 68 insertions(+), 50 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 171cb7475b45..b15958388672 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -544,7 +544,6 @@ struct sched_dl_entity {
 	 * overruns.
 	 */
 	unsigned int			dl_throttled      : 1;
-	unsigned int			dl_boosted        : 1;
 	unsigned int			dl_yielded        : 1;
 	unsigned int			dl_non_contending : 1;
 	unsigned int			dl_overrun	  : 1;
@@ -563,6 +562,15 @@ struct sched_dl_entity {
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
 
 #ifdef CONFIG_UCLAMP_TASK
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5befdecefe94..06b686ef36e6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4554,20 +4554,21 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
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
index 4b87c5362ec0..d8052c2d87e4 100644
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
@@ -2722,11 +2728,14 @@ void __dl_clear_params(struct task_struct *p)
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

