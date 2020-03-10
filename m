Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59AD18052B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 18:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgCJRpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 13:45:18 -0400
Received: from mail-oln040092073033.outbound.protection.outlook.com ([40.92.73.33]:20294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726414AbgCJRpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 13:45:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQZVl/1n/5UYx0y4NOGyFbjmxgEBUJ6uczThMreoCeXfSJLiPK8FtnGvwIm/j7TiXD9yV959v87qydwyRvIupUyjcqys6r+NXM6FTAtcam5M2kvk7mB8YafFve1oGeKBZ+n86lAZ8tDNTcnQpjC0x8pGGOlriElTyjztCrWUIE1U42n3OuZ7LqxBvteQ5Vj0GSToZTiAjk6e7R/SiiTv4raf2GOFXlh7HUUIAskfja0XFvP/o4iKzn0HBgNVlXI6oYXoT9Ur1VhrnrOztmfGAO00NWyoz8kgA3Cf5hY0gmdWKB4AuJrh4flfEWFyrJuIldVzhT1OWRyfzQWPxynBJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzW+vQiK0ldXBGN1Gu1zo93EbVuHDeiMyTvYP/RCPok=;
 b=ndfMms03pIShl9Jagnl2Y+jE9uQ50YPvwZ5z57agv/yPvDxTU/jbvXN6cekIkV9haRnHX6U2Z18HdjhTdcnWhT1lGcCeRYmeYN20TI+rvL/wrvEc9T61AX6R4a6j68rlB0lQvz9rrdUwYmzOpiInbIiwrnOgQj4O46FU9nQCnx1yyh9xSC5Dqs5zFfvs2q2/kqt5+mLdxrcoicInxMriC4NW4K5sp1bX9tHD2feGz+Y99P8gwEEOhw62CPapUwzf/2SClKn3n5UUevJLxff+TVEmTzJci25vGob9Q00hyON4cqQ0HXAXcY7tc95jaxBAcNWwL2Lopte220VOnMHRnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VI1EUR04FT026.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::39) by
 VI1EUR04HT138.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::146)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 17:45:14 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.28.55) by
 VI1EUR04FT026.mail.protection.outlook.com (10.152.28.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 17:45:14 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:B58AEAFA45C949DEBE05B6186D4DBF3A704E14AB315E4E49940646D624D8F720;UpperCasedChecksum:D4166CB02D7CDD15B20499B717F39622D99747916CD714472EDDFFCD7D29679A;SizeAsReceived:10317;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 17:45:14 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 1/4] kernel/kcmp.c: Use new infrastructure to fix deadlocks in
 execve
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
Message-ID: <AM6PR03MB517057A2269C3A4FB287B76EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 18:45:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <875zfcxlwy.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::7) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <030a2087-f995-327b-ac8f-3e2a0fda1c37@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 17:45:12 +0000
X-Microsoft-Original-Message-ID: <030a2087-f995-327b-ac8f-3e2a0fda1c37@hotmail.de>
X-TMN:  [wZuXIGcgdH2Q8W6qKNBoXYGYM/eVthBC]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 99a48d4d-ff98-45a9-c82e-08d7c51ac9a5
X-MS-TrafficTypeDiagnostic: VI1EUR04HT138:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PdIIkda5kaGr6lCbIVe8507xJuc7fBfMn0QYZmW8k4t3Q3MbCWDJMMDiWdMmLtl2PFE/YUWOV1FNDYwyRFfzv2vwYeeLLX4U6AlNjdNlzH+bhhOshoQajl8XBjMVIFCeII80crHptCTpj0uLg6yiqXWHj5saLcQQbtl7rsNNXmUiYqStr3jojGpkIk1swnji
X-MS-Exchange-AntiSpam-MessageData: HXLp8eDJv28UtDSkPAAw0rFQcA0ga+EyhrywohzN1kVn0SSi/oegskaWg6Gr4IT9WANm82RyL0ANRHysmEbj+7+qV1s92Cl2DdD5/lj9bCJT0x2UzbSqhrIgG6/7OfnS8+SnsUVr7GQJwQY2LY27eg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a48d4d-ff98-45a9-c82e-08d7c51ac9a5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 17:45:14.2359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT138
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
