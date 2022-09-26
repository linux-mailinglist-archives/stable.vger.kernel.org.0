Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8182E5EA565
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbiIZMCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239129AbiIZMAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:00:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A827C32D;
        Mon, 26 Sep 2022 03:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F202C60C94;
        Mon, 26 Sep 2022 10:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB653C433C1;
        Mon, 26 Sep 2022 10:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189509;
        bh=wKQ2OWT+iKaWQAMG/hdsCIYwXywAu5qK/bsiXG5dHtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCOz3hd19eOMl2lTfU+SVmbz9fXa/W/6lpWvSWMWcnchpTjkIoYznEUxoe8NT7izu
         FbgwM5DYl/oP55/za3pSe7vZZz/u73bczykpWCXs0LDAWEG/CGEi4cCRB4rifGKI6j
         HNWD/jhPZRh0om+Bl7/PlzcL2cb56z5+Yi+gWhMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 5.19 205/207] ext4: use locality group preallocation for small closed files
Date:   Mon, 26 Sep 2022 12:13:14 +0200
Message-Id: <20220926100815.787405954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit a9f2a2931d0e197ab28c6007966053fdababd53f upstream.

Curently we don't use any preallocation when a file is already closed
when allocating blocks (from writeback code when converting delayed
allocation). However for small files, using locality group preallocation
is actually desirable as that is not specific to a particular file.
Rather it is a method to pack small files together to reduce
fragmentation and for that the fact the file is closed is actually even
stronger hint the file would benefit from packing. So change the logic
to allow locality group preallocation in this case.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@kernel.org
Reported-and-tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/all/0d81a7c2-46b7-6010-62a4-3e6cfc1628d6@i2se.com/
Link: https://lore.kernel.org/r/20220908092136.11770-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5189,6 +5189,7 @@ static void ext4_mb_group_or_file(struct
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	int bsbits = ac->ac_sb->s_blocksize_bits;
 	loff_t size, isize;
+	bool inode_pa_eligible, group_pa_eligible;
 
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return;
@@ -5196,25 +5197,27 @@ static void ext4_mb_group_or_file(struct
 	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
 		return;
 
+	group_pa_eligible = sbi->s_mb_group_prealloc > 0;
+	inode_pa_eligible = true;
 	size = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
 	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
 		>> bsbits;
 
+	/* No point in using inode preallocation for closed files */
 	if ((size == isize) && !ext4_fs_is_busy(sbi) &&
-	    !inode_is_open_for_write(ac->ac_inode)) {
-		ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
-		return;
-	}
-
-	if (sbi->s_mb_group_prealloc <= 0) {
-		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
-		return;
-	}
+	    !inode_is_open_for_write(ac->ac_inode))
+		inode_pa_eligible = false;
 
-	/* don't use group allocation for large files */
 	size = max(size, isize);
-	if (size > sbi->s_mb_stream_request) {
-		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
+	/* Don't use group allocation for large files */
+	if (size > sbi->s_mb_stream_request)
+		group_pa_eligible = false;
+
+	if (!group_pa_eligible) {
+		if (inode_pa_eligible)
+			ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
+		else
+			ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
 		return;
 	}
 


