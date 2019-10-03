Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388A0CAF85
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 21:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfJCTsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 15:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbfJCTsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 15:48:42 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 027E2207FF;
        Thu,  3 Oct 2019 19:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570132121;
        bh=7KnGrY3edgCuzPOLxlDb4V9WqO8qVeaOWYXjcMJiAkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0yK46MgQnh4dKlaP50jmm/Y5o/s+oHQoFyWWZHKDYjtWAj7Hsh9W6Vs0qACedjEC/
         gh/am9KHY7de4Y8/vXGEXnbxhAhrfhFbuG9seU80pVGXz26DdykmbtuQpBrvSUtNCi
         vmK5VGd3j6LkNghAy+rz3Dw3Li70TVmj58oRrwrQ=
Date:   Thu, 3 Oct 2019 12:48:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+af05535bb79520f95431@syzkaller.appspotmail.com,
        syzbot+d86c4426a01f60feddc7@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 209/211] fuse: fix deadlock with aio poll and
 fuse_iqueue::waitq.lock
Message-ID: <20191003194838.GA6620@gmail.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+af05535bb79520f95431@syzkaller.appspotmail.com,
        syzbot+d86c4426a01f60feddc7@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <20191003154447.010950442@linuxfoundation.org>
 <20191003154530.645657617@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003154530.645657617@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:54:35PM +0200, Greg Kroah-Hartman wrote:
>  
>  static void queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
>  {
> -	spin_lock(&fiq->waitq.lock);
> +	spin_lock(&fiq->lock);
>  	if (test_bit(FR_FINISHED, &req->flags)) {
> -		spin_unlock(&fiq->waitq.lock);
> +		spin_unlock(&fiq->lock);
>  		return;
>  	}
>  	if (list_empty(&req->intr_entry)) {
>  		list_add_tail(&req->intr_entry, &fiq->interrupts);
>  		wake_up_locked(&fiq->waitq);
>  	}
> -	spin_unlock(&fiq->waitq.lock);
> +	spin_unlock(&fiq->lock);
>  	kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
>  }

This isn't backported correctly.  wake_up_locked() needs to be changed to wake_up().

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index c0d59a86ada2e..6d39143cfa094 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -434,7 +434,7 @@ static void queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 	}
 	if (list_empty(&req->intr_entry)) {
 		list_add_tail(&req->intr_entry, &fiq->interrupts);
-		wake_up_locked(&fiq->waitq);
+		wake_up(&fiq->waitq);
 	}
 	spin_unlock(&fiq->lock);
 	kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
