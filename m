Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68872CCD57
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 02:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfJFABc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 20:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbfJFABc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 20:01:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5979C222C0;
        Sun,  6 Oct 2019 00:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570320091;
        bh=4oeBq7insg46SLcvkfh+2e9rk9Uf26qTSsU/Q2XHRX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSirJ8HY9KKN8GZpCo/Q6b6tBB346n9IdwHfET0zCQKeRmy+l0ztoL8seAW0QHkAI
         JYuTcqWfSjUL24jfPFn/keUjrnvNKugbv3XRt4iM9lBhCIPtSYOseSqkfDoJmVD48i
         Ad5x4Jmt2cVK1xxTrWhugpTycMXyh4ZD9H+aH+A4=
Date:   Sat, 5 Oct 2019 20:01:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: mq-deadline: Fix queue restart handling
Message-ID: <20191006000130.GE25255@sasha-vm>
References: <20191005030318.3786-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191005030318.3786-1-damien.lemoal@wdc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 05, 2019 at 12:03:18PM +0900, Damien Le Moal wrote:
>[ Upstream commit cb8acabbe33b110157955a7425ee876fb81e6bbc ]
>
>Commit 7211aef86f79 ("block: mq-deadline: Fix write completion
>handling") added a call to blk_mq_sched_mark_restart_hctx() in
>dd_dispatch_request() to make sure that write request dispatching does
>not stall when all target zones are locked. This fix left a subtle race
>when a write completion happens during a dispatch execution on another
>CPU:
>
>CPU 0: Dispatch			CPU1: write completion
>
>dd_dispatch_request()
>    lock(&dd->lock);
>    ...
>    lock(&dd->zone_lock);	dd_finish_request()
>    rq = find request		lock(&dd->zone_lock);
>    unlock(&dd->zone_lock);
>    				zone write unlock
>				unlock(&dd->zone_lock);
>				...
>				__blk_mq_free_request
>                                      check restart flag (not set)
>				      -> queue not run
>    ...
>    if (!rq && have writes)
>        blk_mq_sched_mark_restart_hctx()
>    unlock(&dd->lock)
>
>Since the dispatch context finishes after the write request completion
>handling, marking the queue as needing a restart is not seen from
>__blk_mq_free_request() and blk_mq_sched_restart() not executed leading
>to the dispatch stall under 100% write workloads.
>
>Fix this by moving the call to blk_mq_sched_mark_restart_hctx() from
>dd_dispatch_request() into dd_finish_request() under the zone lock to
>ensure full mutual exclusion between write request dispatch selection
>and zone unlock on write request completion.
>
>Fixes: 7211aef86f79 ("block: mq-deadline: Fix write completion handling")
>Cc: stable@vger.kernel.org
>Reported-by: Hans Holmberg <Hans.Holmberg@wdc.com>
>Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
>Reviewed-by: Christoph Hellwig <hch@lst.de>
>Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

I've queued it up for 4.19, thanks!

-- 
Thanks,
Sasha
