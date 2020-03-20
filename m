Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEEC318D8F6
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCTUYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:24:39 -0400
Received: from mail-oln040092075079.outbound.protection.outlook.com ([40.92.75.79]:34787
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726666AbgCTUYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:24:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ka0XOhNCgJ+7mTiXFX2XFLhFvUQZ5LNhHkD5HkoXZZunB50mrCydFmKCTlh0gJq0Ljgagg/PiGmAZ2qv+5gRayHjbRUK5aLDu5mZ5xddtWKWI/myIX1QpaSzFJe67wTd2OPaJTJUINho62aMbws7aOBwbgifxhBLDKJy8KDN36oAiESOPJ8MTvz3iec0+8e/zUCofzxpZQ14K0WjAE916I1LUigr9a7cKkDKBnOHO+3K7o7InSaXMYDkU2sbb4sUDzfCqoknxE0lxbx1xnZiuNgABt6fVG69/yWrxPXUMLFezuFQHjhkEYkBsmgYfdRhn5fIoG+glsKG6E5yJOkqqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mF9hvSlyjsjm6R8O6qfRVvMoVh2cAPIjgp+zSBQ8lnM=;
 b=BdmW2JpJU0mGLRpXrG05aVpYjf8wuaaRwchsGrN+tseoogxoblnRVBNurXJNyZTOGM/VpCL1iVo+9tHIpdAoKoCnGNOoEPTZ9xJTRs2tev1X9+deZSmFTlhEHBhIDir/0qn6SQBEQWI46KW2YpOO+tQw+IBBaRLxkAciyqQSxhdA28SE+3dJouUmcgEVAVOpSi44mQetsgBnTDp6lSstAxN4u4221Sh2tiM3ItLqQcNCRrOq+boFTnDMEtnN/8hy+7Y/a2P1+bzi7e4ZycPp5m5Jedni48a4ZnwrRypD3f5aQmTAcc60UfQdBrHkhuDZjf1LeFB6bpk4/Ngc4zoW9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::3b) by
 DB3EUR04HT226.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::198)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:24:34 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:24:34 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:F06CA825C62DDE7913DB60AC745985A7F22F12F4AD34ABA977667B82CAC69D8F;UpperCasedChecksum:F8DF489D099C18809EE106F32C2AE616F2E7C6311656340F8A8C293EBED7DBB7;SizeAsReceived:9401;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:24:34 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 01/16] exec: Only compute current once in flush_old_exec
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
Message-ID: <AM6PR03MB5170FC93B158EB8179F91D6AE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:24:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::15) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <c171f779-1559-2147-7efd-ec358daa1d75@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Fri, 20 Mar 2020 20:24:32 +0000
X-Microsoft-Original-Message-ID: <c171f779-1559-2147-7efd-ec358daa1d75@hotmail.de>
X-TMN:  [A0oZ+M1oJTp2KOXaRUZxz79/h60mgRD8]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 6723444d-5a00-403a-0868-08d7cd0cb41e
X-MS-TrafficTypeDiagnostic: DB3EUR04HT226:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3pHIM5tSbCcq4mW1ooyA0BpSM9XB9NLfAUaX5ZttaH0fByXZGjOm4XZ+mh9QpDCEnVTwh06TUZfv76ZNF4Yh0Yw78opORx5EhInNGjXv59olIm37yDGvJdmNtQaUTqCkDhMipEc+y5bkxwbXFCnvrwgOQPSXggTFj44YGBjuC/yBWcLqhyqogHumNc5JsC7w
X-MS-Exchange-AntiSpam-MessageData: Qe/gKX30DCSIK5iUW3RZNnvYtcdvnDCLVoeuBBWqYTv0jRrvnZw5XVdfNDiCZGB8AnaozUK3xpMm9vIxQvO4uymuCkOYUm+EX+NAJtWZ58jWyyuxLhgih5aapZHgch4N1hAdMfkAfuGkMK3+nTjx3w==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6723444d-5a00-403a-0868-08d7cd0cb41e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:24:34.4341
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

Make it clear that current only needs to be computed once in
flush_old_exec.  This may have some efficiency improvements and it
makes the code easier to change.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 fs/exec.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index db17be5..c3f3479 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1260,13 +1260,14 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
  */
 int flush_old_exec(struct linux_binprm * bprm)
 {
+	struct task_struct *me = current;
 	int retval;
 
 	/*
 	 * Make sure we have a private signal table and that
 	 * we are unassociated from the previous thread group.
 	 */
-	retval = de_thread(current);
+	retval = de_thread(me);
 	if (retval)
 		goto out;
 
@@ -1294,10 +1295,10 @@ int flush_old_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;
 
 	set_fs(USER_DS);
-	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
+	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
 					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();
-	current->personality &= ~bprm->per_clear;
+	me->personality &= ~bprm->per_clear;
 
 	/*
 	 * We have to apply CLOEXEC before we change whether the process is
@@ -1305,7 +1306,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 * trying to access the should-be-closed file descriptors of a process
 	 * undergoing exec(2).
 	 */
-	do_close_on_exec(current->files);
+	do_close_on_exec(me->files);
 	return 0;
 
 out:
-- 
1.9.1
