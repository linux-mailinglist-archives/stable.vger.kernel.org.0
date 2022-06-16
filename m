Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B8954E30E
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 16:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377001AbiFPOLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 10:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377558AbiFPOLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 10:11:39 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5365149928;
        Thu, 16 Jun 2022 07:11:38 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 0B084C01E; Thu, 16 Jun 2022 16:11:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655388697; bh=6fLEu8wAlSIhYMNp84lmaEuPjTbe/YpTHYdRdU5qRks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t6uTnZ/bhgyYCOwpTf0dxtMmGQuPxvV2LhTjL8VpZ2Qd1bEDnLnRqxVQ9arzZjg3G
         jZTbPNQBThVvlK2+UksBw2JVgaT5WcPkoxvQB70wz8pIBhLFBZsmqcFenUkkmm0vf9
         ETZIuVs/JtzHvCBiSmI01weqKzDAI8H0VzASWhMr9Eu4k0McdMFhFZIYl2badc9fYp
         vGB8BVa5nP7wTRmEgY8urlofplOhceUlPCIx5ZiI71AKr9K9wjaQfrXVOkGbVjSqnE
         mOqEDfu1eacpwbMelldreAnV5jxeHvbF/zujCZ8nXigTT0AaoulF4GF6AxcqONlG9l
         JDWEoU8SL4wnw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id DD91BC009;
        Thu, 16 Jun 2022 16:11:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655388696; bh=6fLEu8wAlSIhYMNp84lmaEuPjTbe/YpTHYdRdU5qRks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WQLfbC1cYoX14kKZ3N5dB9eRYeWQUnIS8zXTCcPAcfIlZA1HuLsqHZaobqOoRfgtb
         4jh/0vpIJb3xMrkKUR5EP9ozmJgdKkscRFg9VeNVig5d0hIoGAMav0FZ7burj/mw/V
         eOT2o2qDglyUTveKwfwQZ6CICIWNX3VDUK3z7JcoCT34Kri1HL1PPuaXqAwnRVtCIg
         fk45DkIeIZJo77r02GpIfD+ndUQli8+avOcOMIhUAp7HG3L59uoMkGGS28KZqoZX+R
         ejJN8yMpxR3lnXFZVfo8r970t19z5MohR4waRc7Zfe9lVyzkxmY8gHQWTgLk9FqSxX
         ombdi8OZY+KyA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 6e9c3609;
        Thu, 16 Jun 2022 14:11:31 +0000 (UTC)
Date:   Thu, 16 Jun 2022 23:11:16 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Message-ID: <Yqs6BPVc3rNZ9byJ@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org>
 <YqiC8luskkxUftQl@codewreck.org>
 <1796737.mFSqR1lx0c@silver>
 <22073313.PYDa2UxuuP@silver>
 <Yqs1Y8G/Emi/q+S2@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yqs1Y8G/Emi/q+S2@codewreck.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dominique Martinet wrote on Thu, Jun 16, 2022 at 10:51:31PM +0900:
> > Did your patch work there for you? I mean I have not applied the other pending
> > 9p patches, but they should not really make difference, right? I won't have
> > time today, but I will continue to look at it tomorrow. If you already had
> > some thoughts on this, that would be great of course.
> 
> Yes, my version passes basic tests at least, and I could no longer
> reproduce the problem.

For what it's worth I've also tested a version of your patch:

-----
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index a8f512b44a85..d0833fa69faf 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -58,8 +58,21 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
  */
 static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
+	struct inode *inode = file_inode(file);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 	struct p9_fid *fid = file->private_data;
 
+	BUG_ON(!fid);
+
+	/* we might need to read from a fid that was opened write-only
+	 * for read-modify-write of page cache, use the writeback fid
+	 * for that */
+	if (rreq->origin == NETFS_READ_FOR_WRITE &&
+			(fid->mode & O_ACCMODE) == O_WRONLY) {
+		fid = v9inode->writeback_fid;
+		BUG_ON(!fid);
+	}
+
 	refcount_inc(&fid->count);
 	rreq->netfs_priv = fid;
 	return 0;
-----

And this also seems to work alright.

I was about to ask why the original code did writes with the writeback
fid, but I'm noticing now the current code still does (through
v9fs_vfs_write_folio_locked()), so that part hasn't changed from the old
code, and init_request will only be getting reads? Which actually makes
sense now I'm thinking about it because I recall David saying he's
working on netfs writes now...

So that minimal version is probably what we want, give or take style
adjustments (only initializing inode/v9inode in the if case or not) -- I
sure hope compilers optimizes it away when not needed.


I'll let you test one or both versions and will fixup the commit message
again/credit you/resend if we go with this version, unless you want to
send it.

--
Dominique
