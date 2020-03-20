Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC54018D8F0
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCTUYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:24:14 -0400
Received: from mail-oln040092073016.outbound.protection.outlook.com ([40.92.73.16]:14830
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726666AbgCTUYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:24:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB+SzLgw5fb9DlMUuCkR9KshgOxf42Gecy2nvOt2JTMPyjxoSnccuRiKw9N/SVnWBB/hvADbqXslaKfPu2L8FDsBaC2BfFoqiEAbyx8tI2ErStnjs0DY9Ny55/uA4EmkOtuvuaTR2EaEOxIfUcNOASmo3IbGU0+GlTuCByk6GOGk11vmmLpDGjdhPdKmmen7VcpXNGKKkmIEM4XyScd2CZ44C/bk55VzewvfsqttdFxbmaJRZvP95haa71gN3Jer4LKfSQC2Yi+6Ui2i0wENPFecg1aMaFDqWP3dOOxoRa7z1jvYMQzzTHgyaNHD/PPUszLRth9INvMRuVuM01FXrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnzrjsR1MXLEfp6VYylXz8lJomJ1GTiPhRkhVOp2Jno=;
 b=ZalEUzDOZ/npxYTykyNjG3l8jwlHX6GquY9aXLNAtlVL25zZRyTLtgMOzxhshdP17zWCsKvMVJGXqCt3cFbOCUDNYi+LJhAltHW9KW2Fa59Un6J38EK/4XAErulT/7y1330JIfjiJmNeu2Q6V5XGdRuDZ6Yvj7ISNftv+8e+nYe2UBcaOaxJACdgRqZ5QEC/my5ZV+ZMmS5yNlD/GAu3/q9I4VjYq+VEuS30SMwpWh3u7KTbxYicruEGTxnubRzXArk/gjY7g8VoUA9HY1lqpqxf/5l/aMzWdn9Q2UC25hAvpILSH+UUIYk3c/cV/zHrAXyl7lA7q5I8WlILvYs9kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::34) by
 DB3EUR04HT231.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::208)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:24:08 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:24:08 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:AEE64B1550B431206270635F9D8A99774518771E6545A912F7D017D5C57AC256;UpperCasedChecksum:39FFD2F0D261FA8D423CE5CB0EBC04B6973AC5A609322673B09495AF68875B6A;SizeAsReceived:9280;Count:47
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:24:07 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 00/16] Infrastructure to allow fixing exec deadlocks
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
Message-ID: <AM6PR03MB5170B2F5BE24A28980D05780E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:24:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::19) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <0c6e2f5d-4e5c-db65-782e-0f47e07a9ced@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Fri, 20 Mar 2020 20:24:05 +0000
X-Microsoft-Original-Message-ID: <0c6e2f5d-4e5c-db65-782e-0f47e07a9ced@hotmail.de>
X-TMN:  [J1V25By95N2xhKpxjpMoIW+RBDPTCscq]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 47
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: df6b3e20-eaaa-4365-478a-08d7cd0ca42f
X-MS-TrafficTypeDiagnostic: DB3EUR04HT231:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nYSeCGFPYSn+2eWASvmdey0sKtb1geuGHM2M+1N6b3cj5+RU2stF3ICfdrQ6wsftMYqa5ZMAcBXJ/yjB3cKZQjFvllM5WRNHq2fJmDKy9qFMAF6Y0mI3ixe5xFAdpg0eZQGqsE0l9OnXrmmh1fidZrPLCvPklHZMQkS23OysnaZO71COsSejZ9A9ZlBKPnsqAEnGLQkoRYDEe+aqe6tzJeDq/X77xmflrVX5YlyVcbM=
X-MS-Exchange-AntiSpam-MessageData: Quk3kAnSpHqQSnlEPNhZqLyGraCYXIlLyt2nhzqRWoLnS3EXQpfX6rwhKcdQW3o/OUsPfFD1/mOkTu6HpQ/Xyesnvxn4wpX6ejv1e29K1ybsqCRaTEBRhOd9pm7UWUIckwgaTtp3A6eGp2usm0cPnQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6b3e20-eaaa-4365-478a-08d7cd0ca42f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:24:07.7116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT231
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an infrastructure change that makes way for fixing this issue.
Each patch was already posted previously so this is just a cleanup of
the original mailing list thread(s) which got out of control by now.

Everything started here:
https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/

I added reviewed-by tags from the mailing list threads, except when
withdrawn.

It took a lot longer than expected to collect everything from the
mailinglist threads, since several commit messages have been infected
with typos, and they got fixed without a new patch version.

- Correct the point of no return.
- Add two new mutexes to replace cred_guard_mutex.
- Fix each use of cred_guard_mutex.
- Update documentation.
- Add a test case.

Bernd Edlinger (11):
  exec: Fix a deadlock in strace
  selftests/ptrace: add test cases for dead-locks
  mm: docs: Fix a comment in process_vm_rw_core
  kernel: doc: remove outdated comment cred.c
  kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
  proc: Use new infrastructure to fix deadlocks in execve
  proc: io_accounting: Use new infrastructure to fix deadlocks in execve
  perf: Use new infrastructure to fix deadlocks in execve
  pidfd: Use new infrastructure to fix deadlocks in execve
  exec: Fix dead-lock in de_thread with ptrace_attach
  doc: Update documentation of ->exec_*_mutex

Eric W. Biederman (5):
  exec: Only compute current once in flush_old_exec
  exec: Factor unshare_sighand out of de_thread and call it separately
  exec: Move cleanup of posix timers on exec out of de_thread
  exec: Move exec_mmap right after de_thread in flush_old_exec
  exec: Add exec_update_mutex to replace cred_guard_mutex

 Documentation/security/credentials.rst    |  29 +++++--
 fs/exec.c                                 | 122 ++++++++++++++++++++++--------
 fs/proc/base.c                            |  23 +++---
 include/linux/binfmts.h                   |   8 +-
 include/linux/sched/signal.h              |  17 ++++-
 init/init_task.c                          |   3 +-
 kernel/cred.c                             |   4 +-
 kernel/events/core.c                      |  12 +--
 kernel/fork.c                             |   7 +-
 kernel/kcmp.c                             |   8 +-
 kernel/pid.c                              |   4 +-
 kernel/ptrace.c                           |  20 ++++-
 kernel/seccomp.c                          |  15 ++--
 mm/process_vm_access.c                    |   2 +-
 tools/testing/selftests/ptrace/Makefile   |   4 +-
 tools/testing/selftests/ptrace/vmaccess.c |  86 +++++++++++++++++++++
 16 files changed, 278 insertions(+), 86 deletions(-)
 create mode 100644 tools/testing/selftests/ptrace/vmaccess.c

-- 
1.9.1
