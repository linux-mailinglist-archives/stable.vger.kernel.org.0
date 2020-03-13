Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7A9183E41
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 02:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCMBGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 21:06:00 -0400
Received: from mail-oln040092069038.outbound.protection.outlook.com ([40.92.69.38]:5858
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbgCMBF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 21:05:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZe89OJapHEAdTeGcxfMtXNwX/nuYBvq6prjL+Zli0Wwx0qyS7HHNhqUuOLzGi4SVFVg2bK9Ibh+uCJjpT6kJrpnwGKvkxl7bRMJ1RYXngumth6mjMAT5wUBfegjbB3vmMcxWQECNdq066hyFUyLLMnkUxyeCsdoy1gpBLODB+kuzcJP8nPx75jWHUrYTVbTWWSE5UieiwHXC3OY/SBPg1rbxS5ZBh/hg1fpixIkEYxAzuEv0fDyWElF1Q8LEdAX5TFy14y5drhc9H6wuiX2gfE/7muMZR2a7EOV8FNFyvIzYBVQv0ytLG/Shlw2ock2F+4/wD8ZKYn9moeSL5aSAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fL/W3fjGvnqMxzdhSAlvMb6Z0AxNsQkzH7VDK/qG6mk=;
 b=eM4a7qlXA0VR8WLGuXPwQhOwyaTtLdhrA5kb9bevpPHttCyskgKm1JcbDiNqKQ2kIYbJblORR48k1HNBbr0afgJCv7kMpOdmjFpmmXTMKnMhBrSEEb9kyFw69/PAz0lmKzXMVPqUk6M0CUg2aS/6utT/B1rgtFmeO+N4nxdRbHA2QufUdpLPphym/LpjpdWwOcLpPK8+1BgfLvk19O8Ba3EBylbaIkhlPEjM7nos2oVa7LTyr7yprh/ttLT+7IvWN7u5nxliFX+2H3v1bj17KlW0ahUQa4VdOtVAe3Dc0RMFlKUykHYjbz1vWy+Rl5+VtYSLtKdkMt1bqgEja7F28w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR02FT012.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1d::36) by
 HE1EUR02HT193.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1d::228)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 13 Mar
 2020 01:05:53 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.10.59) by
 HE1EUR02FT012.mail.protection.outlook.com (10.152.10.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 13 Mar 2020 01:05:53 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:4AF6DC29AC1F232A67D6F997BF52BC4D60B511DC2EAB02B9553BF4FA2ED0C233;UpperCasedChecksum:3A8574BE8248C5135B1F2644B429421251666B497C3C30C74842EF48D5775A6C;SizeAsReceived:10368;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 01:05:53 +0000
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
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
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <f37a5d68-9674-533f-ee9c-a49174605710@virtuozzo.com>
 <87d09hn4kt.fsf@x220.int.ebiederm.org>
 <dbce35c7-c060-cfd8-bde1-98fd9a0747a9@virtuozzo.com>
 <87lfo5lju6.fsf@x220.int.ebiederm.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 13 Mar 2020 02:05:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <87lfo5lju6.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::13) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <d457086c-60c2-3b4d-977b-4c01117d0b6f@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Fri, 13 Mar 2020 01:05:50 +0000
X-Microsoft-Original-Message-ID: <d457086c-60c2-3b4d-977b-4c01117d0b6f@hotmail.de>
X-TMN:  [ZvoFOvwG9QrKgn2xdjMtVFT3WymZoeXK]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: fc42852e-3fd7-4c54-6b01-08d7c6eaacdd
X-MS-TrafficTypeDiagnostic: HE1EUR02HT193:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qXuFWBkLnHBhakKb3mJ2bGdWggGeJ4DMkmNmo6dIGuGhIE+hoI5tViLJ26fzQ/VFD5Dv3MQNVyzriUPRsJzmGtvTxUu0q1QrVe+OP/ITj1cWCE/ytu/KmJAcVUSTVR1Ej8qlfQe8OpeMz1gGLApE1EtjfsqvDyP9flQbSTtqaTyixC9D+9zqgct2gD4HGFCX
X-MS-Exchange-AntiSpam-MessageData: JqX7lRkO1cip5geuEcxVqwUEWhesCLvZBAZLmkrmdRQ12lh3lUuVyrZSLjhnT787yvE5oWbKi+o8jom7WbeYyeJcG7ASfu5+K9mI5kSGeUYcwTbJ4FKbgLWHMup0+69oOk1jHCCGHHl/kmj0lbdNLQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc42852e-3fd7-4c54-6b01-08d7c6eaacdd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 01:05:52.7579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT193
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/12/20 3:38 PM, Eric W. Biederman wrote:
> Kirill Tkhai <ktkhai@virtuozzo.com> writes:
> 
>> On 12.03.2020 15:24, Eric W. Biederman wrote:
>>>
>>> I actually need to switch the lock ordering here, and I haven't yet
>>> because my son was sick yesterday.

All the best wishes to you and your son.  I hope he will get well soon.

And sorry for not missing the issue in the review.  The reason turns
out that bprm_mm_init is called after prepare_bprm_creds, but there
are error pathes between those where free_bprm is called up with
cred != NULL and mm == NULL, but the mutex not locked.

I figured out a possible fix for the problem that was pointed out:


From ceb6f65b52b3a7f0280f4f20509a1564a439edf6 Mon Sep 17 00:00:00 2001
From: Bernd Edlinger <bernd.edlinger@hotmail.de>
Date: Wed, 11 Mar 2020 15:31:07 +0100
Subject: [PATCH] Fix issues with exec_update_mutex

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 fs/exec.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ffeebb1..cde4937 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1021,8 +1021,14 @@ static int exec_mmap(struct mm_struct *mm)
 	old_mm = current->mm;
 	exec_mm_release(tsk, old_mm);
 
-	if (old_mm) {
+	if (old_mm)
 		sync_mm_rss(old_mm);
+
+	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
+	if (ret)
+		return ret;
+
+	if (old_mm) {
 		/*
 		 * Make sure that if there is a core dump in progress
 		 * for the old mm, we get out and die instead of going
@@ -1032,14 +1038,11 @@ static int exec_mmap(struct mm_struct *mm)
 		down_read(&old_mm->mmap_sem);
 		if (unlikely(old_mm->core_state)) {
 			up_read(&old_mm->mmap_sem);
+			mutex_unlock(&tsk->signal->exec_update_mutex);
 			return -EINTR;
 		}
 	}
 
-	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
-	if (ret)
-		return ret;
-
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
 	membarrier_exec_mmap(mm);
@@ -1444,8 +1447,6 @@ static void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
-		if (!bprm->mm)
-			mutex_unlock(&current->signal->exec_update_mutex);
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1846,6 +1847,8 @@ static int __do_execve_file(int fd, struct filename *filename,
 	would_dump(bprm, bprm->file);
 
 	retval = exec_binprm(bprm);
+	if (bprm->cred && !bprm->mm)
+		mutex_unlock(&current->signal->exec_update_mutex);
 	if (retval < 0)
 		goto out;
 
-- 
1.9.1
