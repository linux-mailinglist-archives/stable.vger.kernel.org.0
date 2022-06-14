Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E5C54A79C
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbiFNDmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiFNDmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:42:03 -0400
X-Greylist: delayed 154066 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Jun 2022 20:42:02 PDT
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F293F36315;
        Mon, 13 Jun 2022 20:42:01 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id B9F35C01D; Tue, 14 Jun 2022 05:42:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655178120; bh=kMhrbHmtDy8FgmIFOYrbI1pKa88ais5XYanlCNmLm+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJfWrgZ3HXfWO/UQCWGDmW7ZCSuYL8dR9Lmc2kF710OpYtEWfGZ5UMNFnWsGUYdSJ
         BvqwzFNePwZRalWakPC25IN8crVstzf9mmlO98v+o7X+IWIrucEOLzxr8WDOIn3XCP
         wPlE/SZtCrtAhnHmC6shrJhXzkPpbj3xUNRnvnyXUQHlK3o4MoL4S5jyqbdxSbACq5
         cOIR9zlE5lPOZDo/6eaVHmPaE83/QfVGe+3RYpT74j7P0QwxuGtSB4b0Wv5mLmBdgy
         A4LP36pSTbhlT1HscCfxuGn3XuHkxoLsO6H2P/R1V1wtI3HoE4bQK5Xl2ICvdF75zv
         f+Ut48QSmErpw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id AE1E6C009;
        Tue, 14 Jun 2022 05:41:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655178120; bh=kMhrbHmtDy8FgmIFOYrbI1pKa88ais5XYanlCNmLm+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJfWrgZ3HXfWO/UQCWGDmW7ZCSuYL8dR9Lmc2kF710OpYtEWfGZ5UMNFnWsGUYdSJ
         BvqwzFNePwZRalWakPC25IN8crVstzf9mmlO98v+o7X+IWIrucEOLzxr8WDOIn3XCP
         wPlE/SZtCrtAhnHmC6shrJhXzkPpbj3xUNRnvnyXUQHlK3o4MoL4S5jyqbdxSbACq5
         cOIR9zlE5lPOZDo/6eaVHmPaE83/QfVGe+3RYpT74j7P0QwxuGtSB4b0Wv5mLmBdgy
         A4LP36pSTbhlT1HscCfxuGn3XuHkxoLsO6H2P/R1V1wtI3HoE4bQK5Xl2ICvdF75zv
         f+Ut48QSmErpw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id dfc027e7;
        Tue, 14 Jun 2022 03:41:55 +0000 (UTC)
Date:   Tue, 14 Jun 2022 12:41:40 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Howells <dhowells@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Message-ID: <YqgDdNUxC0hV6KR9@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org>
 <20220614033802.1606738-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220614033802.1606738-1-asmadeus@codewreck.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dominique Martinet wrote on Tue, Jun 14, 2022 at 12:38:02PM +0900:
> cached operations sometimes need to do invalid operations (e.g. read
> on a write only file)
> Historic fscache had added a "writeback fid" for this, but the conversion
> to new fscache somehow lost usage of it: use the writeback fid instead
> of normal one.
> 
> Note that the way this works (writeback fid being linked to inode) means
> we might use overprivileged fid for some operations, e.g. write as root
> when we shouldn't.
> Ideally we should keep both fids handy, and only use the writeback fid
> when really required e.g. reads to a write-only file to fill in the page
> cache (read-modify-write); but this is the situation we've always had
> and this commit only fixes an issue we've had for too long.
> 
> Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads and caching")
> Cc: stable@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Reported-By: Christian Schoenebeck <linux_oss@crudebyte.com>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
> Ok so finally had time to look at this, and it's not a lot so this is
> the most straight forward way to do: just reverting to how the old
> fscache worked.
> 
> This appears to work from quick testing, Chiristian could you test it?
> 
> I think the warnings you added in p9_client_read/write that check
> fid->mode might a lot of sense, if you care to resend it as
> WARN_ON((fid->mode & ACCMODE) == O_xyz);
> instead I'll queue that for 5.20
> 
> 
> @Stable people, I've checked it applies to 5.17 and 5.18 so should be
> good to grab once I submit it for inclusion (that commit was included in
> 5.16, which is no longer stable)
> 
> 
>  fs/9p/vfs_addr.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
> index 7382c5227e94..262968d02f55 100644
> --- a/fs/9p/vfs_addr.c
> +++ b/fs/9p/vfs_addr.c
> @@ -58,7 +58,11 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
>   */
>  static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
>  {
> -	struct p9_fid *fid = file->private_data;
> +	struct inode *inode = file_inode(file);
> +	struct v9fs_inode *v9inode = V9FS_I(inode);
> +	struct p9_fid *fid = v9inode->writeback_fid;
> +

Sorry for mails back-to-back (grmbl I hate git commit --amend not
warning I only have unstaged changes), this is missing the following
here:

+    /* If there is no writeback fid this file only ever has had
+     * read-only opens, so we can use file's fid which should
+     * always be set instead */
+    if (!fid)
+        fid = file->private_data;

Christian, you can find it here to test:
https://github.com/martinetd/linux/commit/a6e033c41cc9f0ec105f5d208b0a820118e2bda8

> +	BUG_ON(!fid);
>  
>  	p9_fid_get(fid);
>  	rreq->netfs_priv = fid;

Thanks,
-- 
Dominique
