Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71213532CA
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 08:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhDCGKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 02:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhDCGKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Apr 2021 02:10:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05DBF6120A;
        Sat,  3 Apr 2021 06:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617430236;
        bh=LyjJ30TVeTf/HFNxs8PCWYYFIPWpoaUvJ50Oqbh1lNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kDCc0GNar/b7x94TboxXAobz4xaKO0rEWJA7pky/MWdvg1747vnt4jjdfx5hbKv/G
         r3T8/FEU1UI8Nyj95B5WBBBGv/iFbglbct4hCtER9cbVZ8jzJUnsOOluuqbRu5BJjW
         3y4PTEgxw8hFMqYwVQT6maHZ3gPSSqUOTL0XgLVE=
Date:   Sat, 3 Apr 2021 08:10:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org
Subject: Re: [PATCH stable/5.4..5.8] nvme-mpath: replace direct_make_request
 with generic_make_request
Message-ID: <YGgG2TAA9TNqM9S6@kroah.com>
References: <20210402200841.347696-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402200841.347696-1-sagi@grimberg.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 02, 2021 at 01:08:41PM -0700, Sagi Grimberg wrote:
> The below patches caused a regression in a multipath setup:
> Fixes: 9f98772ba307 ("nvme-rdma: fix controller reset hang during traffic")
> Fixes: 2875b0aecabe ("nvme-tcp: fix controller reset hang during traffic")
> 
> These patches on their own are correct because they fixed a controller reset
> regression.
> 
> When we reset/teardown a controller, we must freeze and quiesce the namespaces
> request queues to make sure that we safely stop inflight I/O submissions.
> Freeze is mandatory because if our hctx map changed between reconnects,
> blk_mq_update_nr_hw_queues will immediately attempt to freeze the queue, and
> if it still has pending submissions (that are still quiesced) it will hang.
> This is what the above patches fixed.
> 
> However, by freezing the namespaces request queues, and only unfreezing them
> when we successfully reconnect, inflight submissions that are running
> concurrently can now block grabbing the nshead srcu until either we successfully
> reconnect or ctrl_loss_tmo expired (or the user explicitly disconnected).
> 
> This caused a deadlock [1] when a different controller (different path on the
> same subsystem) became live (i.e. optimized/non-optimized). This is because
> nvme_mpath_set_live needs to synchronize the nshead srcu before requeueing I/O
> in order to make sure that current_path is visible to future (re)submisions.
> However the srcu lock is taken by a blocked submission on a frozen request
> queue, and we have a deadlock.
> 
> In recent kernels (v5.9+) direct_make_request was replaced by submit_bio_noacct
> which does not have this issue because it bio_list will be active when
> nvme-mpath calls submit_bio_noacct on the bottom device (because it was
> populated when submit_bio was triggered on it.
> 
> Hence, we need to fix all the kernels that were before submit_bio_noacct was
> introduced.

Why can we not just add submit_bio_noacct to the 5.4 kernel to correct
this?  What commit id is that?

thanks,

greg k-h
