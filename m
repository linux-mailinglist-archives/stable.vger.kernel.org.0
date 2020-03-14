Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1EE1856F4
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 02:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgCOBak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 21:30:40 -0400
Received: from mail-oln040092065107.outbound.protection.outlook.com ([40.92.65.107]:16462
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726680AbgCOB3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 21:29:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgA6EBaojAjsbYUZkCAQrEFbzgUo3q4xT5fS5ak+pDgKm4cn8sWysNdVmSYe9fNOJWx81lA7cVjAC/sLuFb9yLJFgihlKiOn38WHYfaKaJJ5KhoYqV9R6+wW/lhKmR7mdhUJqsf9Vcp3o2eg9Z7E8N3ZvjEmmUxzWTNDRmm+rjGdSr+l/Tf8ihODLlLvbxbwpjJF4lhpwY8Xsszf2qWzeMZXaWkTXFexO35z1WWVU+tOqTRxpouG3JEDpy0OuUErnwIoZR+A6baTab8h+XiaNKoZAZwA+pg2wP4HXMPMsGKadSz9L9b4z3KPyLoIo5k8uPeRREMphe0JeAukcP5glQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=meX3nDI9o3TzXq867HU1KY3Z19ClxKI7SASWGcBAVMY=;
 b=VICr7+cdW53RWeCIuv9W+Zt05MmTVwaNvUB+w9qPlQXCX9fjw8KPlMv5pS/aV31/uIOOpxVRdg6CEv3GWY8d3X2Km38nYpoksJZtFJhcjN7zO2Jb/DWhKTnYpMcOM/ju/6reZDfSqzmb90OFoIhrontmBwnhPnZlUjbYJoyqZ568AVH8gpCrESW78hFKqnBDqRjsplYe2bChe29xuku/ZRA0zukeoObaVFmYAdpFkdtDGVGuvnY1jXqUwrMKIel8kgt1kD7Upm6babBz6D/aJNiNGGLeT9bxSTW8YK+VQv+ZzfGIizGqjna071SiYuv7Gb8SkfpuNpDlueXd6HGlnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT018.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::3b) by
 HE1EUR01HT032.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::319)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 14 Mar
 2020 09:12:14 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.51) by
 HE1EUR01FT018.mail.protection.outlook.com (10.152.0.175) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 09:12:14 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:51FA84E8CBF5BA95130215CF09FD6D30ABCD365C58E1B3571D0B5C3CA68972C6;UpperCasedChecksum:724E1E87A544DDE79417B7EE4D3A18DAB804C958AA3068EAD60B899BA2E053FB;SizeAsReceived:9923;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2814.018; Sat, 14 Mar 2020
 09:12:14 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH] pidfd: Use new infrastructure to fix deadlocks in execve
To:     Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
References: <877dztz415.fsf@x220.int.ebiederm.org>
 <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org>
 <20200310085540.pztaty2mj62xt2nm@wittgenstein>
 <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
 <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
 <87k13sui1p.fsf@x220.int.ebiederm.org>
 <CAG48ez2vRgaEVJ=Rs8gn6HkGO6syL8MpSOUq7BNN+OUE1uYxCA@mail.gmail.com>
 <CAG48ez1LjW1xAGe-5tNtstCWxG2bkiHaQUMOcJNjx=z-2Wc2Jw@mail.gmail.com>
 <87lfo8rkqo.fsf@x220.int.ebiederm.org> <202003111148.19578AA@keescook>
Message-ID: <AM6PR03MB51706BB74E5588128CD62D64E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 14 Mar 2020 10:12:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <202003111148.19578AA@keescook>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::21) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <23b22eca-8f06-6036-c51c-6a87f559c2f6@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 09:12:12 +0000
X-Microsoft-Original-Message-ID: <23b22eca-8f06-6036-c51c-6a87f559c2f6@hotmail.de>
X-TMN:  [TOOIoRbPJhaUmm2QCnSS9uc4EfUfaL77]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: a164edd3-e313-422a-b43f-08d7c7f7c8f6
X-MS-TrafficTypeDiagnostic: HE1EUR01HT032:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: znmYawuvz+lGrWm1cAxK0euN4MrulX7G+PBhM1sc4edD5nzygIAKiwLMSzOnY7xsThbpCks1WljtEa5ZWBweKKL0XGp+bHawdpEBboevWTU8fpcUS8FStquC7+4SWJqyRkqiO+0oGBVXcm60KDThihFebKaL0n+VwITjQeQN5naqeDUW4M1pWgtmRnqsJmj9
X-MS-Exchange-AntiSpam-MessageData: y+wj5sYdckEoDefowsMI3A9TmwPKNEM7n8/Hf4DKDIMVJ8cJSvf+RZgVU4VB/9wB5Vl+1yIW+wgrGsdwV0TJiP2YZVCtf2ghS55wN32nc7BLPdlvNs5SaHDcRXxNKk+Q3i7Zbey9yDoqcYY10YSgnw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a164edd3-e313-422a-b43f-08d7c7f7c8f6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 09:12:14.1943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT032
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

This replaces Eric's "[PATCH] pidfd: Stop taking cred_guard_mutex"

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
