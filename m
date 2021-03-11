Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3945337162
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhCKLaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232532AbhCKLaD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:30:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 186CD64FA8;
        Thu, 11 Mar 2021 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615462202;
        bh=aL01JXb+W3RKlG1I1YFLxVvUkv0infmDdgd/KDukiME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rK2+N0XyLsZEFo8+/O9oaE20Dx2nRz4HHluZhlyyx/NA+/3Uogt9ACBH3MczCmVVw
         o6JJXwp0I7jPU52cqKfL8TGlN0rULVvombtNWeqR1ez8EIRkk7cIUzgMmXJU2Zq8QX
         77Wq5FnSR1r5wjIpTMtfN+LovqwG5Nyb4xs7jB0Q=
Date:   Thu, 11 Mar 2021 12:29:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] configfs: Fix config_item refcnt error in
 __configfs_open_file()
Message-ID: <YEn/NzUu496YkPJy@kroah.com>
References: <20210311110550.981100-1-gregkh@linuxfoundation.org>
 <20210311111625.GA17025@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311111625.GA17025@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 12:16:25PM +0100, Christoph Hellwig wrote:
> I've actually just queued up a similar patch from Daiyue Zhang.
> 
> > -		goto out_put_item;
> > +		goto out_put_module;
> >  
> >  	if (type & CONFIGFS_ITEM_BIN_ATTR) {
> >  		buffer->bin_attr = to_bin_attr(dentry);
> > @@ -391,7 +391,7 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
> >  	/* Grab the module reference for this attribute if we have one */
> >  	error = -ENODEV;
> >  	if (!try_module_get(buffer->owner))
> > -		goto out_put_item;
> > +		goto out_put_module;
> >  
> >  	error = -EACCES;
> >  	if (!buffer->item->ci_type)
> > @@ -435,8 +435,6 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
> >  
> >  out_put_module:
> >  	module_put(buffer->owner);
> > -out_put_item:
> > -	config_item_put(buffer->item);
> >  out_free_buffer:
> 
> But the goto labe changes here look incorrect anyway, as they now introduce
> a double put on the module..

Oops, should be one label lower.  Daniel must not have checked this on
a system with modules :)

Let me go fix this up...

thanks,

greg k-h
