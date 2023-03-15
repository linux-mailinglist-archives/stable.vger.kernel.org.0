Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D08A6BB00B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjCOMOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjCOMOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2999428D3A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:14:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5CD861D13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5A6C4339B;
        Wed, 15 Mar 2023 12:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882483;
        bh=D3w6n1oTaSe4BzgFAoJ9kH8EpOdd4Y4EGOE4ooM4BY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUMZQx6VhjCHxd1+2SGtiWymfH0K8kEHNjiVhcVNMDBWg5RxNRYgtZu8cjq3My69H
         qro0RzIUEz7PaDHalmpkZGftPU2cMf/ETq3+Y+i0ZchyPZgQ4P93eT08EE9EtKRDAA
         n/xnYlQ9XuvhIyWlsb1EuQxazYbKAfkBCOD0XJ04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Eric Whitney <enwlinux@gmail.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 03/21] ext4: fix RENAME_WHITEOUT handling for inline directories
Date:   Wed, 15 Mar 2023 13:12:26 +0100
Message-Id: <20230315115718.949678470@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115718.796692048@linuxfoundation.org>
References: <20230315115718.796692048@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -1425,11 +1425,10 @@ static struct buffer_head * ext4_find_en
 		int has_inline_data = 1;
 		ret = ext4_find_inline_entry(dir, &fname, res_dir,
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
@@ -3520,7 +3519,8 @@ static void ext4_resetent(handle_t *hand
 	 * so the old->de may no longer valid and need to find it again
 	 * before reset old inode info.
 	 */
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		retval = PTR_ERR(old.bh);
 	if (!old.bh)
@@ -3688,7 +3688,8 @@ static int ext4_rename(struct inode *old
 			return retval;
 	}
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		return PTR_ERR(old.bh);
 	/*


