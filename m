Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E746AECFF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCGSAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjCGR73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:59:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36B6A6747
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:53:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 902B06150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE62C433EF;
        Tue,  7 Mar 2023 17:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211635;
        bh=Py1bmzYKjFEgUWI+o+vUve/ty30Xarky/J0VLTL8Vfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMm0frAfyTpz3/k+YNgVmx1bIUYtewnYl6tev6u0Lb79F8nDANLmzD3EqgSfdQvhx
         GCAjRj8YXKy+J6TKDK3bScFOm3jSsQYRbu5Qn8950aKzW86HNXr6PtXlhY9lxgXxW8
         eyTN62Yr04TkaSwftwipPxYJnaun8xdut59WR13Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.2 0894/1001] ext4: Fix possible corruption when moving a directory
Date:   Tue,  7 Mar 2023 18:01:06 +0100
Message-Id: <20230307170100.767585324@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 0813299c586b175d7edb25f56412c54b812d0379 upstream.

When we are renaming a directory to a different directory, we need to
update '..' entry in the moved directory. However nothing prevents moved
directory from being modified and even converted from the inline format
to the normal format. When such race happens the rename code gets
confused and we crash. Fix the problem by locking the moved directory.

CC: stable@vger.kernel.org
Fixes: 32f7f22c0b52 ("ext4: let ext4_rename handle inline dir")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230126112221.11866-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3872,9 +3872,16 @@ static int ext4_rename(struct user_names
 			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
 				goto end_rename;
 		}
+		/*
+		 * We need to protect against old.inode directory getting
+		 * converted from inline directory format into a normal one.
+		 */
+		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval)
+		if (retval) {
+			inode_unlock(old.inode);
 			goto end_rename;
+		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or
@@ -4006,6 +4013,8 @@ end_rename:
 	} else {
 		ext4_journal_stop(handle);
 	}
+	if (old.dir_bh)
+		inode_unlock(old.inode);
 release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);


