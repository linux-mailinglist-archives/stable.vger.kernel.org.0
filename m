Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B216C64288A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 13:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLEMdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 07:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLEMdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 07:33:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E529E17595;
        Mon,  5 Dec 2022 04:33:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1282B80D5E;
        Mon,  5 Dec 2022 12:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B15C433C1;
        Mon,  5 Dec 2022 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670243615;
        bh=S3e3WKr+Pe1+cQo6SVdJxO9vGWXFjXrW3yTqvYO/bug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oz9NGHb0iWlsBppjCkvqYA0VJuFrs7tTLWSc6ciLicRYT2SmZX0xsullNUeaRpOQD
         KE7NNCiFRgPgFGRJ7L4QyAz+xNROUclS7yNTWiPAIG9ZOn/cyY+r4+ahIclGjxXOq0
         5UAZCDkupLvnVPl6zeCwpIoTLfU/xMkiGWp0Sue8=
Date:   Mon, 5 Dec 2022 13:33:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, cuishw@inspur.com,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5.10.y stable] block: unhash blkdev part inode when the
 part is deleted
Message-ID: <Y43lHGHDHkAERvJb@kroah.com>
References: <20221205122502.841896-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205122502.841896-1-ming.lei@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 08:25:02PM +0800, Ming Lei wrote:
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
> It isn't possible to backport the whole fbig patchset of "merge struct

"fbig"?

> block_device and struct hd_struct v4" for addressing this issue.
> 
> https://lore.kernel.org/linux-block/20201128161510.347752-1-hch@lst.de/
> 
> So fixes it by unhashing part bdev in delete_partition(), and this way
> is actually aligned with v5.11+'s behavior.
> 
> Reported-by: cuishw@inspur.com
> Tested-by: cuishw@inspur.com

We need a real name and this in a proper format as well (<>)

> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

What about for kernels older than 5.10?

thanks,

greg k-h
