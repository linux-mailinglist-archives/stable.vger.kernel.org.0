Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EE6452E39
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 10:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhKPJnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 04:43:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233149AbhKPJnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 04:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC57A61263;
        Tue, 16 Nov 2021 09:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637055654;
        bh=qvJ2MmqdefIgR7a3kOTYk8TVyPCF90+hq0kPO35l50Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y1ypC7GcpCmpNOnu64uHb9tEFRZhyvFqDIkpEVubYvF34VMEiwx/mf+JDjWYD1MMX
         4ZuGRK65u6OGiC4zSet3nynYOelrs+09y46wrGFxp6VmWOT8VrvT7vMjvXtzWLAYSy
         CafvRJjadZ2n/S2XHwRzRUU2YAZMR80eA2kzuU/KkHC6dX82lOtpGxp/c9wsdHCUxW
         OQ1cY1gyzRAoqZ3022Xu0GTttowb8qkp3DeywgWzt6AETK+ovAwSSndR7rmmMf4OzD
         4f2Srx1SvYynHOdnFMO8Pnk4HGUUx7leHS2yG0X8Im5eGk2OQP68OL2oGV5s/CUN1x
         xa2brdP3nTVeA==
Date:   Tue, 16 Nov 2021 10:40:50 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@digitalocean.com>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] fs: handle circular mappings correctly
Message-ID: <20211116094050.bt3k5oaye6sm2ar7@wittgenstein>
References: <20211109145713.1868404-1-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211109145713.1868404-1-brauner@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 03:57:12PM +0100, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> When calling setattr_prepare() to determine the validity of the attributes the
> ia_{g,u}id fields contain the value that will be written to inode->i_{g,u}id.
> When the {g,u}id attribute of the file isn't altered and the caller's fs{g,u}id
> matches the current {g,u}id attribute the attribute change is allowed.
> 
> The value in ia_{g,u}id does already account for idmapped mounts and will have
> taken the relevant idmapping into account. So in order to verify that the
> {g,u}id attribute isn't changed we simple need to compare the ia_{g,u}id value
> against the inode's i_{g,u}id value.
> 
> This only has any meaning for idmapped mounts as idmapping helpers are
> idempotent without them. And for idmapped mounts this really only has a meaning
> when circular idmappings are used, i.e. mappings where e.g. id 1000 is mapped
> to id 1001 and id 1001 is mapped to id 1000. Such ciruclar mappings can e.g. be
> useful when sharing the same home directory between multiple users at the same
> time.
> 
> As an example consider a directory with two files: /source/file1 owned by
> {g,u}id 1000 and /source/file2 owned by {g,u}id 1001. Assume we create an
> idmapped mount at /target with an idmapping that maps files owned by {g,u}id
> 1000 to being owned by {g,u}id 1001 and files owned by {g,u}id 1001 to being
> owned by {g,u}id 1000. In effect, the idmapped mount at /target switches the
> ownership of /source/file1 and source/file2, i.e. /target/file1 will be owned
> by {g,u}id 1001 and /target/file2 will be owned by {g,u}id 1000.
> 
> This means that a user with fs{g,u}id 1000 must be allowed to setattr
> /target/file2 from {g,u}id 1000 to {g,u}id 1000. Similar, a user with fs{g,u}id
> 1001 must be allowed to setattr /target/file1 from {g,u}id 1001 to {g,u}id
> 1001. Conversely, a user with fs{g,u}id 1000 must fail to setattr /target/file1
> from {g,u}id 1001 to {g,u}id 1000. And a user with fs{g,u}id 1001 must fail to
> setattr /target/file2 from {g,u}id 1000 to {g,u}id 1000. Both cases must fail
> with EPERM for non-capable callers.
> 
> Before this patch we could end up denying legitimate attribute changes and
> allowing invalid attribute changes when circular mappings are used. To even get
> into this situation the caller must've been privileged both to create that
> mapping and to create that idmapped mount.
> 
> This hasn't been seen in the wild anywhere but came up when expanding the
> testsuite during work on a series of hardening patches. All idmapped fstests
> pass without any regressions and we add new tests to verify the behavior of
> circular mappings.
> 
> Fixes: 2f221d6f7b88 ("attr: handle idmapped mounts")
> Cc: Seth Forshee <seth.forshee@digitalocean.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org
> CC: linux-fsdevel@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---

Christoph, can you take a look, by any chance? I'd like to get this to
Linus this week.

>  fs/attr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index 473d21b3a86d..66899b6e9bd8 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -35,7 +35,7 @@ static bool chown_ok(struct user_namespace *mnt_userns,
>  		     kuid_t uid)
>  {
>  	kuid_t kuid = i_uid_into_mnt(mnt_userns, inode);
> -	if (uid_eq(current_fsuid(), kuid) && uid_eq(uid, kuid))
> +	if (uid_eq(current_fsuid(), kuid) && uid_eq(uid, inode->i_uid))
>  		return true;
>  	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
>  		return true;
> @@ -62,7 +62,7 @@ static bool chgrp_ok(struct user_namespace *mnt_userns,
>  {
>  	kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
>  	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode)) &&
> -	    (in_group_p(gid) || gid_eq(gid, kgid)))
> +	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
>  		return true;
>  	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
>  		return true;
> 
> base-commit: 8bb7eca972ad531c9b149c0a51ab43a417385813
> -- 
> 2.30.2
> 
