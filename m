Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2F23AFC79
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 07:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhFVFMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 01:12:42 -0400
Received: from mail-db8eur05olkn2078.outbound.protection.outlook.com ([40.92.89.78]:59488
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229612AbhFVFMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 01:12:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXZI9ho9qUs64NR1vVgGmXuexs6joaIyMG7qV0bJYm3xXjIGxElQOVkT3TW8egupEz9qyZNq7YVaW3NtN7Py33TsZWuImFfTo9NYyiSZrlUL/Vtw6Nrg2P4oRfllDEudARXFOjnJa+nOraKMj3ZUPhRlM1lNrIwsMiiGMBC9PiijytczfhBui1q0hNuMllo+gXstSSOY/HFv/Vs18IqqmPixSFTxVNdS8Lz7z4JDmiMHbHvTlh/dMwZwT6szXHLtk/c0iSRF1Eo/kKXAqhviyNftkvE4+Dm1/dQniL1YSELVFU50+toU/aXBmHyeFfkrDfskbx7nRX8QlqTLAOwHCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OytysZu5Z+aAyVrvNx45JXK3NgpiH3c7LaspZb446DE=;
 b=O5yS3lV3zMwJan5ca6+EGAiolc8iQVciKp8zezB3LlOQXzecxGfA2K0Vq0bSOX5n0uwlpAK4ZCxSX8CuM4NBjLQLp9QExwKWiBwrXiuSJmPghmvQCpDME0GLKS0lJKteoyxxNqFlc5qPogM0ZjX/rhHSkujVhnen1fWH1Lfdaeiqq6oYQBfWEjrcZk1sz+ACQ0U0hCYiCmYTpjR9UJJWK9pAnX16gh4Zw12aj8S98yTgvnqAQqLLydBIQXUo/w1vb1mVG8ecVASccpJBzpPCEwgfkCXXA71MSljZXKvdO1pH1EDrDTaCCK4yo5P4bIFTi6hdhMPBdoUacszVTMOnGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR05FT027.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc12::53) by
 VI1EUR05HT195.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc12::477)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Tue, 22 Jun
 2021 05:10:23 +0000
Received: from DB9PR10MB4713.EURPRD10.PROD.OUTLOOK.COM
 (2a01:111:e400:fc12::50) by VI1EUR05FT027.mail.protection.outlook.com
 (2a01:111:e400:fc12::209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend
 Transport; Tue, 22 Jun 2021 05:10:23 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:B537D4C97917BF2D244BB724943815E82B1AEEF575C68F9AF35558D8BDE4A370;UpperCasedChecksum:8A41EBD09CC0797627FAAAB4435C4EE97BB48E6D8EF9E472ADD79745FFA31102;SizeAsReceived:9154;Count:48
Received: from DB9PR10MB4713.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2515:5d6d:6f1e:c41]) by DB9PR10MB4713.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2515:5d6d:6f1e:c41%9]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 05:10:23 +0000
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
 <AM8PR10MB47083E11E2B39ACBDF396954E40F9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
Message-ID: <DB9PR10MB47134C036A2DADB4FD53F16AE4099@DB9PR10MB4713.EURPRD10.PROD.OUTLOOK.COM>
Date:   Tue, 22 Jun 2021 07:10:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <AM8PR10MB47083E11E2B39ACBDF396954E40F9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TMN:  [TxNR3A2P2Z/6GxfqYbv4g+YO6Wi2Feae]
X-ClientProxiedBy: AM0PR03CA0041.eurprd03.prod.outlook.com (2603:10a6:208::18)
 To DB9PR10MB4713.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:261::7)
X-Microsoft-Original-Message-ID: <b1ada4a0-0049-5c68-95cc-dfecf375f8b5@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (84.57.55.161) by AM0PR03CA0041.eurprd03.prod.outlook.com (2603:10a6:208::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Tue, 22 Jun 2021 05:10:21 +0000
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 48
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 4ad1ba75-b682-4dc8-342f-08d9353c09aa
X-MS-TrafficTypeDiagnostic: VI1EUR05HT195:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAoo1wxbIIjfe65ebFtY0zAwStnVsPPv9dyjR4DuitYbast8b9HhnBW0MkrW9VhJxgVpf1PXQ0MoO3RX4OgWvxGX0k3J680FjnZF9UqNFUpwlHYnP1Cj8kPHc2WQRrocjLq692ATI9ugvTspVIg3irRvch0PkML8b8+ATXYuVw8U/AcF0uwTnqR6cXNQPGW+MZ4fIUc+q0C5lXix7huWHFW47+RD41tmNOUWg0krSJ7iPrCwVIh4JuDBhs4cgeBtVLiQCiZFxBkAPxuCpvOzQXk5IxH651+vDxkgJQEK/hfLnxeF+MHe1U0WjbdVuz2opl+GeYVqy+T+I61nEtYy+Jpz4HB+jV9VnbuE6cgoyi3mTChOhuJPVzkmvOSyez7y
X-MS-Exchange-AntiSpam-MessageData: A3X7cpQWT6cBhyeqhn3Dmulejl3u5+AFz1qRhWpA7d9HqqNcjwA4lJbpd6HWGLDS/dmYsodexAv4UpWZuMzUBdzGRGAhnlxBDT/iEnDi9Fteg2lP0pZp6okpt+ysTc7UHK/II4GTdlltIW+Ifotouw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad1ba75-b682-4dc8-342f-08d9353c09aa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 05:10:23.1093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT027.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR05HT195
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/21 11:31 PM, Bernd Edlinger wrote:
> On 6/15/21 4:26 PM, Bernd Edlinger wrote:
>> The first phase of de_thread needs co-operation from a user task,
>> if and only if any task t except the thread leader has t->ptrace.
>> Taking tasks from RUNNING->EXIT_ZOMBIE only needs co-operation from kernel code,
> 
> 
> Aehm, sorry, that is not correct, what I said here.
> 
> I totally overlooked ptrace(PTRACE_SEIZE, pid, 0L, PTRACE_O_TRACEEXIT)
> 
> and unfortunately this also prevents even the thread leader to enter the
> EXIT_ZOMBIE state because do_exit does:
> 
>         ptrace_event(PTRACE_EVENT_EXIT, code);
> 
> unfortunately this sends an event to the tracer, and waits not only for
> the tracer to call waitpid, but also needs a PTRACE_CONT before do_exit
> can call exit_notify which does tsk->exit_state = EXIT_ZOMBIE.
> 

P.S:

I think there is something really odd in ptrace_stop().

If it is intentional (which I believe to be the case) to wait here after a
SIGKILL until the process enters the exit_state == EXIT_ZOMBIE, then aborting the
pending ptrace_stop() via sigkill_pending() is questionable, especially because
arch_ptrace_stop_needed() is defined as (0) in most architectures, only sparc and
ia64 do something here.

static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t *info)
        __releases(&current->sighand->siglock)
        __acquires(&current->sighand->siglock)
{
        bool gstop_done = false;

        if (arch_ptrace_stop_needed(exit_code, info)) {
                /*
                 * The arch code has something special to do before a
                 * ptrace stop.  This is allowed to block, e.g. for faults
                 * on user stack pages.  We can't keep the siglock while
                 * calling arch_ptrace_stop, so we must release it now.
                 * To preserve proper semantics, we must do this before
                 * any signal bookkeeping like checking group_stop_count.
                 * Meanwhile, a SIGKILL could come in before we retake the
                 * siglock.  That must prevent us from sleeping in TASK_TRACED.
                 * So after regaining the lock, we must check for SIGKILL.
                 */
                spin_unlock_irq(&current->sighand->siglock);
                arch_ptrace_stop(exit_code, info);
                spin_lock_irq(&current->sighand->siglock);
                if (sigkill_pending(current))
                        return;
        }

        set_special_state(TASK_TRACED);

After this point there is no sigkill_pending() or fatal_signal_pending(), just
a single freezable_schedule() which explains why this can even wait with a fatal
signal pending.  But if the code executes the if block above the sigkill can
only be ignored if it happens immediately before the set_special_state(TASK_TRACED).

What do you think?


Bernd.
