Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D40415F91C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbgBNVy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387740AbgBNVye (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:34 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A5A2082F;
        Fri, 14 Feb 2020 21:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717274;
        bh=OYh+gSlIU94scxyudSqYwAJAFzTWBH8PGD/ZxNTZSpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d/pC7NpeeEVJli3myYwMwnNNMTxcLniuoB41KuCSl+mFMegbs4O7KgRYFNqA6i+cD
         tIFB1kuVjBEs07wdv+a9uGPyfkThT6zmyyY4uF2lcNnmlNA0VDhO4JasTye42OmZxa
         LltH18J5GndfUoZ/eHRuJImg2upTRiKk7HpL0lMQ=
Date:   Fri, 14 Feb 2020 16:48:39 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.5 496/542] char: hpet: Fix out-of-bounds read
 bug
Message-ID: <20200214214839.GE4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-496-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-496-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:48:08AM -0500, Sasha Levin wrote:
> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> 
> [ Upstream commit 98c49f1746ac44ccc164e914b9a44183fad09f51 ]
> 
> Currently, there is an out-of-bounds read on array hpetp->hp_dev
> in the following for loop:
> 
> 870         for (i = 0; i < hdp->hd_nirqs; i++)
> 871                 hpetp->hp_dev[i].hd_hdwirq = hdp->hd_irq[i];
> 
> This is due to the recent change from one-element array to
> flexible-array member in struct hpets:
> 
> 104 struct hpets {
> 	...
> 113         struct hpet_dev hp_dev[];
> 114 };
> 
> This change affected the total size of the dynamic memory
> allocation, decreasing it by one time the size of struct hpet_dev.
> 
> Fix this by adjusting the allocation size when calling
> struct_size().
> 
> Fixes: 987f028b8637c ("char: hpet: Use flexible-array member")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Link: https://lore.kernel.org/r/20200129022613.GA24281@embeddedor.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/char/hpet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index aed2c45f7968c..ed3b7dab678db 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -855,7 +855,7 @@ int hpet_alloc(struct hpet_data *hdp)
>  		return 0;
>  	}
>  
> -	hpetp = kzalloc(struct_size(hpetp, hp_dev, hdp->hd_nirqs - 1),
> +	hpetp = kzalloc(struct_size(hpetp, hp_dev, hdp->hd_nirqs),
>  			GFP_KERNEL);
>  
>  	if (!hpetp)
> -- 
> 2.20.1
> 

Not needed unless you have the other patch that I asked you to drop
added :)
