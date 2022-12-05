Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31460642B0D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiLEPIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 10:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiLEPIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 10:08:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8BAD2DD;
        Mon,  5 Dec 2022 07:08:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EEF16119A;
        Mon,  5 Dec 2022 15:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC75C433C1;
        Mon,  5 Dec 2022 15:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670252891;
        bh=aD976dpLSZrvdiKPkzTWfbT9kaCjs86wvXYu3RuxCCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xlcLTyRQ6xy0wl3AemTDT+u71655K6rCFAj0bvuVQWUcQOmF+vGRizu6l22wgiJRz
         h/31CdhQKy1S1RjvzV7jufjua9luJpCdvVWRiJle24Rom0o97GcQxxqeCA/Rz+4XWx
         L0EoH8wNwwP1hxWJSn8Si4T/KTycBKZ8kOh84CHA=
Date:   Mon, 5 Dec 2022 16:08:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Shiwei Cui <cuishw@inspur.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5.10.y stable v2] block: unhash blkdev part inode when
 the part is deleted
Message-ID: <Y44JWBw9opr2HVyN@kroah.com>
References: <20221205132739.844399-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205132739.844399-1-ming.lei@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 09:27:39PM +0800, Ming Lei wrote:
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
> Reported-by: Shiwei Cui <cuishw@inspur.com>
> Tested-by: Shiwei Cui <cuishw@inspur.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V2:
> 	- fix one typo and Shiwei's email format
> 
>  block/partitions/core.c | 7 +++++++

I need an ack from the block maintainers/developers to be able to take
this.

thanks,

greg k-h
