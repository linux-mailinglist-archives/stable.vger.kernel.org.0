Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EA34FBF6E
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 16:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347390AbiDKOqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 10:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344434AbiDKOqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 10:46:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3299613CC8;
        Mon, 11 Apr 2022 07:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD42FB81643;
        Mon, 11 Apr 2022 14:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F802C385A4;
        Mon, 11 Apr 2022 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649688235;
        bh=Y3EfVQNNBs/0MytQNTHPYHrnCnnhOOTpdF06Qx+ClDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=faIHQj3pWM2LzvbpuXQNvIWWFousJEmGccimQP3wvJDnViaZpU8gaABucJE5IOd10
         lyj+GTG4jX+avK4cSmQNRBgrfC6RE2tG2Cnw9IR+kAN8rUPdPqhEFP+QDsIgKq9u1q
         sFnyo4j+QdblCzuPSmMZ5i7B0Wvr/zuMAAiTtHew=
Date:   Mon, 11 Apr 2022 16:43:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Valentin Kleibel <valentin@vrvis.at>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 1/2] block: add blk_alloc_disk and blk_cleanup_disk
 APIs
Message-ID: <YlQ+qUjLjg5p33II@kroah.com>
References: <c274db07-9c7d-d857-33ad-4a762819bcdd@vrvis.at>
 <YinpIKY0HVlJ+TLR@kroah.com>
 <50ddedf1-5ac3-91c3-0b50-645ceb541071@vrvis.at>
 <YinufgnQtSeTA18w@kroah.com>
 <9dd4a25a-7deb-fcdf-0c05-d37d4c894d86@vrvis.at>
 <Yi8jO3Q+xbPx0JwF@kroah.com>
 <b19953f8-2097-6962-eceb-5d41f4639ce4@vrvis.at>
 <ab7167b6-8ea5-fd4a-66ea-b8aa93f68ee2@vrvis.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab7167b6-8ea5-fd4a-66ea-b8aa93f68ee2@vrvis.at>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 12:00:08PM +0200, Valentin Kleibel wrote:
> Add two new APIs to allocate and free a gendisk including the
> request_queue for use with BIO based drivers.  This is to avoid
> boilerplate code in drivers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> Link: https://lore.kernel.org/r/20210521055116.1053587-6-hch@lst.de
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> (cherry picked from commit f525464a8000f092c20b00eead3eaa9d849c599e)
> Fixes: 3582dd291788 (aoe: convert aoeblk to blk-mq)
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215647
> Signed-off-by: Valentin Kleibel <valentin@vrvis.at>
> ---
>  block/genhd.c         | 15 +++++++++++++++
>  include/linux/genhd.h |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 796baf761202..421cad085502 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1836,6 +1836,21 @@ void put_disk_and_module(struct gendisk *disk)
>         }
>  }
>  EXPORT_SYMBOL(put_disk_and_module);
> +/**
> + * blk_cleanup_disk - shutdown a gendisk allocated by blk_alloc_disk
> + * @disk: gendisk to shutdown
> + *
> + * Mark the queue hanging off @disk DYING, drain all pending requests, then
> mark
> + * the queue DEAD, destroy and put it and the gendisk structure.
> + *
> + * Context: can sleep
> + */
> +void blk_cleanup_disk(struct gendisk *disk)
> +{
> +       blk_cleanup_queue(disk->queue);
> +       put_disk(disk);
> +}
> +EXPORT_SYMBOL(blk_cleanup_disk);
> 
>  static void set_disk_ro_uevent(struct gendisk *gd, int ro)
>  {
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 03da3f603d30..b7b180d3734a 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -369,6 +369,7 @@ extern void blk_unregister_region(dev_t devt, unsigned
> long range);
>  #define alloc_disk(minors) alloc_disk_node(minors, NUMA_NO_NODE)
> 
>  int register_blkdev(unsigned int major, const char *name);
> +void blk_cleanup_disk(struct gendisk *disk);
>  void unregister_blkdev(unsigned int major, const char *name);
> 
>  void revalidate_disk_size(struct gendisk *disk, bool verbose);

This backport looks to be incomplete, and is also totally whitespace
damaged and can not be applied at all :(

Please fix both up and resend.

thanks,

greg k-h
