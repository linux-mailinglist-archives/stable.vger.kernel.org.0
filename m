Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CCF1C5997
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 16:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgEEObU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 10:31:20 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:58246 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729148AbgEEObU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 10:31:20 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045EQvdd006869;
        Tue, 5 May 2020 15:30:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=03Nwu6JjsT0rWT9gfDoCTWuSbxK/L+5JpaoujUtPskc=;
 b=fMoPDURtC80n7ph2QV4yAIERO5C+rKNaDjq+l09ixrHP5odJVwy4iL4ZmCD4WEmBSVzk
 u9vvcq60GfdxR2RZtvqUPkK98WfodF7zdQjFus1XVwL+1TZvT2VMzQ3COnv6rd6AWzBk
 JtJdtuQrj4bZpGYPO7gTmn9F9FcVuG7mHMBTekRklJRGFtG/usVv9c811CTumFRvos6n
 yux7ZSOv2LL8KWYRYubKYyVsEb/cg+bYxd4AFgtKoTeKNWF2xuh9jlKdEQQWWYIAI22Y
 s5DmiAsxeBAtNYF6SKkuhxt+pu5P3hIfEPRk8V0XvXW2ZX/mSgqoWW68sIrgEDKp1hMr /g== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 30s0wmmw7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 15:30:12 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 045E2jt8016968;
        Tue, 5 May 2020 10:30:03 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 30s46wjr5a-1;
        Tue, 05 May 2020 10:30:03 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 2FCDF34952;
        Tue,  5 May 2020 14:30:03 +0000 (GMT)
Subject: Re: [PATCH 1/1] epoll: call final ep_events_available() check under
 the lock
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200505084049.1779243-1-rpenyaev@suse.de>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <52b58e34-8c2c-9d3f-65f9-3807810c6b69@akamai.com>
Date:   Tue, 5 May 2020 10:30:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505084049.1779243-1-rpenyaev@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_08:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2005050114
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_08:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050117
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/5/20 4:40 AM, Roman Penyaev wrote:
> The original problem was described here:
>    https://lkml.org/lkml/2020/4/27/1121
> 
> There is a possible race when ep_scan_ready_list() leaves ->rdllist
> and ->obflist empty for a short period of time although some events
> are pending. It is quite likely that ep_events_available() observes
> empty lists and goes to sleep. Since 339ddb53d373 ("fs/epoll: remove
> unnecessary wakeups of nested epoll") we are conservative in wakeups
> (there is only one place for wakeup and this is ep_poll_callback()),
> thus ep_events_available() must always observe correct state of
> two lists. The easiest and correct way is to do the final check
> under the lock. This does not impact the performance, since lock
> is taken anyway for adding a wait entry to the wait queue.
> 
> In this patch barrierless __set_current_state() is used. This is
> safe since waitqueue_active() is called under the same lock on wakeup
> side.
> 
> Short-circuit for fatal signals (i.e. fatal_signal_pending() check)
> is moved to the line just before actual events harvesting routine.
> This is fully compliant to what is said in the comment of the patch
> where the actual fatal_signal_pending() check was added:
> c257a340ede0 ("fs, epoll: short circuit fetching events if thread
> has been killed").
> 
> Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
> Reported-by: Jason Baron <jbaron@akamai.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  fs/eventpoll.c | 48 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index aba03ee749f8..8453e5403283 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1879,34 +1879,33 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  		 * event delivery.
>  		 */
>  		init_wait(&wait);
> -		write_lock_irq(&ep->lock);
> -		__add_wait_queue_exclusive(&ep->wq, &wait);
> -		write_unlock_irq(&ep->lock);
>  
> +		write_lock_irq(&ep->lock);
>  		/*
> -		 * We don't want to sleep if the ep_poll_callback() sends us
> -		 * a wakeup in between. That's why we set the task state
> -		 * to TASK_INTERRUPTIBLE before doing the checks.
> +		 * Barrierless variant, waitqueue_active() is called under
> +		 * the same lock on wakeup ep_poll_callback() side, so it
> +		 * is safe to avoid an explicit barrier.
>  		 */
> -		set_current_state(TASK_INTERRUPTIBLE);
> +		__set_current_state(TASK_INTERRUPTIBLE);
> +
>  		/*
> -		 * Always short-circuit for fatal signals to allow
> -		 * threads to make a timely exit without the chance of
> -		 * finding more events available and fetching
> -		 * repeatedly.
> +		 * Do the final check under the lock. ep_scan_ready_list()
> +		 * plays with two lists (->rdllist and ->ovflist) and there
> +		 * is always a race when both lists are empty for short
> +		 * period of time although events are pending, so lock is
> +		 * important.
>  		 */
> -		if (fatal_signal_pending(current)) {
> -			res = -EINTR;
> -			break;
> +		eavail = ep_events_available(ep);
> +		if (!eavail) {
> +			if (signal_pending(current))
> +				res = -EINTR;
> +			else
> +				__add_wait_queue_exclusive(&ep->wq, &wait);
>  		}
> +		write_unlock_irq(&ep->lock);
>  
> -		eavail = ep_events_available(ep);
> -		if (eavail)
> -			break;
> -		if (signal_pending(current)) {
> -			res = -EINTR;
> +		if (eavail || res)
>  			break;
> -		}
>  
>  		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
>  			timed_out = 1;
> @@ -1927,6 +1926,15 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  	}
>  
>  send_events:
> +	if (fatal_signal_pending(current))
> +		/*
> +		 * Always short-circuit for fatal signals to allow
> +		 * threads to make a timely exit without the chance of
> +		 * finding more events available and fetching
> +		 * repeatedly.
> +		 */
> +		res = -EINTR;
> +
>  	/*
>  	 * Try to transfer events to user space. In case we get 0 events and
>  	 * there's still timeout left over, we go trying again in search of
> 



Hi Roman,

Looks good feel free to add:
Reviewed-by: Jason Baron <jbaron@akamai.com>

I think we should also add the fixes tag to assist stable backports:
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")

Thanks,

-Jason

