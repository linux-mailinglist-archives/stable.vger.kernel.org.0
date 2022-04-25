Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C731E50E645
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 18:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbiDYQ51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 12:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbiDYQ50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 12:57:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6E43A739;
        Mon, 25 Apr 2022 09:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963F361338;
        Mon, 25 Apr 2022 16:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2B5C385A7;
        Mon, 25 Apr 2022 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650905660;
        bh=KXJVeHvfBoeQRSEK/W6Wv+6jM5VvVPCcOez/eDrDa1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=re87esaQWebxX3nfjHmMciUuhhC1LDKwLCuG7M+0mkFIuf6LR+a/n4c9h1V+C54eG
         DadjpAAgQP5J12j9f6RO2lqNhPVYbMn0weoP90W8++PUVGZ7OwY0OBLneHX6aOGg0s
         V+6SMQxFOpDbiN/aDkuwcyVTU8uHG3zaGN3zm9PewFypc+FEnCh4ZjtvD8JOmM+ah/
         ErgvD1qIdx4fC7mX4YZ4s24KS624NdBHSAxB/lkhjqKp4n88pnk/snSq0zUpBUyGDb
         /omD9QlzDiqrLuXTUPgm/x8FvybYfkwJKTJE47IGJozAqtdZ5YENtG2WglOfwPe4Xo
         J94od0WvEUWAA==
Date:   Mon, 25 Apr 2022 09:54:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, brauner@kernel.org,
        willy@infradead.org, jlayton@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v6 2/4] fs: Add missing umask strip in vfs_tmpfile
Message-ID: <20220425165419.GE16996@magnolia>
References: <1650856181-21350-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <1650856181-21350-2-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650856181-21350-2-git-send-email-xuyang2018.jy@fujitsu.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 11:09:39AM +0800, Yang Xu wrote:
> All creation paths except for O_TMPFILE handle umask in the vfs directly
> if the filesystem doesn't support or enable POSIX ACLs. If the filesystem
> does then umask handling is deferred until posix_acl_create().
> Because, O_TMPFILE misses umask handling in the vfs it will not honor
> umask settings. Fix this by adding the missing umask handling.
> 
> Fixes: 60545d0d4610 ("[O_TMPFILE] it's still short a few helpers, but infrastructure should be OK now...")

If I had a nickel for every time I felt like I was short a few
helpers... ;)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Cc: <stable@vger.kernel.org> # 4.19+
> Reported-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> ---
>  fs/namei.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 509657fdf4f5..73646e28fae0 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3521,6 +3521,8 @@ struct dentry *vfs_tmpfile(struct user_namespace *mnt_userns,
>  	child = d_alloc(dentry, &slash_name);
>  	if (unlikely(!child))
>  		goto out_err;
> +	if (!IS_POSIXACL(dir))
> +		mode &= ~current_umask();
>  	error = dir->i_op->tmpfile(mnt_userns, dir, child, mode);
>  	if (error)
>  		goto out_err;
> -- 
> 2.27.0
> 
