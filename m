Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165FC1F170D
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 12:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgFHK4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 06:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgFHK4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 06:56:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4492072F;
        Mon,  8 Jun 2020 10:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591613779;
        bh=/EWyRdXUA9OwrLvn9UXEgLKbsRPwLHEtU6i47D2IKMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bMTrN8bool+w6rNX0rdMsMm1JogTp4BUsZhKFsQYwq3BpniubYpewW4O82WWVyN6F
         fzsj8EHRqApQ24v7Zab7mbamK6C/daMf7TOQWkgwUZ+i/sINzN1qFWqMAuaufhagDN
         eoVCOqcWnxcmi1loTqYwTrIj0hhCDoTU2Qm7HvGo=
Date:   Mon, 8 Jun 2020 12:56:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org, Jianchao Wang <jianchao.w.wang@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with
 blk_mq_queue_tag_busy_iter
Message-ID: <20200608105617.GA295073@kroah.com>
References: <20200608094030.87031-1-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608094030.87031-1-gprocida@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 10:40:30AM +0100, Giuliano Procida wrote:
> From: Jianchao Wang <jianchao.w.wang@oracle.com>
> 
> commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f upstream.
> 
> For blk-mq, part_in_flight/rw will invoke blk_mq_in_flight/rw to
> account the inflight requests. It will access the queue_hw_ctx and
> nr_hw_queues w/o any protection. When updating nr_hw_queues and
> blk_mq_in_flight/rw occur concurrently, panic comes up.
> 
> Before update nr_hw_queues, the q will be frozen. So we could use
> q_usage_counter to avoid the race. percpu_ref_is_zero is used here
> so that we will not miss any in-flight request. The access to
> nr_hw_queues and queue_hw_ctx in blk_mq_queue_tag_busy_iter are
> under rcu critical section, __blk_mq_update_nr_hw_queues could use
> synchronize_rcu to ensure the zeroed q_usage_counter to be globally
> visible.
> 
> Backporting Notes
> 
> This is a re-backport, landing synchronize_rcu in the right place.

You sent this twice?

And what stable kernel(s) does it go to?

thanks,

greg k-h
