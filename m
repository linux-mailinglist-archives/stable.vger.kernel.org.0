Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC7D180526
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 18:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCJRpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 13:45:03 -0400
Received: from mail-oln040092073018.outbound.protection.outlook.com ([40.92.73.18]:53252
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726426AbgCJRpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 13:45:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiHAjlXN5qbXMDD/JfnNPl8ui7XjhtGKpAVhyYJg+ASIz3Q9Z/iHNjcuMCwgzIe2TuaaZbn92/HEh/ePqzt3hRrMiDbruaIk7k/XsmcfWn6YQfxlougYTTa4nHK4A20Op4jyTMEcfgcoI9fPm9/pZyY/Cjp0ELAOEZyQ332IHzuqS3UGjXwNmLgd8fGmfAGkHZnxF1l0q4eMLC7ZPZGzfCD5znnX2AZXVRK3rijSS+k2mQoDeTQsDOKQfkT+2WmeqAO1wP3wmjBeX87YJedusp13QX2c3yzNkLgcAAN/olKBOxGxSbeWKCRtzMqKDbdftpz9697WyxSdEVslY/+avg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuaWEum7LK5Nl7cZXTekI4XxZLLAjLTVPkstbsytWsg=;
 b=Q8CKrt+MYJx9SHeuqtOGC95NMar2ZZmlO9Ew49sY87GJzG5KCjy59dHbeWZjmeWgqdVmmu6D5Ol7x6HfvvzLFxC3plDwJ6SoMmYok/87GBfdhNegK33iwK92c3SiDndVFsQyf3jSL6Mmfy5JVDGOedDEh47NdxiMQuR9LtiwR/J8Zeup7Ck4Clc6lRwA2g7v0Iq2YhPE+sJytnphDFD8YYLiqupx9lYc8JPn13D+SSDZtwkewyidIKb94qHnydF4PjCBEdIWyQwPcjrmyJ5pMLhwr3PSpnvhZpAo+hbkhMJtWD9YbJcDenysp+pFIlPZfXMabj9sz6ENxY8V79PrtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VI1EUR04FT026.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::35) by
 VI1EUR04HT216.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::267)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 17:44:59 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.28.55) by
 VI1EUR04FT026.mail.protection.outlook.com (10.152.28.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 17:44:58 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:C66BBA9DCF3DEF17BD261EB77DD16B1009977AC6629A0E946531D39E32E4A8B2;UpperCasedChecksum:C8909EF579CC562BDB35BAF1EEE3308423F7F4F39EBDA1D2FC7571AEE4B7887C;SizeAsReceived:10297;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 17:44:58 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 0/4] Use new infrastructure in more simple cases
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
Message-ID: <AM6PR03MB51706494EF199E122CC041F7E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 18:44:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <875zfcxlwy.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0029.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::16) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <f0594757-fe9d-8351-3a15-014e4405ec22@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0029.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Tue, 10 Mar 2020 17:44:57 +0000
X-Microsoft-Original-Message-ID: <f0594757-fe9d-8351-3a15-014e4405ec22@hotmail.de>
X-TMN:  [7Oc0vrg7P6uiu2oSmedJe1YRpn2rdLIM]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 46783fac-8b56-4ade-3c8b-08d7c51ac071
X-MS-TrafficTypeDiagnostic: VI1EUR04HT216:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dScJnprfhiGs+zwiR6Q8vhFisfXCU/4VIETMRLi7yBeETADvAFnElQZ+OAp+OFPPMB/nGuhfQN1sraJYboXfy04Q/w1tbBng/XS57EOiKeQ3I9toRnfLNcd/ZRk0ZJCEOAbt1yuGBGR95yVqcavgJ99BiSUobmxgYGD/g4DBY73XVy+2o9hZclDpyPttQClt
X-MS-Exchange-AntiSpam-MessageData: zx7zqshi40iLJe5uMRi41B5/qxktXGuQWDGut7otpSDOKVcnKYmjgzOqFW2lOhUjB3WB81riMF7Okpjhnmu4kgYKHJ3WAnf4ScmSoxCnu+Xh3bCCMcX3n1io8+lVtloGSOWxkRiwoveVNEp49mprBw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46783fac-8b56-4ade-3c8b-08d7c51ac071
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 17:44:58.8690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT216
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This continues the execve anti-deadlock patch and addresses all
of the (mostly) simple cases, there the new exec_update_mutex
can be used instead of the cred_guard_mutex.

Note: each of these patches is independent of each other, so
in case one of them turns out to be controversial, that does
not affect the others.

Bernd Edlinger (4):
  kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
  proc: Use new infrastructure to fix deadlocks in execve
  proc: io_accounting: Use new infrastructure to fix deadlocks in execve
  perf: Use new infrastructure to fix deadlocks in execve

 fs/proc/base.c       | 10 +++++-----
 kernel/events/core.c | 12 ++++++------
 kernel/kcmp.c        |  8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

-- 
1.9.1
