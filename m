Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E6918D944
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgCTU2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:28:08 -0400
Received: from mail-oln040092073048.outbound.protection.outlook.com ([40.92.73.48]:23601
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgCTU2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:28:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUUgqrUUln88ANUUUvQGjSLKyi3ilYuiVQadFqA8+HfvSvJ47uj+y1nVIVzdbbAYps9XyPYlJRM52aWVOSayeT8++JL9ZCNgBZz3evUL7PaxEXHjyFvNuE1/ALytWrLoM8JF1SRP7XnwutKJUuPmhT7ckxzhVFFVJjb+l0fF4m/zjefk/QiC5+1pAORVj5gjm81eHEeqiIMT3d8WFcNVwc9MWtGXONdBJVPXchFpcHWaJ6cX89UWXnXgfQqY4jv/Vzq+kJu10naLYiLkVYJ9wDfd9hFucqGHldirJ9FWtbHx4K9T1tNlkQz3BCqKfxCTsYVzhWPNPlNwpXb9hN9aMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgWquvn4baBcCId3qPbr+AXMrBMu4KzW2n3DRociUBo=;
 b=Gc3nr7sp3h74Bp++N51bGw1ojo6G6nLueEqS5t2KELu5lUoU1NUlswAB33+hxls5DdvhJegC3TKJW0qEoUBc/SkmSxzlOKOMbOQJ1FsOYyn4WJyyDZ5/OxAPkep4etsNanaCDkzT1npNzMsPilvO2qV021+ERh8Oq3R898mou3r56IJMFc5sPkHuTiCNJgzeznN+gKFRU8e8unAdRy0tZM8/78cq6RlLKS8AxbokLih9iglvI9nv4kHrxyae8PAQeOdEuJ40QMvxNW5Yjky1gzc9B1aeBsiX9cyrwp5QU6XmVVJYeCf2e/0kZAEpww2DfvchlNf/mwL1KW6AmD+SJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::35) by
 DB3EUR04HT129.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::353)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:27:59 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:27:59 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:9943DE238CC11ED958DD6EEB5E7E8B906A6522A3361406D1EB2F3C563FA13DEA;UpperCasedChecksum:A3B114356DFA34BBCB4A71FF2EDB5046E6CEE548119F42A96ECB5D625D7A415B;SizeAsReceived:9419;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:27:59 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 13/16] perf: Use new infrastructure to fix deadlocks in
 execve
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Message-ID: <AM6PR03MB51704A188C3A1FA02B76B9EFE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:27:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::11) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <814716c8-e55c-9725-2957-6233adca1eab@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Fri, 20 Mar 2020 20:27:57 +0000
X-Microsoft-Original-Message-ID: <814716c8-e55c-9725-2957-6233adca1eab@hotmail.de>
X-TMN:  [erAy8lrHvTvSUeU+Q+W2v+4jwpYq8xaU]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: a06f7948-4214-4332-cbde-08d7cd0d2e85
X-MS-TrafficTypeDiagnostic: DB3EUR04HT129:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gQ20l1tI9GTq+kNbvMlQVoBkFeGlytRVV+oZp8CB0QZQACjVZFSvH+3g3mka7gEOT6TdZFK/J3R2QCB3m6//CjDIZkLKr7BB3PCXnaObqlyc8Z+wge8yZaZahLRiuksYyEMh+Z401lZSWxXrEuhPEqAuQJ6HOqTBq7R3o7eexfkviLnokl4b6hXHYMHzOMWu
X-MS-Exchange-AntiSpam-MessageData: 6hMcdthMTm/IPGHQQOra08JI3+jOxRlYbt1VvvXOwBIkQZiXW5SdmMOn8Ec8pkFWRMiPXvuRHua1xovypkEOdj/hXukfQKQHeqjZIqfAjH35XEnbeLhhmGWRMfTfIlBeNo0uHEpyztcYXszNwgibbg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06f7948-4214-4332-cbde-08d7cd0d2e85
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:27:59.8411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT129
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This changes perf_event_set_clock to use the new exec_update_mutex
instead of cred_guard_mutex.

This should be safe, as the credentials are only used for reading.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 kernel/events/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e453589..71cba8c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1249,7 +1249,7 @@ static void put_ctx(struct perf_event_context *ctx)
  * function.
  *
  * Lock order:
- *    cred_guard_mutex
+ *    exec_update_mutex
  *	task_struct::perf_event_mutex
  *	  perf_event_context::mutex
  *	    perf_event::child_mutex;
@@ -11263,14 +11263,14 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 	}
 
 	if (task) {
-		err = mutex_lock_interruptible(&task->signal->cred_guard_mutex);
+		err = mutex_lock_interruptible(&task->signal->exec_update_mutex);
 		if (err)
 			goto err_task;
 
 		/*
 		 * Reuse ptrace permission checks for now.
 		 *
-		 * We must hold cred_guard_mutex across this and any potential
+		 * We must hold exec_update_mutex across this and any potential
 		 * perf_install_in_context() call for this new event to
 		 * serialize against exec() altering our credentials (and the
 		 * perf_event_exit_task() that could imply).
@@ -11559,7 +11559,7 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 	mutex_unlock(&ctx->mutex);
 
 	if (task) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
+		mutex_unlock(&task->signal->exec_update_mutex);
 		put_task_struct(task);
 	}
 
@@ -11595,7 +11595,7 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 		free_event(event);
 err_cred:
 	if (task)
-		mutex_unlock(&task->signal->cred_guard_mutex);
+		mutex_unlock(&task->signal->exec_update_mutex);
 err_task:
 	if (task)
 		put_task_struct(task);
@@ -11900,7 +11900,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 /*
  * When a child task exits, feed back event values to parent events.
  *
- * Can be called with cred_guard_mutex held when called from
+ * Can be called with exec_update_mutex held when called from
  * install_exec_creds().
  */
 void perf_event_exit_task(struct task_struct *child)
-- 
1.9.1
