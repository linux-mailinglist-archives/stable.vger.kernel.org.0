Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4432C9EBCC
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 17:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfH0PDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 11:03:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:33840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbfH0PDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 11:03:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E5B54AEFB;
        Tue, 27 Aug 2019 15:03:04 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7C8D41E4362; Tue, 27 Aug 2019 17:03:04 +0200 (CEST)
Date:   Tue, 27 Aug 2019 17:03:04 +0200
From:   Jan Kara <jack@suse.cz>
To:     Max Kellermann <mk@cm4all.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, hughd@google.com,
        anna.schumaker@netapp.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] linux/fs.h: fix umask on NFS with
 CONFIG_FS_POSIX_ACL=n
Message-ID: <20190827150304.GB10306@quack2.suse.cz>
References: <20190713041200.18566-1-mk@cm4all.com>
 <20190713041200.18566-3-mk@cm4all.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713041200.18566-3-mk@cm4all.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Sat 13-07-19 06:11:59, Max Kellermann wrote:
> Make IS_POSIXACL() return false if POSIX ACL support is disabled and
> ignore SB_POSIXACL/MS_POSIXACL.
> 
> Never skip applying the umask in namei.c and never bother to do any
> ACL specific checks if the filesystem falsely indicates it has ACLs
> enabled when the feature is completely disabled in the kernel.
> 
> This fixes a problem where the umask is always ignored in the NFS
> client when compiled without CONFIG_FS_POSIX_ACL.  This is a 4 year
> old regression caused by commit 013cdf1088d723 which itself was not
> completely wrong, but failed to consider all the side effects by
> misdesigned VFS code.
> 
> Prior to that commit, there were two places where the umask could be
> applied, for example when creating a directory:
> 
>  1. in the VFS layer in SYSCALL_DEFINE3(mkdirat), but only if
>     !IS_POSIXACL()
> 
>  2. again (unconditionally) in nfs3_proc_mkdir()
> 
> The first one does not apply, because even without
> CONFIG_FS_POSIX_ACL, the NFS client sets MS_POSIXACL in
> nfs_fill_super().
> 
> After that commit, (2.) was replaced by:
> 
>  2b. in posix_acl_create(), called by nfs3_proc_mkdir()
> 
> There's one branch in posix_acl_create() which applies the umask;
> however, without CONFIG_FS_POSIX_ACL, posix_acl_create() is an empty
> dummy function which does not apply the umask.
> 
> The approach chosen by this patch is to make IS_POSIXACL() always
> return false when POSIX ACL support is disabled, so the umask always
> gets applied by the VFS layer.  This is consistent with the (regular)
> behavior of posix_acl_create(): that function returns early if
> IS_POSIXACL() is false, before applying the umask.
> 
> Therefore, posix_acl_create() is responsible for applying the umask if
> there is ACL support enabled in the file system (SB_POSIXACL), and the
> VFS layer is responsible for all other cases (no SB_POSIXACL or no
> CONFIG_FS_POSIX_ACL).
> 
> Signed-off-by: Max Kellermann <mk@cm4all.com>
> Cc: stable@vger.kernel.org

Thanks for the patch. This patch definitely looks good to me so feel free
to add:

Reviewed-by: Jan Kara <jack@suse.cz>

I just wonder, do you really need patches 1 and 2? Doesn't this patch alone
fix the problem? Because AFAIU the problem, this patch should be enough and
indeed the logic "VFS is responsible for applying umask if !IS_POSIXACL and
otherwise posix_acl_create() is responsible for it" looks the most logical
to me. BTW, I think you should add VFS maintainer - Al Viro
<viro@ZenIV.linux.org.uk> - to CC to merge the patch.

								Honza

> ---
>  include/linux/fs.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f7fdfe93e25d..5e9f3aa7ba26 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1993,7 +1993,12 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
>  #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
>  #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
>  #define IS_IMMUTABLE(inode)	((inode)->i_flags & S_IMMUTABLE)
> +
> +#ifdef CONFIG_FS_POSIX_ACL
>  #define IS_POSIXACL(inode)	__IS_FLG(inode, SB_POSIXACL)
> +#else
> +#define IS_POSIXACL(inode)	0
> +#endif
>  
>  #define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
>  #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
