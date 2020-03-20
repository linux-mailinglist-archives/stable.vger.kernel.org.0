Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6A218D914
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgCTUZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:25:35 -0400
Received: from mail-oln040092073097.outbound.protection.outlook.com ([40.92.73.97]:26132
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726738AbgCTUZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:25:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKc1/fQW2OwFPQ5piSnqZBgVstA5UrBanF3snVupHKgRw9wVelLB5xk9sj8pHMl6XN5zaMXgdgx5vJyx92qaTSnxl4nzOAbwYKODl9yb05TVMxSv0SCuVJb3xLEQ86CcmwUyrie5DyXejxY441lUdPQj1wnSeqa7gAxqD52dTCOlJ8bgFE3Q2aPIn1YX68eb5TG7f+1UMy9uSB5Tfr+VFR9wyxvIIHr4rlas39t0lFttGLPFzwiO3YtHWVJpSLJtHhnxokyVP5ag1nnwMkHHdgcU784JIlkTTeQBJ4/FuiFq1Oe+294zqiqM7VrrFPZLvCl+35+Tu3DFx2lxSFUUew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsvEMoK9s13Z+qQ0sZuu7+kduQB91/WgWIRrj3BqjlA=;
 b=YoE8RbUPnM9qIXebFcDCXcgYzOCsNu0yG++xuLeDp+DkH7Zm8Udk8NCVkQR4QNUyFKJqe115DFd+/7Fryjg8x2u6TE9NTObDzNMWGAKFOXG1DG0wt62ZY3t6y4eko3r1MU5Z4F0kxt0OTpFZRUorqc1WtSuTzN1nKLG5ceVW9qKO3wM++k6UBysLyN1MMIy6XwQBUCsDJVXOols9VS+J9JsQvIjS/XgetIeejsyPFc0euNA6VLu8m8wWvoOCSbI2CI+esYQ+x8OR6AeACmHWP91bZCkmJ1ZaW5eL0AD4bM/rfv2PdEU97q2c+ruH66n8GLq44W2Y0W6ag63N8+SXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::34) by
 DB3EUR04HT226.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::198)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:25:30 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:25:30 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:0ADA2C92A0FC7721FCF19E995B18404B02C1BE21A8EFB05591972B5FC6062FF8;UpperCasedChecksum:CDCFA174AF46A5F300AEBDE8C164D99F42A0E75A255FF6D42D4B063CB2975A86;SizeAsReceived:9419;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:25:30 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 04/16] exec: Move exec_mmap right after de_thread in
 flush_old_exec
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
Message-ID: <AM6PR03MB5170FDB2C9B5225224B76398E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:25:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::8) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <d37d83aa-ab19-0250-ef2e-5f56c7a26f8a@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0021.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 20:25:28 +0000
X-Microsoft-Original-Message-ID: <d37d83aa-ab19-0250-ef2e-5f56c7a26f8a@hotmail.de>
X-TMN:  [JEZ6AYxiNIc1pLhgmb/p3F1flAVkBQx2]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 57d85b3d-468a-4558-557f-08d7cd0cd532
X-MS-TrafficTypeDiagnostic: DB3EUR04HT226:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IO/eqF+Td/zpFAw7EHyzf82L5sis4cZpY+mLsOzcD6uxfw5Ub7qoT5HyaC8qqBTmez8jtjLEIoL7tRUSLrl72+uySNwz/j7YMKHtmnei01uhg4l82vIgYn24s16S1fXaeOc3DjnLHw0Fb88h2/C+ukSCvxpgB0L9rmewoHWEYLrpWN7w3vIz9EFGcv2Ywt5R
X-MS-Exchange-AntiSpam-MessageData: efKUni9CFDCaOOEkrjciI3/6JSY7C3YTQtBRJ/19c1ez98jBHW4coh1oDEW4inTfuZVnvwODIl2bKO/qVwoEcOjE3tLSna6EiyHgLxZ/t3na7o/dGzJpD9XKgyIhboFoEKfS4Zt3pyqWr4VzxGk60g==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d85b3d-468a-4558-557f-08d7cd0cd532
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:25:29.9929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT226
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have read through the code in exec_mmap and I do not see anything
that depends on sighand or the sighand lock, or on signals in anyway
so this should be safe.

This rearrangement of code has two significant benefits.  It makes
the determination of passing the point of no return by testing bprm->mm
accurate.  All failures prior to that point in flush_old_exec are
either truly recoverable or they are fatal.

Further this consolidates all of the possible indefinite waits for
userspace together at the top of flush_old_exec.  The possible wait
for a ptracer on PTRACE_EVENT_EXIT, the possible wait for a page fault
to be resolved in clear_child_tid, and the possible wait for a page
fault in exit_robust_list.

This consolidation allows the creation of a mutex to replace
cred_guard_mutex that is not held over possible indefinite userspace
waits.  Which will allow removing deadlock scenarios from the kernel.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 fs/exec.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 215d86f7..d820a72 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1272,18 +1272,6 @@ int flush_old_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
-#ifdef CONFIG_POSIX_TIMERS
-	exit_itimers(me->signal);
-	flush_itimer_signals();
-#endif
-
-	/*
-	 * Make the signal table private.
-	 */
-	retval = unshare_sighand(me);
-	if (retval)
-		goto out;
-
 	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
 	 * not visibile until then. This also enables the update
@@ -1307,6 +1295,18 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	bprm->mm = NULL;
 
+#ifdef CONFIG_POSIX_TIMERS
+	exit_itimers(me->signal);
+	flush_itimer_signals();
+#endif
+
+	/*
+	 * Make the signal table private.
+	 */
+	retval = unshare_sighand(me);
+	if (retval)
+		goto out;
+
 	set_fs(USER_DS);
 	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
 					PF_NOFREEZE | PF_NO_SETAFFINITY);
-- 
1.9.1
