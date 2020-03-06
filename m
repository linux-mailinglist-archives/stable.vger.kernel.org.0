Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1BB17BC03
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgCFLqF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 6 Mar 2020 06:46:05 -0500
Received: from mail-db8eur05olkn2106.outbound.protection.outlook.com ([40.92.89.106]:22182
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbgCFLqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 06:46:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lq29nZ0GrCm5ZBsRuzmUtTjNF9NMOGpbhQTgfihWLuP45FdBkK6qHNnOoOGvHEDDQKSvWY3wtZ86cjHmBYtEyipol+a4P98e0/g3aex7NbZdkcFMvnYVge2uEX74TZG6R1QMso4amIZNpTTiY3veCzWAXK5IDvMUMgJEBKS6i4cNsOGy6/cMaPS1vAeCpnuxmdAw39yt5Bdwzn+km/P0up5rKPTyZqD0eOOi6+Yz5WUgBS5oJlTJNy9vZshVUtBE6GDCuhapr5sJz1xhcAi98dkVBlX8FoxUX6M+ac7hzKhH3jMEN3mNun+N4WR8z0DeYmAo27sIAsxtUfJmSGwpUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtc5L0L14OZEoSj3a0yc699cWCHD/8WO21mqeEtzBLM=;
 b=WpSskQj3jIEhQRZ4b8Ev6mTE91zMmNrE8Vd/5iziU2nduAs/7qXPsWTR7R0ViFDLbm9HLY9B5n8Hd2ZTEhfB0X1mTMxITGbzIy+1FMWH8t+s4HvqnLTD01jRHIAZ3/Cjj/SDn9yDG3nAp9x7FVGL4Yy/lRhTAwY8w96M3UCbqbmdET/3bE/lVYRqvvlXRFrdc5BrEQYiW281FNqhStpzkshFj1VvQ0NAF8HJeS1Yi9Iq6u0qBAG1Ltrwa263If4yi3S2hWqLQjEvaZnKLtN1L+l0SFNGiTFGBXHxdRwlBqFQMlxzW6SsdOLztmSELjMwwP5Pzhaww1UP230gXMEuKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB8EUR05FT060.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::37) by
 DB8EUR05HT100.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::330)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Fri, 6 Mar
 2020 11:46:01 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.53) by
 DB8EUR05FT060.mail.protection.outlook.com (10.233.238.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Fri, 6 Mar 2020 11:46:01 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 11:46:01 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR01CA0078.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Fri, 6 Mar 2020 11:45:59 +0000
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
Subject: Re: [PATCH 2/2] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Topic: [PATCH 2/2] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Index: AQHV8zOjiaOX92PFsUy1cOGGFJ5V7ag6ihsAgAB9KjCAAGvuAA==
Date:   Fri, 6 Mar 2020 11:46:01 +0000
Message-ID: <AM6PR03MB5170FC44E102D4F8C1B2E854E4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87imjicxjw.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170375DBF699D4F3DC7A08DE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k13yawpp.fsf@x220.int.ebiederm.org>
In-Reply-To: <87k13yawpp.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::19) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:6A374852C01B3EF613757ABDC991B772716A76AF96AB389077CE5FA1ADE7F350;UpperCasedChecksum:A8F3CBDF8F5B3300EA6AFB7DAB9F6A9E9C28E2440B1F75B24AF0AA33A89505CC;SizeAsReceived:9962;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Dq0iUjElK8FhGRtZy48KKV7ZMjH4c9jK]
x-microsoft-original-message-id: <503bf661-9426-f9ea-5c1f-a1a9762f89c3@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 6ba5ec6f-ba76-4802-fac4-08d7c1c3f101
x-ms-traffictypediagnostic: DB8EUR05HT100:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ccWyuF+3K79hahWw5nqZBFdxKADIvjDYt9BhFhOlnYoAXTfBMBvQBsyh5knnwHo+WpwBPWHf+dozFWjZT38kIXZA076X9TBK0ITYEEphnO/gZCXHPBfk1NhTHsVqWLF9g+dRgUHhX9dMTvQ20TMmYONoh6fTQRluGtoJhVxXXsjpkX69+X453rFA1BeaE24qfafvFDis0Wd3FeebYoJhk1d709lnnCJ4728JuiLgMlY=
x-ms-exchange-antispam-messagedata: joD90TpJxkAgvVm47IEsGXTTY+KcTvtpuerVZVWtSC/5TAyM5h/sAKp5hJQBlAyIcbdhfLE2Dri55KJWxH9Rp3Jq9y18JZOxAr5TRPlrUbkxYdwY+ZXx/2G8cnq1elXojxrdBUDi2HEgBVV44Pr9iA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <1C556EFF0DB20147A68F62658B55FF00@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba5ec6f-ba76-4802-fac4-08d7c1c3f101
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2020 11:46:01.1281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 06.03.20 um 06:17 schrieb Eric W. Biederman:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/5/20 10:16 PM, Eric W. Biederman wrote:
>>>
>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>> over the userspace accesses as the arguments from userspace are read.
>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>> threads are killed.  The cred_guard_mutex is held over
>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>
>>> Any of those can result in deadlock, as the cred_guard_mutex is held
>>> over a possible indefinite userspace waits for userspace.
>>>
>>> Add exec_update_mutex that is only held over exec updating process
>>> with the new contents of exec, so that code that needs not to be
>>> confused by exec changing the mm and the cred in ways that can not
>>> happen during ordinary execution of a process can take.
>>>
>>> The plan is to switch the users of cred_guard_mutex to
>>> exed_udpate_mutex one by one.  This lets us move forward while still
>>> being careful and not introducing any regressions.
>>>
>>> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>>> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>>> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>>> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>>> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>>> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>>> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>> ---
>>>  fs/exec.c                    | 4 ++++
>>>  include/linux/sched/signal.h | 9 ++++++++-
>>>  kernel/fork.c                | 1 +
>>>  3 files changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/exec.c b/fs/exec.c
>>> index c243f9660d46..ad7b518f906d 100644
>>> --- a/fs/exec.c
>>> +++ b/fs/exec.c
>>> @@ -1182,6 +1182,7 @@ static int de_thread(struct linux_binprm *bprm, struct task_struct *tsk)
>>>  		release_task(leader);
>>>  	}
>>>  
>>> +	mutex_lock(&current->signal->exec_update_mutex);

And by the way, could you make this mutex_lock_killable?


Bernd.
