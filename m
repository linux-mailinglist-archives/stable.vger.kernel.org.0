Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DA47369C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 20:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfGXSbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 14:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbfGXSbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 14:31:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA9A12173B;
        Wed, 24 Jul 2019 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563993111;
        bh=PDerl6DFN3d6ljEo7Fkbagd0j1UT9S7Wiaa7+EL+XUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUJay37EP65HoMHZYBbOT3GRZ397+i7K0VvcItLBNJdozhmiBxnFGX0288HBhQrVi
         OOAqtYOKBzgZSiuShix8hQrI01EJpW0n72XPu9zJEwUqZae9ujAPV3o3r2Jt+3kd5b
         ieSUwhF+CdgL9fpDrkp4GOjd849JGZEx/RqxUWG8=
Date:   Wed, 24 Jul 2019 20:31:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        stable <stable@vger.kernel.org>
Subject: Re: btrfs related build failures in stable queues
Message-ID: <20190724183148.GA23045@kroah.com>
References: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
 <20190724154039.GB3050@kroah.com>
 <20190724161534.GA10454@kroah.com>
 <8d039d25-7e88-2de7-00d9-de2c30e11c82@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d039d25-7e88-2de7-00d9-de2c30e11c82@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 09:50:54AM -0700, Guenter Roeck wrote:
> On 7/24/19 9:15 AM, Greg Kroah-Hartman wrote:
> > On Wed, Jul 24, 2019 at 05:40:39PM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Jul 24, 2019 at 08:07:50AM -0700, Guenter Roeck wrote:
> > > > v4.9.y to v5.1.y:
> > > > 
> > > > fs/btrfs/file.c: In function 'btrfs_punch_hole':
> > > > fs/btrfs/file.c:2787:27: error: invalid initializer
> > > >     struct timespec64 now = current_time(inode);
> > > >                             ^~~~~~~~~~~~
> > > > fs/btrfs/file.c:2790:18: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > > 
> > > Oops, no, this looks like a 32bit issue, let me dig into that...
> > 
> > Ok, this makes no sense.
> > 
> > A few lines above this we do:
> > 	inode->i_mtime = inode->i_ctime = current_time(inode);
> > 
> > And here we are now doing:
> > 	struct timespec64 now = current_time(inode);
> > 
> > 	inode_inc_iversion(inode);
> > 	inode->i_mtime = now;
> > 	inode->i_ctime = now;
> > 
> > 
> > And current_time() is defined as:
> > 	extern struct timespec64 current_time(struct inode *inode);
> > 
> 
> v4.9.186-108-g5b3c7cd16340 and v4.9.186-126-g97ad1fbc1478, line 1489 of fs.h:
> 
> extern struct timespec current_fs_time(struct super_block *sb);
> 
> Your code base seems to be different :-(.

I was looking at 5.1 as you said it failed there :(

I'll go fix up 4.9 and I think 4.14, but the other kernel versions
should be fine.

thanks,

greg k-h
