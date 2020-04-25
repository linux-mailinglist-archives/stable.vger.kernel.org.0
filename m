Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C99A1B87BC
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 18:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgDYQmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 12:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgDYQmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 12:42:00 -0400
X-Greylist: delayed 1483 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Apr 2020 09:41:59 PDT
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23A1C09B04D;
        Sat, 25 Apr 2020 09:41:59 -0700 (PDT)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03PG83dA012540;
        Sat, 25 Apr 2020 17:17:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=yE8gezMKqzZQGT969c6mIeMNFgyLsfU3BI5rtoH1gdg=;
 b=flkRGpoLVF3+DftY4HJkXeHNf6R5nGNh6teD2pR5RgqAQr49oiCkvuhwxFrthmogUsX+
 W+bw5V+RnH8vcmwhK53o38F7M+cmwRVelsO/TG/lHJwNHQafmTrbF9L6zt576sty4anC
 gIPpi+5Det7LFhR2OWpj1NHpeSnw8q+pzSSYf33/bDa8qDtydVe9VQKakL1eiAsdfNca
 e75/pnxi48Hl4GzuCaMRHpLdI3F72XG5eJ6SEGBr1a/hjFasRzfNHG4fis0mbdJpmvue
 /sS+RBkeW4/K8rkI3yfCgGXkiNNqEopIJeD5VkRPT1FnWk6zqXDV42mZdz0/nKOFPdCf /A== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 30mcuwhuyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Apr 2020 17:17:09 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 03PGH90J030057;
        Sat, 25 Apr 2020 09:17:09 -0700
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint5.akamai.com with ESMTP id 30mk688p7b-1;
        Sat, 25 Apr 2020 09:17:09 -0700
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id C10DC347F8;
        Sat, 25 Apr 2020 16:17:08 +0000 (GMT)
Subject: Re: [PATCH v2] eventpoll: fix missing wakeup for ovflist in
 ep_poll_callback
To:     Khazhismel Kumykov <khazhy@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        stable@vger.kernel.org
References: <20200424025057.118641-1-khazhy@google.com>
 <20200424190039.192373-1-khazhy@google.com>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <66f26e74-6c7b-28c2-8b3f-faf8ea5229d4@akamai.com>
Date:   Sat, 25 Apr 2020 12:17:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424190039.192373-1-khazhy@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-25_08:2020-04-24,2020-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2004250143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-25_08:2020-04-24,2020-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1011 mlxlogscore=999
 spamscore=0 impostorscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004250141
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/24/20 3:00 PM, Khazhismel Kumykov wrote:
> In the event that we add to ovflist, before 339ddb53d373 we would be
> woken up by ep_scan_ready_list, and did no wakeup in ep_poll_callback.
> With that wakeup removed, if we add to ovflist here, we may never wake
> up. Rather than adding back the ep_scan_ready_list wakeup - which was
> resulting in unnecessary wakeups, trigger a wake-up in ep_poll_callback.

I'm just curious which 'wakeup' we are talking about here? There is:
wake_up(&ep->wq) for the 'ep' and then there is the nested one via:
ep_poll_safewake(ep, epi). It seems to me that its only about the later
one being missing not both? Is your workload using nested epoll?

If so, it might make sense to just do the later, since the point of
the original patch was to minimize unnecessary wakeups.

Thanks,

-Jason

> 
> We noticed that one of our workloads was missing wakeups starting with
> 339ddb53d373 and upon manual inspection, this wakeup seemed missing to
> me. With this patch added, we no longer see missing wakeups. I haven't
> yet tried to make a small reproducer, but the existing kselftests in
> filesystem/epoll passed for me with this patch.
> 
> Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> Reviewed-by: Roman Penyaev <rpenyaev@suse.de>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Heiher <r@hev.cc>
> Cc: Jason Baron <jbaron@akamai.com>
> Cc: <stable@vger.kernel.org>
> ---
> v2: use if/elif instead of goto + cleanup suggested by Roman
>  fs/eventpoll.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 8c596641a72b..d6ba0e52439b 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1171,6 +1171,10 @@ static inline bool chain_epi_lockless(struct epitem *epi)
>  {
>  	struct eventpoll *ep = epi->ep;
>  
> +	/* Fast preliminary check */
> +	if (epi->next != EP_UNACTIVE_PTR)
> +		return false;
> +
>  	/* Check that the same epi has not been just chained from another CPU */
>  	if (cmpxchg(&epi->next, EP_UNACTIVE_PTR, NULL) != EP_UNACTIVE_PTR)
>  		return false;
> @@ -1237,16 +1241,12 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
>  	 * chained in ep->ovflist and requeued later on.
>  	 */
>  	if (READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR) {
> -		if (epi->next == EP_UNACTIVE_PTR &&
> -		    chain_epi_lockless(epi))
> +		if (chain_epi_lockless(epi))
> +			ep_pm_stay_awake_rcu(epi);
> +	} else if (!ep_is_linked(epi)) {
> +		/* In the usual case, add event to ready list. */
> +		if (list_add_tail_lockless(&epi->rdllink, &ep->rdllist))
>  			ep_pm_stay_awake_rcu(epi);
> -		goto out_unlock;
> -	}
> -
> -	/* If this file is already in the ready list we exit soon */
> -	if (!ep_is_linked(epi) &&
> -	    list_add_tail_lockless(&epi->rdllink, &ep->rdllist)) {
> -		ep_pm_stay_awake_rcu(epi);
>  	}
>  
>  	/*
> 
