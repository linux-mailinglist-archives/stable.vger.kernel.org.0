Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBD1D9777
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 18:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405403AbfJPQd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 12:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730251AbfJPQd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 12:33:27 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6BFB21835;
        Wed, 16 Oct 2019 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571243605;
        bh=PRG8FXIMyvpSm7XuyO5n0P5whjQefq+EG+9DddpOvss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TO/EnmLOiRISfZj+ExsfGKKqRrcUY0/JLyv23XDeQcaGTw9HKLbkY8h4TJ9C8/+ru
         sM2E6UktubjV2hOXO2JKFTMF36X3jCv/usBzfUQV0FL7NFTOfcia8Mx7Vb9sw614Pb
         aAElaTFhdSISXboeNdcWmxjRKCY5rpVWsFGYXQ9U=
Date:   Wed, 16 Oct 2019 09:33:19 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stefanha@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: only flush workqueues on
 fileset removal" failed to apply to 5.3-stable tree
Message-ID: <20191016163319.GA506416@kroah.com>
References: <1571241883130167@kroah.com>
 <20191016161320.GC441788@kroah.com>
 <3a044404-f84e-992a-ff2d-6d35aa4bddf2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a044404-f84e-992a-ff2d-6d35aa4bddf2@kernel.dk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 10:20:16AM -0600, Jens Axboe wrote:
> On 10/16/19 10:13 AM, Greg KH wrote:
> > On Wed, Oct 16, 2019 at 09:04:43AM -0700, gregkh@linuxfoundation.org wrote:
> >>
> >> The patch below does not apply to the 5.3-stable tree.
> >> If someone wants it applied there, or to any other stable or longterm
> >> tree, then please email the backport, including the original git commit
> >> id to <stable@vger.kernel.org>.
> >>
> >> thanks,
> >>
> >> greg k-h
> >>
> >> ------------------ original commit in Linus's tree ------------------
> >>
> >> >From 8a99734081775c012a4a6c442fdef0379fe52bdf Mon Sep 17 00:00:00 2001
> >> From: Jens Axboe <axboe@kernel.dk>
> >> Date: Wed, 9 Oct 2019 14:40:13 -0600
> >> Subject: [PATCH] io_uring: only flush workqueues on fileset removal
> >>
> >> We should not remove the workqueue, we just need to ensure that the
> >> workqueues are synced. The workqueues are torn down on ctx removal.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 6b06314c47e1 ("io_uring: add file set registration")
> >> Reported-by: Stefan Hajnoczi <stefanha@redhat.com>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index ceb3497bdd2a..2c44648217bd 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -2866,8 +2866,12 @@ static void io_finish_async(struct io_ring_ctx *ctx)
> >>   static void io_destruct_skb(struct sk_buff *skb)
> >>   {
> >>   	struct io_ring_ctx *ctx = skb->sk->sk_user_data;
> >> +	int i;
> >> +
> >> +	for (i = 0; i < ARRAY_SIZE(ctx->sqo_wq); i++)
> >> +		if (ctx->sqo_wq[i])
> >> +			flush_workqueue(ctx->sqo_wq[i]);
> >>   
> >> -	io_finish_async(ctx);
> >>   	unix_destruct_scm(skb);
> >>   }
> >>   
> >>
> > 
> > This fails to build as sqo_wq is a pointer in 5.3, not an arrary.
> > Backporting that array change feels "big" for 5.3, is that needed here,
> > or can this be fixed differently?
> 
> Yeah, we don't need to do that. It's just a pointer in 5.3, not an
> array of pointers, so the below should be all we need for 5.3 (and
> 5.2/5.1).

5.2/5.1 are long end-of-life, but this change looks sane.  I'll go queue
it up for 5.3.y, thanks for the patch!

greg k-h
