Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB02996B74
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 23:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbfHTV0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 17:26:53 -0400
Received: from fieldses.org ([173.255.197.46]:40596 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730858AbfHTV0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 17:26:53 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id C91A21E3B; Tue, 20 Aug 2019 17:26:52 -0400 (EDT)
Date:   Tue, 20 Aug 2019 17:26:52 -0400
To:     Max Kellermann <mk@cm4all.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, hughd@google.com,
        anna.schumaker@netapp.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] fs/posix_acl: apply umask if superblock disables
 ACL support
Message-ID: <20190820212652.GB10909@fieldses.org>
References: <20190713041200.18566-1-mk@cm4all.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713041200.18566-1-mk@cm4all.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From:   bfields@fieldses.org (J. Bruce Fields)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

What happened to these patches?  All four make sense to me, for what
it's worth; feel free to add a

	Reviewed-by: J. Bruce Fields <bfields@redhat.com>

--b.

On Sat, Jul 13, 2019 at 06:11:57AM +0200, Max Kellermann wrote:
> The function posix_acl_create() applies the umask only if the inode
> has no ACL (= NULL) or if ACLs are not supported by the filesystem
> driver (= -EOPNOTSUPP).
> 
> However, this happens only after after the IS_POSIXACL() check
> succeeeded.  If the superblock doesn't enable ACL support, umask will
> never be applied.  A filesystem which has no ACL support will of
> course not enable SB_POSIXACL, rendering the umask-applying code path
> unreachable.
> 
> This fixes a bug which causes the umask to be ignored with O_TMPFILE
> on tmpfs:
> 
>  https://github.com/MusicPlayerDaemon/MPD/issues/558
>  https://bugs.gentoo.org/show_bug.cgi?id=686142#c3
>  https://bugzilla.kernel.org/show_bug.cgi?id=203625
> 
> Signed-off-by: Max Kellermann <mk@cm4all.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/posix_acl.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index 84ad1c90d535..4071c66f234a 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -589,9 +589,14 @@ posix_acl_create(struct inode *dir, umode_t *mode,
>  	*acl = NULL;
>  	*default_acl = NULL;
>  
> -	if (S_ISLNK(*mode) || !IS_POSIXACL(dir))
> +	if (S_ISLNK(*mode))
>  		return 0;
>  
> +	if (!IS_POSIXACL(dir)) {
> +		*mode &= ~current_umask();
> +		return 0;
> +	}
> +
>  	p = get_acl(dir, ACL_TYPE_DEFAULT);
>  	if (!p || p == ERR_PTR(-EOPNOTSUPP)) {
>  		*mode &= ~current_umask();
> -- 
> 2.20.1
