Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A8B6BB029
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCOMQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjCOMPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C60888ED7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3662461D3F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49415C433EF;
        Wed, 15 Mar 2023 12:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882540;
        bh=Yu185cZOyxNQWz7whzSmIM7buAISPTDpgoSlQOvHq1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7l1oaAa1LLFnL2V4gH3yAvZe7F5REbPcENIABsy8U0xzg0n3FjyZ6VOxWOg56dAR
         rpcEPyN7cDIkHdlgzGRqFcK1Z5vZkFB6sR4ZVmjW9MdQ4edvu7GfVkUp9p6FyGW/1l
         Bg/6AxZAj5gZ+dyNi5o/cLKvydT3aDXMxeR5IOLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Eric Whitney <enwlinux@gmail.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 03/39] ext4: fix RENAME_WHITEOUT handling for inline directories
Date:   Wed, 15 Mar 2023 13:12:17 +0100
Message-Id: <20230315115721.367887867@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
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

From: Eric Whitney <enwlinux@gmail.com>

commit c9f62c8b2dbf7240536c0cc9a4529397bb8bf38e upstream.

A significant number of xfstests can cause ext4 to log one or more
warning messages when they are run on a test file system where the
inline_data feature has been enabled.  An example:

"EXT4-fs warning (device vdc): ext4_dirblock_csum_set:425: inode
 #16385: comm fsstress: No space for directory leaf checksum. Please
run e2fsck -D."

The xfstests include: ext4/057, 058, and 307; generic/013, 051, 068,
070, 076, 078, 083, 232, 269, 270, 390, 461, 475, 476, 482, 579, 585,
589, 626, 631, and 650.

In this situation, the warning message indicates a bug in the code that
performs the RENAME_WHITEOUT operation on a directory entry that has
been stored inline.  It doesn't detect that the directory is stored
inline, and incorrectly attempts to compute a dirent block checksum on
the whiteout inode when creating it.  This attempt fails as a result
of the integrity checking in get_dirent_tail (usually due to a failure
to match the EXT4_FT_DIR_CSUM magic cookie), and the warning message
is then emitted.

Fix this by simply collecting the inlined data state at the time the
search for the source directory entry is performed.  Existing code
handles the rest, and this is sufficient to eliminate all spurious
warning messages produced by the tests above.  Go one step further
and do the same in the code that resets the source directory entry in
the event of failure.  The inlined state should be present in the
"old" struct, but given the possibility of a race there's no harm
in taking a conservative approach and getting that information again
since the directory entry is being reread anyway.

Fixes: b7ff91fd030d ("ext4: find old entry again if failed to rename whiteout")
Cc: stable@kernel.org
Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230210173244.679890-1-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1419,11 +1419,10 @@ static struct buffer_head *__ext4_find_e
 		int has_inline_data = 1;
 		ret = ext4_find_inline_entry(dir, fname, res_dir,
 					     &has_inline_data);
-		if (has_inline_data) {
-			if (inlined)
-				*inlined = 1;
+		if (inlined)
+			*inlined = has_inline_data;
+		if (has_inline_data)
 			goto cleanup_and_exit;
-		}
 	}
 
 	if ((namelen <= 2) && (name[0] == '.') &&
@@ -3515,7 +3514,8 @@ static void ext4_resetent(handle_t *hand
 	 * so the old->de may no longer valid and need to find it again
 	 * before reset old inode info.
 	 */
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		retval = PTR_ERR(old.bh);
 	if (!old.bh)
@@ -3677,7 +3677,8 @@ static int ext4_rename(struct inode *old
 			return retval;
 	}
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		return PTR_ERR(old.bh);
 	/*


