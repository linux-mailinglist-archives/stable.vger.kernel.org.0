Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B1267C9BF
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 12:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbjAZLWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 06:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbjAZLWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 06:22:31 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246789013;
        Thu, 26 Jan 2023 03:22:31 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D7A541FFBB;
        Thu, 26 Jan 2023 11:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674732149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=yB3FfIu4dWsCpXF98x4AGtRjoXShmEuDW2q5TwTJLKQ=;
        b=i+15vPCY4+Efg2v8X4MjYaiKQTsKsFp0HjfZd46nXG5qPW6zP+U0z4elzbceJ0Jld6r9WQ
        eoaSPPdf7AFUWmQK7/GfQTt0jTOZ9yWBUWfNHvOCXNH25O3PphFulAJSrM0RY4GQ6gZ5eq
        zEmD9NaNikDitKzB1g44IQJmgYYMoPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674732149;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=yB3FfIu4dWsCpXF98x4AGtRjoXShmEuDW2q5TwTJLKQ=;
        b=E9GEW4wVEXB+80/P5wMXHn3qwO5RugKpcXwl/fgX6Yo33lYIBdcZNnIkIJDwXCp8K9YIW1
        aH5wWMYCKx7R8iAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC0EE139B3;
        Thu, 26 Jan 2023 11:22:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IlTJMXVi0mOtGgAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 26 Jan 2023 11:22:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 5D2A5A06B4; Thu, 26 Jan 2023 12:22:29 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] ext4: Fix possible corruption when moving a directory
Date:   Thu, 26 Jan 2023 12:22:21 +0100
Message-Id: <20230126112221.11866-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1600; i=jack@suse.cz; h=from:subject; bh=BBtklDzkyhuk9nZhBwgfsOujMuK0kpm5e60aYHGYZ58=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBj0mJn3kGxmRC7e+nneAC9bMxtlGofntiZjHcwZt5J 4/46Z+eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY9JiZwAKCRCcnaoHP2RA2QFoB/ wPKCW/39BogJ3VZoskO7j9xLtWg6QeouVXskjwewbGZot8LvnUJWY6KBnBKvhp0wy6w4oRhEJtxoVb xjh1+U/sYawIp7rmt3a3eIHaXNixML5WtpeCY7CGBG4e05qUEdHr+2ewNjLX3qrbGM9M1yb1iVvInM C2sqFLD9DyzbDiZbe3QL2xCH0aOIgw6s1u8XQj1LUlN2tEk/owyeZT0w/k/TMmRTg2FFY3eM3v/x53 09fWUWBwcHQrl8FYVm1ujwFS7uzzhWQGLFI3oV2hQorfReysLaThKO7Bi52lGWyBXHH9bpX6kQZFUL 8RYpdR/CkuDCtpP9h9wQTIY5hWLUJd
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we are renaming a directory to a different directory, we need to
update '..' entry in the moved directory. However nothing prevents moved
directory from being modified and even converted from the inline format
to the normal format. When such race happens the rename code gets
confused and we crash. Fix the problem by locking the moved directory.

CC: stable@vger.kernel.org
Fixes: 32f7f22c0b52 ("ext4: let ext4_rename handle inline dir")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index dd28453d6ea3..270fbcba75b6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3872,9 +3872,16 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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
@@ -4006,6 +4013,8 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	} else {
 		ext4_journal_stop(handle);
 	}
+	if (old.dir_bh)
+		inode_unlock(old.inode);
 release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);
-- 
2.35.3

