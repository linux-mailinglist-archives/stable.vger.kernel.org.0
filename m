Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F0954EC40
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 23:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379099AbiFPVKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 17:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379098AbiFPVKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 17:10:47 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EF060BB4;
        Thu, 16 Jun 2022 14:10:46 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 16C50C009; Thu, 16 Jun 2022 23:10:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655413845; bh=VbuObtaq/Xj/9czX/5l9zKA6V33YfeHnptJycN7lX/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9YjB7axwSR9K81mBACZ3+xb0RqogmbKoz1Zarpo4jnfhdMd9+hknehWfSnusNzJs
         hy23z8e0asKymmHwDcXWZSFGoGqtVHNpPQqM1G462vvXFuyl2OCVq0KqiiZoHQjA/H
         b1gjHYR6xSSnv3dRAcjGV7L4QcsWzChrczmvihwcF/iobah9gVlkCZ7o7vzZu3RtT7
         kET1Z/JzV/KtORxSl0Ht50JO+c6bIyTjP7nWZP7vfFxM2ZHqaHN+gcW+jijVkmUSrW
         wsQI/iOdjpQon262la6/V3oZ+BXXFBNGIOaInOVbrqN8ijTRk+xOIv3Eewg5B/fvjj
         4TbUUxjJUDAGA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id CF64FC009;
        Thu, 16 Jun 2022 23:10:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655413844; bh=VbuObtaq/Xj/9czX/5l9zKA6V33YfeHnptJycN7lX/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2KiccZzHDi58sq19Fwuhtd4F403cMuN761fHNRg6hXigyHJboAPQwI7O5x1Z57UD
         D482Mur4sR6jjYakgtPMy9x0gOo5/0MQE4Xtyuy44OkR4yoCQtfiPEW6nsCmezVava
         RSCnUln2Y3AWxesnZNdwZ9/nBXw6OSMaq3VD4SpeC1Xg4nhkvVAgYwM26ASA4QoeMD
         K3OF0O/rH+ecN2JX8/Stp2tEOLkn5Fio0zhENLij0B2lmyDViQomBn/tjqLs4PDMiv
         5zumaGfcJ94Ui6CUFXhzTlI0TjDNEEggruBpFXNlnWtx5GeqChYv/OtH4wT/jnka7o
         /axCjbS7g3ivQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id ca77515f;
        Thu, 16 Jun 2022 21:10:39 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Howells <dhowells@redhat.com>
Cc:     stable@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] 9p: fix EBADF errors in cached mode
Date:   Fri, 17 Jun 2022 06:10:25 +0900
Message-Id: <20220616211025.1790171-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <15767273.MGizftpLG7@silver>
References: <15767273.MGizftpLG7@silver>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cached operations sometimes need to do invalid operations (e.g. read
on a write only file)
Historic fscache had added a "writeback fid", a special handle opened
RW as root, for this. The conversion to new fscache missed that bit.

This commit reinstates a slightly lesser variant of the original code
that uses the writeback fid for partial pages backfills if the regular
user fid had been open as WRONLY, and thus would lack read permissions.

Link: https://lkml.kernel.org/r/20220614033802.1606738-1-asmadeus@codewreck.org
Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads and caching")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Reported-By: Christian Schoenebeck <linux_oss@crudebyte.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Tested-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
v3: use the least permissive version of the patch that only uses
writeback fid when really required

If no problem shows up by then I'll post this patch around Wed 23 (next
week) with the other stable fixes.

 fs/9p/vfs_addr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

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
-- 
2.35.1

