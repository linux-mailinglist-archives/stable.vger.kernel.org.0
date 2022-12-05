Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BB9643461
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiLETqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbiLETpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:45:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106692D75A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:42:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 874C6B811CF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47CAC433C1;
        Mon,  5 Dec 2022 19:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269335;
        bh=S+mJVPtqd+RyWTkOJN/UoNmh4qeQeVppC5hhqKOW9AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOTkWC7+iULq43KxBNXm4mnE8SVTOLd9iMRMLFwCWsIFZIKFrd5R+L3mQyx/ap/T6
         bXkuZvwNj2o9qYIO3uUvwuhG6P+M2PiVC9ghvIFaNS/L3KlEVCM6D6CNm9kaqaO9kV
         /v4nwFvUcEprAvL620KOKSvZY9JFbBwy5W7wJuqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengfei Xu <pengfei.xu@intel.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+462da39f0667b357c4b6@syzkaller.appspotmail.com
Subject: [PATCH 5.4 082/153] fuse: lock inode unconditionally in fuse_fallocate()
Date:   Mon,  5 Dec 2022 20:10:06 +0100
Message-Id: <20221205190811.076299662@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 44361e8cf9ddb23f17bdcc40ca944abf32e83e79 upstream.

file_modified() must be called with inode lock held.  fuse_fallocate()
didn't lock the inode in case of just FALLOC_KEEP_SIZE flags value, which
resulted in a kernel Warning in notify_change().

Lock the inode unconditionally, like all other fallocate implementations
do.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Reported-and-tested-by: syzbot+462da39f0667b357c4b6@syzkaller.appspotmail.com
Fixes: 4a6f278d4827 ("fuse: add file_modified() to fallocate")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3212,24 +3212,19 @@ static long fuse_file_fallocate(struct f
 		.mode = mode
 	};
 	int err;
-	bool lock_inode = !(mode & FALLOC_FL_KEEP_SIZE) ||
-			   (mode & FALLOC_FL_PUNCH_HOLE);
-
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
 	if (fc->no_fallocate)
 		return -EOPNOTSUPP;
 
-	if (lock_inode) {
-		inode_lock(inode);
-		if (mode & FALLOC_FL_PUNCH_HOLE) {
-			loff_t endbyte = offset + length - 1;
-
-			err = fuse_writeback_range(inode, offset, endbyte);
-			if (err)
-				goto out;
-		}
+	inode_lock(inode);
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		loff_t endbyte = offset + length - 1;
+
+		err = fuse_writeback_range(inode, offset, endbyte);
+		if (err)
+			goto out;
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
@@ -3276,8 +3271,7 @@ out:
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
-	if (lock_inode)
-		inode_unlock(inode);
+	inode_unlock(inode);
 
 	return err;
 }


