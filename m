Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E3D185737
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 02:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCOBd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 21:33:57 -0400
Received: from mail-oln040092066041.outbound.protection.outlook.com ([40.92.66.41]:39502
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726713AbgCOBd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 21:33:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2JGEaFYwYJEyZPREVztBw/1m9NJvuDWX90umxUK/jlJldCzw6ipz3fKm0jSf3L9ww5zTjsC9TYonX9rTtVrqyG0P+24nlSoCS1WTLzCHzTPsrFivWoJHC25qWRUXfkPGonnDSUqpjZEuYB3CQlsU24R+naQAcPwHv3JI9dqb65HexU8O2zl4Crj1NNyLmc80OZ3YM/8S7VpB8b4jdu7Xlq6uMh4ihw+5kAW20NtzBWtVcWQY+HjhZ7ISawmBAad7n6DpWgFIAuR056OM9Ue03iAtG8fv0EJnGrnUgnpyLMU+KSxAKgEbuv0yoUuQAbRR1HUdKDQR2O6Dgfj+NTPVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbE3uweMaaHJaWUfWTHug4W4TVzDc7pJcDEE3TtdOYE=;
 b=TTKUMfThpECLe7G+jrCqcmYdw/WLzd2W4tKW254D4d+uDk3aPjk94SdgyHFmyJOu8d/0fsWGPVyTwAeUOyr7MErp5h7SUtYg7Ncl9anfskp/2t3VpPqOrUasKGHrkll0ijaqwgLRwwUXQl0DmkMTx4nrCJ4PrrfbjmmGRWeCiQPyIKPGw+D89z3sdPnCDVQfs9uANYuGmgfDTOez7gWVHuA0pxsUj2Agjc/1BNfWSs24EiwnNdZYaPQFtzYs+6DL5zpLehAFY3+9vYiTcbVxC4dhFmkrlXeEyOlTLcQ5T4+f0KyTNsWH8K3RfvTtDW4fAXhRPd2cgUffofhrblNgew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT018.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::34) by
 HE1EUR01HT012.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::79)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 14 Mar
 2020 09:12:46 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.51) by
 HE1EUR01FT018.mail.protection.outlook.com (10.152.0.175) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 09:12:46 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:EEFED189FB7E781DFD65E1EB063B25B78C1D5D6E449ACC0F326C3EFD86AFDEBD;UpperCasedChecksum:763318C5EF22B2B27EBCBE92ECB34B0D0C5CA3D20A0C9E8BB989FABAA0EAECF1;SizeAsReceived:10376;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2814.018; Sat, 14 Mar 2020
 09:12:46 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 0/2] exec: Fix dead-lock in de_thread with ptrace_attach
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
Message-ID: <AM6PR03MB5170396D87DED49FE00BC624E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 14 Mar 2020 10:12:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0006.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::16) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <85f93145-03c3-9eab-458b-eca9e4f96dca@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZRAP278CA0006.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 09:12:44 +0000
X-Microsoft-Original-Message-ID: <85f93145-03c3-9eab-458b-eca9e4f96dca@hotmail.de>
X-TMN:  [HGNVDl+fo+q1MOx4BdQVKdKGq4mHjN9J]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 6c6f3025-896e-4494-0afd-08d7c7f7dc2c
X-MS-TrafficTypeDiagnostic: HE1EUR01HT012:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: syS9h4UbqfmM+o42cKahLPKcRkr07jSOIAN0IPZZsqtVAeQySjJJpQg17ZJiwj+i4NWCvKBz/LONLLwc9W0j8XJjETowVPJowNpTL4r+muwxEPOGgCKRto9ahb6o80dPH1XQzHthuEfn9w2ZiUaU3Yr1Dgt5TwolqIofUsPjsKX3aZju+LnXm+FBnkZ7t7eg
X-MS-Exchange-AntiSpam-MessageData: B2plmnkFfYINcAorh99ZPutdmrWMWqDd18F6vKzATcQctW0FjSc87W1JRGYq7wy4fjC3Veov/kcWAQk+uRV4y+RFEoBOGSrky2u04BLgk1B5OuU3vlabGQHugYiqEDLg+7otLdX/yis3pe03w2ULzA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6f3025-896e-4494-0afd-08d7c7f7dc2c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 09:12:46.5945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT012
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This completes the new infrastructure patch, and replaces the
cred_guard_mutex with an exec_guard_mutex, and a boolean, that
is set, when a dead-lock situation is detected.

I also change ptrace_traceme to use the new mutex, but I consider
it a bug, that it didn't take any mutex previously since it calls
security_ptrace_traceme, and all the security modules operate under
the assumption that execve is not operating in parallel.

This patch fixes the test case tools/testing/selftests/ptrace/vmaccess:

[==========] Running 2 tests from 1 test cases.
[ RUN      ] global.vmaccess
[       OK ] global.vmaccess
[ RUN      ] global.attach
[       OK ] global.attach  <= this was still failing
[==========] 2 / 2 tests passed.
[  PASSED  ]

Yes, it is an API change, but only in some very special case,
so I would exepect this to be un-noticeable to user space applications.

Bernd Edlinger (2):
  exec: Fix dead-lock in de_thread with ptrace_attach
  doc: Update documentation of ->exec_*_mutex

 Documentation/security/credentials.rst | 29 +++++++++++++++-------
 fs/exec.c                              | 44 +++++++++++++++++++++++++++-------
 fs/proc/base.c                         | 13 ++++++----
 include/linux/sched/signal.h           | 14 +++++++----
 init/init_task.c                       |  2 +-
 kernel/cred.c                          |  2 +-
 kernel/fork.c                          |  2 +-
 kernel/ptrace.c                        | 20 +++++++++++++---
 kernel/seccomp.c                       | 15 +++++++-----
 9 files changed, 102 insertions(+), 39 deletions(-)

-- 
1.9.1
