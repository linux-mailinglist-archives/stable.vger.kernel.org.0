Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1806596D0
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 10:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiL3JeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 04:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiL3JeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 04:34:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F181A831
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 01:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5378EB81A8D
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16CAC433EF;
        Fri, 30 Dec 2022 09:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672392844;
        bh=bTruuB15lr66yKwyRNqxYrdJjXl6XAiX2ECAhAdKZY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hldF/inSoUObMzN+ikQpP45E93DYIzEWqyptp4TVwtdqNoNz2qxzQMbLm8Z68An3U
         76FkB+p/RyXnrFI+6wMXoUHZQcIWydtxxilSbQBEQaey+JakVwyqOxui/NE4lhyTDJ
         Dtw6lD5ZduR1DeyDOLQXHFkj72WpxM3ms5W7XTTo=
Date:   Fri, 30 Dec 2022 10:34:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH 6.0 0853/1073] blk-mq: move the srcu_struct used for
 quiescing to the tagset
Message-ID: <Y66wif4K7MrKdYek@kroah.com>
References: <20221228144328.162723588@linuxfoundation.org>
 <20221228144351.187844650@linuxfoundation.org>
 <Y6z8tXYQ9ZEVVuNk@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6z8tXYQ9ZEVVuNk@T590>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 29, 2022 at 10:34:29AM +0800, Ming Lei wrote:
> On Wed, Dec 28, 2022 at 03:40:41PM +0100, Greg Kroah-Hartman wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > [ Upstream commit 80bd4a7aab4c9ce59bf5e35fdf52aa23d8a3c9f5 ]
> > 
> > All I/O submissions have fairly similar latencies, and a tagset-wide
> > quiesce is a fairly common operation.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Keith Busch <kbusch@kernel.org>
> > Reviewed-by: Ming Lei <ming.lei@redhat.com>
> > Reviewed-by: Chao Leng <lengchao@huawei.com>
> > Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> > Link: https://lore.kernel.org/r/20221101150050.3510-12-hch@lst.de
> > [axboe: fix whitespace]
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> commit 8537380bb988 ("blk-mq: skip non-mq queues in blk_mq_quiesce_queue")
> is required for backporting this patch, otherwise kernel panic can be
> triggered.

I've dropped this commit from the queues for now until they can be
brought all back in in a clean way.

thanks,

greg k-h
