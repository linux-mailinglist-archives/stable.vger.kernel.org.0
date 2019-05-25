Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA8A2A453
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 14:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfEYMJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 08:09:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42620 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfEYMJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 08:09:25 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 941F98029F; Sat, 25 May 2019 14:09:12 +0200 (CEST)
Date:   Sat, 25 May 2019 14:08:35 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, Xiao Ni <xni@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 4.19 108/114] Revert "Dont jump to compute_result state
 from check_result state"
Message-ID: <20190525120835.GA2975@xo-6d-61-c0.localdomain>
References: <20190523181731.372074275@linuxfoundation.org>
 <20190523181740.646499661@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523181740.646499661@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 2019-05-23 21:06:47, Greg Kroah-Hartman wrote:
> From: Song Liu <songliubraving@fb.com>
> 
> commit a25d8c327bb41742dbd59f8c545f59f3b9c39983 upstream.
> 
> This reverts commit 4f4fd7c5798bbdd5a03a60f6269cf1177fbd11ef.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Nigel Croxon <ncroxon@redhat.com>
> Cc: Xiao Ni <xni@redhat.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

We normally reject patches without changelog, and this has none. Why
make exception here?

									Pavel

> 
> ---
>  drivers/md/raid5.c |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4221,15 +4221,26 @@ static void handle_parity_checks6(struct
>  	case check_state_check_result:
>  		sh->check_state = check_state_idle;
>  
> -		if (s->failed > 1)
> -			break;
>  		/* handle a successful check operation, if parity is correct
>  		 * we are done.  Otherwise update the mismatch count and repair
>  		 * parity if !MD_RECOVERY_CHECK
>  		 */
>  		if (sh->ops.zero_sum_result == 0) {
> -			/* Any parity checked was correct */
> -			set_bit(STRIPE_INSYNC, &sh->state);
> +			/* both parities are correct */
> +			if (!s->failed)
> +				set_bit(STRIPE_INSYNC, &sh->state);
> +			else {
> +				/* in contrast to the raid5 case we can validate
> +				 * parity, but still have a failure to write
> +				 * back
> +				 */
> +				sh->check_state = check_state_compute_result;
> +				/* Returning at this point means that we may go
> +				 * off and bring p and/or q uptodate again so
> +				 * we make sure to check zero_sum_result again
> +				 * to verify if p or q need writeback
> +				 */
> +			}
>  		} else {
>  			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
>  			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
