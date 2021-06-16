Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203223AA62A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 23:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhFPVdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 17:33:36 -0400
Received: from mail-db8eur06olkn2034.outbound.protection.outlook.com ([40.92.51.34]:60256
        "EHLO EUR06-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232410AbhFPVde (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 17:33:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYHHBajI0LSr2LBgufZhUC/vNB3DvE9ckgtOpt6YP59j4ULYw9e9sPYkFJYnV7JhqlF2Q0exz8pziq/0b+9anne3ljwx4T1pVlOGa0FluPQpT9+ZfZAgV1d1wNdrZLFm1G6JDiefUAlz2VOshlKskB0XerB81UIu3pjss3TTvGj69LIFxRuvN21p+aJxlAQ/0xrFeopuFRJpzIdQvozpzjKoypySdtv7yeLrZJ3E47fVoOahBdfKKGOZAogGsXoHkQpIwZljPXxD9MW7VC9urbBcSeXIdq8u4oB2xpLY9xyhUxlrIib+AuHMbtX633FqoExszT6WBPjeKreHnrO4iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OiBt5WPmN65/yHVDTAS/BOGqi0vas4pYU36+sKsOVE=;
 b=JUHTTKRNr09e6LSnUv9PtERnxlxuGjNybRL/qcT+S+xk5lnYr3TOv4faws2buqFyOXrt3k8puzczDnijLZvu07iUdVL+FBh5hfeDVBYGtBbF46VFdXOdqTMxXZS5Il/MPXLv2dCfrS+zchIpsmncYG3bc6VxbOdS+fbwCnX63q4zoXyXoBIAdEC3MjU11gqopKQaDsPdhflLMUB9F4g1Y8CefM3NBlN1R29S+r/dmDZPGYYstiAaFlstiRanEJcz2CxbgjZd0noIaphYEetjKNKLNVOwPk34w1o+q1+0ogKriYg5JPfb28inoIfak3npYyohagOTyS5MYg78RlEl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR06FT054.eop-eur06.prod.protection.outlook.com
 (2a01:111:e400:fc37::4d) by
 VI1EUR06HT037.eop-eur06.prod.protection.outlook.com (2a01:111:e400:fc37::277)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 16 Jun
 2021 21:31:24 +0000
Received: from AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 (2a01:111:e400:fc37::43) by VI1EUR06FT054.mail.protection.outlook.com
 (2a01:111:e400:fc37::124) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend
 Transport; Wed, 16 Jun 2021 21:31:24 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:74E8CFE3640342A36002F32EFAEBB16B1439925A473632195C6EDC67495A610E;UpperCasedChecksum:EC30D31AE0D8A0AEAD4832465CB5FC280963AD82C831B29186E94B3D5B7BD8DC;SizeAsReceived:9085;Count:48
Received: from AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e5e5:7b7a:5ea5:c75a]) by AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e5e5:7b7a:5ea5:c75a%9]) with mapi id 15.20.4242.018; Wed, 16 Jun 2021
 21:31:24 +0000
Subject: Re: [PATCH v9] exec: Fix dead-lock in de_thread with ptrace_attach
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Charles Haithcock <chaithco@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Helge Deller <deller@gmx.de>,
        YiFei Zhu <yifeifz2@illinois.edu>,
        Adrian Reber <areber@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <AM8PR10MB4708AFBD838138A84CE89EF8E4359@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <20210610143642.e4535dbdc0db0b1bd3ee5367@linux-foundation.org>
 <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <877diwtn2p.fsf@disp2133>
 <AS8PR10MB47120E7A195A593C1377172CE4309@AS8PR10MB4712.EURPRD10.PROD.OUTLOOK.COM>
Message-ID: <AM8PR10MB47083E11E2B39ACBDF396954E40F9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
Date:   Wed, 16 Jun 2021 23:31:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <AS8PR10MB47120E7A195A593C1377172CE4309@AS8PR10MB4712.EURPRD10.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TMN:  [Noi30EIOejGx4oUQ+wSn5IR4epgRC91o]
X-ClientProxiedBy: PR0P264CA0284.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::32) To AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:364::23)
X-Microsoft-Original-Message-ID: <7b679873-c316-8f32-a036-45a6b8ff6cd1@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (84.57.55.161) by PR0P264CA0284.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 21:31:22 +0000
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 48
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 899d0f65-4211-48db-52fd-08d9310e171b
X-MS-TrafficTypeDiagnostic: VI1EUR06HT037:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0qYhOcXxL25xssPzTEkg7zuJNIrpK35tZcQKD6d/4EotD12nVVthK+k6ykqGqFuSxl8jJ1hmjc6TUX1bjJNOzRK6TqfnP9EsT4IDsTAWUAzUvrA2Raw+JzxmA262EKQi4b8QiEcq/7Udjae4L1EbgbFvtPT4pPvrXrZ99JUpMIbNu7e5IXYoFKP6Lq4I8D66ueR/kvspNAAaYQjwFhvXNBDaKCvyggr3dvxJ/KWX5/h5k3IME5Uubn1D1Nyhj0Z8xXjnKgfS7saSgmUObwl5e9v3H+MlQmtqim+xrM+P1gCnR1ag7uH47VvqI+z/Km/MJZa/3oXcN3c37VA7VWGQ2wwUNdfzXObCa6ONtV52+MOQt/YMV2O8M3Bpysu2Z9AQmfXWTkSfhcFrulpGEiPFxg==
X-MS-Exchange-AntiSpam-MessageData: wib9er4KNmhj+EgjicKEzPzI7+UGHCY+4J3jFmvqeWcnn/GevAfEnbSWNXdKOPqU9wNLSBNwmWapDr++2d5Oc4/zBtDV4p6gmRmI8Dma5CYdcU/eOvcM9bemPijTTNx78231wF0AfIWFm6/Ssn7kWg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 899d0f65-4211-48db-52fd-08d9310e171b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 21:31:24.0777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT054.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR06HT037
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/15/21 4:26 PM, Bernd Edlinger wrote:
> Thanks for your review.
> 
> On 6/14/21 6:42 PM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>
>>> This introduces signal->unsafe_execve_in_progress,
>>> which is used to fix the case when at least one of the
>>> sibling threads is traced, and therefore the trace
>>> process may dead-lock in ptrace_attach, but de_thread
>>> will need to wait for the tracer to continue execution.
>>
>> Userspace processes hang waiting for each other.  Not a proper kernel
>> deadlock.  Annoying but not horrible.  Definitely worth fixing if we can.
>>
> 
> I wonder if I am used a wrong term in the title.
> Do you have a suggestion for better wording?
> 
>>> The solution is to detect this situation and allow
>>> ptrace_attach to continue, while de_thread() is still
>>> waiting for traced zombies to be eventually released.
>>> When the current thread changed the ptrace status from
>>> non-traced to traced, we can simply abort the whole
>>> execve and restart it by returning -ERESTARTSYS.
>>> This needs to be done before changing the thread leader,
>>> because the PTRACE_EVENT_EXEC needs to know the old
>>> thread pid.
>>
>> Except you are not detecting this situation.  Testing for t->ptrace
>> finds tasks that have completed their ptrace attach and no longer need
>> the cred_gaurd_mutex.
>>
> 
> The first phase of de_thread needs co-operation from a user task,
> if and only if any task t except the thread leader has t->ptrace.
> Taking tasks from RUNNING->EXIT_ZOMBIE only needs co-operation from kernel code,


Aehm, sorry, that is not correct, what I said here.

I totally overlooked ptrace(PTRACE_SEIZE, pid, 0L, PTRACE_O_TRACEEXIT)

and unfortunately this also prevents even the thread leader to enter the
EXIT_ZOMBIE state because do_exit does:

        ptrace_event(PTRACE_EVENT_EXIT, code);

unfortunately this sends an event to the tracer, and waits not only for
the tracer to call waitpid, but also needs a PTRACE_CONT before do_exit
can call exit_notify which does tsk->exit_state = EXIT_ZOMBIE.

So unfortunately this breaks my patch, so I have to withdraw it for now,
since I see no way how to fix it.

I will clean-up my previous patch which changes the ptrace API to return
an error if an unsafe execve is detected, and send it to this list.


Thanks
Bernd.
