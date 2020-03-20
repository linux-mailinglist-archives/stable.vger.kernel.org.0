Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E526418D934
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgCTU1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:27:12 -0400
Received: from mail-oln040092074061.outbound.protection.outlook.com ([40.92.74.61]:21352
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgCTU1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:27:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3m/d2SD+woxZvCmiKSpMYRD5EPTOOPpiRvwDThGTaRPlUm1uEJcHVw+Tx02C14SrAZPZlsKTOWr1F7DAD2PZquYgjhxtKTzBl7JvmPjsAyJOil/26j/F5zcUBy10IDhaOMghQ/4bgGlAK/OjwxSqlSjAA+1Hp6iAHRWpurK1Vg+mUCITnlihd+0QOlXE+2IdZwnhqZGapGy6wJsRFTydcHSefBOAAw+/DJ5RWUakpVD1CmC4kmNqqbrTMxGBX+74LAfbkIi4RZjcSK2Os60xssYY3GtCrApx9L1at/D+uIcjdr5XAIld8rRquSmjm5td+m7YgWGKn6cGkH3Rgpkfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzW+vQiK0ldXBGN1Gu1zo93EbVuHDeiMyTvYP/RCPok=;
 b=UvuHvHn9l6H6t/b8uclnpxNYq1BU3afUwbU5owQ9jAvMhdkJTJJ8vqhUkf/pFkvhNQCOKq/tECBtZO+rBVwibKCfHU9pqYaIFydZQ0kfnx1HWChlGieEVkdxFGmN4YwN5hYt0aufrEA7FMWF1oxZuyFzrsZzp47QJI1qFltm97kZhS4vRVfgLI8fgil06dp+EsO5i8o4fK6/ChokDFh4CxQ94nueAOGwpynYkiLR/jxE9sdG4rlUVhX/4RRFuyRIgplNGNBeGtk7H7K0DJ45hSZDeQgTfOZKOn/BI5CvCivXAZbvF0YSd7CmVVb7uC4mbfpUdrJOs3K8j+q4i2RKfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::35) by
 DB3EUR04HT196.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::385)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:27:08 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:27:08 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:B7940FB6878C584FE4BA8A608B4C2C244A784776753A438D62B4B6B99FE5F7F0;UpperCasedChecksum:E2FA0B6F36253D817039D938D587AAB2B38D9273A5C2E832489D76A5B2EFE4B9;SizeAsReceived:9440;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:27:08 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 10/16] kernel/kcmp.c: Use new infrastructure to fix
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
Message-ID: <AM6PR03MB5170FFDE1D7BF09DD2663EDEE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:27:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0072.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:e6::49) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <75797027-9d6d-eb54-0f39-5ed0de123c76@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR01CA0072.eurprd01.prod.exchangelabs.com (2603:10a6:208:e6::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Fri, 20 Mar 2020 20:27:06 +0000
X-Microsoft-Original-Message-ID: <75797027-9d6d-eb54-0f39-5ed0de123c76@hotmail.de>
X-TMN:  [1ZobPWiHRCzj/8NxpqVhqaIpvepap5N2]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 6592cc8a-a85c-4168-242b-08d7cd0d0fc7
X-MS-TrafficTypeDiagnostic: DB3EUR04HT196:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tcqd9dbQ9Abo+PI27x2INEQaXGGD8MJJ+v5nRyaQTut22CiMfnX53ANyA5m3rIRcytqM1KaLu8HuBVdQjUxjCyW51zIwlkLFGPuipkPmswPnc+E8RzWSQNa2E6ikngfroVJKJCPl18Ff3cEbYBIZnIWfykO2MkW7JmvU8moR6Wo5t1WRbLaa/W2HLh9vcnUw
X-MS-Exchange-AntiSpam-MessageData: hByCOdmwrh7EXOJaLEgpvMGenff/1cDDLDEx+FWDzafw7nbI9Ch11kZm7xv38vIJROvHmfttH4cE3EIKnlsUEcVQLYE/YIO3S6qsJluEmtkGZfo6ka9xKa7nQKmje4ZfAL8cSwK2cb3wGgX67lJqbg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6592cc8a-a85c-4168-242b-08d7cd0d0fc7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:27:08.1951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT196
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This changes kcmp_epoll_target to use the new exec_update_mutex
instead of cred_guard_mutex.

This should be safe, as the credentials are only used for reading,
and furthermore ->mm and ->sighand are updated on execve,
but only under the new exec_update_mutex.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 kernel/kcmp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index a0e3d7a..b3ff928 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -173,8 +173,8 @@ static int kcmp_epoll_target(struct task_struct *task1,
 	/*
 	 * One should have enough rights to inspect task details.
 	 */
-	ret = kcmp_lock(&task1->signal->cred_guard_mutex,
-			&task2->signal->cred_guard_mutex);
+	ret = kcmp_lock(&task1->signal->exec_update_mutex,
+			&task2->signal->exec_update_mutex);
 	if (ret)
 		goto err;
 	if (!ptrace_may_access(task1, PTRACE_MODE_READ_REALCREDS) ||
@@ -229,8 +229,8 @@ static int kcmp_epoll_target(struct task_struct *task1,
 	}
 
 err_unlock:
-	kcmp_unlock(&task1->signal->cred_guard_mutex,
-		    &task2->signal->cred_guard_mutex);
+	kcmp_unlock(&task1->signal->exec_update_mutex,
+		    &task2->signal->exec_update_mutex);
 err:
 	put_task_struct(task1);
 	put_task_struct(task2);
-- 
1.9.1
