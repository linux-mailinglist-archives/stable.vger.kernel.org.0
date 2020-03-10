Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCB3180536
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 18:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCJRpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 13:45:55 -0400
Received: from mail-oln040092074100.outbound.protection.outlook.com ([40.92.74.100]:26357
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbgCJRpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 13:45:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKgzFyPeDRQvAqZbHDTA6PC1nkisjfygtDL7xDQwxcs8c6kW0bEHLUdg4+WxQKfxoE/MXpC6KV/FvSyY5G6dvHD3mmg1nK5lg9aHJGO1EGU0CaIa+NayBBFRGKT/7fSjA3OKJDpYKq2V2Jv+b4PYFf8ZkY1/pZgR+OT3pYdJU74yXeLWFv3jJn2Fq6qeTbtzMiyd/pTSXCnVYOHxyxXYc11QqJCTC+bktozkO1qhbrdzzbKPTPhKbLb0aym6Vy1IhHiKnI+jC1sgs+/3FOnAJ68WB1QtzsF34DJxI17encF4CGaGYIihfpr1TeEBiS6WLwtJjdIFvXj/fU6YD4jjtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOA+i8XcR3dkQpEfOU6A2i9UgdiEg1obJk7wzBeLiTw=;
 b=Aba/3kK5VOQWmRrWRs38dX1EjIyEUV8wL57CbvHTjem8V9bBN9Dv0TuzxNmGcoOo6/HC6abv77QQVGTiHZi4TqpLmEblUhIMJlWBdfezOKK/BbHslEb0ClBWkHkZqH40PbP4m/ExUmyaUGvXqeDgPPtkMys8G1Tvnu1oQThrC0Ev+97PmbYWBdfBSZN9+H1L1+/9TdfN4gBWKlIs9peRjwiN7AKOzYfd2rwMgCBBrBJSnRmvWhK1AmGGLV9oXMNQJ3CIDkWigN5sWtOa3YXs6K4ZXFWJGoa1CxUE/YmLftgo1Wm0pxYL4wHIxsL8I16nxXHPoySXLBX+Ge06wkk2zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VI1EUR04FT026.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::3b) by
 VI1EUR04HT244.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::347)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 17:45:50 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.28.55) by
 VI1EUR04FT026.mail.protection.outlook.com (10.152.28.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 17:45:50 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:4AE4C90853D8DDB61D15FD78AD842565F3BCC514A17005AD0DC52AEA26DFE82C;UpperCasedChecksum:93DC566E0BA2CB19E0B93FC62F35DC63F7A4E0955B4D558E5F3153D195CD6EA1;SizeAsReceived:10341;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 17:45:50 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 3/4] proc: io_accounting: Use new infrastructure to fix
 deadlocks in execve
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
Message-ID: <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 18:45:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <875zfcxlwy.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0028.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::15) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <300abca9-375c-58ec-5cef-cbf1406a4464@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0028.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 17:45:48 +0000
X-Microsoft-Original-Message-ID: <300abca9-375c-58ec-5cef-cbf1406a4464@hotmail.de>
X-TMN:  [XCvP3XhmcvfDfjTzxvAK99X2UOOLZOyp]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: efb675c5-cbfb-4af6-12cd-08d7c51adf22
X-MS-TrafficTypeDiagnostic: VI1EUR04HT244:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZXrqPBjWbqOhkxrLTTusV/4/SaJoZmBMpE69amyQ2X7XgH6Wkmjuksf9e4l+mL34VfzmRAPiDoWPbzpD6lOt8nTC47JMpm2FnosaaJORYu7nakXyXB5rGhJM1723qUr5kPkPdFJDmfpqfa2UUSxIKbuU1B9NXAH8xAV2M1SY/1pmMGbKSL9KHI0Gsi1j3BY
X-MS-Exchange-AntiSpam-MessageData: XUVtpUlamwAcWN3pgCDDxgnnyUIjSy/DoS3WNkkxjMEC5PMbEKiFoca7ABgSePO8N+zF7Lu4HcdIarJVa9FTb1sDw2iBVjG2Zc9sOu37RDb5Ha5tDA8wDlFpEpchBxs2uLif+MKQ/wZBjXIpF5/5Mg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb675c5-cbfb-4af6-12cd-08d7c51adf22
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 17:45:50.2526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT244
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
index 4fdfe4f..529d0c6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2770,7 +2770,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	unsigned long flags;
 	int result;
 
-	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	result = mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (result)
 		return result;
 
@@ -2806,7 +2806,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	result = 0;
 
 out_unlock:
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 	return result;
 }
 
-- 
1.9.1
