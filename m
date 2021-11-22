Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B3C458E56
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 13:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhKVMbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 07:31:37 -0500
Received: from mail-eopbgr140139.outbound.protection.outlook.com ([40.107.14.139]:60422
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239027AbhKVMbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 07:31:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8SibRtS0sDSYhdJkWibFr5/EuMwIbAkIWTWvgr65bpJIchggcP8zmrW9Qgwjr/yZvcjF16ZbMvOKDLFoR3VwLoRY1iXMpd85OUltpn+c1UyidVuyzkGEeTpRBHGwx+Sxof8MPW9jcEtXrjWCnJGrYYi9fPDFtBYGEXdyrh4Thib833iodzo+c32TZog1mVYjAWakyAU0RSXH+gACjiW1prm3HG+dD45rCQhojS4FWyk8g1I2rS2eOlwyIbjpcralW5lvar/nzsFvF5FOAhtHuKha/c+1q9guU9hJqvpuSG4DiXfnydz4XQqXR7AZQsqJW1Y7oGYPfjMb0VmmDD0RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YPkz/73vuBuUlJKJ5ZlJiQzHinmy/4CI4AjgF4rWvk=;
 b=Ee3LeL7L9ywtnJm4mzyO75y+puiGMbjtwG2iSFTsa3M26PqijlXO54UwQIRTzLvdPElZBMMTqJ/S57IcfzTeJ0DWFSAsalG5QQ7MuquYH7lpe81OrtcOZRoy31OAd9aCs9hWhiTaQW4eO+XGGNuy7OIx91/oi8gTJRR0ZNSDREEMQ+X0hFZFWuM1sBA0kRKlKt+txaLsOfIhROP4WhNEPp9+1W+rKrhDo7HAQroquT4dCFBOKW7mbUCZeiDoUPl30Ta1XjIJws6IvbWmkySnTzm9aVESwhCrCIWsMp+Hy5XA5ZIpUksiOYlcqAbQY/y+rArc2ES21KV3U9WEAP+rFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YPkz/73vuBuUlJKJ5ZlJiQzHinmy/4CI4AjgF4rWvk=;
 b=hZicC+QBfjM/GuCGvk6UAgSaCASkH+EBbLMZiyUWRlcqG5FluOcDiyvaITcbIWmWltEvoBET8k8v0KFNU8Rx0Y2SfWD/SEI+hqIFMZmLaCnh34NdZSYXcabE3nYAc0x+7iGBv5I0lQeAG2dowttGliWHllhJhMPQFmcI5SrIYns=
Received: from DB7PR08MB3579.eurprd08.prod.outlook.com (2603:10a6:10:46::15)
 by DB6PR0802MB2534.eurprd08.prod.outlook.com (2603:10a6:4:97::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Mon, 22 Nov
 2021 12:28:28 +0000
Received: from DB7PR08MB3579.eurprd08.prod.outlook.com
 ([fe80::e4f4:c4be:41ac:f912]) by DB7PR08MB3579.eurprd08.prod.outlook.com
 ([fe80::e4f4:c4be:41ac:f912%7]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 12:28:28 +0000
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Andrei Vagin (C)" <avagin@gmail.com>,
        "dave@stgolabs.net" <dave@stgolabs.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "manfred@colorfullife.com" <manfred@colorfullife.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Vasiliy Averin <vvs@virtuozzo.com>
Subject: Re: FAILED: patch "[PATCH] shm: extend forced shm destroy to support
 objects from" failed to apply to 5.10-stable tree
Thread-Topic: FAILED: patch "[PATCH] shm: extend forced shm destroy to support
 objects from" failed to apply to 5.10-stable tree
Thread-Index: AQHX35vkruXuVmE9wEeoZCCl6kNriqwPeVCx
Date:   Mon, 22 Nov 2021 12:28:28 +0000
Message-ID: <DB7PR08MB3579F4444B9AED5D660BF1D0E89F9@DB7PR08MB3579.eurprd08.prod.outlook.com>
References: <163758386010469@kroah.com>
In-Reply-To: <163758386010469@kroah.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: f3d2e17f-a8bd-e077-11bd-efb0da99a5c1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b66943ff-012b-4da8-2821-08d9adb39687
x-ms-traffictypediagnostic: DB6PR0802MB2534:
x-ld-processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
x-microsoft-antispam-prvs: <DB6PR0802MB2534F1FC949284320C43958EE89F9@DB6PR0802MB2534.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RYK9+sd0qPsToEQxJyf8l9mPxqrdha81uL7p2xhMFKV3E5H4VjYO9IYVA3B8yudKHcfX1P/jaamKtXVmO8jegzpl0DRZOm5N3VCeLVQM+6VN600+eQNx5fyafpWV45scFYt31QvqOjh0kpFuRl8c693VSButKmvpjU08iRvghuuUz+H4fdhoUl3WDHTksmPReMgUzr6bnZZWnWK1MZAGMFf49Tou51BZ8eJKXG4ITRNQmq2cd+W1qlpOf5ryrYo0jjPPnHBTJEOMuA5aJA2w0SCTZT2If5v4s4uWDtAvfuyOyU3qfYWtjOATcO1T+r30INboUS3czZGPAT8e0HCtJuGboqNOfhi8Niogha9OnyMDu8NERMCKzytYvdjxn6FCiDJI6TZcmydC5IqBT4Kud/wIuZBFb1AJZtzruYb8nVEp1+cfcJ/OtfVQJhp8y1kKgIduPPmG6mL5YvAw4mgneLj83ncotjpGEH6JOVqQ3cA5YiIT+RIySjjbsc1tVz1usZDwD4doN7UTrkBKIo59kaULhKLmdeJBnrr50DXWyNqRVnfEAunTXqwjn8zqUyl6/R6rVQ5CDmEaVRa9wa9n0WewCEP/MoZ14PzH2QwVaqpM1h9ev3XC3HXpZ/aiWWtoxvpPMsAKYrcKIdkdbF0CB/3I9qw2oRVw+RSa7cXGqN6ViHQ0pR9c++o90dmK1aApMTC3cnopMV5KtLUp8F8qmBpw0rYoMfH89KZPvdA7coEizTs8hc/1HK1GeBjw9EL+CtTzwJ4jbMifm/fkgz+kZXTseExIYDvvYBUY4rFmms3LeXu/8sZHW48E+3L5Mw11NiqskTJNRNX95I5L5kpp686X5InxzFSoNav14tPd5g4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR08MB3579.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(921005)(26005)(38100700002)(66446008)(8676002)(64756008)(7696005)(55016002)(9686003)(91956017)(316002)(53546011)(33656002)(76116006)(71200400001)(86362001)(6506007)(30864003)(83380400001)(6636002)(66946007)(66476007)(508600001)(122000001)(52536014)(2906002)(186003)(5660300002)(44832011)(38070700005)(66556008)(966005)(110136005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VJML8IueUrjo+6Ut7wCSDJdCjmML4E3vzedGolJ1QZyjs6zMS4Hl/4NsQQ1m?=
 =?us-ascii?Q?f8k68onribZXpv7D9YF8joGCfFT2Uid7aD1NAHVM/A0ZVAMBwZDnWbOvpR9c?=
 =?us-ascii?Q?xVtfvsgn9zpGLZVfXaA1huBI3k3FKx1tXN3SdlZ2jZnbA3zaNLhFrp7DzZWj?=
 =?us-ascii?Q?XWcig6HzTkTPARdCURuPhY3b9DUGohQGMW4JQ0/wF2i+Bp/CBt2N8s8L6KsN?=
 =?us-ascii?Q?ZAXXMyrUm0GUzKkVaFI/CXN4m6Snhk6THIDCih5F9mBhaFRxmRX4Ve6JnT9+?=
 =?us-ascii?Q?5LK/5zlNZlOgGE3E1BisVKBfYPy1J2jZEct3YrkPW1sOKOq7IyCf52+AMmq7?=
 =?us-ascii?Q?DxVtw8hjuzoGcLfrSQjO1Py1+wWVBXmZYDDZEeW1HPaRSm0ig0wc3eWgd30L?=
 =?us-ascii?Q?waPNZSLMHSQptNoUHUYtcROHIL8COg090Tq2PmRVpqRvdT0z4IjCKKxTpAOI?=
 =?us-ascii?Q?g1DIxQ8JYd+M/oRZZGlt0x+oziAL+Yv2T36EXKS6dd2p/ya4mBA4nLCksvov?=
 =?us-ascii?Q?Pcqj4LJyw851U1kWwjg0tDxnR07eyA0sM3oyPF0F1VcFEIKSYmu8+i1b60Fq?=
 =?us-ascii?Q?p4n8a8fKyA0pZB3N8HAa7M+BCkdx/UNs0lpVAPbonmhIcI9ktv5TnZ+IQrFT?=
 =?us-ascii?Q?RicVuWIHbDJO8vqc0KPVXRNj7MS5+WNJp8ekkm7TuceBDOvJ9G7pAHf8juzD?=
 =?us-ascii?Q?3VWPzMk6FM5hlDKHpzQO8eP76/7pDMyjBGCbRnDpcEK91DHzAYXN0N9iANey?=
 =?us-ascii?Q?UcL2vmRm8BvxfuMijURQXc05Oo1GMkzGjn2y47KTuyuDGQO6jRAXxIMuZ95Y?=
 =?us-ascii?Q?rM+n/OQhSZvnSidTSHIGiYWthC6VJ4eVwdq6AFWSwnQ8N/ASX6l85gKWIcKA?=
 =?us-ascii?Q?/7PFcyqIzG6QVqPHua2XUeSAs5zzJmIu4l/TEH/yJYllgO9lrJ+jD6UTignJ?=
 =?us-ascii?Q?noPoyA1CE9eKA7DfrQLtcq0/PIxYzV8jX6URY4dM/R3brqfenSqG5RHKFKsH?=
 =?us-ascii?Q?exZSwXt+6o8fqeioqRJmRVSyGncmwRWQei4nwHWtSaYkxjQ1mwcWBXPkmlku?=
 =?us-ascii?Q?M/y9wOTaCeGjyYcsbk9ofJae/RatxcvuIKd+FWv4K83Ive2AjKM8jGmusWWT?=
 =?us-ascii?Q?AD3YJp/LBGrZjL1MFdcDEHzvfho5AB1Ucom6j3JvuDaQGCm3gnOAtU74oPtq?=
 =?us-ascii?Q?IfbS/yTGXb24AQGUsQet5XqyE6MjQahly3KjIBfaO78VW4LEp/FNs0i+JqCB?=
 =?us-ascii?Q?3XNemgjJc0zYJN3U4avpEryulmlFiRe3117tZRYzNPdSQiW21c6dBbEX6Y+Y?=
 =?us-ascii?Q?29Yph30K0Qouc8nrrgzhx/7ROzSSG+kEp2L/r5vtGxrNtc9BnFTsd9DaFSPj?=
 =?us-ascii?Q?/HmjlNeJb8oMLiOAbVkJkiKIwzlYHY8rrCExR6BNfPDOsZw0sECoo0AcBEcn?=
 =?us-ascii?Q?Ljo6B7zhyfLiSMi9JSc8MEqRuIkaJ/J1EQIW26d/d/L40UyAhx419zTGfN1x?=
 =?us-ascii?Q?/PEJs8so5OiYATU1Li9fE7++lAdXVkhFXNTYekBfxkH1LYfHImOJokgyw6sH?=
 =?us-ascii?Q?gSBuTj6NHYQBJRrBuECuQkofgI3DI4w3BXqsxGJdRrCRU/mORn5xpXms6uBV?=
 =?us-ascii?Q?NSfO3PzMDf2Qs6lxWbTX98m4kCzm4tVEN2VqQTMOvW3XLbLFP7KS3XOOcBlE?=
 =?us-ascii?Q?+PyKbQi0M0HU1S9+yb7NneLXhRoI1WQRnllVMhi/Q4AjY8LN?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR08MB3579.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b66943ff-012b-4da8-2821-08d9adb39687
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 12:28:28.4607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VVJLUODeda1qTu4LJhlKWJ65uL7iWFyPY6DeSzCD81yAe+kCrFhvyTuqkyUqGRzqQUl/Tr/13wntEFy2ioBhIWiKkxMt+RbI4KOKtG7JB8lYnqPgHB4mCexzYikiVyPq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2534
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Greg,

thanks for the notifications! I will port our changes to all stable branches and send them.

Thanks!

Regards,
Alex

________________________________________
From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
Sent: Monday, November 22, 2021 15:24
To: Alexander Mikhalitsyn; akpm@linux-foundation.org; Andrei Vagin (C); dave@stgolabs.net; ebiederm@xmission.com; gregkh@linuxfoundation.org; manfred@colorfullife.com; Pavel Tikhomirov; stable@vger.kernel.org; torvalds@linux-foundation.org; Vasiliy Averin
Cc: stable@vger.kernel.org
Subject: FAILED: patch "[PATCH] shm: extend forced shm destroy to support objects from" failed to apply to 5.10-stable tree


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85b6d24646e4125c591639841169baa98a2da503 Mon Sep 17 00:00:00 2001
From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Date: Fri, 19 Nov 2021 16:43:21 -0800
Subject: [PATCH] shm: extend forced shm destroy to support objects from
 several IPC nses

Currently, the exit_shm() function not designed to work properly when
task->sysvshm.shm_clist holds shm objects from different IPC namespaces.

This is a real pain when sysctl kernel.shm_rmid_forced = 1, because it
leads to use-after-free (reproducer exists).

This is an attempt to fix the problem by extending exit_shm mechanism to
handle shm's destroy from several IPC ns'es.

To achieve that we do several things:

1. add a namespace (non-refcounted) pointer to the struct shmid_kernel

2. during new shm object creation (newseg()/shmget syscall) we
   initialize this pointer by current task IPC ns

3. exit_shm() fully reworked such that it traverses over all shp's in
   task->sysvshm.shm_clist and gets IPC namespace not from current task
   as it was before but from shp's object itself, then call
   shm_destroy(shp, ns).

Note: We need to be really careful here, because as it was said before
(1), our pointer to IPC ns non-refcnt'ed.  To be on the safe side we
using special helper get_ipc_ns_not_zero() which allows to get IPC ns
refcounter only if IPC ns not in the "state of destruction".

Q/A

Q: Why can we access shp->ns memory using non-refcounted pointer?
A: Because shp object lifetime is always shorther than IPC namespace
   lifetime, so, if we get shp object from the task->sysvshm.shm_clist
   while holding task_lock(task) nobody can steal our namespace.

Q: Does this patch change semantics of unshare/setns/clone syscalls?
A: No. It's just fixes non-covered case when process may leave IPC
   namespace without getting task->sysvshm.shm_clist list cleaned up.

Link: https://lkml.kernel.org/r/67bb03e5-f79c-1815-e2bf-949c67047418@colorfullife.com
Link: https://lkml.kernel.org/r/20211109151501.4921-1-manfred@colorfullife.com
Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 05e22770af51..b75395ec8d52 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -131,6 +131,16 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
        return ns;
 }

+static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
+{
+       if (ns) {
+               if (refcount_inc_not_zero(&ns->ns.count))
+                       return ns;
+       }
+
+       return NULL;
+}
+
 extern void put_ipc_ns(struct ipc_namespace *ns);
 #else
 static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
@@ -147,6 +157,11 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
        return ns;
 }

+static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
+{
+       return ns;
+}
+
 static inline void put_ipc_ns(struct ipc_namespace *ns)
 {
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index ba88a6987400..058d7f371e25 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -158,7 +158,7 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[]. And ->vfork_done.
+ * ->cgroup.subsys[]. And ->vfork_done. And ->sysvshm.shm_clist.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
diff --git a/ipc/shm.c b/ipc/shm.c
index 4942bdd65748..b3048ebd5c31 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -62,9 +62,18 @@ struct shmid_kernel /* private to the kernel */
        struct pid              *shm_lprid;
        struct ucounts          *mlock_ucounts;

-       /* The task created the shm object.  NULL if the task is dead. */
+       /*
+        * The task created the shm object, for
+        * task_lock(shp->shm_creator)
+        */
        struct task_struct      *shm_creator;
-       struct list_head        shm_clist;      /* list by creator */
+
+       /*
+        * List by creator. task_lock(->shm_creator) required for read/write.
+        * If list_empty(), then the creator is dead already.
+        */
+       struct list_head        shm_clist;
+       struct ipc_namespace    *ns;
 } __randomize_layout;

 /* shm_mode upper byte flags */
@@ -115,6 +124,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
        struct shmid_kernel *shp;

        shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+       WARN_ON(ns != shp->ns);

        if (shp->shm_nattch) {
                shp->shm_perm.mode |= SHM_DEST;
@@ -225,10 +235,43 @@ static void shm_rcu_free(struct rcu_head *head)
        kfree(shp);
 }

-static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
+/*
+ * It has to be called with shp locked.
+ * It must be called before ipc_rmid()
+ */
+static inline void shm_clist_rm(struct shmid_kernel *shp)
 {
-       list_del(&s->shm_clist);
-       ipc_rmid(&shm_ids(ns), &s->shm_perm);
+       struct task_struct *creator;
+
+       /* ensure that shm_creator does not disappear */
+       rcu_read_lock();
+
+       /*
+        * A concurrent exit_shm may do a list_del_init() as well.
+        * Just do nothing if exit_shm already did the work
+        */
+       if (!list_empty(&shp->shm_clist)) {
+               /*
+                * shp->shm_creator is guaranteed to be valid *only*
+                * if shp->shm_clist is not empty.
+                */
+               creator = shp->shm_creator;
+
+               task_lock(creator);
+               /*
+                * list_del_init() is a nop if the entry was already removed
+                * from the list.
+                */
+               list_del_init(&shp->shm_clist);
+               task_unlock(creator);
+       }
+       rcu_read_unlock();
+}
+
+static inline void shm_rmid(struct shmid_kernel *s)
+{
+       shm_clist_rm(s);
+       ipc_rmid(&shm_ids(s->ns), &s->shm_perm);
 }


@@ -283,7 +326,7 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
        shm_file = shp->shm_file;
        shp->shm_file = NULL;
        ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
-       shm_rmid(ns, shp);
+       shm_rmid(shp);
        shm_unlock(shp);
        if (!is_file_hugepages(shm_file))
                shmem_lock(shm_file, 0, shp->mlock_ucounts);
@@ -303,10 +346,10 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
  *
  * 2) sysctl kernel.shm_rmid_forced is set to 1.
  */
-static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
+static bool shm_may_destroy(struct shmid_kernel *shp)
 {
        return (shp->shm_nattch == 0) &&
-              (ns->shm_rmid_forced ||
+              (shp->ns->shm_rmid_forced ||
                (shp->shm_perm.mode & SHM_DEST));
 }

@@ -337,7 +380,7 @@ static void shm_close(struct vm_area_struct *vma)
        ipc_update_pid(&shp->shm_lprid, task_tgid(current));
        shp->shm_dtim = ktime_get_real_seconds();
        shp->shm_nattch--;
-       if (shm_may_destroy(ns, shp))
+       if (shm_may_destroy(shp))
                shm_destroy(ns, shp);
        else
                shm_unlock(shp);
@@ -358,10 +401,10 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
         *
         * As shp->* are changed under rwsem, it's safe to skip shp locking.
         */
-       if (shp->shm_creator != NULL)
+       if (!list_empty(&shp->shm_clist))
                return 0;

-       if (shm_may_destroy(ns, shp)) {
+       if (shm_may_destroy(shp)) {
                shm_lock_by_ptr(shp);
                shm_destroy(ns, shp);
        }
@@ -379,48 +422,97 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
 /* Locking assumes this will only be called with task == current */
 void exit_shm(struct task_struct *task)
 {
-       struct ipc_namespace *ns = task->nsproxy->ipc_ns;
-       struct shmid_kernel *shp, *n;
+       for (;;) {
+               struct shmid_kernel *shp;
+               struct ipc_namespace *ns;

-       if (list_empty(&task->sysvshm.shm_clist))
-               return;
+               task_lock(task);
+
+               if (list_empty(&task->sysvshm.shm_clist)) {
+                       task_unlock(task);
+                       break;
+               }
+
+               shp = list_first_entry(&task->sysvshm.shm_clist, struct shmid_kernel,
+                               shm_clist);

-       /*
-        * If kernel.shm_rmid_forced is not set then only keep track of
-        * which shmids are orphaned, so that a later set of the sysctl
-        * can clean them up.
-        */
-       if (!ns->shm_rmid_forced) {
-               down_read(&shm_ids(ns).rwsem);
-               list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
-                       shp->shm_creator = NULL;
                /*
-                * Only under read lock but we are only called on current
-                * so no entry on the list will be shared.
+                * 1) Get pointer to the ipc namespace. It is worth to say
+                * that this pointer is guaranteed to be valid because
+                * shp lifetime is always shorter than namespace lifetime
+                * in which shp lives.
+                * We taken task_lock it means that shp won't be freed.
                 */
-               list_del(&task->sysvshm.shm_clist);
-               up_read(&shm_ids(ns).rwsem);
-               return;
-       }
+               ns = shp->ns;

-       /*
-        * Destroy all already created segments, that were not yet mapped,
-        * and mark any mapped as orphan to cover the sysctl toggling.
-        * Destroy is skipped if shm_may_destroy() returns false.
-        */
-       down_write(&shm_ids(ns).rwsem);
-       list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
-               shp->shm_creator = NULL;
+               /*
+                * 2) If kernel.shm_rmid_forced is not set then only keep track of
+                * which shmids are orphaned, so that a later set of the sysctl
+                * can clean them up.
+                */
+               if (!ns->shm_rmid_forced)
+                       goto unlink_continue;

-               if (shm_may_destroy(ns, shp)) {
-                       shm_lock_by_ptr(shp);
-                       shm_destroy(ns, shp);
+               /*
+                * 3) get a reference to the namespace.
+                *    The refcount could be already 0. If it is 0, then
+                *    the shm objects will be free by free_ipc_work().
+                */
+               ns = get_ipc_ns_not_zero(ns);
+               if (!ns) {
+unlink_continue:
+                       list_del_init(&shp->shm_clist);
+                       task_unlock(task);
+                       continue;
                }
-       }

-       /* Remove the list head from any segments still attached. */
-       list_del(&task->sysvshm.shm_clist);
-       up_write(&shm_ids(ns).rwsem);
+               /*
+                * 4) get a reference to shp.
+                *   This cannot fail: shm_clist_rm() is called before
+                *   ipc_rmid(), thus the refcount cannot be 0.
+                */
+               WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
+
+               /*
+                * 5) unlink the shm segment from the list of segments
+                *    created by current.
+                *    This must be done last. After unlinking,
+                *    only the refcounts obtained above prevent IPC_RMID
+                *    from destroying the segment or the namespace.
+                */
+               list_del_init(&shp->shm_clist);
+
+               task_unlock(task);
+
+               /*
+                * 6) we have all references
+                *    Thus lock & if needed destroy shp.
+                */
+               down_write(&shm_ids(ns).rwsem);
+               shm_lock_by_ptr(shp);
+               /*
+                * rcu_read_lock was implicitly taken in shm_lock_by_ptr, it's
+                * safe to call ipc_rcu_putref here
+                */
+               ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
+
+               if (ipc_valid_object(&shp->shm_perm)) {
+                       if (shm_may_destroy(shp))
+                               shm_destroy(ns, shp);
+                       else
+                               shm_unlock(shp);
+               } else {
+                       /*
+                        * Someone else deleted the shp from namespace
+                        * idr/kht while we have waited.
+                        * Just unlock and continue.
+                        */
+                       shm_unlock(shp);
+               }
+
+               up_write(&shm_ids(ns).rwsem);
+               put_ipc_ns(ns); /* paired with get_ipc_ns_not_zero */
+       }
 }

 static vm_fault_t shm_fault(struct vm_fault *vmf)
@@ -676,7 +768,11 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
        if (error < 0)
                goto no_id;

+       shp->ns = ns;
+
+       task_lock(current);
        list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
+       task_unlock(current);

        /*
         * shmid gets reported as "inode#" in /proc/pid/maps.
@@ -1567,7 +1663,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
        down_write(&shm_ids(ns).rwsem);
        shp = shm_lock(ns, shmid);
        shp->shm_nattch--;
-       if (shm_may_destroy(ns, shp))
+
+       if (shm_may_destroy(shp))
                shm_destroy(ns, shp);
        else
                shm_unlock(shp);

