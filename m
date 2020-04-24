Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E91B77B0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgDXN66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 09:58:58 -0400
Received: from mother.openwall.net ([195.42.179.200]:37297 "HELO
        mother.openwall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727064AbgDXN65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 09:58:57 -0400
Received: (qmail 32561 invoked from network); 24 Apr 2020 13:52:14 -0000
Received: from localhost (HELO pvt.openwall.com) (127.0.0.1)
  by localhost with SMTP; 24 Apr 2020 13:52:14 -0000
Received: by pvt.openwall.com (Postfix, from userid 503)
        id 5E3FBAB5C7; Fri, 24 Apr 2020 15:52:05 +0200 (CEST)
Date:   Fri, 24 Apr 2020 15:52:05 +0200
From:   Solar Designer <solar@openwall.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Salvatore Mesoraca <s.mesoraca16@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.16 208/245] namei: allow restricted O_CREAT of FIFOs and regular files
Message-ID: <20200424135205.GA27204@openwall.com>
References: <lsq.1587683027.831233700@decadent.org.uk> <lsq.1587683028.722200761@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1587683028.722200761@decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 12:07:15AM +0100, Ben Hutchings wrote:
> 3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

I do.  This patch is currently known-buggy, see this thread:

https://www.openwall.com/lists/oss-security/2020/01/28/2

It is (partially) fixed with these newer commits in 5.5 and 5.5.2:

commit d0cb50185ae942b03c4327be322055d622dc79f6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Jan 26 09:29:34 2020 -0500

    do_last(): fetch directory ->i_mode and ->i_uid before it's too late
    
    may_create_in_sticky() call is done when we already have dropped the
    reference to dir.
    
    Fixes: 30aba6656f61e (namei: allow restricted O_CREAT of FIFOs and regular files)
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit d76341d93dedbcf6ed5a08dfc8bce82d3e9a772b
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Feb 1 16:26:45 2020 +0000

    vfs: fix do_last() regression
    
    commit 6404674acd596de41fd3ad5f267b4525494a891a upstream.
    
    Brown paperbag time: fetching ->i_uid/->i_mode really should've been
    done from nd->inode.  I even suggested that, but the reason for that has
    slipped through the cracks and I went for dir->d_inode instead - made
    for more "obvious" patch.
    
    Analysis:
    
     - at the entry into do_last() and all the way to step_into(): dir (aka
       nd->path.dentry) is known not to have been freed; so's nd->inode and
       it's equal to dir->d_inode unless we are already doomed to -ECHILD.
       inode of the file to get opened is not known.
    
     - after step_into(): inode of the file to get opened is known; dir
       might be pointing to freed memory/be negative/etc.
    
     - at the call of may_create_in_sticky(): guaranteed to be out of RCU
       mode; inode of the file to get opened is known and pinned; dir might
       be garbage.
    
    The last was the reason for the original patch.  Except that at the
    do_last() entry we can be in RCU mode and it is possible that
    nd->path.dentry->d_inode has already changed under us.
    
    In that case we are going to fail with -ECHILD, but we need to be
    careful; nd->inode is pointing to valid struct inode and it's the same
    as nd->path.dentry->d_inode in "won't fail with -ECHILD" case, so we
    should use that.
    
    Reported-by: "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
    Reported-by: syzbot+190005201ced78a74ad6@syzkaller.appspotmail.com
    Wearing-brown-paperbag: Al Viro <viro@zeniv.linux.org.uk>
    Cc: stable@kernel.org
    Fixes: d0cb50185ae9 ("do_last(): fetch directory ->i_mode and ->i_uid before it's too late")
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

At least inclusion of the above fixes is mandatory for any backports.

Also, I think no one has fixed the logic of may_create_in_sticky() so
that it wouldn't unintentionally apply the "protection" when the file
is neither a FIFO nor a regular file (something I found and mentioned in
the oss-security posting above).

> +/**
> + * may_create_in_sticky - Check whether an O_CREAT open in a sticky directory
> + *			  should be allowed, or not, on files that already
> + *			  exist.
> + * @dir: the sticky parent directory
> + * @inode: the inode of the file to open
> + *
> + * Block an O_CREAT open of a FIFO (or a regular file) when:
> + *   - sysctl_protected_fifos (or sysctl_protected_regular) is enabled
> + *   - the file already exists
> + *   - we are in a sticky directory
> + *   - we don't own the file
> + *   - the owner of the directory doesn't own the file
> + *   - the directory is world writable
> + * If the sysctl_protected_fifos (or sysctl_protected_regular) is set to 2
> + * the directory doesn't have to be world writable: being group writable will
> + * be enough.
> + *
> + * Returns 0 if the open is allowed, -ve on error.
> + */
> +static int may_create_in_sticky(struct dentry * const dir,
> +				struct inode * const inode)
> +{
> +	if ((!sysctl_protected_fifos && S_ISFIFO(inode->i_mode)) ||
> +	    (!sysctl_protected_regular && S_ISREG(inode->i_mode)) ||
> +	    likely(!(dir->d_inode->i_mode & S_ISVTX)) ||
> +	    uid_eq(inode->i_uid, dir->d_inode->i_uid) ||
> +	    uid_eq(current_fsuid(), inode->i_uid))
> +		return 0;
> +
> +	if (likely(dir->d_inode->i_mode & 0002) ||
> +	    (dir->d_inode->i_mode & 0020 &&
> +	     ((sysctl_protected_fifos >= 2 && S_ISFIFO(inode->i_mode)) ||
> +	      (sysctl_protected_regular >= 2 && S_ISREG(inode->i_mode))))) {
> +		return -EACCES;
> +	}
> +	return 0;
> +}

I think the implementation of may_create_in_sticky() should be rewritten
such that it'd directly correspond to the textual description in the
comment above.  As we've seen, trying to write the code "more optimally"
resulted in its logic actually being different from the description.

Meanwhile, I think backporting known-so-buggy code is a bad idea.

Alexander
