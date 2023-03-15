Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5D16BB0E0
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjCOMWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjCOMVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:21:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605DE96C06
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E87D61D13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E09CC4339B;
        Wed, 15 Mar 2023 12:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882856;
        bh=qjiLJ0Dvh7icM56S5KrPJ1kYIZkT3lghw/hSQ6GLIwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGOFbO1bx56GieG6NVnPrZdmuavcLFQzBgaPCZI/z9CZ1YdhrV0Hq1DpD3b7QOH4F
         vLaWdPcXW8XiHKpCuxP+2rOq+IwXnosv85oapG7Ho5EJ6HvprGEMDzgfQWR48cQA/+
         o+iPSu3xu2WgDcGYD0lq1Y0gmWMgX+AwPF76K0VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/104] ext4: Fix possible corruption when moving a directory
Date:   Wed, 15 Mar 2023 13:11:58 +0100
Message-Id: <20230315115733.192441180@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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

[ Upstream commit 0813299c586b175d7edb25f56412c54b812d0379 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6f335d58183ee..17590bb769147 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3923,9 +3923,16 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -4050,6 +4057,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	} else {
 		ext4_journal_stop(handle);
 	}
+	if (old.dir_bh)
+		inode_unlock(old.inode);
 release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);
-- 
2.39.2



