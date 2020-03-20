Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C478318D936
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCTU1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:27:34 -0400
Received: from mail-oln040092073082.outbound.protection.outlook.com ([40.92.73.82]:35666
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgCTU1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:27:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfTTtTDLzVGlP6IpxttbO3bF26EF55KTvi1mKHJRQbpjkIKZ1XD7rWquAvsIggfef252zUg0cdLeXNen8amacgG0fPGgGZwujIMhecKPJ5oGAc9k0mGYGXPY/7Vg/6i08rq7NOPgH5AqcKcy+dlJkBSVtxDYYCXzg+Jtr8jxSLITJ1V4y6M2Y9wKhyyquv8TrXmge8wyy1Y64vqjPHHGMgNuri+GnxC+Fuy6XyUatdnYp5FpK6AkYzfnIYuBCWDqp8Qis7HOSf0P9jdiYhvKOTyUnkhQXcmEG8DplWEKk924p1YQiydAgo8TMrvOQHKg1tWubog3DfFP54NQQ370cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJmRER3UcnVdcj+aJDElOb9vgVkrVlofI7o1Kn1NZ+g=;
 b=OjvuwOsfgwXe/Bi2GoUO5lzHvitaMKZFxNo88ttaeA1VJ5EwZyehC5oRfASu2kwUqEJ0BwpXKq6JyU+gOfR5pwadb7T+VrqJlI/zb7auHTLCuCfZsT1PvqRapTf1iLEVjdithSDit7T31hhdUlG+Jf7Z9Utg78IelKwpLjelet0ZhPJAS+x6fMW+gygO4gOAoQacT9I82UlQn3a4JWomxQBbBR397C9mSdYt4wDG5zyQ9q3e9SvKQnlbpnTmvyP/g0iArOMi7VUo3KqUQT4M2o9p+YWuVLEg4amMcms2F1aGHbOvj+Bop2OS8Lp4bCwbhYX7+LZBkzRtcEA6VAdHig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::37) by
 DB3EUR04HT111.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::350)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:27:28 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:27:28 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:56C330A9A70DB96EE735B408EEFA331D3C2CA990C9D56D6C00ADCC5B62BA98E2;UpperCasedChecksum:40BFEC8257A7B82F6AC6470234101DDC8AAE1F51F1F06FA13E5E4BA5789D764A;SizeAsReceived:9415;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:27:28 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 11/16] proc: Use new infrastructure to fix deadlocks in
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
Message-ID: <AM6PR03MB5170C4D177DD76E3C65E8033E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:27:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0019.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::6) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <60c281a3-5bd0-f01b-60b4-398221fffe5c@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0019.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 20:27:26 +0000
X-Microsoft-Original-Message-ID: <60c281a3-5bd0-f01b-60b4-398221fffe5c@hotmail.de>
X-TMN:  [8o2JbL35JfHG0CF/Web1fABngrpEmOdV]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: cdc9e6e5-2ba8-4d82-2482-08d7cd0d1bca
X-MS-TrafficTypeDiagnostic: DB3EUR04HT111:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+r5n9VUw8/8dIYTVPwzSuxAoiqy0i1lWKx7X4I6i5tR1PYdAnWgmOPcbXUmo1HlMc7oozVdm2GSC7vHKlLMCut0OKM1LFBvKFFfxhGTKXubi1xC1B8CS67Xz2qWlS31C1FjKfmuk9DnjI4vAuMf3ks+I0KKexXy2RI3tPNTUP6C911F/D4CzY6yaYiSUiUx
X-MS-Exchange-AntiSpam-MessageData: n+mZZ6uXUYaPFGdRojpj8SG9eSTGW3cNDDoMytoIZ+8yVLRZ86E45SQH2br9uEgTixeRPDQYusUz5p4E+iK81RPW7+EMH+HoJ9unb+JPTBE2Cn2qURpVQIz8OY9+I7BfK0e1fVRmXIg1pbiFniJtGA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc9e6e5-2ba8-4d82-2482-08d7cd0d1bca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:27:28.3484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT111
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This changes lock_trace to use the new exec_update_mutex
instead of cred_guard_mutex.

This fixes possible deadlocks when the trace is accessing
/proc/$pid/stack for instance.

This should be safe, as the credentials are only used for reading,
and task->mm is updated on execve under the new exec_update_mutex.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 fs/proc/base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c7c6427..fed76abf 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -405,11 +405,11 @@ static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
 
 static int lock_trace(struct task_struct *task)
 {
-	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	int err = mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (err)
 		return err;
 	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH_FSCREDS)) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
+		mutex_unlock(&task->signal->exec_update_mutex);
 		return -EPERM;
 	}
 	return 0;
@@ -417,7 +417,7 @@ static int lock_trace(struct task_struct *task)
 
 static void unlock_trace(struct task_struct *task)
 {
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 }
 
 #ifdef CONFIG_STACKTRACE
-- 
1.9.1
