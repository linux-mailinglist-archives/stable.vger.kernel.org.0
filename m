Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B9C54A793
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiFNDid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiFNDic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:38:32 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA3633A26;
        Mon, 13 Jun 2022 20:38:30 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3AC0AC01E; Tue, 14 Jun 2022 05:38:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655177908; bh=SKBy3DKVfNlrFaCP/8Dtym1Pjl7YP37RHZXiwxzpYsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap0gj6B48RZcKFFmxmYZC0AquDtakpRgEkSaw8sKkeMA3q5n6pMpG8ahdr2+jzl05
         UJi5LgcfpbwVnjDlIJgwkcpdidczMBWgQnavTF1U3PU+7zqC4PHgY1MdSqtTu+c/mI
         8Qx5GyYnRKFXdWIfPjSlk/osSNQw6L4kIyy8lXCTd73dAVUwCqJEfd2aWbShrOeVOl
         tZ9hFnPwydpwi1ihNLQd+oOjJVRgR27NEtZ+fCVkAJuySJ+L4vZcrswQovm1pGv5BE
         EBfwiN4XuY05cEdQ/NhT/Rhww/pbAND0kO1YUJeFKH3EnVnIqbHrTLwy/4gn1rk59r
         SDt5O0vV+JKjQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7CF18C009;
        Tue, 14 Jun 2022 05:38:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655177907; bh=SKBy3DKVfNlrFaCP/8Dtym1Pjl7YP37RHZXiwxzpYsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=28IXVq3l+ga1y/wE2URuxUhvPUE05ceTmaL7GDy231Ox0OX29px9rKrgeAi0HEJrz
         LQf4YfbacEydU9Ehx5Zq/FxHBNJb2zzS4f/7MyDDDhw0W+Geo3xygAuYnq36sy6lyE
         xZYwhxZXL/0sflI9HyADExseimgbP3zLrkNZls2HWSSSPbxnOQJo5Cwfgr+DymwmCw
         WVltr+R41SQlJlT8RmZXVrzexkVV/eM5ogjCjEesIXrhnzav9x3G3TjzH4WwUloyL2
         hwc9F6HWr64h1I+HtktO5RfygwDanmOZZ0UTff4T8G3+iq8TJ3kTI/e7fFWV+AsHkZ
         okHgqLmj0YE2A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id a34bb87f;
        Tue, 14 Jun 2022 03:38:18 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Howells <dhowells@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: fix EBADF errors in cached mode
Date:   Tue, 14 Jun 2022 12:38:02 +0900
Message-Id: <20220614033802.1606738-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <YqW5s+GQZwZ/DP5q@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org>
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

Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads and caching")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Reported-By: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
Ok so finally had time to look at this, and it's not a lot so this is
the most straight forward way to do: just reverting to how the old
fscache worked.

This appears to work from quick testing, Chiristian could you test it?

I think the warnings you added in p9_client_read/write that check
fid->mode might a lot of sense, if you care to resend it as
WARN_ON((fid->mode & ACCMODE) == O_xyz);
instead I'll queue that for 5.20


@Stable people, I've checked it applies to 5.17 and 5.18 so should be
good to grab once I submit it for inclusion (that commit was included in
5.16, which is no longer stable)


 fs/9p/vfs_addr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 7382c5227e94..262968d02f55 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -58,7 +58,11 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
  */
 static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
-	struct p9_fid *fid = file->private_data;
+	struct inode *inode = file_inode(file);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+	struct p9_fid *fid = v9inode->writeback_fid;
+
+	BUG_ON(!fid);
 
 	p9_fid_get(fid);
 	rreq->netfs_priv = fid;
-- 
2.35.1

