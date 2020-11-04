Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FFD2A604B
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgKDJJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgKDJJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 04:09:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C4312242A;
        Wed,  4 Nov 2020 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604480993;
        bh=UAwU3IdltPLolHLJKrgS3yX1pyFLwdjEdZQk5vEQmhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sW34e9QQs+F0CO3t64LAWJAKA8bayNBUtyIOnqqB2nWAeUbpLNUgFvW12cWQs9nMC
         nQ3eTnM2Rn6qOvh5MG9gXo60E/GDsiBppa3agul9E7L2qijDq0rVDtBIPd0mbL7bZc
         +K2e0Xc+FO4Q9/hQpkYVXm3mr3xhZY889Fgsx2Kc=
Date:   Wed, 4 Nov 2020 10:10:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.9 374/391] null_blk: synchronization fix for zoned
 device
Message-ID: <20201104091045.GE1588160@kroah.com>
References: <20201103203348.153465465@linuxfoundation.org>
 <20201103203412.385651316@linuxfoundation.org>
 <BL0PR04MB65147F17F20E4E4A77E35B38E7110@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR04MB65147F17F20E4E4A77E35B38E7110@BL0PR04MB6514.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 11:36:35PM +0000, Damien Le Moal wrote:
> On 2020/11/04 5:52, Greg Kroah-Hartman wrote:
> > From: Kanchan Joshi <joshi.k@samsung.com>
> > 
> > commit 35bc10b2eafbb701064b94f283b77c54d3304842 upstream.
> > 
> > Parallel write,read,zone-mgmt operations accessing/altering zone state
> > and write-pointer may get into race. Avoid the situation by using a new
> > spinlock for zoned device.
> > Concurrent zone-appends (on a zone) returning same write-pointer issue
> > is also avoided using this lock.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: e0489ed5daeb ("null_blk: Support REQ_OP_ZONE_APPEND")
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Greg,
> 
> I sent a followup patch fixing a bug introduced by this patch, but I forgot to
> mark it for stable. The patch is
> 
> commit aa1c09cb65e2 "null_blk: Fix locking in zoned mode"
> 
> Could you pickup that one too please ?

It doesn't apply cleanly at all, can you provide a backport?

thanks,

greg k-h
