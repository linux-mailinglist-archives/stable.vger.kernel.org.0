Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96646F202
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 10:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfD3I2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 04:28:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59914 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfD3I2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 04:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ztnwMSHtedoT9Gv7PEZNypm2kmS00QDMZIphrledsXY=; b=sVSA9x2lnTx39ltHEPZtds4dz
        YiEJNhm1B4JWAiJA5kIIQke8QAp+P/wvO+MpBgMwf/WxjFPOs6jG2rak9aVm/M3/ZdBxZWQ8Eq0M/
        ppL6ZO2RZepBB8jhJQrqnBf+2+TlFCa5wiCDSdV9mUx2Bqi4zaHrvr8IGK76jyx6gZ3OCEqffBoNx
        +2UCQ8lh0ZVLit+1SZaRrM7rwNKZRcSpx7EHI2aacowq6goEHq2RGVSazG9OVR/uInVVLQoIZsrI7
        +vDBej0JLuz1/PGPwdXuziIx5UaGdIyy/HNLAzXTGbvd3z56RtJFYqjc7l5pAqPfKlQvpwWrcgQwL
        RuMaM33Dw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLO7b-00018M-Rz; Tue, 30 Apr 2019 08:28:16 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 60AFC29D2D6D8; Tue, 30 Apr 2019 10:28:14 +0200 (CEST)
Date:   Tue, 30 Apr 2019 10:28:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 5/5] IB/hfi1: Fix improper uses of smp_mb__before_atomic()
Message-ID: <20190430082814.GC2677@hirez.programming.kicks-ass.net>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 10:15:01PM +0200, Andrea Parri wrote:
> This barrier only applies to the read-modify-write operations; in
> particular, it does not apply to the atomic_read() primitive.
> 
> Replace the barrier with an smp_mb().
> 
> Fixes: 856cc4c237add ("IB/hfi1: Add the capability for reserved operations")
> Cc: stable@vger.kernel.org
> Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: linux-rdma@vger.kernel.org
> ---
>  drivers/infiniband/sw/rdmavt/qp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
> index a34b9a2a32b60..b64fd151d31fb 100644
> --- a/drivers/infiniband/sw/rdmavt/qp.c
> +++ b/drivers/infiniband/sw/rdmavt/qp.c
> @@ -1863,11 +1863,11 @@ static inline int rvt_qp_is_avail(
>  	u32 reserved_used;
>  
>  	/* see rvt_qp_wqe_unreserve() */

I see a completely bogus comment in rvf_op_wqe_unreserve(), referring to
bogus comments makes this barrier bogus too.

> -	smp_mb__before_atomic();
> +	smp_mb();
>  	reserved_used = atomic_read(&qp->s_reserved_used);
>  	if (unlikely(reserved_op)) {
>  		/* see rvt_qp_wqe_unreserve() */
> -		smp_mb__before_atomic();

This was before, but there is nothing _after_ this. Which means this
barrier was complete garbage anyway.

> +		smp_mb();
>  		if (reserved_used >= rdi->dparms.reserved_operations)
>  			return -ENOMEM;
>  		return 0;
> @@ -1882,7 +1882,7 @@ static inline int rvt_qp_is_avail(
>  		avail = slast - qp->s_head;
>  
>  	/* see rvt_qp_wqe_unreserve() */
> -	smp_mb__before_atomic();
> +	smp_mb();

Same as the first.

>  	reserved_used = atomic_read(&qp->s_reserved_used);
>  	avail =  avail - 1 -
>  		(rdi->dparms.reserved_operations - reserved_used);
