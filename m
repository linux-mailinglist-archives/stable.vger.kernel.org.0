Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A423E65D6C3
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjADPCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjADPCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:02:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7314EE37
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:02:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84AD261738
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A3EC433F2;
        Wed,  4 Jan 2023 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844554;
        bh=C5gwNusuirKUXDR+y8F9lWVUfPlC+DkN/1hxlxFe3LQ=;
        h=Subject:To:Cc:From:Date:From;
        b=XD+q5Ld+4+xW1B4phicgBwgoBLk/EvWS5p1aptseQWzytcCpkF+6hJaDBLqULFrz+
         lkPKpH+EG9iMiA+7CpsQR31tZpOGa+XZ8xOKvPyIeZNP4FvsG/r2kM7jKv/ZRBecXj
         /Y3b2Ij6kOEqJ7bYun1qS5URAg8R0mPD/vTfz8Cc=
Subject: FAILED: patch "[PATCH] ext4: fix leaking uninitialized memory in fast-commit journal" failed to apply to 5.10-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:02:01 +0100
Message-ID: <167284452161163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

594bc43b4103 ("ext4: fix leaking uninitialized memory in fast-commit journal")
e9f53353e166 ("ext4: remove expensive flush on fast commit")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 594bc43b410316d70bb42aeff168837888d96810 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Sun, 6 Nov 2022 14:48:37 -0800
Subject: [PATCH] ext4: fix leaking uninitialized memory in fast-commit journal

When space at the end of fast-commit journal blocks is unused, make sure
to zero it out so that uninitialized memory is not leaked to disk.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-4-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index da0c8228cf9c..1e8be0554239 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -737,6 +737,9 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
 	if (pad_len > 0)
 		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+	/* Don't leak uninitialized memory in the unused last byte. */
+	*((u8 *)(tl + 1) + pad_len) = 0;
+
 	ext4_fc_submit_bh(sb, false);
 
 	ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
@@ -793,6 +796,8 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	dst += sizeof(tail.fc_tid);
 	tail.fc_crc = cpu_to_le32(crc);
 	ext4_fc_memcpy(sb, dst, &tail.fc_crc, sizeof(tail.fc_crc), NULL);
+	dst += sizeof(tail.fc_crc);
+	memset(dst, 0, bsize - off); /* Don't leak uninitialized memory. */
 
 	ext4_fc_submit_bh(sb, true);
 

