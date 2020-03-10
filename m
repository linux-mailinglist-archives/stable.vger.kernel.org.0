Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A98417FEE8
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgCJNn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:43:28 -0400
Received: from mail-oln040092065090.outbound.protection.outlook.com ([40.92.65.90]:30183
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727312AbgCJNn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:43:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMN6w/Qr/aS+HIOfZPZ5/HS/kEaZhWvScWGYXuxjLY9WPXvIlNnaRl2RxRBJkYp9LsVyZ5h2jRsUwI6i7IoMvi1bRiafxWezUycxxBDBtBY2427+Q+cfBK2/yPcNAfBxaQ21trd3Kbc8KYnwkNAqXKEbj7oPV7FV4VIUku2HQmBh2eBs+xKzUjx9gc3utBJbDeU/+3eDCCujn9dD+6tzRiBfqUJyA74cP3nMCkqXDmIoQNLakQdgNdcuORh9N9rtkCOx4goGZzsm8/fIoLw4WkDh32o3whyYGtkXKEA2dpwRfp+BC/DaAYBHOylwXBB7McYM/VrsHGSWJln0JKbv4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTIzbf6Kcu4NlVyKdTF/2JwkVBkFSzRIiCGYzIWzx7U=;
 b=h9QF3UhrzTj4e/81LMmX0Ji/eLV2aiCo+nL7CpLUd/qLUdR9H/fsmLHQZDBFIbmrWctZlBTOto4mqvLUwkCGkQ2xoD1TCjbMuiaaAFAhVc5/abY99YEfEMRYkUvOVgzrqfzhw3kYc9YKJXenNf2LiGvLgZJzKzDFHXg8YkubiPWzxXFH6EcmBBrDZiAx2gWnfkE1ta77q4HVQT5khORC9s1V9UpUkmhB/OQscEd8xuET45BLJKrLjh/fFUbFTTFS2a8x1ZsEujHao6kkZIxctxStZkXJx/R8riT1M99Ri6a36kPed5b6WzNXAW3+So0Qg+zZhSEMM8w5KmV0Q0GnfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT023.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::3a) by
 HE1EUR01HT009.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::488)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 13:43:23 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.52) by
 HE1EUR01FT023.mail.protection.outlook.com (10.152.0.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 13:43:23 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:BC32DD4A261A6B8205E6ADF6EAB85B37EC990743ABB9F94782C126A987649264;UpperCasedChecksum:35D01622DF07921CB9D4DB6EBAE8AA9A4EC44BD275AB2ADAEE31F947CB5AF6DD;SizeAsReceived:10306;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 13:43:23 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 0/4] Use new infrastructure to fix deadlocks in execve
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
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
Message-ID: <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 14:43:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <877dzt1fnf.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <c7315cf7-713e-5b1d-38f7-20f77d3babea@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 13:43:21 +0000
X-Microsoft-Original-Message-ID: <c7315cf7-713e-5b1d-38f7-20f77d3babea@hotmail.de>
X-TMN:  [brG/2mTCvyYYudno6HDU6fhBD8F14Y7+]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 10d9e532-7fd0-4b56-d300-08d7c4f9006b
X-MS-TrafficTypeDiagnostic: HE1EUR01HT009:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpfFSpSqKmus4lGNhEHdz7J7tlMiA/tSubeDZRFzX52cevNYsjMTr1uWuT8AbioUTZkwNOO4/GJPHzZYVcI2TAl5cWNaqLHSfnwgIxMORe7Svl1uJd8HFmgKr7IiZpbiHIpUQQ4tbkU8BhwpTwFq7DUi1rgPN1CR9ESMpMMRhORTn7MGYLayQTTXqv1C0zdz
X-MS-Exchange-AntiSpam-MessageData: HovD+oKudL+zDQeiwb8n73p9ytIxhfk+yzOEkn0mybXKdEQbxNrH6ctVE3knvAgLYmSqR2tvFNxsbDWZrrPu+frQIKPfS3UDRTETi4Nfq1EApXmHeGw5lZX1aV5oM0cXbi2AlwRkL41XCTZrRjAMjg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d9e532-7fd0-4b56-d300-08d7c4f9006b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 13:43:23.3299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT009
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a follow up on Eric's patch series to
fix the deadlocks observed with ptracing when execve
in multi-threaded applications.

This fixes the simple and most important case where
the cred_guard_mutex causes strace to deadlock.

This also adds a test case (which is only partially
fixed so far, the rest of the fixes will follow
soon).

Two trivial comment fixes are also included.

Bernd Edlinger (4):
  exec: Fix a deadlock in ptrace
  selftests/ptrace: add test cases for dead-locks
  mm: docs: Fix a comment in process_vm_rw_core
  kernel: doc: remove outdated comment in prepare_kernel_cred

 kernel/cred.c                             |  2 -
 kernel/fork.c                             |  4 +-
 mm/process_vm_access.c                    |  2 +-
 tools/testing/selftests/ptrace/Makefile   |  4 +-
 tools/testing/selftests/ptrace/vmaccess.c | 86 +++++++++++++++++++++++++++++++
 5 files changed, 91 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/ptrace/vmaccess.c

-- 
1.9.1
