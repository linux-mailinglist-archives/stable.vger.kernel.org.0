Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A68514EC64
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 13:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgAaMUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 07:20:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40816 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgAaMUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 07:20:17 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixVHR-005DvB-Og; Fri, 31 Jan 2020 12:20:13 +0000
Date:   Fri, 31 Jan 2020 12:20:13 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 43/92] do_last(): fetch directory ->i_mode and
 ->i_uid before its too late
Message-ID: <20200131122013.GF23230@ZenIV.linux.org.uk>
References: <20200128135809.344954797@linuxfoundation.org>
 <20200128135814.584735840@linuxfoundation.org>
 <5cbe397b7f7bb0f8bd579080c8a4c41d7b359632.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cbe397b7f7bb0f8bd579080c8a4c41d7b359632.camel@nokia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 10:08:37AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> On Tue, 2020-01-28 at 15:08 +0100, Greg Kroah-Hartman wrote:
> > From: Al Viro <viro@zeniv.linux.org.uk>
> > 
> > commit d0cb50185ae942b03c4327be322055d622dc79f6 upstream.
> > 
> > may_create_in_sticky() call is done when we already have dropped the
> > reference to dir.
> > 
> > Fixes: 30aba6656f61e (namei: allow restricted O_CREAT of FIFOs and
> > regular files)
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  fs/namei.c |   17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > [...]
> > @@ -3258,6 +3259,8 @@ static int do_last(struct nameidata *nd,
> >  		   struct file *file, const struct open_flags *op)
> >  {
> >  	struct dentry *dir = nd->path.dentry;
> > +	kuid_t dir_uid = dir->d_inode->i_uid;
> 
> I hit the following oops in 4.19.100 while running kselftests.
> 
> fs/namei.c:3262 matches the line above.
> 
> Any ideas?

Yes.  Make those two line
	kuid_t dir_uid = nd->inode->i_uid;
	umode_t dir_mode = nd->inode->i_mode;

I'm pretty sure that I know which way I'd fucked up there; we can
get here in RCU mode with stale nd->path.dentry (that would make
the thing fail with -ECHILD. with retry in non-RCU mode).  In
non-stale case nd->inode is the same as nd->path.dentry->d_inode
and it's always pointing to a struct inode that hadn't been
freed yet.
