Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDB519732
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 05:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfEJDlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 23:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbfEJDlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 23:41:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A79E33082E5F;
        Fri, 10 May 2019 03:41:13 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B12761A267;
        Fri, 10 May 2019 03:41:07 +0000 (UTC)
Date:   Fri, 10 May 2019 11:41:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@fb.com>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/5] sbitmap: fix improper use of smp_mb__before_atomic()
Message-ID: <20190510034101.GC27944@ming.t460p>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-4-git-send-email-andrea.parri@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556568902-12464-4-git-send-email-andrea.parri@amarulasolutions.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 10 May 2019 03:41:13 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 10:14:59PM +0200, Andrea Parri wrote:
> This barrier only applies to the read-modify-write operations; in
> particular, it does not apply to the atomic_set() primitive.
> 
> Replace the barrier with an smp_mb().
> 
> Fixes: 6c0ca7ae292ad ("sbitmap: fix wakeup hang after sbq resize")
> Cc: stable@vger.kernel.org
> Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: linux-block@vger.kernel.org
> ---
>  lib/sbitmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/sbitmap.c b/lib/sbitmap.c
> index 155fe38756ecf..4a7fc4915dfc6 100644
> --- a/lib/sbitmap.c
> +++ b/lib/sbitmap.c
> @@ -435,7 +435,7 @@ static void sbitmap_queue_update_wake_batch(struct sbitmap_queue *sbq,
>  		 * to ensure that the batch size is updated before the wait
>  		 * counts.
>  		 */
> -		smp_mb__before_atomic();
> +		smp_mb();
>  		for (i = 0; i < SBQ_WAIT_QUEUES; i++)
>  			atomic_set(&sbq->ws[i].wait_cnt, 1);
>  	}
> -- 
> 2.7.4
> 

sbitmap_queue_update_wake_batch() won't be called in fast path, and
the fix is correct too, so:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

thanks,
Ming
