Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8822427F
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 23:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfETVHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 17:07:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfETVHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 17:07:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2A27160E5A; Mon, 20 May 2019 21:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558386458;
        bh=sWncJZuhv8jI+fIBFRSxi31uAvCtEl1i4p1lxELRFRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nL//rSHE6KjOz11WOppOfdg1BN3yl8ghHHVhz73xGsT+Lg4VWyhE04fiURkXgMd4/
         AoXnudMM8SOnS/5QSYsw6qba8/ryRIuWNYjCgtHAjxC0YDcRSgQQY3ZrN+QgEq94RX
         z2VLyfl88VQK/YnQaQISymEp0VM5ucs888ManETM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from jcrouse1-lnx.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jcrouse@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A6EF6087F;
        Mon, 20 May 2019 21:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558386455;
        bh=sWncJZuhv8jI+fIBFRSxi31uAvCtEl1i4p1lxELRFRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ofhwcs4UV5Eiw/8Yh2sbqC5v5RszTv9UDRERtPCyHv57GGfii7jR7FIpsvYfSI3ix
         7jVVXO5LMVHUH3yFV1a9VAI0JM6M2qONikDtYrsbXg6mGqh2iLCBpBkFpu4r/iCpgb
         /vwVtw1JbtNGZAEDezrF4QMBKcOmKSbWzsZDeUyY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A6EF6087F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jcrouse@codeaurora.org
Date:   Mon, 20 May 2019 15:07:32 -0600
From:   Jordan Crouse <jcrouse@codeaurora.org>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] drm/msm: Fix improper uses of
 smp_mb__{before,after}_atomic()
Message-ID: <20190520210732.GF24137@jcrouse1-lnx.qualcomm.com>
Mail-Followup-To: Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <1558373038-5611-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1558373038-5611-2-git-send-email-andrea.parri@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558373038-5611-2-git-send-email-andrea.parri@amarulasolutions.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 07:23:55PM +0200, Andrea Parri wrote:
> These barriers only apply to the read-modify-write operations; in
> particular, they do not apply to the atomic_set() primitive.
> 
> Replace the barriers with smp_mb()s.
> 
> Fixes: b1fc2839d2f92 ("drm/msm: Implement preemption for A5XX targets")
> Cc: stable@vger.kernel.org
> Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Sean Paul <sean@poorly.run>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Jordan Crouse <jcrouse@codeaurora.org>
> Cc: linux-arm-msm@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: freedreno@lists.freedesktop.org
> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>

I'll go ahead and ack this - I'm not super clued in on atomic barriers, but this
seems to be in the spirit of what we are trying to do to protect the atomic
value. Rob can disagree, of course.

Acked-by: Jordan Crouse <jcrouse@codeaurora.org>

> ---
>  drivers/gpu/drm/msm/adreno/a5xx_preempt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
> index 3d62310a535fb..ee0820ee0c664 100644
> --- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
> +++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
> @@ -39,10 +39,10 @@ static inline void set_preempt_state(struct a5xx_gpu *gpu,
>  	 * preemption or in the interrupt handler so barriers are needed
>  	 * before...
>  	 */
> -	smp_mb__before_atomic();
> +	smp_mb();
>  	atomic_set(&gpu->preempt_state, new);
>  	/* ... and after*/
> -	smp_mb__after_atomic();
> +	smp_mb();
>  }
>  
>  /* Write the most recent wptr for the given ring into the hardware */
> -- 
> 2.7.4
> 

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
