Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606E82B5CD4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 11:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgKQK2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 05:28:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgKQK2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 05:28:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB4FD20E65;
        Tue, 17 Nov 2020 10:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605608892;
        bh=Qggw/1raSUAHDLYANebW0oUUWEe6Ft3XNlmK1I2pxXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LTT2sWvEEBSaDnsxeGQQLRD+2d4K3EqvkQHX0wFrlGgr0ry7OSjW1lyIhUbKudirL
         Ual9LvnroxGKzI/Iovyp2gOa4npj1KqNwmNgANjmuqOQkr1o2mkGyskV01c2ykX9RN
         rm8akAfW1T2odNxGReFCP+sWTSkIQIjgzfW2jXY8=
Date:   Tue, 17 Nov 2020 11:29:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] null_blk: Fix scheduling in atomic with zoned mode
Message-ID: <X7Ol7OoF7z02TCVK@kroah.com>
References: <160491753798199@kroah.com>
 <20201110073605.296624-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110073605.296624-1-damien.lemoal@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 04:36:05PM +0900, Damien Le Moal wrote:
> commit e1777d099728a76a8f8090f89649aac961e7e530 upstream.
> 
> Commit aa1c09cb65e2 ("null_blk: Fix locking in zoned mode") changed
> zone locking to using the potentially sleeping wait_on_bit_io()
> function. This is acceptable when memory backing is enabled as the
> device queue is in that case marked as blocking, but this triggers a
> scheduling while in atomic context with memory backing disabled.
> 
> Fix this by relying solely on the device zone spinlock for zone
> information protection without temporarily releasing this lock around
> null_process_cmd() execution in null_zone_write(). This is OK to do
> since when memory backing is disabled, command processing does not
> block and the memory backing lock nullb->lock is unused. This solution
> avoids the overhead of having to mark a zoned null_blk device queue as
> blocking when memory backing is unused.
> 
> This patch also adds comments to the zone locking code to explain the
> unusual locking scheme.
> 
> Fixes: aa1c09cb65e2 ("null_blk: Fix locking in zoned mode")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/block/null_blk.h       |  1 +
>  drivers/block/null_blk_zoned.c | 31 +++++++++++++++++++++++++------
>  2 files changed, 26 insertions(+), 6 deletions(-)

Now queued up, thanks.

greg k-h
