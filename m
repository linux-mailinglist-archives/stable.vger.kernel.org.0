Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B461972E
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 05:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfEJDkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 23:40:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbfEJDkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 23:40:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D6E863004156;
        Fri, 10 May 2019 03:40:13 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C05621001E74;
        Fri, 10 May 2019 03:40:06 +0000 (UTC)
Date:   Fri, 10 May 2019 11:40:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/5] bio: fix improper use of smp_mb__before_atomic()
Message-ID: <20190510034001.GB27944@ming.t460p>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-3-git-send-email-andrea.parri@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556568902-12464-3-git-send-email-andrea.parri@amarulasolutions.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 10 May 2019 03:40:13 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 10:14:58PM +0200, Andrea Parri wrote:
> This barrier only applies to the read-modify-write operations; in
> particular, it does not apply to the atomic_set() primitive.
> 
> Replace the barrier with an smp_mb().
> 
> Fixes: dac56212e8127 ("bio: skip atomic inc/dec of ->bi_cnt for most use cases")
> Cc: stable@vger.kernel.org
> Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-block@vger.kernel.org
> ---
>  include/linux/bio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index e584673c18814..5becbafb84e8a 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -224,7 +224,7 @@ static inline void bio_cnt_set(struct bio *bio, unsigned int count)
>  {
>  	if (count != 1) {
>  		bio->bi_flags |= (1 << BIO_REFFED);
> -		smp_mb__before_atomic();
> +		smp_mb();
>  	}
>  	atomic_set(&bio->__bi_cnt, count);
>  }
> -- 
> 2.7.4
> 

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming
