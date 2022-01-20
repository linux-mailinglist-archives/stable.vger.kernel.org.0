Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02AB494E42
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 13:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243668AbiATMwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 07:52:11 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41354 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243466AbiATMwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 07:52:10 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 971951F770;
        Thu, 20 Jan 2022 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642683129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IHwzhjOPAT+gULPmdflw9YlXG9LtJm1sRS+rnmT5KOE=;
        b=MXz5Ny2SEeQX8T/IA5cMuzVsgTKTSocUfImuUeHIs/lYBsMqHZEAOfYUjBvZJ2Jgj7K38T
        pwMPPJ0Kyq0OLoi2Wll2fZV62nKEnD9b9rrDsYS0DTsWDrIAfGdKxKdOIKeNIVYm5nDJ8J
        9pBSgAekGm+wX7tFpZw1eatFwWzgAIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642683129;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IHwzhjOPAT+gULPmdflw9YlXG9LtJm1sRS+rnmT5KOE=;
        b=t+QyBhR+5BEmDl+f6wJwBbPRNgkwStlei9EccIlyew9XrEXVzQ6PS8ng4YryGoO8MnSVGo
        JLAK4HftDRZoF3CA==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7A0D0A3B85;
        Thu, 20 Jan 2022 12:52:09 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E91EBA05D9; Thu, 20 Jan 2022 13:52:08 +0100 (CET)
Date:   Thu, 20 Jan 2022 13:52:08 +0100
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Matthew Bobrowski <repnop@google.com>,
        Ivan Delalande <colona@arista.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fnotify: invalidate dcache before IN_DELETE event
Message-ID: <20220120125208.jmm2xjwcxaswt3tn@quack3.lan>
References: <20220118120031.196123-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118120031.196123-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 18-01-22 14:00:31, Amir Goldstein wrote:
> Apparently, there are some applications that use IN_DELETE event as an
> invalidation mechanism and expect that if they try to open a file with
> the name reported with the delete event, that it should not contain the
> content of the deleted file.
> 
> Commit 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of
> d_delete()") moved the fsnotify delete hook before d_delete() so fsnotify
> will have access to a positive dentry.
> 
> This allowed a race where opening the deleted file via cached dentry
> is now possible after receiving the IN_DELETE event.
> 
> To fix the regression, we use two different techniques:
> 1) For call sites that call d_delete() with elevated refcount, convert
>    the call to d_drop() and move the fsnotify hook after d_drop().

Maybe do this in a separate patch? It's quite a bit of mostly mechanical
changes, after separating them it is more obvious what the logical changes
actually are (and backporting is actually less error prone as well).

> 2) For the vfs helpers that may turn dentry to negative on d_delete(),
>    use a helper d_delete_notify() to pin the inode, so we can pass it
>    to an fsnotify hook after d_delete().
> 
> Create a new hook fsnotify_delete() that allows to pass a negative
> dentry and takes the unlinked inode as an argument.
> 
> Add a missing fsnotify_unlink() hook in nfsdfs that was found during
> the call sites audit.
> 
> Note that the call sites in simple_recursive_removal() follow
> d_invalidate(), so they require no change.
> 
> Backporting hint: this regression is from v5.3. Although patch will
> apply with only trivial conflicts to v5.4 and v5.10, it won't build,
> because fsnotify_delete() implementation is different in each of those
> versions (see fsnotify_link()).
> 
> Reported-by: Ivan Delalande <colona@arista.com>
> Link: https://lore.kernel.org/linux-fsdevel/YeNyzoDM5hP5LtGW@visor/
> Fixes: 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of d_delete()")
> Cc: stable@vger.kernel.org # v5.3+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

...

> diff --git a/fs/namei.c b/fs/namei.c
> index 1f9d2187c765..b11991b57f9b 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3929,6 +3929,23 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
>  	return do_mkdirat(AT_FDCWD, getname(pathname), mode);
>  }
>  
> +/**
> + * d_delete_notify - delete a dentry and call fsnotify_delete()
> + * @dentry: The dentry to delete
> + *
> + * This helper is used to guaranty that the unlinked inode cannot be found
			     ^^^ guarantee

> + * by lookup of this name after fsnotify_delete() event has been delivered.
> + */
> +static void d_delete_notify(struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode *inode = d_inode(dentry);
> +
> +	ihold(inode);
> +	d_delete(dentry);
> +	fsnotify_delete(dir, inode, dentry);
> +	iput(inode);
> +}
> +
>  /**
>   * vfs_rmdir - remove directory
>   * @mnt_userns:	user namespace of the mount the inode was found from
...
> @@ -4101,7 +4117,6 @@ int vfs_unlink(struct user_namespace *mnt_userns, struct inode *dir,
>  			if (!error) {
>  				dont_mount(dentry);
>  				detach_mounts(dentry);
> -				fsnotify_unlink(dir, dentry);
>  			}
>  		}
>  	}
> @@ -4109,9 +4124,11 @@ int vfs_unlink(struct user_namespace *mnt_userns, struct inode *dir,
>  	inode_unlock(target);
>  
>  	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
> -	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
> +	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
> +		fsnotify_unlink(dir, dentry);
> +	} else if (!error) {
>  		fsnotify_link_count(target);
> -		d_delete(dentry);
> +		d_delete_notify(dir, dentry);
>  	}

Are we sure that if DCACHE_NFSFS_RENAMED is set, error == 0? Maybe yes but
it is not completely clear to me - e.g. if you try to rename something to a
name that is taken by sillyrenamed file, the unlink will fail but dentry
has DCACHE_NFSFS_RENAMED set...

> +/*
> + * fsnotify_delete - @dentry was unlinked and unhashed
> + *
> + * Caller must make sure that dentry->d_name is stable.
> + *
> + * Note: unlike fsnotify_unlink(), we have to pass also the unlinked inode
> + * as this may be called after d_delete() and old_dentry may be negative.
> + */
> +static inline void fsnotify_delete(struct inode *dir, struct inode *inode,
> +				   struct dentry *dentry)
> +{
> +	__u32 mask = FS_DELETE;
> +
> +	if (S_ISDIR(inode->i_mode))
> +		mask |= FS_ISDIR;
> +
> +	fsnotify_name(mask, inode, FSNOTIFY_EVENT_INODE, dir, &dentry->d_name,
> +		      0);
> +}
> +

OK, this is fine because we use dentry only for FAN_RENAME event, don't we?
In all other cases we always use only inode anyway. Can we perhaps cleanup
include/linux/fsnotify.h to use FSNOTIFY_EVENT_DENTRY only in that one call
site inside fsnotify_move() and use FSNOTIFY_EVENT_INODE in all the other
cases? So that this is clear and also so that we don't start using dentry
inadvertedly for something inside fsnotify thus breaking unlink reporting
in subtle ways...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
