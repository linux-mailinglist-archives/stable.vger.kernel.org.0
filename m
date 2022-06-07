Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15CB54082E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348666AbiFGR40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348698AbiFGRy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:54:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B639144FFD;
        Tue,  7 Jun 2022 10:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACCB0B822CE;
        Tue,  7 Jun 2022 17:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247B3C34115;
        Tue,  7 Jun 2022 17:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623288;
        bh=IeaTqaLEzPlaM4RkSnKLeBGciH+Iz0ykpPXh8d68FCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8c8HqkXqWWjW1zQGh7PO3xQawNcJu+91v5vwaz3xBxkuqFOQeTBxwf9l/uEmViSA
         iA7hlpfbl27KmIwmdquA2u+liS3TwoBSENuPkXYYTFx0ptO/ZmobBEC2xcgIQoacHv
         NWcdgnSvds1Ni15MPMqnj/Fzxio1yo129+PMK5ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>,
        syzbot+c7358a3cd05ee786eb31@syzkaller.appspotmail.com
Subject: [PATCH 5.10 362/452] ext4: filter out EXT4_FC_REPLAY from on-disk superblock field s_state
Date:   Tue,  7 Jun 2022 19:03:39 +0200
Message-Id: <20220607164919.351649050@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
@@ -4538,7 +4538,7 @@ static int ext4_fill_super(struct super_
 					sbi->s_inodes_per_block;
 	sbi->s_desc_per_block = blocksize / EXT4_DESC_SIZE(sb);
 	sbi->s_sbh = bh;
-	sbi->s_mount_state = le16_to_cpu(es->s_state);
+	sbi->s_mount_state = le16_to_cpu(es->s_state) & ~EXT4_FC_REPLAY;
 	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
 
@@ -5998,7 +5998,8 @@ static int ext4_remount(struct super_blo
 				if (err)
 					goto restore_opts;
 			}
-			sbi->s_mount_state = le16_to_cpu(es->s_state);
+			sbi->s_mount_state = (le16_to_cpu(es->s_state) &
+					      ~EXT4_FC_REPLAY);
 
 			err = ext4_setup_super(sb, es, 0);
 			if (err)


