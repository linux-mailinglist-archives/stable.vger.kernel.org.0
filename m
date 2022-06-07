Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A0E541684
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376916AbiFGUxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376912AbiFGUtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:49:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E3E1F77C3;
        Tue,  7 Jun 2022 11:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160F7612F2;
        Tue,  7 Jun 2022 18:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CE6C385A2;
        Tue,  7 Jun 2022 18:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627176;
        bh=CE9fNNcldNDuuD0Cqy824P8Phcg5NsT9JARyufuV3vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nThiGnTLpVK1M5ClnjXONw0v4YaZhP6fBwsNdBLzY+sxnI8BFlbUAV8UTYvWBPUAc
         LOMapejBwme0URouPZyjd1YBKtghw1AJNeLPNQyiX4VzxDrf7MfLz/DzYZa0bc8VXQ
         vtxuatt3ec6ufPlsgBGMpLvRsVedDO/A0D+U4x1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>,
        syzbot+c7358a3cd05ee786eb31@syzkaller.appspotmail.com
Subject: [PATCH 5.17 643/772] ext4: filter out EXT4_FC_REPLAY from on-disk superblock field s_state
Date:   Tue,  7 Jun 2022 19:03:55 +0200
Message-Id: <20220607165008.014707886@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit c878bea3c9d724ddfa05a813f30de3d25a0ba83f upstream.

The EXT4_FC_REPLAY bit in sbi->s_mount_state is used to indicate that
we are in the middle of replay the fast commit journal.  This was
actually a mistake, since the sbi->s_mount_info is initialized from
es->s_state.  Arguably s_mount_state is misleadingly named, but the
name is historical --- s_mount_state and s_state dates back to ext2.

What should have been used is the ext4_{set,clear,test}_mount_flag()
inline functions, which sets EXT4_MF_* bits in sbi->s_mount_flags.

The problem with using EXT4_FC_REPLAY is that a maliciously corrupted
superblock could result in EXT4_FC_REPLAY getting set in
s_mount_state.  This bypasses some sanity checks, and this can trigger
a BUG() in ext4_es_cache_extent().  As a easy-to-backport-fix, filter
out the EXT4_FC_REPLAY bit for now.  We should eventually transition
away from EXT4_FC_REPLAY to something like EXT4_MF_REPLAY.

Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20220420192312.1655305-1-phind.uet@gmail.com
Link: https://lore.kernel.org/r/20220517174028.942119-1-tytso@mit.edu
Reported-by: syzbot+c7358a3cd05ee786eb31@syzkaller.appspotmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4874,7 +4874,7 @@ static int __ext4_fill_super(struct fs_c
 					sbi->s_inodes_per_block;
 	sbi->s_desc_per_block = blocksize / EXT4_DESC_SIZE(sb);
 	sbi->s_sbh = bh;
-	sbi->s_mount_state = le16_to_cpu(es->s_state);
+	sbi->s_mount_state = le16_to_cpu(es->s_state) & ~EXT4_FC_REPLAY;
 	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
 
@@ -6437,7 +6437,8 @@ static int __ext4_remount(struct fs_cont
 				if (err)
 					goto restore_opts;
 			}
-			sbi->s_mount_state = le16_to_cpu(es->s_state);
+			sbi->s_mount_state = (le16_to_cpu(es->s_state) &
+					      ~EXT4_FC_REPLAY);
 
 			err = ext4_setup_super(sb, es, 0);
 			if (err)


