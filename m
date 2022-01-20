Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FBB49517C
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 16:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346474AbiATPb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 10:31:29 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:36248 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346385AbiATPb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 10:31:26 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8BBC92190B;
        Thu, 20 Jan 2022 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642692685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CeAKA/iV/5m4aLZ6NbhTnNQny+wAlGZwM27Jzkopjbk=;
        b=3X1YObwzeOcHGUM+4drtok74aVJX/znxmEe8AHAeUtWM7LKR8t0lQ+tUAu/DO059k9FOn6
        07NT2yZOAqVCrrzsf6HNrfMMh/Gyb3veNwU0sTZ8b+ocyWEzIChYNW+HZ0+it8T6VAEi3K
        c2FFP5WAMjO7ZqlBxMvxRK0qoVTOJoc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642692685;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CeAKA/iV/5m4aLZ6NbhTnNQny+wAlGZwM27Jzkopjbk=;
        b=efaUYMlqQ+jZRmwujeIMi7RF1nt+/XzC8Hi8u9mm+xOxtaQu2Uv6PnufTHs6vnAJfhSX8s
        3oKomywEZIpwYHDw==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7B22EA3B89;
        Thu, 20 Jan 2022 15:31:25 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 38308A05D3; Thu, 20 Jan 2022 16:31:22 +0100 (CET)
Date:   Thu, 20 Jan 2022 16:31:22 +0100
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Matthew Bobrowski <repnop@google.com>,
        Ivan Delalande <colona@arista.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] fnotify: invalidate dcache before IN_DELETE event
Message-ID: <20220120153122.fpxg24okcmcvkcay@quack3.lan>
References: <20220118120031.196123-1-amir73il@gmail.com>
 <20220120125208.jmm2xjwcxaswt3tn@quack3.lan>
 <CAOQ4uxjxayK006RDAiEm9hKP_JAZhZZDcj7tbnANjQWP-_XObA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjxayK006RDAiEm9hKP_JAZhZZDcj7tbnANjQWP-_XObA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 20-01-22 16:31:11, Amir Goldstein wrote:
> On Thu, Jan 20, 2022 at 2:52 PM Jan Kara <jack@suse.cz> wrote:
> > > +/*
> > > + * fsnotify_delete - @dentry was unlinked and unhashed
> > > + *
> > > + * Caller must make sure that dentry->d_name is stable.
> > > + *
> > > + * Note: unlike fsnotify_unlink(), we have to pass also the unlinked inode
> > > + * as this may be called after d_delete() and old_dentry may be negative.
> > > + */
> > > +static inline void fsnotify_delete(struct inode *dir, struct inode *inode,
> > > +                                struct dentry *dentry)
> > > +{
> > > +     __u32 mask = FS_DELETE;
> > > +
> > > +     if (S_ISDIR(inode->i_mode))
> > > +             mask |= FS_ISDIR;
> > > +
> > > +     fsnotify_name(mask, inode, FSNOTIFY_EVENT_INODE, dir, &dentry->d_name,
> > > +                   0);
> > > +}
> > > +
> >
> > OK, this is fine because we use dentry only for FAN_RENAME event, don't we?
> 
> Almost.
> We also use dentry in FS_CREATE to get sb from d_sb for error event, because:
>  * Note: some filesystems (e.g. kernfs) leave @dentry negative and instantiate
>  * ->d_inode later

Ah, right.

> > In all other cases we always use only inode anyway. Can we perhaps cleanup
> > include/linux/fsnotify.h to use FSNOTIFY_EVENT_DENTRY only in that one call
> > site inside fsnotify_move() and use FSNOTIFY_EVENT_INODE in all the other
> > cases? So that this is clear and also so that we don't start using dentry
> > inadvertedly for something inside fsnotify thus breaking unlink reporting
> > in subtle ways...
> >
> 
> I don't know.
> For fsnotify_unlink/rmdir we check d_is_negative, so it's fine to use
> FSNOTIFY_EVENT_INODE.
> For fsnotify_link,fsnotify_move we get the inode explicitly, but we already
> use FSNOTIFY_EVENT_INODE in those cases (except FS_RENAME).

Yeah, plus we have the xattr and attrib events which need dentry to lookup
parent. So scratch this idea.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
