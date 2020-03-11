Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E0A1822C0
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 20:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgCKTsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 15:48:43 -0400
Received: from mail-vi1eur05olkn2043.outbound.protection.outlook.com ([40.92.90.43]:50048
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730705AbgCKTsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 15:48:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8NEwoeAFioSFIOQiQUtA9WAMmB+oVV0s74oA04vTvhMGmvCVjNGg2TpfhLoeDgjs7ckjASkVcM9hhH9WdSWU7YTC4Xlu/2BeXsxhoheLkf0HJXSLKeCHFZobFNFi4PJvSKT/fslywa6CCBEdvMhkL1D69MaHmbkTgFMTK+pLfXD3nPff4TgcOvJSF8tZmDpWJsKiYxGN5ZSHoBCbQSD2FbYQLWwt0QtQV+AKZfrg/EhakXVfSVKEDVUwwn98gPysZTjhGSC7D9BsNifv+AZrIw1kNulhQF/gVRDGYBDIMxRGq7a4K7k0SKL0QR1kBO0Mn+ubGm6oIfEkzGnD+0bLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsscKs0P5jyU2LHhrYkdbgvnKWhlHbB0QpXnPagrln8=;
 b=fHjJFugl2p8GOcOb9RAR1h+cSNBRcxLNW+nNA1IYxLJk8BnnqQtwnPG1mOJwrm02FeQokI4kVDnqipNa6HWMruKILTR+M8d6jNG4/o05rj1gy1LG0f04TiO9VdwXMDHKhhUCQX8xzXYEBYWfG69/iOlKmtshcecbE8CmSVtkN9hFlY5NL0d0X8Q8+T9JqsR4NBqL+sS6Ku0eRvHCwiT2PcW6k6zDDZR8Hl2TDKUlj4Wp7UaLklSQ1kkDxNjmKMWs7FObYmN0LYKoX5CyQvoRCgZfxtUwMvgIP8kijwo34ceOmdkRRHe0Dkb8X8imOEdkEwKeV5T2pbvea0AedCpdWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VI1EUR05FT027.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc12::36) by
 VI1EUR05HT105.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc12::392)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 11 Mar
 2020 19:48:33 +0000
Received: from PR2PR03MB5179.eurprd03.prod.outlook.com (10.233.242.56) by
 VI1EUR05FT027.mail.protection.outlook.com (10.233.242.209) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Wed, 11 Mar 2020 19:48:33 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:FAB945D2B34D4EFAC4DBFD187298691FD6C823159495DCDC001B7FD28278D05A;UpperCasedChecksum:EADB10275C5B21F815CCF6A0C3D4BE24A629B26DE934B31006B168A0BF411FD8;SizeAsReceived:9941;Count:50
Received: from PR2PR03MB5179.eurprd03.prod.outlook.com
 ([fe80::5914:cd4e:9863:88c2]) by PR2PR03MB5179.eurprd03.prod.outlook.com
 ([fe80::5914:cd4e:9863:88c2%5]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 19:48:33 +0000
Subject: Re: [PATCH 3/4] proc: io_accounting: Use new infrastructure to fix
 deadlocks in execve
To:     Kees Cook <keescook@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <87r1y12yc7.fsf@x220.int.ebiederm.org>
 <87k13t2xpd.fsf@x220.int.ebiederm.org> <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfcxlwy.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003111203.738487D@keescook>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <PR2PR03MB51793050A9C93CC2EBEF86B3E4FC0@PR2PR03MB5179.eurprd03.prod.outlook.com>
Date:   Wed, 11 Mar 2020 20:48:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <202003111203.738487D@keescook>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0701CA0010.eurprd07.prod.outlook.com
 (2603:10a6:200:42::20) To PR2PR03MB5179.eurprd03.prod.outlook.com
 (2603:10a6:101:25::12)
X-Microsoft-Original-Message-ID: <39910082-2854-132b-4f4f-5cb36ae86400@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM4PR0701CA0010.eurprd07.prod.outlook.com (2603:10a6:200:42::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.7 via Frontend Transport; Wed, 11 Mar 2020 19:48:31 +0000
X-Microsoft-Original-Message-ID: <39910082-2854-132b-4f4f-5cb36ae86400@hotmail.de>
X-TMN:  [63zg36Uak5VhpA77nTTr6TqJcIutlNup]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: da2c8154-b793-45f2-70c4-08d7c5f52e57
X-MS-TrafficTypeDiagnostic: VI1EUR05HT105:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zWd+v+xeCZKIQ4mfXXvRjRcB3XdpB7KsBOQzdQsaUZlA7LXjxYAtKegqNSUathgXFsU/VIOCPZruD/ZMMXB2Y9ohb3L1F74+cZQpT3djxwcf9dRK++mYhcUNBjeFfEp0xdjvPlPyooOMP0wpW24e/cC6/v8d0BYLUvBXb00fVKkFtbSIhGNMwP+m6xF9nK9A
X-MS-Exchange-AntiSpam-MessageData: r7Gso8je51C8bHqcpuokpObQSpFKilSYZNH3jC+bqzrIdb8xdZCDsIvJpC+kq4QGygSbrdtQ7dA6gfXG6CAIvkRY2eU84NDHVCuMbFYtHbP+FU6zI3p55ZS8houha5au9PUobZ5JKsLE8nePXrwSRA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da2c8154-b793-45f2-70c4-08d7c5f52e57
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 19:48:33.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR05HT105
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/11/20 8:08 PM, Kees Cook wrote:
> On Tue, Mar 10, 2020 at 06:45:47PM +0100, Bernd Edlinger wrote:
>> This changes do_io_accounting to use the new exec_update_mutex
>> instead of cred_guard_mutex.
>>
>> This fixes possible deadlocks when the trace is accessing
>> /proc/$pid/io for instance.
>>
>> This should be safe, as the credentials are only used for reading.
> 
> I'd like to see the rationale described better here for why it should be
> safe. I'm still not seeing why this is safe here, as we might check
> ptrace_may_access() with one cred and then iterate io accounting with a
> different credential...
> 
> What am I missing?
> 

The same here, even if execve is already started, the credentials
are not actually changed until the execve acquired the exec_update_mutex.

The data flow is from the task->cred => do_io_accounting,
if the data flow would be from do_io_accounting => task's no new privs
you would see an entirely different patch.

I am open for suggestions how to improve the description, or even
add a comment from time to time :)

Thanks
Bernd.

> -Kees
> 
>>
>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>> ---
>>  fs/proc/base.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 4fdfe4f..529d0c6 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2770,7 +2770,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>>  	unsigned long flags;
>>  	int result;
>>  
>> -	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
>> +	result = mutex_lock_killable(&task->signal->exec_update_mutex);
>>  	if (result)
>>  		return result;
>>  
>> @@ -2806,7 +2806,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>>  	result = 0;
>>  
>>  out_unlock:
>> -	mutex_unlock(&task->signal->cred_guard_mutex);
>> +	mutex_unlock(&task->signal->exec_update_mutex);
>>  	return result;
>>  }
>>  
>> -- 
>> 1.9.1
> 
