Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8A553F578
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 07:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiFGFJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 01:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiFGFJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 01:09:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C3257B1B;
        Mon,  6 Jun 2022 22:09:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 304281F9F5;
        Tue,  7 Jun 2022 05:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654578572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qDIKDtXVCYFiCnGF1nhhtRoIST5+FaaMfXvgeyMv84I=;
        b=EvWYQrCzi4tBXjVEAIKLUK5dfVHgFv9R2f6w8u/OrHhKtjgOEj+TEfnkcj0PdUq4ThXC6h
        i8kGf92DO0yh3xDk56Gm17aLyx+dOp88Hp+p4mge5KBr4O60Z+Pp1PDG9+VJzKd6ZZPplF
        B0NH3P2QAJF5WRCTn+kRnUnvw+/3jQQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4EE4F13638;
        Tue,  7 Jun 2022 05:09:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nGSCBovdnmJZUAAAMHmgww
        (envelope-from <wqu@suse.com>); Tue, 07 Jun 2022 05:09:31 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: correctly populate btrfs_super_block::log_root_transid
Date:   Tue,  7 Jun 2022 13:09:13 +0800
Message-Id: <f7ae86f509d11d941ceac2a153b38a4f3bc5d342.1654578537.git.wqu@suse.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[BUG]
After creating a dirty log tree, although
btrfs_super_block::log_root and log_root_level is correctly populated,
its generation is still left 0:

 log_root                30474240
 log_root_transid        0 <<<
 log_root_level          0

[CAUSE]
We just forgot to update btrfs_super_block::log_root_transid completely.

Thus it's always the original value (0) from the initial super block.

Thankfully this old behavior won't break log replay, as in
btrfs_read_tree(), parent generation 0 means we just skip the generation
check.

And per-root log tree is still done properly using the root generation,
so here we really only missed the generation check for log tree root,
and even we fixed it, it should not cause any compatible problem.

[FIX]
Just update btrfs_super_block::log_root_transid properly.

Cc: stable@vger.kernel.org #4.9+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-log.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 370388fadf96..27a76d6fef8c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3083,7 +3083,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct btrfs_log_ctx root_log_ctx;
 	struct blk_plug plug;
 	u64 log_root_start;
-	u64 log_root_level;
+	u64 log_root_transid;
+	u8 log_root_level;
 
 	mutex_lock(&root->log_mutex);
 	log_transid = ctx->log_transid;
@@ -3297,6 +3298,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	log_root_start = log_root_tree->node->start;
 	log_root_level = btrfs_header_level(log_root_tree->node);
+	log_root_transid = btrfs_header_generation(log_root_tree->node);
 	log_root_tree->log_transid++;
 	mutex_unlock(&log_root_tree->log_mutex);
 
@@ -3334,6 +3336,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	btrfs_set_super_log_root(fs_info->super_for_commit, log_root_start);
 	btrfs_set_super_log_root_level(fs_info->super_for_commit, log_root_level);
+	btrfs_set_super_log_root_transid(fs_info->super_for_commit, log_root_transid);
 	ret = write_all_supers(fs_info, 1);
 	mutex_unlock(&fs_info->tree_log_mutex);
 	if (ret) {
-- 
2.36.1

