Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBDD4939A4
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 12:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354229AbiASLiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 06:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354216AbiASLiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 06:38:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A69C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 03:38:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D6D4B81901
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 11:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6FCC004E1;
        Wed, 19 Jan 2022 11:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642592277;
        bh=t9BYfKB5W8tdgjoqeYl+LMWZv4qma0M4UloNeDu589k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y+SrZOpWdQejqyxNdfHn+JM6fWnCrtUpVAUcebj9Xyha/s4x6KnbY8CYbbhI7kDTs
         PFEfPfRqZyFWn+QwyToGbKm3CNKvu2qkcgUG953pyYVNKQUyo4MgNs0GMNu5nXMoUA
         /9bVlDKTCR1L3b4GfwhDJv5OthqHjteORYihkpG0=
Date:   Wed, 19 Jan 2022 12:37:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>
Cc:     stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4.14 1/2] fuse: fix bad inode
Message-ID: <Yef4Ejks7hTSgl6C@kroah.com>
References: <20220119005201.130738-1-samjonas@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119005201.130738-1-samjonas@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 04:52:00PM -0800, Samuel Mendoza-Jonas wrote:
> From: Miklos Szeredi <mszeredi@redhat.com>
> 
> commit 5d069dbe8aaf2a197142558b6fb2978189ba3454 upstream.
> 
> Jan Kara's analysis of the syzbot report (edited):
> 
>   The reproducer opens a directory on FUSE filesystem, it then attaches
>   dnotify mark to the open directory.  After that a fuse_do_getattr() call
>   finds that attributes returned by the server are inconsistent, and calls
>   make_bad_inode() which, among other things does:
> 
>           inode->i_mode = S_IFREG;
> 
>   This then confuses dnotify which doesn't tear down its structures
>   properly and eventually crashes.
> 
> Avoid calling make_bad_inode() on a live inode: switch to a private flag on
> the fuse inode.  Also add the test to ops which the bad_inode_ops would
> have caught.
> 
> This bug goes back to the initial merge of fuse in 2.6.14...
> 
> Reported-by: syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Tested-by: Jan Kara <jack@suse.cz>
> Cc: <stable@vger.kernel.org>
> [adjusted for missing fs/fuse/readdir.c and changes in fuse_evict_inode() in 4.14]
> Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>

What about 4.19.y, will this work there as well?  We need it for that
kernel before we can take it into 4.14.y.

Also what about 4.4.y and 4.9.y?

thanks,

greg k-h
