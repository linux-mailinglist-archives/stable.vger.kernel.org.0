Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4440C64D6A9
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 07:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiLOGux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 01:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLOGup (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 01:50:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFDB21E33;
        Wed, 14 Dec 2022 22:50:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D84F4B81AD3;
        Thu, 15 Dec 2022 06:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3612CC433F2;
        Thu, 15 Dec 2022 06:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671087040;
        bh=dsffucc6I2sU3ocPccR5Wt4nUWd9vSTjx8+hyd+0RWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DLm5tHEZp1xiGgjKyWDc+mWbcd5f6p2OlvsnREv2115mQ8NI9eca8UpCJ/F9S+bfN
         wuARYqKkjrLkNOlRqTUcvvfj+U9SeIkxGqHC72Qm2a1GtTZYLWXq2D/LpQ10Gw9DDD
         61WkHnvIoJ1xqk4TdMFQu1xKHfOwpnegDxaDCSvM=
Date:   Thu, 15 Dec 2022 07:50:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Shiwei Cui <cuishw@inspur.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH stable 4.9.y] block: unhash blkdev part inode when the
 part is deleted
Message-ID: <Y5rDttO3ah+zzhDX@kroah.com>
References: <20221213071655.1197875-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213071655.1197875-1-ming.lei@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 03:16:55PM +0800, Ming Lei wrote:
> v5.11 changes the blkdev lookup mechanism completely since commit
> 22ae8ce8b892 ("block: simplify bdev/disk lookup in blkdev_get"),
> and small part of the change is to unhash part bdev inode when
> deleting partition. Turns out this kind of change does fix one
> nasty issue in case of BLOCK_EXT_MAJOR:
> 
> 1) when one partition is deleted & closed, disk_put_part() is always
> called before bdput(bdev), see blkdev_put(); so the part's devt can
> be freed & re-used before the inode is dropped
> 
> 2) then new partition with same devt can be created just before the
> inode in 1) is dropped, then the old inode/bdev structurein 1) is
> re-used for this new partition, this way causes use-after-free and
> kernel panic.
> 
> It isn't possible to backport the whole big patchset of "merge struct
> block_device and struct hd_struct v4" for addressing this issue.
> 
> https://lore.kernel.org/linux-block/20201128161510.347752-1-hch@lst.de/
> 
> So fixes it by unhashing part bdev in delete_partition(), and this way
> is actually aligned with v5.11+'s behavior.
> 
> Backported from the following 5.10.y commit:
> 
> 5f2f77560591 ("block: unhash blkdev part inode when the part is deleted")
> 
> Reported-by: Shiwei Cui <cuishw@inspur.com>
> Tested-by: Shiwei Cui <cuishw@inspur.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/partition-generic.c | 6 ++++++
>  1 file changed, 6 insertions(+)

All now queued up, thanks!

greg k-h
