Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8471266CD98
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbjAPRhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjAPRhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:37:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E1649003
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:13:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A39CB8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A008CC433F1;
        Mon, 16 Jan 2023 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889224;
        bh=FmIJtGeR9JgieLoFAgEKk1hb6ZjSj20NIGhA0aFwQRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cty+lEeJAWdBGRBUU99JeCuiJCHaHL8TLNqeEyIv5seHLQruKBjvBzrQUr3W43Zhw
         0EJ6dNWGoeV1snSWCPhbPseWPv8YYc6LTZizwvZpFPS5gqqyPuzTDH/ubJVOoFfNJL
         viTBEyiosUg1MXzUkfzZlesPzVvZo/QKci/khY5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        stable@kernel.org, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 304/338] ext4: initialize quota before expanding inode in setproject ioctl
Date:   Mon, 16 Jan 2023 16:52:57 +0100
Message-Id: <20230116154834.369033250@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 1485f726c6dec1a1f85438f2962feaa3d585526f upstream.

Make sure we initialize quotas before possibly expanding inode space
(and thus maybe needing to allocate external xattr block) in
ext4_ioctl_setproject(). This prevents not accounting the necessary
block allocation.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221207115937.26601-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -390,6 +390,10 @@ static int ext4_ioctl_setproject(struct
 	if (ext4_is_quota_file(inode))
 		return err;
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
 		return err;
@@ -405,10 +409,6 @@ static int ext4_ioctl_setproject(struct
 		brelse(iloc.bh);
 	}
 
-	err = dquot_initialize(inode);
-	if (err)
-		return err;
-
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);


