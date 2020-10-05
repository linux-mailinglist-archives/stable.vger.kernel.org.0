Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83792835FF
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 15:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgJENAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 09:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJENAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 09:00:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B891520848;
        Mon,  5 Oct 2020 13:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601902854;
        bh=QA+dqNJKtvHSXYc5cKERRIgzM2tZYFO9kcE4JRLyyt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xkJUQxohwCBYy49uoqiCcV7UbCZVz0jxa0YhajJsarcFHGUuXj8DHsjMCb/ywiu/C
         PrQLZ3KeiZPqXPwxDoQtg1TeI/7p7FNPXOyNcNT5hTeJ39Tf/BhY9ujfMbxjoGcHtU
         dkXgkj6S9JH/FT9nvTW4S/svXd0btvGG/CKsvyPY=
Date:   Mon, 5 Oct 2020 15:01:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org, bp@alien8.de,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 1/2] scsi: sd: sd_zbc: Fix handling of host-aware ZBC
 disks
Message-ID: <20201005130139.GA827657@kroah.com>
References: <1601302609229102@kroah.com>
 <20200930061329.562168-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930061329.562168-1-damien.lemoal@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 30, 2020 at 03:13:29PM +0900, Damien Le Moal wrote:
> Upstream commit 27ba3e8ff3ab86449e63d38a8d623053591e65fa
> 
> When CONFIG_BLK_DEV_ZONED is disabled, allow using host-aware ZBC disks as
> regular disks. In this case, ensure that command completion is correctly
> executed by changing sd_zbc_complete() to return good_bytes instead of 0
> and causing a hang during device probe (endless retries).
> 
> When CONFIG_BLK_DEV_ZONED is enabled and a host-aware disk is detected to
> have partitions, it will be used as a regular disk. In this case, make sure
> to not do anything in sd_zbc_revalidate_zones() as that triggers warnings.
> 
> Since all these different cases result in subtle settings of the disk queue
> zoned model, introduce the block layer helper function
> blk_queue_set_zoned() to generically implement setting up the effective
> zoned model according to the disk type, the presence of partitions on the
> disk and CONFIG_BLK_DEV_ZONED configuration.
> 
> Link: https://lore.kernel.org/r/20200915073347.832424-2-damien.lemoal@wdc.com
> Fixes: b72053072c0b ("block: allow partitions on host aware zone devices")
> Cc: <stable@vger.kernel.org>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/blk-settings.c   | 46 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/sd.c      | 30 ++++++++++++++++-----------
>  drivers/scsi/sd.h      |  2 +-
>  drivers/scsi/sd_zbc.c  | 37 +++++++++++++++++++--------------
>  include/linux/blkdev.h |  2 ++
>  5 files changed, 89 insertions(+), 28 deletions(-)

THanks for both of these, now queued up.

greg k-h
