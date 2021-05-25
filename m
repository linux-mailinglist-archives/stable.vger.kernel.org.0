Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFDE3900C5
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 14:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhEYMWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 08:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhEYMWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 08:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1B961402;
        Tue, 25 May 2021 12:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621945236;
        bh=gx/t188gAFSgxajdVpgfU2Zhnp3NC44G/heSPvIIs0g=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=xQebaIa64ceeyLM/zbw5vJBk+/4PpCs7Nqaru386n6n41x0QyRoiQvZjTQ+yPAL3k
         ijqDLg5PgZDqS5IgktghngoZd+aFubpAzMuNeKsR20HtwWLjqlahhTs1Kxjx2v/eIr
         femh9gPwkrl6bjeRh6FZvsbfH7KnXOfXjHEQHj7Q=
Date:   Tue, 25 May 2021 14:20:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 5.12 038/127] btrfs: zoned: fix parallel compressed writes
Message-ID: <YKzrkhe5/ToXb3p5@kroah.com>
References: <20210524152334.857620285@linuxfoundation.org>
 <20210524152336.139215075@linuxfoundation.org>
 <20210525120054.GU7604@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525120054.GU7604@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 02:00:54PM +0200, David Sterba wrote:
> On Mon, May 24, 2021 at 05:25:55PM +0200, Greg Kroah-Hartman wrote:
> > From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > 
> > commit 764c7c9a464b68f7c6a5a9ec0b923176a05e8e8f upstream.
> > 
> > When multiple processes write data to the same block group on a
> > compressed zoned filesystem, the underlying device could report I/O
> > errors and data corruption is possible.
> > 
> > This happens because on a zoned file system, compressed data writes
> > where sent to the device via a REQ_OP_WRITE instead of a
> > REQ_OP_ZONE_APPEND operation. But with REQ_OP_WRITE and parallel
> > submission it cannot be guaranteed that the data is always submitted
> > aligned to the underlying zone's write pointer.
> > 
> > The change to using REQ_OP_ZONE_APPEND instead of REQ_OP_WRITE on a
> > zoned filesystem is non intrusive on a regular file system or when
> > submitting to a conventional zone on a zoned filesystem, as it is
> > guarded by btrfs_use_zone_append.
> > 
> > Reported-by: David Sterba <dsterba@suse.com>
> > Fixes: 9d294a685fbc ("btrfs: zoned: enable to mount ZONED incompat flag")
> > CC: stable@vger.kernel.org # 5.12.x: e380adfc213a13: btrfs: zoned: pass start block to btrfs_use_zone_append
> > CC: stable@vger.kernel.org # 5.12.x
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> We found a bug in this patch, please drop it from 5.12 queue.

This one, and the previous one, now dropped.

thanks,

greg k-h
