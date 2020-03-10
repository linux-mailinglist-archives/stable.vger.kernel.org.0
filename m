Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF4C180531
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 18:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCJRpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 13:45:39 -0400
Received: from mail-oln040092075065.outbound.protection.outlook.com ([40.92.75.65]:26510
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbgCJRpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 13:45:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L61N0EpFZVhcAGZNAUTWe3t9jAQh6h71YDzxG3GiXnvp7B4TO3FFCUtkLXdxjGwPL+DKK5KFLZVcT5oLkzX0POsnd2eEqn2VSbcqJO/dFNwdhfSdMBe8c8eCJ3WU7D6cGmKQiCt0hDx+2fambNZA1juKt9lTZlAxO3EsW9NcxnfM1vVeLik8v5UQ93tnrwrQZsqxGmf3/oW5H4lVOjNS+Om0E4WsazorLY3QCem7ZtwvSILIwRHDt3cg7yDIzxqpPuZsILH0vzBCR1q75v3KCudvQQYiOXC02qXUfX1qizskt3tK7FcSdenIcyb5P1iklAIUe8RxXnKZJsmEHa+jsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYx/eGMQRk15p5KGn00JKRBBncFFuzv3ujSL4CsQZpM=;
 b=EXsEyXMGWkxyHsb9kJYmr5PnYiHtIKC0VwGUyf6dwBbSS8xvAEgmug7b8+/UVvE802ZLH58YpoaYU9ZCfNdwV4ro51obCF2zurEJTH98J7Vzjelo4t4JDMSGzydC50AIu1WcbAJ8xRH+zooBPZ7McKKPyjMuwh+58mc8QKtk0qM60tbPOzVsK3JEOI+hkzm9CmfDkiUpvMJdw8nPRb1ZewVehxNV+pqAhxsCbQTtCLuwPyPsNF6NUXTggEhxr8QG+TFqCjwIH6SnGNuLmLWlSiBZME0BMfDzt8Q0urTZxM6KHi7+kr104IdEUEaLAoOeeNVrsUocaDqIhHzrVxkKGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VI1EUR04FT026.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::39) by
 VI1EUR04HT214.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::340)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 17:45:35 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.28.55) by
 VI1EUR04FT026.mail.protection.outlook.com (10.152.28.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 17:45:35 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:709DA8CC4D739A346F6F10415B77C549C2C75E51CF8174E86C50DAD72C3A9D6D;UpperCasedChecksum:A17C6A373AF089981264002FD010737C4107A98A0BEEFBD59F21DD3FA2E8BA2A;SizeAsReceived:10315;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 17:45:35 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 2/4] proc: Use new infrastructure to fix deadlocks in execve
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
Message-ID: <AM6PR03MB51705D211EC8E7EA270627B1E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 18:45:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <875zfcxlwy.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::22) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <4dedec91-5e43-7ab6-31f6-0c4d4c0b961e@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 17:45:33 +0000
X-Microsoft-Original-Message-ID: <4dedec91-5e43-7ab6-31f6-0c4d4c0b961e@hotmail.de>
X-TMN:  [LVSYAfv/7I+AspDEth9Kxn0HT/mwPT3U]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: b2ab4bba-4122-4fc8-38ff-08d7c51ad618
X-MS-TrafficTypeDiagnostic: VI1EUR04HT214:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vo2uMPUIIfj1yyvT3Xy0XHDknalHYieujECBOOVKUv6tA4N34c+kC2nf/gquQqEAlTZ7/UALtAm0dT2ztA5LgSwLNX+DeydeSP6yX/HGFDKKKKPFGYZPDvW3gQfHvKFYqsH788Hl8ehKOGlqnWB8LLyYkwK6CuyAz145FMx/ZsRF9B54U+wVzVt0BHfrJhbB
X-MS-Exchange-AntiSpam-MessageData: dstz6T4CN9AkqZrg8y0kV0yO5Y8uR9XpzwTiYYjO16n0O/oVPuOa69DiH81/WGJA+ScjyodBxSM4EIWfwJ7ErQ2lWMQN8GqZR3AUaaZvYud2bYKkfYTvea8RLQhFi31R38+gi+xTNYoFBCE0y2+zgA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ab4bba-4122-4fc8-38ff-08d7c51ad618
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 17:45:35.0846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT214
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
index ebea950..4fdfe4f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -403,11 +403,11 @@ static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
 
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
@@ -415,7 +415,7 @@ static int lock_trace(struct task_struct *task)
 
 static void unlock_trace(struct task_struct *task)
 {
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 }
 
 #ifdef CONFIG_STACKTRACE
-- 
1.9.1
