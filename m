Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBBE18D93B
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCTU1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:27:48 -0400
Received: from mail-oln040092074062.outbound.protection.outlook.com ([40.92.74.62]:50153
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgCTU1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:27:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAtsIeEBjXbaQ3mdg4TlfmCbgXXEFw7FElal2WRXFftl38kccc9fJEvkvWA5Rsa7OiHdwr6t26axOdBovZrjiu3FdUXN7o06EWoblxrQyxysht80U5pooIHXD3zq96J52sCtose2AEh0SYN7RoYcW+ld8nQdVsqApD1j3wYeRF6XoAvo2/APFIwxZdH0WcI/5HMH0goUEhHm+UtKGs+HxKa5/4zYM2uUfA4khzGpEsS2owLOyniR6FVBuLyq8g5kf/yJBgsXVdigB0F8vtpfAG0Ns6XFMWqXDIOzbBZlraNbs3yFrRWEgCP57oQNV2CnabX6NmbE0xAUxMWNSUJ8KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNoysm1NEM+uK0Qpok8HGY+SdB/cu3DfrcgQyZJAOyQ=;
 b=GJeslHd6oZBtoWhgH6cVYLiBaLvLgWWoh9BsU2p5BLxkVGHKQRDc5Dm1i5zTokz2aku0k6HPaSy4Xup1KEecLp0alL/PUiSPrDkUHsO3nYTN3nw3JfjuGuXNeEt+7KmHE8oSfE2m5HV5btj+o6qNqUNLsnBMRn7T1ruDwMV23BuUMjo5DtyJDVnBCpXWcHcBiAz57N40rZZRK2aNrRt/IXesRHYNhJVVm3My5I62ZpMoWcz8LM2dRM1PnpG57Wm/RuL2ga+tqFS27LiEISO5PJal8VvECYF5NzAe5KH6rvoaTGnLFtJEHeGE8s7JHiCVU2wBfqeSODsnBWVMvhp/4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::35) by
 DB3EUR04HT134.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::356)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:27:45 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:27:44 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:65D9A53059D0CA393912EACF28F4CF314EF9AF6B3DD0105B6F1F371DE17F8FA0;UpperCasedChecksum:3D462F6C3FF845464835E354DF74519615C4760264D46DF00FD5682C06B58D94;SizeAsReceived:9420;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:27:44 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 12/16] proc: io_accounting: Use new infrastructure to fix
 deadlocks in execve
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
Message-ID: <AM6PR03MB51701CB541B08F21D56DCAC9E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:27:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::8) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <8decd8ec-90e8-373e-7936-d8b6b1e5341d@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Fri, 20 Mar 2020 20:27:43 +0000
X-Microsoft-Original-Message-ID: <8decd8ec-90e8-373e-7936-d8b6b1e5341d@hotmail.de>
X-TMN:  [N+35OmbNjv1CQNurlagqYXNCeAVMja6i]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: ad62df84-7b0d-4c27-ece6-08d7cd0d25a6
X-MS-TrafficTypeDiagnostic: DB3EUR04HT134:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CMmIEn7POoXmYwst3A8Ac+Npt/0Xx0XLq7/Uu/GArKPvAa7GWRJFKTRFlZMUo8DDPrGvcV9vVV0FiOvgzjwJrymGYzKoJMUH3Qb7gmvmqoKwB139tKa1k7YzSVh3ip5ZMwKwEl7Sf6BsOSvP6srPxtJyHNSdC4ULFMw8OmxvYHiPhwN3q3hPmKZ7LLFcZnWi
X-MS-Exchange-AntiSpam-MessageData: KIhviCliUNuh0YvP/mxJmNKch9/Kc9L0JYtbAZKTGds6AVrrdp3D+i8By6fjcEAKZnfY1cMesz6DkrBgTyE88+srVqJsByJjAJ4fklIS7suTwW4c05s1CWP0p5zwGx9MdseVUTIjuA5xBoEpl457QQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad62df84-7b0d-4c27-ece6-08d7cd0d25a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:27:44.9128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT134
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This changes do_io_accounting to use the new exec_update_mutex
instead of cred_guard_mutex.

This fixes possible deadlocks when the trace is accessing
/proc/$pid/io for instance.

This should be safe, as the credentials are only used for reading.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 fs/proc/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index fed76abf..6b13fc4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2861,7 +2861,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	unsigned long flags;
 	int result;
 
-	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	result = mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (result)
 		return result;
 
@@ -2897,7 +2897,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	result = 0;
 
 out_unlock:
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 	return result;
 }
 
-- 
1.9.1
