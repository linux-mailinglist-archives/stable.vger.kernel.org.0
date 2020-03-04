Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B217926F
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 15:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgCDOhw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 4 Mar 2020 09:37:52 -0500
Received: from mail-oln040092072016.outbound.protection.outlook.com ([40.92.72.16]:23299
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726579AbgCDOhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 09:37:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPM7oXtuh2PQX/o2c/awB8JgMzyPXI1GqQfLmPPQWvnCLzld5FhuhlDi+bPO/OfrLc+jTT+uzjVFtUnk9UlEjnmfw8cG+/YV5EMM71W6A+KIfwxk8RMcLTttTaqZJ8D7GOAaVvGTDryQa+J8NkIM6DTqPkOw0jFac+p3TP5bzQDTMy3ObjaKHqiRp/wMa0ITuRTQXa5c2qrgilIBEvYcTKHWZ8atLxjufLxxEJ8AwFfFgwd8LXTLDgWS0BX7b9K0Xta1181NuvioWdyU6SkBanPTv7Z38NphNvSJxs0WU8rfHwtx+2/dwFABEXI4tQIKhsiDzUa1JApEU+A4wW2m5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcXQPedkhnNFfILIej2nx8/wTn4g9uUg8LLYl2MjqTA=;
 b=boVa9SH309ngrPYevhQ03HXpzQjwgGd+LxtBywBfb9KyCnaNci/7foGrcHZFkfj6TFchDqXht7htIDnJJ8EEK1vJEW4RkqqXeRhEDpOb92pmyBFDlGM6XNMEQK1E0BrF3ec7KsVRZ7DhXCLC3CvboluC5D1m28bhxxKBViQpW6jy9QRCbOC7X68wudVtwC4EaBRl04oDuLiXlC4hVmcyMReTewPt0bxSZty3OGuInv69C8jVeG0tBBOshMoN3omSDZvFvG4lTF51+0UDcozPgaOqdDNT8/EZ4n9g/sDrgG8vW6SXHd1XZnWSTOid7squVKoiFlmz7iSNnD9JWzv7og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB5EUR03FT008.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e0a::3c) by
 DB5EUR03HT151.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e0a::501)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Wed, 4 Mar
 2020 14:37:46 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.20.52) by
 DB5EUR03FT008.mail.protection.outlook.com (10.152.20.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Wed, 4 Mar 2020 14:37:46 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 14:37:46 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZRAP278CA0015.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Wed, 4 Mar 2020 14:37:44 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
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
Subject: Re: [PATCHv5] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv5] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8VwLHjttz8YuA0eRTVSvUK/ceqg2/AiMgAAYPYCAAFh/v4ABFW8A
Date:   Wed, 4 Mar 2020 14:37:46 +0000
Message-ID: <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
In-Reply-To: <87a74xi4kz.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZRAP278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::25) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:8814B95B07A5B0B59BE91785DDCE9E40209FCCC148AD5BC9662A74C4C04787B2;UpperCasedChecksum:E3AEDB6651F319D354AF4BA117D37D3DD92C011E561AB11076661740AC6D35FB;SizeAsReceived:9784;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [lNZ/pEmcA9wn5CLL9LaN1KSCnE9NpNc5]
x-microsoft-original-message-id: <6fab002c-2888-531a-f70d-4d7149bca60d@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 681f5db9-d17b-49c9-2eda-08d7c0499aea
x-ms-traffictypediagnostic: DB5EUR03HT151:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cFUTlXWU0emzpD7yJZ7X/AcOPA6PfI2sjK95LBS1HxgdeALb/3UPEd2zHG6fLJEEij3lW3xDG7SBzT7CBkau8yT6avuneGDRujNzPD896TCxxrxNUnFhKD78GJMmbMFM72XR4liH8jRNuG6krkqtf0ONT91P3Vra39RYCX0pvY2wi49zGnfsW5Q5WNstNBwK
x-ms-exchange-antispam-messagedata: ql3ua4jqqanbhJSXEGSaZ/qbkSvNDWS8sTVT6aaCR3VYN8evbDUAxOi416yuLFcbgaFn5tm7/70/nc5Mb/iwISypeynwDNGWWyCd5rKNtPZ1/yCMnKFUPTc/oWHFufVCZ/iGS3ErpxWhdba+5HWLoA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <730E5A674ABEB245ADB99ECE0FDD8B86@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 681f5db9-d17b-49c9-2eda-08d7c0499aea
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 14:37:46.5136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT151
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/20 9:08 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/3/20 4:18 PM, Eric W. Biederman wrote:
>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
>>>> new file mode 100644
>>>> index 0000000..6d8a048
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/ptrace/vmaccess.c
>>>> @@ -0,0 +1,66 @@
>>>> +// SPDX-License-Identifier: GPL-2.0+
>>>> +/*
>>>> + * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
>>>> + * All rights reserved.
>>>> + *
>>>> + * Check whether /proc/$pid/mem can be accessed without causing deadlocks
>>>> + * when de_thread is blocked with ->cred_guard_mutex held.
>>>> + */
>>>> +
>>>> +#include "../kselftest_harness.h"
>>>> +#include <stdio.h>
>>>> +#include <fcntl.h>
>>>> +#include <pthread.h>
>>>> +#include <signal.h>
>>>> +#include <unistd.h>
>>>> +#include <sys/ptrace.h>
>>>> +
>>>> +static void *thread(void *arg)
>>>> +{
>>>> +	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
>>>> +	return NULL;
>>>> +}
>>>> +
>>>> +TEST(vmaccess)
>>>> +{
>>>> +	int f, pid = fork();
>>>> +	char mm[64];
>>>> +
>>>> +	if (!pid) {
>>>> +		pthread_t pt;
>>>> +
>>>> +		pthread_create(&pt, NULL, thread, NULL);
>>>> +		pthread_join(pt, NULL);
>>>> +		execlp("true", "true", NULL);
>>>> +	}
>>>> +
>>>> +	sleep(1);
>>>> +	sprintf(mm, "/proc/%d/mem", pid);
>>>> +	f = open(mm, O_RDONLY);
>>>> +	ASSERT_LE(0, f);
>>>> +	close(f);
>>>> +	f = kill(pid, SIGCONT);
>>>> +	ASSERT_EQ(0, f);
>>>> +}
>>>> +
>>>> +TEST(attach)
>>>> +{
>>>> +	int f, pid = fork();
>>>> +
>>>> +	if (!pid) {
>>>> +		pthread_t pt;
>>>> +
>>>> +		pthread_create(&pt, NULL, thread, NULL);
>>>> +		pthread_join(pt, NULL);
>>>> +		execlp("true", "true", NULL);
>>>> +	}
>>>> +
>>>> +	sleep(1);
>>>> +	f = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
>>>
>>> To be meaningful this code needs to learn to loop when
>>> ptrace returns -EAGAIN.
>>>
>>> Because that is pretty much what any self respecting user space
>>> process will do.
>>>
>>> At which point I am not certain we can say that the behavior has
>>> sufficiently improved not to be a deadlock.
>>>
>>
>> In this special dead-duck test it won't work, but it would
>> still be lots more transparent what is going on, since previously
>> you had two zombie process, and no way to even output debug
>> messages, which also all self respecting user space processes
>> should do.
> 
> Agreed it is more transparent.  So if you are going to deadlock
> it is better.
> 
> My previous proposal (which I admit is more work to implement) would
> actually allow succeeding in this case and so it would not be subject to
> a dead lock (even via -EGAIN) at this point.
> 
>> So yes, I can at least give a good example and re-try it several
>> times together with wait4 which a tracer is expected to do.
> 
> Thank you,
> 
> Eric
> 

Okay, I think it can be done with minimal API changes,
but it needs two mutexes, one that guards the execve,
and one that guards only the credentials.

If no traced sibling thread exists, the mutexes are used this way:
lock(exec_guard_mutex)
cred_locked_in_execve = true;
de_thread()
lock(cred_guard_mutex)
unlock(cred_guard_mutex)
cred_locked_in_execve = false;
unlock(exec_guard_mutex)

so effectively no API change at all.

If a traced sibling thread exists, the mutexes are used differently:
lock(exec_guard_mutex)
cred_locked_in_execve = true;
unlock(exec_guard_mutex)
de_thread()
lock(cred_guard_mutex)
unlock(cred_guard_mutex)
lock(exec_guard_mutex)
cred_locked_in_execve = false;
unlock(exec_guard_mutex)

Only the case changes that would deadlock anyway.


Bernd.
