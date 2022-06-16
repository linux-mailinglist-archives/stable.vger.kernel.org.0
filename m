Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C038754E285
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377245AbiFPNxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiFPNxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:53:10 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4916318B0A;
        Thu, 16 Jun 2022 06:53:09 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D7F94C01A; Thu, 16 Jun 2022 15:53:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655387587; bh=4nSqo7I8x65gGtDiG32GUmCNchdtE9/QOARXVTfLdiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k57/XhKo9tUpFUuhpqwOCB2RHT9tUhhu1njN/0NozwWeiiH9fwY2+RqkXV/FMJHZU
         SmNekz5eNPwo4uGG6kdWjgU02Y1OVG9UFahh2hVF8RqPYS+wUt7o/TK9vJ4QI8p8Wt
         ZzNgqSeQTuRHS5JHdP+VHnrCaXYhFlM5R3us/KNUV7wRfjtuh/n1rdaMe5qBp26wdG
         LXkq3z7CkGFmdBwtX4wfomHMj0+MJfqwXzgbCS3mx+l5wQJsvRBrw7MvmI6IOfhhcA
         eHjwjRzWo6Hoxwg3obreXpJjht2BsAHkSFvesMtJ8RF6Y1o4h3hr3N9tQdCovAm4Qz
         xHvdHRH871/Ag==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 9ACA0C009;
        Thu, 16 Jun 2022 15:53:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655387587; bh=4nSqo7I8x65gGtDiG32GUmCNchdtE9/QOARXVTfLdiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k57/XhKo9tUpFUuhpqwOCB2RHT9tUhhu1njN/0NozwWeiiH9fwY2+RqkXV/FMJHZU
         SmNekz5eNPwo4uGG6kdWjgU02Y1OVG9UFahh2hVF8RqPYS+wUt7o/TK9vJ4QI8p8Wt
         ZzNgqSeQTuRHS5JHdP+VHnrCaXYhFlM5R3us/KNUV7wRfjtuh/n1rdaMe5qBp26wdG
         LXkq3z7CkGFmdBwtX4wfomHMj0+MJfqwXzgbCS3mx+l5wQJsvRBrw7MvmI6IOfhhcA
         eHjwjRzWo6Hoxwg3obreXpJjht2BsAHkSFvesMtJ8RF6Y1o4h3hr3N9tQdCovAm4Qz
         xHvdHRH871/Ag==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 20e706e1;
        Thu, 16 Jun 2022 13:53:02 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Howells <dhowells@redhat.com>
Cc:     stable@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] 9p: fix EBADF errors in cached mode
Date:   Thu, 16 Jun 2022 22:52:55 +0900
Message-Id: <20220616135256.1787252-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <22073313.PYDa2UxuuP@silver>
References: <22073313.PYDa2UxuuP@silver>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cached operations sometimes need to do invalid operations (e.g. read
on a write only file)
Historic fscache had added a "writeback fid" for this, but the conversion
to new fscache somehow lost usage of it: use the writeback fid instead
of normal one.

Note that the way this works (writeback fid being linked to inode) means
we might use overprivileged fid for some operations, e.g. write as root
when we shouldn't.
Ideally we should keep both fids handy, and only use the writeback fid
when really required e.g. reads to a write-only file to fill in the page
cache (read-modify-write); but this is the situation we've always had
and this commit only fixes an issue we've had for too long.

Link: https://lkml.kernel.org/r/20220614033802.1606738-1-asmadeus@codewreck.org
Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads and caching")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Reported-By: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/vfs_addr.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index a8f512b44a85..7f924e671e3e 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -58,7 +58,17 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
  */
 static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
-	struct p9_fid *fid = file->private_data;
+	struct inode *inode = file_inode(file);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+	struct p9_fid *fid = v9inode->writeback_fid;
+
+	/* If there is no writeback fid this file only ever has had
+	 * read-only opens, so we can use file's fid which should
+	 * always be set instead */
+	if (!fid)
+		fid = file->private_data;
+
+	BUG_ON(!fid);
 
 	refcount_inc(&fid->count);
 	rreq->netfs_priv = fid;
-- 
2.35.1

