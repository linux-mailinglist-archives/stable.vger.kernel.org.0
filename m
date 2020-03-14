Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64941856DA
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 02:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgCOBaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 21:30:17 -0400
Received: from mail-oln040092064016.outbound.protection.outlook.com ([40.92.64.16]:7102
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727124AbgCOBaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 21:30:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHpML/EatMPKjYYuw1j/ThmWeg2s0Po94lxL/ljVtowp02IflwlHIHft8PrP6wCnlgcz2xqbiNMzB478cqrLROS2HD/6bBtr9jtBWG+UCzKiAa2fXcxB/kTwUTBZvCW6ROpCLCUXM5DoRtR+64PsOYuVkLi4d0OWIm1+odzdO/UkvTEsmC80TqryP7vGBYdLD5CBT/6qD8aEFMIonKbNo59QTmIQOnkYAJtzpwZ6Z4z5s18tmxCGUBw9vMXZRJQoV9nokc8nklE5v0eSbIuil+A/rD7Ogo1H36fhLVO/6GZub5acmwVZrBQJKUDsoj2Aa/IoLW6vlvznqvxrTp8X1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRmAX/OI61eqhmXCBfdUBr5C1G3cnhhM2qWyStJQ/Yw=;
 b=HenlQ9+aFC5HBN6rwloSpFJaPBriPcsnwMpyYsXBANTDhgosctoCjVCLu7Q4WxwYnJJcuhmq0FGue5QnCYwOlYZjH4nKWv1iw7C7dCh1mBkomm1I6nKTjxwCSOwPokUZPrj5kUAZ+wswB2zuF5jAXgz/7WypfXqSkdK1MYVHnulonzEOUJhXJ3uekfg7JkRPazec9VGcdYGpVyZmuah827hTRpyVYMOX8ajzDqg2wDiUbi3fa8E60OFY3t6jyPXEtMrM3nT9hO8zQyyYh/Gb3rjDi2BCFI2aN0vWVYpw+to76v/vSUSTYh1h8N7G9H5dwl+NzP/bQ1zoJxxhmxrXLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT018.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::34) by
 HE1EUR01HT202.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::112)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 14 Mar
 2020 09:13:17 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.51) by
 HE1EUR01FT018.mail.protection.outlook.com (10.152.0.175) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 09:13:17 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:8CE24824D4CF11DA40486AA63BC47089CCDBB38AC67873DB1D11395F2C2A39B2;UpperCasedChecksum:B12F21BDB49347E55AF04C5E2CB763FB8819207BE82B744A3BABAA6E95BDE773;SizeAsReceived:10353;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2814.018; Sat, 14 Mar 2020
 09:13:17 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 2/2] doc: Update documentation of ->exec_*_mutex
To:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
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
 <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
Message-ID: <AM6PR03MB517037F06E72CE4834712336E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 14 Mar 2020 10:13:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::22) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <a76c23c5-67cb-7fd4-ee15-bcbafb7efd71@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 09:13:14 +0000
X-Microsoft-Original-Message-ID: <a76c23c5-67cb-7fd4-ee15-bcbafb7efd71@hotmail.de>
X-TMN:  [lQvF7eJgMD4uU/zAOx7rD1GKElo9G5tH]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 83ea98b6-4eff-4a75-3f52-08d7c7f7ee74
X-MS-TrafficTypeDiagnostic: HE1EUR01HT202:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UsB9oVXwbfEBesf7UzhJXtqcS0bWl4qcLLR7gpYDB+n61LSoPfyhxNMe6FrxFviGSs6YuB+ih1leyGoOPyKx2lxd2Ol4uHBmEediKShyyWFS3OwR4UPZjip60U77V5fJvpWB0e5pxZ2Ct37qSQSkwT88LOTLJnF5o1Pzm+j+w33SSKoTI0K6RTfO7NcejUy1
X-MS-Exchange-AntiSpam-MessageData: D/goxYZYrDp2AhdWso9po/cfkz15IRlMNddhjlrsBMxmiaXO6+KFIfxygpvZzZ9ftikS8c4fTJB8HRg4Jd/GqhENwzhpf8jWrwHnEdGG+ovOpGYi0EiscRJus6hBgteYE9kOMhd6ooXUw3c2Khm6fA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ea98b6-4eff-4a75-3f52-08d7c7f7ee74
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 09:13:17.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT202
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This brings the outdated Documentation/security/credentials.rst
back in line with the current implementation, and describes the
purpose of current->signal->exec_update_mutex,
current->signal->exec_guard_mutex and
current->signal->unsafe_execve_in_progress.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 Documentation/security/credentials.rst | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/Documentation/security/credentials.rst b/Documentation/security/credentials.rst
index 282e79f..fe4cd76 100644
--- a/Documentation/security/credentials.rst
+++ b/Documentation/security/credentials.rst
@@ -437,15 +437,30 @@ new set of credentials by calling::
 
 	struct cred *prepare_creds(void);
 
-this locks current->cred_replace_mutex and then allocates and constructs a
-duplicate of the current process's credentials, returning with the mutex still
-held if successful.  It returns NULL if not successful (out of memory).
+this allocates and constructs a duplicate of the current process's credentials.
+It returns NULL if not successful (out of memory).
+
+If called from __do_execve_file, the mutex current->signal->exec_guard_mutex
+is acquired before this function gets called, and usually released after
+the new process mmap and credentials are installed.  However if one of the
+sibling threads are being traced when the execve is invoked, there is no
+guarantee how long it takes to terminate all sibling threads, and therefore
+the variable current->signal->unsafe_execve_in_progress is set, and the
+exec_guard_mutex is released immediately.  Functions that may have effect
+on the credentials of a different thread need to lock the exec_guard_mutex
+and additionally check the unsafe_execve_in_progress status, and fail with
+-EAGAIN if that variable is set.
 
 The mutex prevents ``ptrace()`` from altering the ptrace state of a process
 while security checks on credentials construction and changing is taking place
 as the ptrace state may alter the outcome, particularly in the case of
 ``execve()``.
 
+The mutex current->signal->exec_update_mutex is acquired when only a single
+thread is remaining, and the credentials and the process mmap are actually
+changed.  Functions that only need to access to a consistent state of the
+credentials and the process mmap do only need to aquire this mutex.
+
 The new credentials set should be altered appropriately, and any security
 checks and hooks done.  Both the current and the proposed sets of credentials
 are available for this purpose as current_cred() will return the current set
@@ -466,9 +481,8 @@ by calling::
 
 This will alter various aspects of the credentials and the process, giving the
 LSM a chance to do likewise, then it will use ``rcu_assign_pointer()`` to
-actually commit the new credentials to ``current->cred``, it will release
-``current->cred_replace_mutex`` to allow ``ptrace()`` to take place, and it
-will notify the scheduler and others of the changes.
+actually commit the new credentials to ``current->cred``, and it will notify
+the scheduler and others of the changes.
 
 This function is guaranteed to return 0, so that it can be tail-called at the
 end of such functions as ``sys_setresuid()``.
@@ -486,8 +500,7 @@ invoked::
 
 	void abort_creds(struct cred *new);
 
-This releases the lock on ``current->cred_replace_mutex`` that
-``prepare_creds()`` got and then releases the new credentials.
+This releases the new credentials.
 
 
 A typical credentials alteration function would look something like this::
-- 
1.9.1
