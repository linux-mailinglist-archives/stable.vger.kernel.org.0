Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9EDC18AD40
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 08:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgCSHTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 03:19:31 -0400
Received: from mail-oln040092075049.outbound.protection.outlook.com ([40.92.75.49]:2786
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbgCSHTa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 03:19:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrUPWrUqOaKWAf1aMquFWlh4Oy1/f/HAOKhSlD6Lq7bfYuyHysoA+YgnYq7Tig7teDFyTX0FYGrpM1WYW6k2B5RbRd7LgR7rGzMpGL+HWtwOhFAlLolluq/4qRWH8uSBTVO9tObA5433/I46ZARG8P0T/H3ujw5AqC/5pp24sITW4VaZMadUMjmT74O3B6LDzPADDqKTnPD0RRY1LhVWLq9M6ZFy+x8KltzZPmLxEAbRQFI0azbnGkXg8kjjTDtwxV924ubNMyAQODVOwNLkXxCIFchEqXhCSihTSMTfhFwhfZwdvna9EfBIbB1zMkXt/uyLDKJy+5oMLneZtUTp2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxIBA0eTTJmtvzqWujapOEKtGUqHaJJ9YhL5aqFDIao=;
 b=JW99FeZsWUIITD8fpMR3hGfOMBcqQrH7wYWyz0Fga13fF43wnK+J2vMKuFm6ns93H/AZwamPUZf8a1YqxzaKbMzsRKe2EQoVFLz0dwtihP9NAL7uPbvBmvcDHgKQGrXzLivWI1+9GGcQPCM/Bu96k/qunjdNmd8I7AUw7AE83zf50jfKCUtTj/KcnlXKDQBft9ZW9YcGqScztgHYmPgIQiiEk7HdXlbjxLnC9u1VlvEEG3a/CVHU/9CFMzhNndnf2G7Y5BMd28HTpWjcnL4DIPTmqZi+DXoRuieAZRoTFvGIAKzOjy7Qc51E6yKRkjHXV6HHnVEiL0ThfNxCPJUcbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR04FT040.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0d::39) by
 HE1EUR04HT022.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0d::180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Thu, 19 Mar
 2020 07:19:25 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.26.56) by
 HE1EUR04FT040.mail.protection.outlook.com (10.152.26.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Thu, 19 Mar 2020 07:19:25 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:B5C2B2B81A31B114FA65B0D3F3DB93E518946F7458CE334BF9BEEB6C89AFCEC9;UpperCasedChecksum:D4F0E88236249F7EB1A0DF7531DD5D2B4DADEA94CB0CF94780BC0E257E4A6F30;SizeAsReceived:10330;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Thu, 19 Mar 2020
 07:19:25 +0000
Subject: Re: [PATCH v3 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
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
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <f37a5d68-9674-533f-ee9c-a49174605710@virtuozzo.com>
 <87d09hn4kt.fsf@x220.int.ebiederm.org>
 <dbce35c7-c060-cfd8-bde1-98fd9a0747a9@virtuozzo.com>
 <87lfo5lju6.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
 <AM6PR03MB5170353DF3575FF7742BB155E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <532ce6a3-f0df-e3e4-6966-473c608246e1@virtuozzo.com>
 <AM6PR03MB51705D8A5631B53844CE447CE4F60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <13c4d333-9c33-8036-3142-dac22c392c60@virtuozzo.com>
 <AM6PR03MB5170110A5D332DD0C1AC929FE4F70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <f7c1508a-a456-6ae4-a81e-8e8aa41d8d39@virtuozzo.com>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170F50FD049FA7B365924F7E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Thu, 19 Mar 2020 08:19:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <f7c1508a-a456-6ae4-a81e-8e8aa41d8d39@virtuozzo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::25) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <5e38267c-cb7f-8049-26b8-3a0a155ca51a@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Thu, 19 Mar 2020 07:19:24 +0000
X-Microsoft-Original-Message-ID: <5e38267c-cb7f-8049-26b8-3a0a155ca51a@hotmail.de>
X-TMN:  [m8LpYdCrZRxzdlzBeoQ2jXshgvDIn49Y]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 6f08d5e8-2023-42ff-f29b-08d7cbd5da79
X-MS-TrafficTypeDiagnostic: HE1EUR04HT022:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /X3jasuoM4he5VZ9efsssHDT2JLhi+bxnFrvMzKBipdJq7PD6e1D3/bieeI+FRYDf1zu8JdLQmLUzGDcaXiDwKTRfzWDlY4HKjKE1ClgnhUj/k1I4A0xVwI9yQP0cDl3+OODdh/HupnOxdzAZ6UwpbpvWEJxgTkH/ntX1CCGMo+usNsJbOlaazkqIIBvXCVq
X-MS-Exchange-AntiSpam-MessageData: oK1Nj1SgfWb6a6HS+SOIRMvtP8Dk22KU8zlA/X9NBlFcG2WdV9gjSZSZq4/B5BXm38PHa2SVMw3oR2Ff4pKPD3eBa2RPrJmDDXxkgrdHqhsUh7iJDtEjjA2UjoJY/rG0uZBmz3FKFDndoIrTvEzKSQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f08d5e8-2023-42ff-f29b-08d7cbd5da79
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 07:19:25.4399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR04HT022
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/19/20 8:13 AM, Kirill Tkhai wrote:
> On 18.03.2020 23:06, Bernd Edlinger wrote:
>>
>> I was thinking of something like that:
>>
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1010,6 +1010,11 @@ ssize_t read_code(struct file *file, unsigned long addr, 
>>  }
>>  EXPORT_SYMBOL(read_code);
>>  
>> +/*
>> + * Maps the mm_struct mm into the current task struct.
>> + * On success, this function returns with the mutex
>> + * exec_update_mutex locked.
>> + */
> 
> Looks OK for me.
> 

Cool, yeah, then I will post an updated patch in a moment.


Thanks
Bernd.
