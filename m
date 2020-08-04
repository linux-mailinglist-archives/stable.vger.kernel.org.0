Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C932E23B57C
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 09:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgHDHSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 03:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgHDHSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 03:18:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078552076C;
        Tue,  4 Aug 2020 07:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596525535;
        bh=hfBcjPkGkyJcxN+uBmeH4V4WssMYKsI4OSjMhe3j9nE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OwVpGR0Ok0sLNItVNHru4lTDPUkTdpzFDk8L3/KmtmbkchGcz4R2Ofi5pahs9dwmh
         asvWs/5rINuqvXq0fIVnio+kCnED4NAxfCXUI1twJjGLXTUytelaxJgyGr97pMrPcW
         V/676XUzfCd7Jei4O+TkZeXTbaVUD4DEDlAOKHvU=
Date:   Tue, 4 Aug 2020 09:18:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 09/56] btrfs: inode: Verify inode mode to avoid NULL
 pointer dereference
Message-ID: <20200804071836.GA1416416@kroah.com>
References: <20200803121850.306734207@linuxfoundation.org>
 <20200803121850.766021165@linuxfoundation.org>
 <20200804071132.d6awebnvt7gnqfkb@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804071132.d6awebnvt7gnqfkb@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 09:11:32AM +0200, Pavel Machek wrote:
> Hi!
> 
> 
> > @@ -6993,6 +7010,14 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
> >  	extent_start = found_key.offset;
> >  	if (found_type == BTRFS_FILE_EXTENT_REG ||
> >  	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
> > +		/* Only regular file could have regular/prealloc extent */
> > +		if (!S_ISREG(inode->vfs_inode.i_mode)) {
> > +			ret = -EUCLEAN;
> > +			btrfs_crit(fs_info,
> > +		"regular/prealloc extent found for non-regular inode %llu",
> > +				   btrfs_ino(inode));
> > +			goto out;
> > +		}
> 
> This sets ret, but function returns err. Fix was already submitted.

What is the git commit id of that fix?

thanks,

greg k-h
