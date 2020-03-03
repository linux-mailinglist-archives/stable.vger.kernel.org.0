Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D581782C7
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgCCTFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 14:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729484AbgCCTFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 14:05:52 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53D0020866;
        Tue,  3 Mar 2020 19:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583262351;
        bh=7oVEFbNlTZs1VRKElH/E2vVHypkdBi9pVhCmnsMRY10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PoP7rXzHWyifDLXhlk5z+rPlC4dP8Inq0fyf3V3696dRlP6pPB2KWWc48LSH9GtB/
         cgLIdgUthvwfzyNpkyd39FZrqKW7D2JxISNrxoGCdtFTUEpjTB2jMQ5it6Q0/6xTYg
         uys52HPFo1cQpPmhbyofTDVtGGyPkU/j3thQeuxM=
Date:   Tue, 3 Mar 2020 14:05:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jack@suse.cz, axboe@kernel.dk, bvanassche@acm.org,
        chaitanya.kulkarni@wdc.com, ming.lei@redhat.com, tristmd@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] blktrace: Protect q->blk_trace with RCU"
 failed to apply to 5.4-stable tree
Message-ID: <20200303190550.GM21491@sasha-vm>
References: <158317397191104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158317397191104@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 02, 2020 at 07:32:51PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From c780e86dd48ef6467a1146cf7d0fe1e05a635039 Mon Sep 17 00:00:00 2001
>From: Jan Kara <jack@suse.cz>
>Date: Thu, 6 Feb 2020 15:28:12 +0100
>Subject: [PATCH] blktrace: Protect q->blk_trace with RCU
>
>KASAN is reporting that __blk_add_trace() has a use-after-free issue
>when accessing q->blk_trace. Indeed the switching of block tracing (and
>thus eventual freeing of q->blk_trace) is completely unsynchronized with
>the currently running tracing and thus it can happen that the blk_trace
>structure is being freed just while __blk_add_trace() works on it.
>Protect accesses to q->blk_trace by RCU during tracing and make sure we
>wait for the end of RCU grace period when shutting down tracing. Luckily
>that is rare enough event that we can afford that. Note that postponing
>the freeing of blk_trace to an RCU callback should better be avoided as
>it could have unexpected user visible side-effects as debugfs files
>would be still existing for a short while block tracing has been shut
>down.
>
>Link: https://bugzilla.kernel.org/show_bug.cgi?id=205711
>CC: stable@vger.kernel.org
>Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>Reviewed-by: Ming Lei <ming.lei@redhat.com>
>Tested-by: Ming Lei <ming.lei@redhat.com>
>Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>Reported-by: Tristan Madani <tristmd@gmail.com>
>Signed-off-by: Jan Kara <jack@suse.cz>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

The conflict was because we don't have 67c0496e87d1 ("kernfs: convert
kernfs_node->id from union kernfs_node_id to u64") on 5.4. Fixed and
queued up.

-- 
Thanks,
Sasha
