Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B3C62990
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404359AbfGHT2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:28:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45724 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404353AbfGHT2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:28:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so8048907pfq.12;
        Mon, 08 Jul 2019 12:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gYORkOVhBZ3qEfxmUhzIzVtUTq0YjbmyEVwzAUWkCu4=;
        b=Fu98mGVA9yn/B3ahwTaX+oOlQQGwdD4LZ6N7wpWW5wwlAvjJjiW+x/+OGhlgai8UOt
         ZJfM+7Fklv28HFUM3b9VchIgUG9rOw5kyu1DJt0z6NwIfKtvk3xUTxh+fri0c9jUwYje
         gnwLApCr/2Yw0D1q3/qRGfAoqtsCWsDOamU/43RkCrQoXwBcRyGC1IJuoT6Fbj9Hj1ws
         ij1o+vL+358IMceLoTQ9jXg5GXrPNQYrXNFnGXpBoczeAtAFL7L1xMalsd6jWrZDoZ+1
         iZ3RlUJNkEJny390/QWdMrczPq9IgOqMcAds2BD5OkZbSfKtwJNfbsVcQPg7RcQJmuaz
         ty2g==
X-Gm-Message-State: APjAAAVlrCnOqJfHbQ/tTQt4kvgmsQazz72GPZ0nMQEb1t9nmItdEfGB
        uLhYvcWkO+FzKfNZtmSYPWk=
X-Google-Smtp-Source: APXvYqxPe0tbDU8G83EqyqzukW2HzB+R+6kKau5wgSRQGfqWlosKarDiCdKCWJ7ETpwEJmik5kXPqg==
X-Received: by 2002:a17:90a:9bca:: with SMTP id b10mr27811582pjw.90.1562614083277;
        Mon, 08 Jul 2019 12:28:03 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o14sm280839pjp.19.2019.07.08.12.28.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:28:02 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C08C140255; Mon,  8 Jul 2019 19:28:01 +0000 (UTC)
Date:   Mon, 8 Jul 2019 19:28:01 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Radoslaw Burny <rburny@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jsperbeck@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] fs: Fix the default values of i_uid/i_gid on
 /proc/sys inodes.
Message-ID: <20190708192801.GG19023@42.do-not-panic.com>
References: <20190708115130.250149-1-rburny@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708115130.250149-1-rburny@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 01:51:30PM +0200, Radoslaw Burny wrote:
> fs: Fix the default values of i_uid/i_gid on /proc/sys inodes.
> Normally, the inode's i_uid/i_gid are translated relative to s_user_ns,
> but this is not a correct behavior for proc. Since sysctl permission
> check in test_perm is done against GLOBAL_ROOT_[UG]ID, it makes more
> sense to use these values in u_[ug]id of proc inodes.
> In other words: although uid/gid in the inode is not read during
> test_perm, the inode logically belongs to the root of the namespace.
> I have confirmed this with Eric Biederman at LPC and in this thread:
> https://lore.kernel.org/lkml/87k1kzjdff.fsf@xmission.com
> 
> Consequences
> ============
> Since the i_[ug]id values of proc nodes are not used for permissions
> checks, this change usually makes no functional difference. However, it
> causes an issue in a setup where:
> * a namespace container is created without root user in container -
>   hence the i_[ug]id of proc nodes are set to INVALID_[UG]ID
> * container creator tries to configure it by writing /proc/sys files,
>   e.g. writing /proc/sys/kernel/shmmax to configure shared memory limit
> Kernel does not allow to open an inode for writing if its i_[ug]id are
> invalid, making it impossible to write shmmax and thus - configure the
> container.
> Using a container with no root mapping is apparently rare, but we do use
> this configuration at Google. Also, we use a generic tool to configure
> the container limits, and the inability to write any of them causes a
> failure.
> 
> History
> =======
> The invalid uids/gids in inodes first appeared due to 81754357770e (fs:
> Update i_[ug]id_(read|write) to translate relative to s_user_ns).
> However, AFAIK, this did not immediately cause any issues.
> The inability to write to these "invalid" inodes was only caused by a
> later commit 0bd23d09b874 (vfs: Don't modify inodes with a uid or gid
> unknown to the vfs).
> 
> Tested: Used a repro program that creates a user namespace without any
> mapping and stat'ed /proc/$PID/root/proc/sys/kernel/shmmax from outside.
> Before the change, it shows the overflow uid, with the change it's 0.
> The overflow uid indicates that the uid in the inode is not correct and
> thus it is not possible to open the file for writing.
> 
> Fixes: 0bd23d09b874 ("vfs: Don't modify inodes with a uid or gid unknown to the vfs")
> Cc: stable@vger.kernel.org # v4.8+
> Signed-off-by: Radoslaw Burny <rburny@google.com>

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

Andrew,

When you get a chance, can you pick this one up on your tree? This was
an old patch that just fell through the cracks, but fortuntely Radoslaw
followed through with an updated commit message. This affects only a
small crowd, however it is a proper fix.

  Luis
> ---
> Changelog since v1:
>   - Updated the commit title and description.
> 
>  fs/proc/proc_sysctl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index c74570736b24..36ad1b0d6259 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -499,6 +499,10 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  
>  	if (root->set_ownership)
>  		root->set_ownership(head, table, &inode->i_uid, &inode->i_gid);
> +	else {
> +		inode->i_uid = GLOBAL_ROOT_UID;
> +		inode->i_gid = GLOBAL_ROOT_GID;
> +	}
>  
>  	return inode;
>  }
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 
