Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF9718AFD0
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 10:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgCSJUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 05:20:15 -0400
Received: from mail-oln040092074085.outbound.protection.outlook.com ([40.92.74.85]:39837
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbgCSJUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 05:20:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bi0LdcXxqERIobnc5Y9IDT4E3IDYK0p9EVoeI2UCjvq+qzAVSNbLFQHDnu8ydyIn21FdtUSgM0hFXYDSMb3N/iyaWsEYVF1n8CLSbUDCojBPtPFWBHAuHoQ64RHwV+8fwcdwjIImcs4JsQBw5UcItmp0B82iv2/NkrWuvWMHGdx47MmItrs1doon8/bDbFog6XI+sZJzu+VJ1tBniwI7VUvG6TXWSxOOYgeolDWxSuh7JBRldcuVuDsmmFlsu5ZOUdHoC2DvE2Jos0NY/kctfbMsgq9/i5KydGfcy2eii/Tm8EhjSTKCv2tsURYxPYahatpGh2+jVJB5/RjCUk7NiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIawH/JPf0v/dyiwlDCMIt1oeo1fkfV4r3v9j3ZuXVs=;
 b=lFVPXrz8EnUoHuUXWclhdG94WuVkeQNwjyrsuoQ68/EBgCHeQjLXbLaIQ54QSHS6hYyKxoofIwVnX/vwd8YV6KyZ7pLwLs5dzfzYWRDT+XxXtci73cE21Pn5Eommwp/HaB0M35cqL8izVe7/OFO3omyceZ3JvWcfToY+bQ6qiBRyFK51wNKhCo4AoHxDsfxDbxsegQWEarS52objV749zye3+HszCpO+I8IsdnHFY4nNOA/7NKUgrjdKYXQgxz9f49zh4JYiI4hlIGJrhjYzOcZ3vK4sEcDlXl3BH/n8hKLriWncflFc7esUZsty6072f0VHkDLcBJAWRw+r+gU6LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT050.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::39) by
 DB3EUR04HT100.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::422)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Thu, 19 Mar
 2020 09:20:11 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.54) by
 DB3EUR04FT050.mail.protection.outlook.com (10.152.25.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Thu, 19 Mar 2020 09:20:11 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:62C4EEA58661120DB4A52A5FAC0C9EA3CF71EBD2B43BB54949AF40FE0ED12B78;UpperCasedChecksum:C34C603D1A49DD8DB4E1826F209CD475DD454C77C5BC1CD1B9EDA7EEE3161834;SizeAsReceived:10115;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Thu, 19 Mar 2020
 09:20:10 +0000
Subject: Re: [PATCH v4 3/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
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
References: <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
 <AM6PR03MB5170353DF3575FF7742BB155E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <532ce6a3-f0df-e3e4-6966-473c608246e1@virtuozzo.com>
 <AM6PR03MB51705D8A5631B53844CE447CE4F60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <13c4d333-9c33-8036-3142-dac22c392c60@virtuozzo.com>
 <AM6PR03MB5170110A5D332DD0C1AC929FE4F70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <f7c1508a-a456-6ae4-a81e-8e8aa41d8d39@virtuozzo.com>
 <AM6PR03MB5170946BCC61F5D6CA233390E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703082215BDFE074E9D735E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <20200319091907.GC3495501@kroah.com>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170A0E2784B2C6BA4CF22A2E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Thu, 19 Mar 2020 10:20:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <20200319091907.GC3495501@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR05CA0146.eurprd05.prod.outlook.com
 (2603:10a6:207:3::24) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <100ae06d-bf75-e1b8-1e03-9ddb60fa581c@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM3PR05CA0146.eurprd05.prod.outlook.com (2603:10a6:207:3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Thu, 19 Mar 2020 09:20:09 +0000
X-Microsoft-Original-Message-ID: <100ae06d-bf75-e1b8-1e03-9ddb60fa581c@hotmail.de>
X-TMN:  [59ZlNLR0Fm3Xz6BLPrkk282AHHy6Xxpq]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 81411eb8-fe8c-4d75-346e-08d7cbe6b92b
X-MS-TrafficTypeDiagnostic: DB3EUR04HT100:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0n4peSUtUY+W47RkckgdZhBf5WUftjhwS6GSiNAMab47EzyqnAmmOEEJD2rumOCS1LeXX9hqskGMPx9492yMe76sT0Z8mnY1nAt5UyKexxzXCF48tnPrUF0XezOCKLLe8kXQ5xjhJ+Fu1vPt4gvZ0Wk1LHj6M+9w3AbvhEBS5qtYdgypRIQryHF4YQvm6iQg
X-MS-Exchange-AntiSpam-MessageData: ZU8KiswfDA3gvPAV8f3u/suZKmkH6PbJ5IIsI2kxqfikpB9LLdA+lkhwcqh9MurK67uN42p+BoZLaEM+QE73QSXVugCnB2nHb/P/0pClm+Dyh/yFZ1OupZZFtgd7cnbNttZvYwhK5iNDWAFNDsuF5g==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81411eb8-fe8c-4d75-346e-08d7cbe6b92b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 09:20:10.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/19/20 10:19 AM, Greg Kroah-Hartman wrote:
> On Thu, Mar 19, 2020 at 10:13:20AM +0100, Bernd Edlinger wrote:
>> Ah, sorry this is actuall v4 5/5.
>> Should I send a new version or can you handle it?
> 
> This thread is a total crazy mess of different versions.
> 
> I know I can't unwind any of this, so I _STRONGLY_ suggest resending the
> whole series, properly versioned, as a new thread.
> 
> Would you want to try to pick out the proper patches from this pile?
> 
> thanks,
> 
> greg k-h
> 

Yes, thanks, good suggestion.

I will do that in the evening.
