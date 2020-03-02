Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37676175ECF
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 16:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCBP4N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 2 Mar 2020 10:56:13 -0500
Received: from mail-oln040092064094.outbound.protection.outlook.com ([40.92.64.94]:12774
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727401AbgCBP4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 10:56:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2r3lvduDL96KS0h0EN+7YkSAgje1jk+5tNPueNh3896BYDWWc5Euj89wNeorAf+i+XQ4oAcQE5FLJ1MT1c9UXTxXVeXf8HhgoiQxlDsuaPWwiWI4Wsv/BRUja8QhjUaEW26tHDP5DFU9fnrg6fU9YKfvy9aP/prZqb/k79qFZjYyVO5Gpc2uRM4n8tPsZNtC7T0MuOFyj17VZ6MXq1Ig+mVPiJpysZz0893ZAKGaTmpWpMVJ58sXFU8iA99gZKshoXcsKxfg8RonimPSg1ol882GyiFB55K8G3hqt5pQ/vP54SII9CtkHoWBT80M+UOJ0uXHVQ49XOBtjKg01EI4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+Kd81xLm1x3TxoEszHoxLRpj/1LPM1dSZ2/tf9dSgw=;
 b=PmJA18Lywan1RnlRmim+xy+Px27lFm8eH6q8ZWG8aNfsHhYqeD/JL43NlVaV2Uqkx5OqqAEc6R+C4x3FJ6FSrjuDC2uA6P7aY9sb6B7etQBMWAwevGa+rkPo802JZJFFQI9/sB3J1qurcCH1ByhPxaiAYsCdK3V4tgPZHe+Jgjug3qkijLkw1OGE75A89/JHUVFlntbqBskbfGdSHQKOyTT++CdHNZeQzRJQ6Toq/ZNlWDBY6tVbIG78xZp8z9A4J3rP5HUcWM8jlxelfVCo5vgtOY3sxazEPhk55dJNnnwOyqVJq/Shux9dcnBYxD0iUNM6uo7ltWk8oZTAZVNxaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VE1EUR01FT020.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e19::39) by
 VE1EUR01HT123.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e19::346)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 15:56:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.2.58) by
 VE1EUR01FT020.mail.protection.outlook.com (10.152.2.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14 via Frontend Transport; Mon, 2 Mar 2020 15:56:05 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 15:56:04 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0075.eurprd06.prod.outlook.com (2603:10a6:208:fa::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Mon, 2 Mar 2020 15:56:03 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Oleg Nesterov <oleg@redhat.com>
CC:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Kees Cook <keescook@chromium.org>,
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv2] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8AjGwZG4WijWc0+aQpdADP+q6qg1PBaAgAA5/QA=
Date:   Mon, 2 Mar 2020 15:56:04 +0000
Message-ID: <AM6PR03MB51706D69E3F0126237DDD110E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
 <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
 <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <20200302122828.GA9769@redhat.com>
In-Reply-To: <20200302122828.GA9769@redhat.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0075.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::16) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:3859E16BF71A8EC6423EB232D80AE29A1E09FEE95B4D7450D9F8D23EAC84772D;UpperCasedChecksum:B223ECFEDCD92A9F2C1781AAC90A39F9E0AA91ECCB1C8618827A1BBCB80C5D95;SizeAsReceived:9182;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [RgRM/hymeKlspWJoHmyR0Ulb73pdTH9g]
x-microsoft-original-message-id: <a3723c53-2c41-ed50-309f-ba0d8555f67b@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: b61d0c25-2554-4b5a-1def-08d7bec23679
x-ms-traffictypediagnostic: VE1EUR01HT123:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zGFfTOXtwopFCtyvp7ptFwafemwNiCw/uWpTmVi+SLPvY/6zuwibbsn8jTFPu/q2u2H6q8coBRQSeCgdgFDYwHrY3rtF5IsrQXElOAMtsrgIiN5EHlgln0I7tWBp6pwuZO7kOf9/huDfs3VB5dZWQAnep8rzczUeg+2gWknmc1KDpBTdjEbspnnS2QTbrGb2lvk4zzlDGbQQ27IB//zFxqMUM5tkCXNn1q4/dbz4gEE=
x-ms-exchange-antispam-messagedata: 5b5OpsuSrxieJKpRNkYaSOPnTdNv+Phjlo/8abt2jrLPA/WxuhhMsDmFiKcLHzV+6jKJLoxI6QI9LkQJHYJcQn0kl/B+AwkcAN4XXQUap6t+GL3Qw5sqxWNdwePFmm7WZmHpszbmMt79ctrvP8Wu2w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <AF6DD11A35CDD44D93462FA5182F8F18@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b61d0c25-2554-4b5a-1def-08d7bec23679
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 15:56:04.6412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR01HT123
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/2/20 1:28 PM, Oleg Nesterov wrote:
> On 03/01, Bernd Edlinger wrote:
>>
>> This fixes a deadlock in the tracer when tracing a multi-threaded
>> application that calls execve while more than one thread are running.
> 
> Heh. Yes, known problem. See my attempt to fix it:
> https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
> 
>> @@ -1224,7 +1224,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>>  	struct mm_struct *mm;
>>  	int err;
>>  
>> -	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
>> +	err =  mutex_lock_killable(&task->signal->cred_change_mutex);
> 
> So if I understand correctly your patch doesn't fix other problems
> with debugger waiting for cred_guard_mutex.
> 

No, but I see this just as a first step.

> I too do not think this can justify the new mutex in signal_struct...
> 

I think for the vm_access the semantic of this mutex is clear, that it
prevents the credentials to change while it is held by vm_access,
and probably other places can take advantage of this mutex as well.

While on the other hand, the cred_guard_mutex is needed to avoid two
threads calling execve at the same time.  So that is needed as well.

What remains is probably making PTHREAD_ATTACH detect that the process
is currently in execve, and make that call fail in that situation.
I have not thought in depth about that problem, but it will probably
just need the right mutex to access current->in_execve.


That's at least how I see it.


Thanks
Bernd.



