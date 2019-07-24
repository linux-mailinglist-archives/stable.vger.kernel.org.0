Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1356073378
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 18:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfGXQPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 12:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfGXQPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 12:15:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18AD921850;
        Wed, 24 Jul 2019 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563984937;
        bh=jqxKoel7Q9DfU2jsQOBR45VvoowBEop1EXLXgnqk4OY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qPRB0cU7r0j2Ejk3/ScsW6c5KOfX5ti64VCoMZ+w8Grl91tJtri95MBOPusnkMIe4
         /luSnF4DFHMoHoMsvxlAU3VCSdmq8lY1/MMx2F+NET3J4Or2Qqdk+UmmwiflX93mJn
         GNL3bD+5ridjDiNuKPs9UlUSTbcUCmBogii6uYoU=
Date:   Wed, 24 Jul 2019 18:15:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: btrfs related build failures in stable queues
Message-ID: <20190724161534.GA10454@kroah.com>
References: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
 <20190724154039.GB3050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724154039.GB3050@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 05:40:39PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 24, 2019 at 08:07:50AM -0700, Guenter Roeck wrote:
> > v4.9.y to v5.1.y:
> > 
> > fs/btrfs/file.c: In function 'btrfs_punch_hole':
> > fs/btrfs/file.c:2787:27: error: invalid initializer
> >    struct timespec64 now = current_time(inode);
> >                            ^~~~~~~~~~~~
> > fs/btrfs/file.c:2790:18: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> 
> Oops, no, this looks like a 32bit issue, let me dig into that...

Ok, this makes no sense.

A few lines above this we do:
	inode->i_mtime = inode->i_ctime = current_time(inode);

And here we are now doing:
	struct timespec64 now = current_time(inode);

	inode_inc_iversion(inode);
	inode->i_mtime = now;
	inode->i_ctime = now;


And current_time() is defined as:
	extern struct timespec64 current_time(struct inode *inode);


I have no idea what is going on :(

This is caused by Felipe's patch: 179006688a7e ("Btrfs: add missing
inode version, ctime and mtime updates when punching hole").  Felipe,
any ideas?

thanks,

greg k-h
