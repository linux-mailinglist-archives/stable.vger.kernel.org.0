Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C7134909D
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhCYLgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbhCYLeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 07:34:23 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C23C06175F;
        Thu, 25 Mar 2021 04:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=USC2WJpl4Jn44EV27pxTIqr2IklVlHiIDrJVkv1jeLY=; b=wakw1vVlv0FDttFbFRrdtZGKI8
        DEpRMa3vC7l97yJ41a+hvNjRqJOvgTIAZXHAsXJ236zQIf+b/v3EWuvDpXCpwy/7V/i9y+nax1nkX
        XVJo46583cncdaYBnjnL2yOCulbfCYUj6yXhdY65xkc6xZXM3JsJ8dh7YRVBIWOoAniYqugr7dhPQ
        sLCIMXYRJ/Y7lUh4S9pdn44f3fnkZQshJis5tfcdXYVaUEg68Xo3VBUwGvzaQcx2Fx5OXaGGolp7H
        F2oJtN5qvKkvd4RcTU5CiqYNm27xnAogk9CwoQg/lKdT6trKh5laQ5I8TKLSl1hXtv5JuZeygKHiz
        KIaRDGQahmo8iJpxODX+bIug5GP8zlQfcZkCip6Bkm/MD1/x53GqDlLNsUm0e180s71/YStaOF1oT
        DcPW2eofdTsI5Uy9FPtZ+wo6mfdLRBpHCg1isnmQZTnRR7qmUUy1HIvC2gaZ9ttmP6Y+dBViu9FBs
        0590eJV3IRoB/vo4zZIsSSPf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPOFo-0007NA-SF; Thu, 25 Mar 2021 11:34:20 +0000
Subject: Re: [PATCH AUTOSEL 5.11 43/44] signal: don't allow STOP on
 PF_IO_WORKER threads
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-43-sashal@kernel.org>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <f4c932b4-b787-651e-dd9f-584b386acddb@samba.org>
Date:   Thu, 25 Mar 2021 12:34:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210325112459.1926846-43-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 25.03.21 um 12:24 schrieb Sasha Levin:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> [ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]
> 
> Just like we don't allow normal signals to IO threads, don't deliver a
> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
> signals in general, and have no means of flushing out a stop either.
> 
> Longer term, we may want to look into allowing stop of these threads,
> as it relates to eg process freezing. For now, this prevents a spin
> issue if a SIGSTOP is delivered to the parent task.
> 
> Reported-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/signal.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 55526b941011..00a3840f6037 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>  
> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
> +	if (unlikely(fatal_signal_pending(task) ||
> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>  		return false;
>  
>  	if (mask & JOBCTL_STOP_SIGMASK)
> 

Again, why is this proposed for 5.11 and 5.10 already?

metze
