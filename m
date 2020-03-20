Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1FC18D900
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgCTUZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:25:02 -0400
Received: from mail-oln040092075041.outbound.protection.outlook.com ([40.92.75.41]:26197
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726666AbgCTUZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:25:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfeQxRmZ9RJWqUeysvOl/6WOUFFcb6jSqhbZsgPp3D99zTDkrjIxWXvYQvsH2pHKrhIgoW5VjsNFAc2yXH3qirOxNEvkih1+lakEL2M50ULtDEtP5BKrOdkLoB1Z0M+jD5robXXI4zSnKp78Tzwr98FlFY/bWi7cs/FONPVmSf9mSIMaE6HzqWytsYuyM0PBc+p3Aup57RFfLdFMP8ivp804AHDviwmklBVmFJRz/NZ3DcEXeQbWNxy6wkHR1aapmVj34oJFeJlwsTEvuDOA8UxdEMIvdT4hFaHUa1DU49hdvndF2LyXZkuxNJqfCrhUqUMRPQETffzMiBICbmsPOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEG1G63BQyTj4NIAgyL0sILHWEZk/yOpP/x1R6xqgjk=;
 b=iTwBx6xkJ9vuvcMuECHEEl4w3jrBP1MJCnmzssu/MOsyj2MzpitBi6zNVDrEg/xlgH1ZZvcDr9/3fDZ+ELePUR0Y/WJ5j0eGRm6C7D1NcfKJ6YpfyO9xfB1yrBdLl4xw/kwuqnGQPF4KiqAwQjeO3vd8Mc23hengjs3mpHiQooHc0Kyy7Xdqwamc60S/FQXs1WKPC2iFUVE6ItLUfxbRWQDT4V5riaDwp3g8F4usnlwaTWQXD/9Fp5fyYbLjyWRmRRmaf8QTYtCTNYWWtaPnlRQrGltC4L0GWM3fsu0h3i/q11z4axajpIRjcigS899vPjvX/O8Obs5KstGTw4hvcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::36) by
 DB3EUR04HT021.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::446)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:24:54 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:24:54 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:869908CF01EFF52FDCDECC38EB77254CAEFC249ED423CE489D332E457C4D9BB9;UpperCasedChecksum:5371DEE21799D84893EF9CDD123E730B7C6AD75BD50B949988FB24A3540839E0;SizeAsReceived:9432;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:24:54 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 02/16] exec: Factor unshare_sighand out of de_thread and
 call it separately
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
Message-ID: <AM6PR03MB51708AECEA6E05CAE2FDC166E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:24:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::25) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <c53f15dd-b408-68e5-490e-9d5bdb7ec90f@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0015.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Fri, 20 Mar 2020 20:24:52 +0000
X-Microsoft-Original-Message-ID: <c53f15dd-b408-68e5-490e-9d5bdb7ec90f@hotmail.de>
X-TMN:  [C6UtGPhiEDoOWZeg17+HeAeDyltOzGuO]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 6fcdf3b4-8986-4738-e45d-08d7cd0cbfbf
X-MS-TrafficTypeDiagnostic: DB3EUR04HT021:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bR+gXeYFhS1KWVb2KormQIajtSUbhoc2qfSfTd1cFf9VrBfAxanqwPUloWPuOo4SDdHfLN5JkDmUULyzoKp0bt4khz+jBH7pKjeKcr1sZqWvKuCCtDjoRaMt+ad/FfBC/gCiF5LdtkvWKrgTn+LQslsIiGllJb2SCg4d8sDY4h4FDCDpOPWv/h+fTRdKZ40v
X-MS-Exchange-AntiSpam-MessageData: tzuSPZVlTP7pcBstDl0CtCDS+rU8j44jxa3awH3HV/ez2jqm5elMyriH8wzNY66L602KRiLekRHt91T9fOIeCNQsDvvALB/8ff3nDiUA4qmK0ReTJPi0i/EG1wU6Yer0fNW8e/ZJB0NUDP7RIgPnFw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fcdf3b4-8986-4738-e45d-08d7cd0cbfbf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:24:53.9478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT021
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This makes the code clearer and makes it easier to implement a mutex
that is not taken over any locations that may block indefinitely waiting
for userspace.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 fs/exec.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c3f3479..ff74b9a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1194,6 +1194,23 @@ static int de_thread(struct task_struct *tsk)
 	flush_itimer_signals();
 #endif
 
+	BUG_ON(!thread_group_leader(tsk));
+	return 0;
+
+killed:
+	/* protects against exit_notify() and __exit_signal() */
+	read_lock(&tasklist_lock);
+	sig->group_exit_task = NULL;
+	sig->notify_count = 0;
+	read_unlock(&tasklist_lock);
+	return -EAGAIN;
+}
+
+
+static int unshare_sighand(struct task_struct *me)
+{
+	struct sighand_struct *oldsighand = me->sighand;
+
 	if (refcount_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;
 		/*
@@ -1210,23 +1227,13 @@ static int de_thread(struct task_struct *tsk)
 
 		write_lock_irq(&tasklist_lock);
 		spin_lock(&oldsighand->siglock);
-		rcu_assign_pointer(tsk->sighand, newsighand);
+		rcu_assign_pointer(me->sighand, newsighand);
 		spin_unlock(&oldsighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 
 		__cleanup_sighand(oldsighand);
 	}
-
-	BUG_ON(!thread_group_leader(tsk));
 	return 0;
-
-killed:
-	/* protects against exit_notify() and __exit_signal() */
-	read_lock(&tasklist_lock);
-	sig->group_exit_task = NULL;
-	sig->notify_count = 0;
-	read_unlock(&tasklist_lock);
-	return -EAGAIN;
 }
 
 char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
@@ -1264,14 +1271,20 @@ int flush_old_exec(struct linux_binprm * bprm)
 	int retval;
 
 	/*
-	 * Make sure we have a private signal table and that
-	 * we are unassociated from the previous thread group.
+	 * Make this the only thread in the thread group.
 	 */
 	retval = de_thread(me);
 	if (retval)
 		goto out;
 
 	/*
+	 * Make the signal table private.
+	 */
+	retval = unshare_sighand(me);
+	if (retval)
+		goto out;
+
+	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
 	 * not visibile until then. This also enables the update
 	 * to be lockless.
-- 
1.9.1
