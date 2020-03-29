Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB076196B87
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 08:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgC2GgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 02:36:22 -0400
Received: from mail-oln040092072031.outbound.protection.outlook.com ([40.92.72.31]:43515
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726912AbgC2GgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Mar 2020 02:36:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxQBZvT1De1T0Q2PiYx+KqrbhtmorGJ4L9u35Mejs0hEteq0+H4qKdVhbpbHX6ux6SJm1Mv8ZtZ0vDagII2XZYHXH/Nk2ioh6z9QHGQIckce++W/RsHyFZnnvNAsR0aSV8BEssReRaEENV0UvLC/O5Rypt0GWeQEiBQ2vVD5ev0eBg7V5z3D97xa9w4ZB5tEtUl3+eJ4RcC4RUy8p4GRvaboWC+geeBPrdwCS2FvMklCGBWx9xKgvOC33LcYUKR/e+V/DnVyRzEOX7Ht9Bck9RptcZhQYB7BtPWoHsfIwBSokFWgJ7xHSFu5AOgh2QjpnBnGKlebjW/4ZZwqqXJe3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fwp+uQ8HM8pwpe8ZH/JzuU7EHAJYZBBWZMnostibveQ=;
 b=SrV5wO1SmDM+k30P+vb4UW58n0ULyNOGp4D7KbOV+bBUoiTxc5bCa8Veno00mVpgaV7s2JqPg/WiUGcBqorttFvJaUlVG70HYCIZ+wTkMNLJcAz+rCrZ9OzlrcnM2VBqrjMHEtG3k6kfXbXsgOtFzu5MtJQ/zKqnxBdxp6NcCI75E/6r+OBUIpkcFx//8hgSrC+CKuQHRDzSomWy+Vc0SSIwgCpi6nvudyDs1pdlAWZNRDhAXBcfjp28Bx4L/hWGV2co9pTwamUMeQzn7aUYHQmpmld8TJatmV/JfmeqjaQG+X4wxtrNHQ6we+VxI0kHglhHbLHhBZflMcDjKMeiGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e09::4d) by
 VE1EUR03HT115.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e09::268)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.17; Sun, 29 Mar
 2020 06:36:18 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.18.56) by
 VE1EUR03FT041.mail.protection.outlook.com (10.152.19.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.17 via Frontend Transport; Sun, 29 Mar 2020 06:36:18 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:9C4D017BA2481E7479A2C2531E34F8C07BDE1FCF52BD939200BB0D77DF220E73;UpperCasedChecksum:66BD48ECA13AC4D92CFCF8DB80D93BFE98FA00C1F0ACA51A672F531C510B0964;SizeAsReceived:9666;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.025; Sun, 29 Mar 2020
 06:36:18 +0000
Subject: Re: [PATCH v6 15/16] exec: Fix dead-lock in de_thread with
 ptrace_attach
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
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
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
 <b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de>
 <87a7448q7t.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51700B30078BDCB6C6A4E0CAE4CA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Message-ID: <AM6PR03MB5170480FE4462D0DFF04B14BE4CA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sun, 29 Mar 2020 08:36:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <AM6PR03MB51700B30078BDCB6C6A4E0CAE4CA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0038.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::7) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <468cc5cc-9ac0-190e-c869-afc8eeb4264b@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0038.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Sun, 29 Mar 2020 06:36:16 +0000
X-Microsoft-Original-Message-ID: <468cc5cc-9ac0-190e-c869-afc8eeb4264b@hotmail.de>
X-TMN:  [YSNqkoVkGPbE9LVpfsvLuc8avDaSmBwm]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: aca972d2-0306-4c2d-f6f3-08d7d3ab7c7f
X-MS-TrafficTypeDiagnostic: VE1EUR03HT115:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w74RRcKfQNGFhv2iIUBASQoDIm6/Pxdz8wDja7713bv3BcDYbTL1fNdsRWtgWCOi5XZC64ZKdo9u9cRoHwlJXu2jQB72Xx9EaTFYGTu6zp337qa+cDIyuLJBAjUltGhoAtrYyrGv0QfPwjrK9xSUBb+kBZ6SUKtjMhFsHBgKxSDlMWoiXhsuGMp8ZzTSJ1Fo
X-MS-Exchange-AntiSpam-MessageData: d3puSzqSYI2uPhPDzZu5cNqyZHjfI8e3lGyn9tAhrbSbUYVC3bynFSO+qK5hfe02MW20eZpTFX6MQPgEXvuFkzDlrTXAL3NoDpOu34O/W4PpLvp7TtdoUQGG5BI98Kv3TrtbZUZbw9/2koKUhgM8/g==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca972d2-0306-4c2d-f6f3-08d7d3ab7c7f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2020 06:36:18.1761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR03HT115
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/20 6:31 AM, Bernd Edlinger wrote:
> On 3/25/20 3:27 PM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>> At a minimum the code is subtle and I don't see big fat
>> warning comments that subtle code needs to keep people
>> from using it wrong.
>>
> 
> Okay, I can add big fat warning comments, yeah.
> 

So how about that:

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 221759e..2d6b5cd 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -395,6 +395,17 @@ static int ptrace_attach(struct task_struct *task, long req
        if (mutex_lock_interruptible(&task->signal->exec_guard_mutex))
                goto out;
 
+       /*
+        * BIG FAT WARNING - Fragile code ahead.
+        * Please do not insert any code between these two
+        * if statements.  It may happen that execve has to
+        * release the exec_guard_mutex in order to prevent
+        * deadlocks.  In that case unsafe_execve_in_progress
+        * will be set.  If that happens you cannot assume that
+        * the usual guarantees implied by exec_guard_mutex
+        * are valid.  Just return -EAGAIN in that case and
+        * unlock the mutex immediately.
+        */
        retval = -EAGAIN;
        if (unlikely(task->signal->unsafe_execve_in_progress))
                goto unlock_creds;

Is that cool enough :-)


Thanks
Bernd.
