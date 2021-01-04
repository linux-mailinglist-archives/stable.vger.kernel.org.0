Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B492E94CE
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbhADMYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbhADMYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 07:24:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A922075E;
        Mon,  4 Jan 2021 12:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609763036;
        bh=4rarYMMxj98iBabv7SYSGy2WxUb8g33YL9VAXBz+6fQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXi81ANwu9/rlPVrQkNWrtRU1D595+y21cGTcqAejw/28ioGucLxwxSJOZikKo4/8
         RwX5cJSg2QCtrurMEbN4kDdWEqbvhzKLewcIxTiiWUqs2+Y6TY4KGIp9edjx+jtgYv
         jJUdTl6mmATK5fopSnUNCqKC6UR7yn18mA0bWB1I=
Date:   Mon, 4 Jan 2021 13:25:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] null_blk: Fix zone size initialization
Message-ID: <X/MJM2cLKxnCeJcI@kroah.com>
References: <X/LzaLYN3k0JFJw3@kroah.com>
 <20210104121147.809755-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104121147.809755-1-damien.lemoal@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 09:11:47PM +0900, Damien Le Moal wrote:
> commit 0ebcdd702f49aeb0ad2e2d894f8c124a0acc6e23 upstream.
> 
> For a null_blk device with zoned mode enabled is currently initialized
> with a number of zones equal to the device capacity divided by the zone
> size, without considering if the device capacity is a multiple of the
> zone size. If the zone size is not a divisor of the capacity, the zones
> end up not covering the entire capacity, potentially resulting is out
> of bounds accesses to the zone array.
> 
> Fix this by adding one last smaller zone with a size equal to the
> remainder of the disk capacity divided by the zone size if the capacity
> is not a multiple of the zone size. For such smaller last zone, the zone
> capacity is also checked so that it does not exceed the smaller zone
> size.
> 
> Reported-by: Naohiro Aota <naohiro.aota@wdc.com>
> Fixes: ca4b2a011948 ("null_blk: add zone support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/block/null_blk_zoned.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)

That worked, thanks!

greg k-h
