Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42DA497C5E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 10:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbiAXJqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 04:46:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57658 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiAXJq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 04:46:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F0F361250
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C418C340E1;
        Mon, 24 Jan 2022 09:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643017588;
        bh=4MUajzlNv0sxtCnrflNTKIKtDBcWJYi0e23ceD1d5XQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AfrEp68hUPfuchGPklbM9QkQxXVbPNiY7VJ51H28yg4/2f/Ufj0Y3VjZBHznjV8tb
         bed5bCx1JG30FYtA1Lfs6dGL27xQkWh5Kgs7ag9GLeMsH14viHr0MNZRG9givQAYNn
         SbIFDlgJ11b5iTMWc+1cBOjF5U07Dmx6bTyzoD00=
Date:   Mon, 24 Jan 2022 10:46:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>
Cc:     stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4.14 1/2] fuse: fix bad inode
Message-ID: <Ye51ceNM5Z3IawgO@kroah.com>
References: <20220119005201.130738-1-samjonas@amazon.com>
 <Yef4Ejks7hTSgl6C@kroah.com>
 <20220119170436.2lhqyx66nwvaovov@u46989501580c5c.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119170436.2lhqyx66nwvaovov@u46989501580c5c.ant.amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 09:04:36AM -0800, Samuel Mendoza-Jonas wrote:
> On Wed, Jan 19, 2022 at 12:37:54PM +0100, Greg KH wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> > 
> > On Tue, Jan 18, 2022 at 04:52:00PM -0800, Samuel Mendoza-Jonas wrote:
> > > From: Miklos Szeredi <mszeredi@redhat.com>
> > >
> > > commit 5d069dbe8aaf2a197142558b6fb2978189ba3454 upstream.
> > >
> > > Jan Kara's analysis of the syzbot report (edited):
> > >
> > >   The reproducer opens a directory on FUSE filesystem, it then attaches
> > >   dnotify mark to the open directory.  After that a fuse_do_getattr() call
> > >   finds that attributes returned by the server are inconsistent, and calls
> > >   make_bad_inode() which, among other things does:
> > >
> > >           inode->i_mode = S_IFREG;
> > >
> > >   This then confuses dnotify which doesn't tear down its structures
> > >   properly and eventually crashes.
> > >
> > > Avoid calling make_bad_inode() on a live inode: switch to a private flag on
> > > the fuse inode.  Also add the test to ops which the bad_inode_ops would
> > > have caught.
> > >
> > > This bug goes back to the initial merge of fuse in 2.6.14...
> > >
> > > Reported-by: syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com
> > > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > > Tested-by: Jan Kara <jack@suse.cz>
> > > Cc: <stable@vger.kernel.org>
> > > [adjusted for missing fs/fuse/readdir.c and changes in fuse_evict_inode() in 4.14]
> > > Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> > 
> > What about 4.19.y, will this work there as well?  We need it for that
> > kernel before we can take it into 4.14.y.
> > 
> > Also what about 4.4.y and 4.9.y?
> 
> Hi,
> 
> This applies & builds on 4.19.y and 4.9.y fine as well, 4.4.y runs into
> a conflict which I'll have a closer look at.

Ok, thanks, now queued up.

greg k-h
