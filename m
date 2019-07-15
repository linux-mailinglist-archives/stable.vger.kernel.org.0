Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEE569BCD
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 21:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbfGOT6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 15:58:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45484 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730712AbfGOT6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 15:58:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so8206087pgp.12;
        Mon, 15 Jul 2019 12:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ceLECMEmBKTfKlOu7paiH5PQ+8sxnNMR+mr/dxfQEl4=;
        b=DVG25CA+YnRtwdSO7z+++PHnmtVxGy2AekQPf1X2D9muQnThshcJFGG+3kUAqZFrbK
         1QIpkEPp4F0AKiXPZ2imbmS1ZbRw6WWiDTYLa3CfLHjvIX0S6X4LbQUAG+2/DvE1zKjM
         n4qrQXnUAlnqKG3B2UnpwIfwJ3imktX8ZNU5BnTBBroADzrbIZkhT9igbxhQalOn05Mj
         W72jQlgGwnzHu53a7/DOphPA5KsBfjEJjiAh5afkMIKuDsZD0tiI13RfEcmNPl9P4WmE
         S6WP6LpbnX1NDO9wHB87INmsC8fcDsgkieBSgYALwDD2TyQg/za5pY0vY9ha1phG8+Tb
         B0gQ==
X-Gm-Message-State: APjAAAWY5GET6mMMIucp2N3B3Klr9QvVb61fcu1xBgZJipu2yT91Q4Mf
        /g4gEMOh9t1vgBH3WYa1GYQ=
X-Google-Smtp-Source: APXvYqzpe7jfic5H1di9uqXZuyvefqKIO0cUqhkLmNSVfvQ/u5EHGYSJTiWBz16lgGHQPfpHItVcDA==
X-Received: by 2002:a17:90a:21cc:: with SMTP id q70mr32105249pjc.56.1563220690012;
        Mon, 15 Jul 2019 12:58:10 -0700 (PDT)
Received: from dennisz-mbp ([2620:10d:c091:500::3:5b6b])
        by smtp.gmail.com with ESMTPSA id p7sm18514921pfp.131.2019.07.15.12.58.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 12:58:09 -0700 (PDT)
Date:   Mon, 15 Jul 2019 15:58:06 -0400
From:   Dennis Zhou <dennis@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dennis Zhou <dennis@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.2 129/249] blk-iolatency: only account
 submitted bios
Message-ID: <20190715195806.GA77907@dennisz-mbp>
References: <20190715134655.4076-1-sashal@kernel.org>
 <20190715134655.4076-129-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715134655.4076-129-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 09:44:54AM -0400, Sasha Levin wrote:
> From: Dennis Zhou <dennis@kernel.org>
> 
> [ Upstream commit a3fb01ba5af066521f3f3421839e501bb2c71805 ]
> 
> As is, iolatency recognizes done_bio and cleanup as ending paths. If a
> request is marked REQ_NOWAIT and fails to get a request, the bio is
> cleaned up via rq_qos_cleanup() and ended in bio_wouldblock_error().
> This results in underflowing the inflight counter. Fix this by only
> accounting bios that were actually submitted.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  block/blk-iolatency.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index d22e61bced86..c91b84bb9d0a 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -600,6 +600,10 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
>  	if (!blkg || !bio_flagged(bio, BIO_TRACKED))
>  		return;
>  
> +	/* We didn't actually submit this bio, don't account it. */
> +	if (bio->bi_status == BLK_STS_AGAIN)
> +		return;
> +
>  	iolat = blkg_to_lat(bio->bi_blkg);
>  	if (!iolat)
>  		return;
> -- 
> 2.20.1
> 

Hi Sasha,

If you're going to pick this up, c9b3007feca0 ("blk-iolatency: fix
STS_AGAIN handling") fixes this patch, so please pick that up too.

Thanks,
Dennis
