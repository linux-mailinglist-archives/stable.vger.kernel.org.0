Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C7218D90E
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCTUZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:25:19 -0400
Received: from mail-oln040092073093.outbound.protection.outlook.com ([40.92.73.93]:13421
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbgCTUZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:25:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALoo6FkOdh7UAiZeQOql/CiAcHqxadx+ogui3u34tdhZhFhuqzXIwngVBUl5fBBj9vuXbjiPqPH+rR8DbyqKo1CMy96CxBaLnBmfc901lsnF87ax6FdLQc6TqmmXiJ+OJhaW6tr5yxz+/aL4ELEqn9HzbA6EEhpmsGErimub/QW8qT1hpFCm5qMIOkkf+KzS4xdGpAge/PGFwI/vAF2q6g7p6nPA67bB04oZUU3h27tBGCttNsR2tMstoQ+Pdr1joW3D8ucSyl6JYF7nCXJQZ0F8WZDr4iC3m6gDy35xxEcHr+7manfzD3VxrDvJxSylWHtrTFz1XOYbgP0W/3ZQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iqKQ8iJMPPHs0stqpjWH2idJ1gtMI30mGoa9ajLgyc=;
 b=JM63A5i2kQuoQ8sy0Bxr8Ju48eZG2Iq+KWw3PkYwSpuYQvs7YbKSP0HyJg68BKlL6j6kWf+M8r6wzfKbJL+VVseoPedVsQFWf1f02y4ydk94QYRUJk6kdbAMOrvCweWGltQnyNiZZueX+6SMYjiLiKQhbNifDTMXaSFXeRF+Ddzhp/EOShU0oHwaBaiO8wBtV/D4EW1kXd1HREGiqDSxSh4Xp2G/JJFKneNpjYHHlBSbAcraDSd57yCq7+DrEqVy3ex4z2RgTBt+wY54GAYiTZFCKfP9MiE7D90Kr4NfAb8qgc+h8wPH8c5TA+4yeQKxiWIZxVFV+BMzwrvRTDsVBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::39) by
 DB3EUR04HT151.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::164)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:25:13 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:25:13 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:AF11A19A115B8F9989A9D1B21E9851F8A5626EB739F5731DB7A50418DA0D97C2;UpperCasedChecksum:914F8E391114572AC00C8FE23E869BC087B69CD944B12A3027CE4C4C24323DFB;SizeAsReceived:9414;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:25:12 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 03/16] exec: Move cleanup of posix timers on exec out of
 de_thread
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
Message-ID: <AM6PR03MB5170CCB8D8B36F6002446FBDE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:25:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::10) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <047d07bc-5050-06f6-9494-24f3e7e92616@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 20:25:11 +0000
X-Microsoft-Original-Message-ID: <047d07bc-5050-06f6-9494-24f3e7e92616@hotmail.de>
X-TMN:  [nUTIdkd0Q4fkiU0I4gtqb6H5u3ZVz9aW]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: bcad9447-4918-4b56-e426-08d7cd0ccb14
X-MS-TrafficTypeDiagnostic: DB3EUR04HT151:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oADBsXnaKHWWY/5rERPrPbjN76PcpYL7dytFGyzMfqCj40gcpIiBKWpveHMzSFa8xrYjUn6gIf1FmKBmGO30/eANDjNmGo3nmkxIXumxLVFKx4ElqGdrrfti9ClllB6ctpqG5wZhbtOOVJ81d6jbqVhcUkUw8qaVsnBe2TwJuCcgmZaCfstdcV8SaBDQpZc1
X-MS-Exchange-AntiSpam-MessageData: qcV0C42F7VtRIP4+AJo8qTukBTkWVRCT39AIrog8S8tyAxr6q1gW6Rvwo9RkkRjsKRHvxyARgDQH383su+bOqIWmDYkR5BQ+OF9pu+adm0YoRhZt0elckA29zIhFeRbe5dcwD1+ZFKcSlIp4iFUi1Q==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcad9447-4918-4b56-e426-08d7cd0ccb14
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:25:12.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT151
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These functions have very little to do with de_thread move them out
of de_thread an into flush_old_exec proper so it can be more clearly
seen what flush_old_exec is doing.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 fs/exec.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ff74b9a..215d86f7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1189,11 +1189,6 @@ static int de_thread(struct task_struct *tsk)
 	/* we have changed execution domain */
 	tsk->exit_signal = SIGCHLD;
 
-#ifdef CONFIG_POSIX_TIMERS
-	exit_itimers(sig);
-	flush_itimer_signals();
-#endif
-
 	BUG_ON(!thread_group_leader(tsk));
 	return 0;
 
@@ -1277,6 +1272,11 @@ int flush_old_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
+#ifdef CONFIG_POSIX_TIMERS
+	exit_itimers(me->signal);
+	flush_itimer_signals();
+#endif
+
 	/*
 	 * Make the signal table private.
 	 */
-- 
1.9.1
