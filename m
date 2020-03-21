Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6541D18DDB3
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 03:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgCUCqV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Mar 2020 22:46:21 -0400
Received: from mail-vi1eur05olkn2102.outbound.protection.outlook.com ([40.92.90.102]:55660
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbgCUCqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 22:46:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTQO02L4eWhiVfYRp7z0Rb5rZdxmYRjxBVh5QdZOecdF4GFyQq8xGXP2TxwzeU3/vdLmok6UUR7q9H5im4WR6KNNHeSxdJsZoVdBSJyJ4hTBgH1MTnkgfFR5qKZRAHn5yv1CtOrbDwTWxJpprGInsrQMBapGXGBtbh96Fq5ecBNvmNwRXdJ9i/S+s3r49wHKk7i6mHGylKPNmvkzsdOB8/4L/Mu7SNUakw08IXa74PiayHyqI/Pq31XwU2lSgL/WEmIHlBV07gJ6TRfEm+tX4O2typdTQjhUDRtAYt7wWk2AExEkUwgRYkWbYpIqklDR3X/o158PRTGz9Hx/V9vOcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOrvyCqZl0QwMnQO7rJ9qA1uZ5mwF8Ne/TzuiMX9Z9k=;
 b=c5UIgXFhL9a2Cy9hnSLdxtV51KewBd9+QyJUcCdYwNkyEc0Qg0p1ovYxy4XFUqgn6qS1u5tbyI6pYOM6zmITz9he0p18KIJwIatwge3ff7xN9SoPix/LLy4AU6UO6q4vM9duq7RZi6p2ziiTWjwala5geyZbc23VyWmifwT/jm6fciu0cm38FNs7YDc8c3OEnYn60iyeeLXqIPTf7fbE79dU2LBCo5LXmAr6rtAk+iKeZ6epY83bqXe2rt4Hz5sOWXrUHPWKaRMbxI1018AbabolE31KgrQlI9HFon2UV077I1zMTU89YLkkUlksqsvjhSiwP4IpGPJAJuGwAv8LOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc12::35) by
 VI1EUR05HT254.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc12::409)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Sat, 21 Mar
 2020 02:46:16 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.242.53) by
 VI1EUR05FT062.mail.protection.outlook.com (10.233.243.189) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Sat, 21 Mar 2020 02:46:16 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Sat, 21 Mar 2020
 02:46:16 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        "jannh@google.com" <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "duyuyang@gmail.com" <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "christian@kellner.me" <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: [PATCH v6 14/16] pidfd: Use new infrastructure to fix deadlocks in
 execve
Thread-Topic: [PATCH v6 14/16] pidfd: Use new infrastructure to fix deadlocks
 in execve
Thread-Index: AQHV/vUHXWYWYQ5hnEuyHEhgn9TLyA==
Date:   Sat, 21 Mar 2020 02:46:16 +0000
Message-ID: <e2ae1c06-b205-a053-d36c-045be27b3138@hotmail.de>
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-imapappendstamp: AM6PR03MB5170.eurprd03.prod.outlook.com
 (15.20.2835.016)
x-incomingtopheadermarker: OriginalChecksum:C350A3DD288F03D7E4EE0C9B2F2316BC317C0C9FE32F71DBC82A82E3D2661FCE;UpperCasedChecksum:8494EA4B495FE7D135DDA62C5FA7BC4374C89A31B284D2E61A54A8FBB144B473;SizeAsReceived:8518;Count:46
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [xtOr6vwBQQ76ygj0oAZ4m8Z+6FOurKN0]
x-ms-publictraffictype: Email
x-incomingheadercount: 46
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: d0733873-8032-4877-bbe0-08d7cd4206fe
x-ms-traffictypediagnostic: VI1EUR05HT254:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 43KCDLvNfF/dpVhgiZPLo5I1KQLzwSZnPzcsMdq2dKHugT0RZ72R9Bfd68nI7FyPk4I+Q70oLVesRE4wz+mUoKm6aPHIqwP6iQEuvpgAjATV5ZWD1wnecasZct04IIyI02GRU4WzzLYKKqw/SJVNsxYOaykf5pg8V1WcE2/7DcAZE7qsk2dDM4O+6kzmbkfJ
x-ms-exchange-antispam-messagedata: //suOCtiyn+4HKlh/wAoTfnTJAVfuby+RZn/BoUrRBuKGhKDZoGBXkWPa+ByGsWlU3m03PGTeUpj4WdGLNELkXgQJgjANJGvSocEqr9pPWrEdQbA+FxjQFXOg3B6pGfqQQDsmZEejm0yesQ89b944A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <2594756E531D2443AE21F664F138337B@sct-15-20-2387-20-msonline-outlook-45755.templateTenant>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d0733873-8032-4877-bbe0-08d7cd4206fe
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2020 02:46:16.1339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR05HT254
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This changes __pidfd_fget to use the new exec_update_mutex
instead of cred_guard_mutex.

This should be safe, as the credentials do not change
before exec_update_mutex is locked.  Therefore whatever
file access is possible with holding the cred_guard_mutex
here is also possbile with the exec_update_mutex.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 kernel/pid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 0f4ecb5..04821f4 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -584,7 +584,7 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
 	struct file *file;
 	int ret;
 
-	ret = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	ret = mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -593,7 +593,7 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
 	else
 		file = ERR_PTR(-EPERM);
 
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 
 	return file ?: ERR_PTR(-EBADF);
 }
-- 
1.9.1
