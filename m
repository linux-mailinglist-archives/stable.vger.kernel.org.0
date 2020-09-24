Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F205277330
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 15:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgIXNzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 09:55:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:39424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgIXNzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 09:55:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31965ABAD;
        Thu, 24 Sep 2020 13:55:39 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EB4561E1303; Thu, 24 Sep 2020 11:08:59 +0200 (CEST)
Date:   Thu, 24 Sep 2020 11:08:59 +0200
From:   Jan Kara <jack@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: fix leaking sysfs kobject after failed mount
Message-ID: <20200924090859.GF27019@quack2.suse.cz>
References: <000000000000443d8a05afcff2b5@google.com>
 <20200922162456.93657-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922162456.93657-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 22-09-20 09:24:56, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ext4_unregister_sysfs() only deletes the kobject.  The reference to it
> needs to be put separately, like ext4_put_super() does.
> 
> This addresses the syzbot report
> "memory leak in kobject_set_name_vargs (3)"
> (https://syzkaller.appspot.com/bug?extid=9f864abad79fae7c17e1).
> 
> Reported-by: syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
> Fixes: 72ba74508b28 ("ext4: release sysfs kobject when failing to enable quotas on mount")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ea425b49b345..41953b86ffe3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4872,6 +4872,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  
>  failed_mount8:
>  	ext4_unregister_sysfs(sb);
> +	kobject_put(&sbi->s_kobj);
>  failed_mount7:
>  	ext4_unregister_li_request(sb);
>  failed_mount6:
> 
> base-commit: ba4f184e126b751d1bffad5897f263108befc780
> -- 
> 2.28.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
