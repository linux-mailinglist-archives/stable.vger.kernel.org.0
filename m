Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260BF23D774
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 09:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgHFHjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 03:39:43 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38819 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728226AbgHFHjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 03:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596699580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=An1Oasi6WfjvFdX07SK6xSxY9p8UaW2YdG0lQLP49z8=;
        b=B4XkP7FX6OIyH/CnqDf+tnIjbdCfBIqtN5wLCUdoH+g0dg/Ml+EOMxCCYeB6frxaYFxs6u
        5B0yReqIUyraEq0DVgzGG1l4VOntOuH9GlFF7zZruKofOIDDusdB8DcfTP9mcSSECGT+tL
        eJgdVtIUzG+QW+TfeNxhgrfuqaz2yyw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-sMVuStivOXWevsd_fZBFlg-1; Thu, 06 Aug 2020 03:39:38 -0400
X-MC-Unique: sMVuStivOXWevsd_fZBFlg-1
Received: by mail-wm1-f72.google.com with SMTP id g72so3257278wme.4
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 00:39:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=An1Oasi6WfjvFdX07SK6xSxY9p8UaW2YdG0lQLP49z8=;
        b=Q8UKEsjTAdq2G9seH20C7kgC6rRmKc02/aEcTLfRAeMk73s2SaIl/8vYCWjjhQm//A
         PjEnk+dngjmC/YXbw61ikb291VHIH9XT5Viw9XrhSn5ltjAHq4d5qFLvpU2Xd7yuM2hs
         LVgvOlCfhbLTASfTLg54fDByRmbx15n3bV0U2iLa5HG1R9D7yVICmP6r1tipZmwp2Ikm
         qRS3ZaYERY/yzyq0Vfkof6iJHQxcU2qhC5OX+LDe1QlPXY3bJT1zK1U7NZuBwzP+k/Sb
         m+64oaHUJhJgqTZD1ANpCYK+SCUH5W7njEXQ/Lf49o6eI1iOinQ+D92cgZDFRtUbKBP+
         OFrg==
X-Gm-Message-State: AOAM531yUiZzvyYvwJt5SNuuLiy14lj9Q1TrFr95tB30fVlcXevOGgC1
        Ev00zm1OQnHGKiMsdO/V4VP26WMsvVpZxN8lHJtzcnqxULrsdIGlqwVxx1ZPeo3AkiMmH/9n7dE
        v3Y6LZEKRYhLe7NFy
X-Received: by 2002:a5d:644b:: with SMTP id d11mr5899186wrw.373.1596699577302;
        Thu, 06 Aug 2020 00:39:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhhFAPesv2pyh//l3LGSf7bqxfe76nMfFOWPNOCJ6Z2jd43DcUcTvx/jp54W1gKK2BQHo8Eg==
X-Received: by 2002:a5d:644b:: with SMTP id d11mr5899168wrw.373.1596699577087;
        Thu, 06 Aug 2020 00:39:37 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id i82sm5638561wmi.10.2020.08.06.00.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 00:39:36 -0700 (PDT)
Date:   Thu, 6 Aug 2020 09:39:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring: set ctx sq/cq entry count earlier
Message-ID: <20200806073933.khoasyujngaxbcq4@steredhat>
References: <20200805190224.401962-1-axboe@kernel.dk>
 <20200805190224.401962-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805190224.401962-2-axboe@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 01:02:23PM -0600, Jens Axboe wrote:
> If we hit an earlier error path in io_uring_create(), then we will have
> accounted memory, but not set ctx->{sq,cq}_entries yet. Then when the
> ring is torn down in error, we use those values to unaccount the memory.
> 
> Ensure we set the ctx entries before we're able to hit a potential error
> path.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8f96566603f3..0d857f7ca507 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8193,6 +8193,10 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>  	struct io_rings *rings;
>  	size_t size, sq_array_offset;
>  
> +	/* make sure these are sane, as we already accounted them */
> +	ctx->sq_entries = p->sq_entries;
> +	ctx->cq_entries = p->cq_entries;
> +
>  	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
>  	if (size == SIZE_MAX)
>  		return -EOVERFLOW;
> @@ -8209,8 +8213,6 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>  	rings->cq_ring_entries = p->cq_entries;
>  	ctx->sq_mask = rings->sq_ring_mask;
>  	ctx->cq_mask = rings->cq_ring_mask;
> -	ctx->sq_entries = rings->sq_ring_entries;
> -	ctx->cq_entries = rings->cq_ring_entries;
>  
>  	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
>  	if (size == SIZE_MAX) {
> -- 
> 2.28.0
> 

While reviewing I was asking if we should move io_account_mem() before
io_allocate_scq_urings(), then I saw the second patch :-)

LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

