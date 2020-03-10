Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBCA18077D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCJSym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:54:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56464 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbgCJSyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 14:54:41 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBk1K-0000Vk-UM; Tue, 10 Mar 2020 12:54:26 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBk1J-000215-JY; Tue, 10 Mar 2020 12:54:26 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
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
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
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
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
References: <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
        <20200309195909.h2lv5uawce5wgryx@wittgenstein>
        <877dztz415.fsf@x220.int.ebiederm.org>
        <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
        <87k13txnig.fsf@x220.int.ebiederm.org>
        <20200310085540.pztaty2mj62xt2nm@wittgenstein>
Date:   Tue, 10 Mar 2020 13:52:05 -0500
In-Reply-To: <20200310085540.pztaty2mj62xt2nm@wittgenstein> (Christian
        Brauner's message of "Tue, 10 Mar 2020 09:55:40 +0100")
Message-ID: <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBk1J-000215-JY;;;mid=<87wo7svy96.fsf_-_@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/UQDQ9+ZCJN9SiRdg7xtb+liwj6nFG3vc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christian Brauner <christian.brauner@ubuntu.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 648 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.6 (0.4%), b_tie_ro: 1.83 (0.3%), parse: 0.94
        (0.1%), extract_message_metadata: 20 (3.0%), get_uri_detail_list: 1.56
        (0.2%), tests_pri_-1000: 27 (4.1%), tests_pri_-950: 1.26 (0.2%),
        tests_pri_-900: 1.12 (0.2%), tests_pri_-90: 31 (4.8%), check_bayes: 30
        (4.6%), b_tokenize: 12 (1.8%), b_tok_get_all: 9 (1.3%), b_comp_prob:
        2.6 (0.4%), b_tok_touch_all: 4.0 (0.6%), b_finish: 0.66 (0.1%),
        tests_pri_0: 553 (85.4%), check_dkim_signature: 0.52 (0.1%),
        check_dkim_adsp: 3.2 (0.5%), poll_dns_idle: 0.32 (0.0%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 6 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH] pidfd: Stop taking cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


During exec some file descriptors are closed and the files struct is
unshared.  But all of that can happen at other times and it has the
same protections during exec as at ordinary times.  So stop taking the
cred_guard_mutex as it is useless.

Furthermore he cred_guard_mutex is a bad idea because it is deadlock
prone, as it is held in serveral while waiting possibly indefinitely
for userspace to do something.

Cc: Sargun Dhillon <sargun@sargun.me>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid.c | 6 ------
 1 file changed, 6 deletions(-)

Christian if you don't have any objections I will take this one through
my tree.

I tried to figure out why this code path takes the cred_guard_mutex and
the archive on lore.kernel.org was not helpful in finding that part of
the conversation.

diff --git a/kernel/pid.c b/kernel/pid.c
index 60820e72634c..53646d5616d2 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -577,17 +577,11 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
 	struct file *file;
 	int ret;
 
-	ret = mutex_lock_killable(&task->signal->cred_guard_mutex);
-	if (ret)
-		return ERR_PTR(ret);
-
 	if (ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
 		file = fget_task(task, fd);
 	else
 		file = ERR_PTR(-EPERM);
 
-	mutex_unlock(&task->signal->cred_guard_mutex);
-
 	return file ?: ERR_PTR(-EBADF);
 }
 
-- 
2.20.1

