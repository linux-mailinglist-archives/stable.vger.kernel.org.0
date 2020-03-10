Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0791B18053B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 18:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCJRqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 13:46:06 -0400
Received: from mail-oln040092073084.outbound.protection.outlook.com ([40.92.73.84]:31187
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbgCJRqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 13:46:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTnb3zN2prC4Va3XgJIxKCFmt2RiY8azHtlcpueaWf777smX+ZVE2IFP6H10W3bjqWvJEUpjYyChe7H5kweBT3LzyyEbQ/vRDCGQA/Ev9OdHQHckBAXgU9fmX4rpDDrq/xzHrr8Er6T5uOJgt4HtFDvjpVfWXhDMTvNLVnGLUDDoyQvwK78eAUADeCbAVkmPbrehR0XYwFEljodjGI9TdNd/3t/HIkeKSLHeD++Zy/vZPhkiD1h9Ozl/b9n8sIsCe0g5JvtET9BMcmflYEUpL4mlHtu0o7KVNT6emPrBkbuYSsVSyzJrcofQFcjQ8F54BaaC3JYwqCwgwuGk/XAsCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olnWKl/qROPBG2YSqCrVe3w/cuXB3vs2TZn2SEBQtS4=;
 b=R60ja+hO2CPqQV5wf6Jd8O9OJM9U9LPOIdU+JvQRsl7FZM2HGV85sF0A5SWa6nc14Vh7pBdc4RFyf0q9cF0HbsjeOewg8/nx12N2g+ke30m4rYegSLMRth94cUTsrWUvul0WpQxPh1XPJhUP9gdEa49Kt6Rjr39Ki25M0/Ax4yskALEK0Qp8rDl5Kc7vZ2Lq294d7NMszoWtc5yx1Mj1Edt/zvfWGXAailoYqHbrZQHNrfsQaFuACa8b6s3EQfoC8lR1NlMvoxhnZ4FBKcF/idoZG/qkXmROFp3D9Mb2p6Gg9ICHFUBr0Pq8FJoYvduct94hN4BGnCZGuRpyutVjpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VI1EUR04FT026.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::34) by
 VI1EUR04HT049.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 17:45:59 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.28.55) by
 VI1EUR04FT026.mail.protection.outlook.com (10.152.28.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 17:45:59 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:157065CD350ECAB81667C96E5C20CAA90097A96A3C94C657D26C18E03AAAE564;UpperCasedChecksum:792CF835DAF8018F691592D716FE310F3AD2DB5F98FFECBD57CA01097CC3E226;SizeAsReceived:10287;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 17:45:59 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 4/4] perf: Use new infrastructure to fix deadlocks in execve
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <878sk94eay.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org> <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfcxlwy.fsf@x220.int.ebiederm.org>
Message-ID: <AM6PR03MB517035DEEDB9C8699CB6B34EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 18:45:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <875zfcxlwy.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To AM6PR03MB5170.eurprd03.prod.outlook.com (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <ac7b9c5d-171f-1f66-c0ef-7495e8b1ab9c@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 17:45:57 +0000
X-Microsoft-Original-Message-ID: <ac7b9c5d-171f-1f66-c0ef-7495e8b1ab9c@hotmail.de>
X-TMN:  [PsiCRHURkwuV3QcRtzZCs1L6kQTGErPj]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 4169ac3b-8718-4076-5a5c-08d7c51ae47b
X-MS-TrafficTypeDiagnostic: VI1EUR04HT049:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6V61Vwd71eCV5/xyqr6zFGWGkmdr0e/2xpXtwaqSADHJnCfjSq5tp0f+zozp1GpwgWCF23E5eYpBtYEOD6HiFcoTdii9XjpbkyP+/Si0MDbHUEVE5j5nT4T9iMJ3VlylqLSfT8Tk5ogmNDHNRhAHZkVJjuibHp9Hc9aL44OesT3ysLdMr/xVtT5ZcskSlKDt
X-MS-Exchange-AntiSpam-MessageData: ZVT8iy5lQXVmz7CVP9D2H8Ed7OsWTSXwudkpB0jQF3LLZyNBmXjvv8l5ji3Fu5pnZh8sL+9tJw7u0581+WfG2gbDhAtuVhitJrkqaoAy6YuJSgPRCBcq0OiiC1Qo19OLJ2pDrEQTNBN1qa5ZGFs9/w==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4169ac3b-8718-4076-5a5c-08d7c51ae47b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 17:45:59.2303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT049
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
index 2173c23..c37f6eb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1248,7 +1248,7 @@ static void put_ctx(struct perf_event_context *ctx)
  * function.
  *
  * Lock order:
- *    cred_guard_mutex
+ *    exec_update_mutex
  *	task_struct::perf_event_mutex
  *	  perf_event_context::mutex
  *	    perf_event::child_mutex;
@@ -11254,14 +11254,14 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
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
@@ -11550,7 +11550,7 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 	mutex_unlock(&ctx->mutex);
 
 	if (task) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
+		mutex_unlock(&task->signal->exec_update_mutex);
 		put_task_struct(task);
 	}
 
@@ -11586,7 +11586,7 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 		free_event(event);
 err_cred:
 	if (task)
-		mutex_unlock(&task->signal->cred_guard_mutex);
+		mutex_unlock(&task->signal->exec_update_mutex);
 err_task:
 	if (task)
 		put_task_struct(task);
@@ -11891,7 +11891,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
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
