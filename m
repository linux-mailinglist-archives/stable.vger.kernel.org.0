Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6613370FD
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhCKLQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:16:51 -0500
Received: from verein.lst.de ([213.95.11.211]:40479 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhCKLQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:16:28 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E6F7A68B05; Thu, 11 Mar 2021 12:16:25 +0100 (CET)
Date:   Thu, 11 Mar 2021 12:16:25 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     gregkh@linuxfoundation.org
Cc:     Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] configfs: Fix config_item refcnt error in
 __configfs_open_file()
Message-ID: <20210311111625.GA17025@lst.de>
References: <20210311110550.981100-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311110550.981100-1-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I've actually just queued up a similar patch from Daiyue Zhang.

> -		goto out_put_item;
> +		goto out_put_module;
>  
>  	if (type & CONFIGFS_ITEM_BIN_ATTR) {
>  		buffer->bin_attr = to_bin_attr(dentry);
> @@ -391,7 +391,7 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
>  	/* Grab the module reference for this attribute if we have one */
>  	error = -ENODEV;
>  	if (!try_module_get(buffer->owner))
> -		goto out_put_item;
> +		goto out_put_module;
>  
>  	error = -EACCES;
>  	if (!buffer->item->ci_type)
> @@ -435,8 +435,6 @@ static int __configfs_open_file(struct inode *inode, struct file *file, int type
>  
>  out_put_module:
>  	module_put(buffer->owner);
> -out_put_item:
> -	config_item_put(buffer->item);
>  out_free_buffer:

But the goto labe changes here look incorrect anyway, as they now introduce
a double put on the module..
