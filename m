Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95E519BC9F
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 09:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387403AbgDBHWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 03:22:33 -0400
Received: from mail-oln040092074010.outbound.protection.outlook.com ([40.92.74.10]:6084
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728425AbgDBHWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 03:22:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiNOZHMxpkKMBa6yuvQ8xTPdsWHI2ALPl1ggDv5AsaulH/k71k3Kpxb3zJ3c8CroLACqB9jYW3cJE+hwac2mGBNvKkjIZ1gRRcg1Az1QVmKTsPScMkw6kgpicNrHPYcPwPdXJef+LZiLlOCtI87cAJlZ0YnCoj6WmYJcaAx2rKPptk3pesLIMGkaKwDEB1RMCfX2ZE9dfP0nIQ7LSFq/lNtPYKBqdkRlnAAOo2idO0/texpwA6eLlUJwbLxrhp2cMdH0Fj+ISxgFhesFXM6cf+Lqa+g0F/UgzyfCwNjgxWHhyDCkpJPrPufjISDWESW0c/7v5mCW02W2l4VGCOMorg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBVJqtgMdQtnFcQSqwHmVcy5aH977kgvW7Xg+tZeWPc=;
 b=bB9fE1/UyozaAie9fjYcBYQzCDBL0DnzTS1/OAXCcLgPn/iZeQuRlpjcY8Nrrw6uIuY3WACqnVBTzf+QvT9Bmfwtl142ErjsSmPfKqOEElxuGrbq+t418XpS0pMAsGRgasJfI3nPlH0FH9IDaCV/JKrB9IFNO3nTcngWJTtSUikaosIjnha5yjh7hLTkbDg7l7fMCiJn0njPhOoX79RImT8zNi2ajOMiwRxsPjDad3faW9zpPVH8KoNwV7aLWr8cYeX9+HQf3pPm4tmvJOLTiybPxWO5WGITbHqJNqXfFm65IJ0nnj836yUUITnJWzHHcRRrarUb5HqvN+craU4taA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR04FT004.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0d::4a) by
 HE1EUR04HT014.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0d::309)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Thu, 2 Apr
 2020 07:22:29 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 (2a01:111:e400:7e0d::50) by HE1EUR04FT004.mail.protection.outlook.com
 (2a01:111:e400:7e0d::274) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend
 Transport; Thu, 2 Apr 2020 07:22:29 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:E7B5E17202D6A90C04C325695E3FAE5128698D345945BB92FCDBA0F020470AD7;UpperCasedChecksum:6A14A83A027B343DDFAFF9CF8B12B8576AD0143054F668726F7F8F3A51721EAF;SizeAsReceived:8374;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::d57:5853:a396:969d]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::d57:5853:a396:969d%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 07:22:29 +0000
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Adam Zabrocki <pi3@pi3.com.pl>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB51701153BF3E55EB4285EADFE4C60@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Thu, 2 Apr 2020 09:22:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0001.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::11) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <46ac0369-ff40-733f-bb2a-2a6919a48eee@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR10CA0001.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Thu, 2 Apr 2020 07:22:28 +0000
X-Microsoft-Original-Message-ID: <46ac0369-ff40-733f-bb2a-2a6919a48eee@hotmail.de>
X-TMN:  [tiG2wbnlWRVxx08YkgRHuaN5VFK7C3H0]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 88af6c2b-72f4-43b2-87b2-08d7d6d69a06
X-MS-TrafficTypeDiagnostic: HE1EUR04HT014:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vm9mxdpuYK8ONT77erL+LkK2OyGrTGQYbgZJWSY+/T8i1UnES7/hfotlBAs3ATJGfbvapvj9SXlb4I0mT2Npabpn5jZ9TRSMRE7Y7dtjLC8wnyRuUUhJ5DWkjAkQX808ADEz8o8gOS16cw9saekcZ6BU6CCEIJAPGfMiQix8wGvTcPp4EQWpl5kwes3Np9d/w4KLKRzfletMS5sO0uU4oIXTtCV1eWnHiZTvEHZIleg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:0;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB5170.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:;DIR:OUT;SFP:1901;
X-MS-Exchange-AntiSpam-MessageData: W+KtyJgIKA9trqB39M/vA4OFmZqevmrFIVXWsvioHdXVYlUUcj1XCSvwrdSnpKwQhEsn64QWA/t5dd7j/k8HimAd71Q1Vuuhltw9TyP4Y10A8A9K1TlaBxCW4ZPgKHEf60NPwB06qfcxRc1jkOuluA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88af6c2b-72f4-43b2-87b2-08d7d6d69a06
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 07:22:29.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR04HT014
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/1/20 10:47 PM, Eric W. Biederman wrote:
> 
> Replace the 32bit exec_id with a 64bit exec_id to make it impossible
> to wrap the exec_id counter.  With care an attacker can cause exec_id
> wrap and send arbitrary signals to a newly exec'd parent.  This
> bypasses the signal sending checks if the parent changes their
> credentials during exec.
> 
> The severity of this problem can been seen that in my limited testing
> of a 32bit exec_id it can take as little as 19s to exec 65536 times.
> Which means that it can take as little as 14 days to wrap a 32bit
> exec_id.  Adam Zabrocki has succeeded wrapping the self_exe_id in 7
> days.  Even my slower timing is in the uptime of a typical server.
> Which means self_exec_id is simply a speed bump today, and if exec
> gets noticably faster self_exec_id won't even be a speed bump.
> 
> Extending self_exec_id to 64bits introduces a problem on 32bit
> architectures where reading self_exec_id is no longer atomic and can
> take two read instructions.  Which means that is is possible to hit
> a window where the read value of exec_id does not match the written
> value.  So with very lucky timing after this change this still
> remains expoiltable.
> 
> I have updated the update of exec_id on exec to use WRITE_ONCE
> and the read of exec_id in do_notify_parent to use READ_ONCE
> to make it clear that there is no locking between these two
> locations.
> 
> Link: https://lore.kernel.org/kernel-hardening/20200324215049.GA3710@pi3.com.pl
> Fixes: 2.3.23pre2
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>


Thanks
Bernd.
> ---
> 
> Linus would you prefer to take this patch directly or I could put it in
> a brach and send you a pull request.
>  
>  fs/exec.c             | 2 +-
>  include/linux/sched.h | 4 ++--
>  kernel/signal.c       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 0e46ec57fe0a..d55710a36056 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1413,7 +1413,7 @@ void setup_new_exec(struct linux_binprm * bprm)
>  
>  	/* An exec changes our domain. We are no longer part of the thread
>  	   group */
> -	current->self_exec_id++;
> +	WRITE_ONCE(current->self_exec_id, current->self_exec_id + 1);
>  	flush_signal_handlers(current, 0);
>  }
>  EXPORT_SYMBOL(setup_new_exec);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 04278493bf15..0323e4f0982a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -939,8 +939,8 @@ struct task_struct {
>  	struct seccomp			seccomp;
>  
>  	/* Thread group tracking: */
> -	u32				parent_exec_id;
> -	u32				self_exec_id;
> +	u64				parent_exec_id;
> +	u64				self_exec_id;
>  
>  	/* Protection against (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed, mempolicy: */
>  	spinlock_t			alloc_lock;
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 9ad8dea93dbb..5383b562df85 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1926,7 +1926,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
>  		 * This is only possible if parent == real_parent.
>  		 * Check if it has changed security domain.
>  		 */
> -		if (tsk->parent_exec_id != tsk->parent->self_exec_id)
> +		if (tsk->parent_exec_id != READ_ONCE(tsk->parent->self_exec_id))
>  			sig = SIGCHLD;
>  	}
>  
> 
