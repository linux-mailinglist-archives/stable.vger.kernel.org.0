Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB17B53F3EF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbiFGCcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiFGCcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:32:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8B28B09E;
        Mon,  6 Jun 2022 19:32:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B4C1B1F897;
        Tue,  7 Jun 2022 02:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654569124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rhZkitHnB5DxIbB2/J9K3uC95LKNlO8QwCZwYobee2g=;
        b=LUUVPpHFZ/REReA82XLsZscvXQ6mNNwt6P2XzAtSOjIRWsJIDYVnJuzntkfZdDYZ4FEpgN
        Lx9PqdTKyAUsj/i3/4PeyrSfVubQ3fQpyiuGgr5I2B3GUumVztuAjNo/St5aYa6f1gwUaG
        DXDeMNgHlCNxX3Kw1edm+r4pxeeM4+c=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D078A13A15;
        Tue,  7 Jun 2022 02:32:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fGxHJqO4nmJ8KQAAMHmgww
        (envelope-from <wqu@suse.com>); Tue, 07 Jun 2022 02:32:03 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: reject log replay if there is unsupported RO flag
Date:   Tue,  7 Jun 2022 10:31:46 +0800
Message-Id: <429396b1039ec416504bc2bffca36d66ec8b52e2.1654569076.git.wqu@suse.com>
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
If we have a btrfs image with dirty log, along with an unsupported RO
compatible flag:

log_root		30474240
...
compat_flags		0x0
compat_ro_flags		0x40000003
			( FREE_SPACE_TREE |
			  FREE_SPACE_TREE_VALID |
			  unknown flag: 0x40000000 )

Then even if we can only mount it RO, we will still cause metadata
update for log replay:

 BTRFS info (device dm-1): flagging fs with big metadata feature
 BTRFS info (device dm-1): using free space tree
 BTRFS info (device dm-1): has skinny extents
 BTRFS info (device dm-1): start tree-log replay

This is definitely against RO compact flag requirement.

[CAUSE]
RO compact flag only forces us to do RO mount, but we will still do log
replay for plain RO mount.

Thus this will result us to do log replay and update metadata.

This can be very problematic for new RO compat flag, for example older
kernel can not understand v2 cache, and if we allow metadata update on
RO mount and invalidate/corrupt v2 cache.

[FIX]
Just set the nologreplay flag if there is any unsupported RO compact
flag.

This will reject log replay no matter if we have dirty log or not, with
the following message:

 BTRFS info (device dm-1): disabling log replay due to unsupported ro compat features

Cc: stable@vger.kernel.org #4.9+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fe309db9f5ff..d06f1a176b5b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3655,6 +3655,14 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		err = -EINVAL;
 		goto fail_alloc;
 	}
+	/*
+	 * We have unsupported RO compat features, although RO mounted, we
+	 * should any metadata write, including the log replay.
+	 * Or we can screw up whatever the new feature requires.
+	 */
+	if (features)
+		btrfs_set_and_info(fs_info, NOLOGREPLAY,
+		"disabling log replay due to unsupported ro compat features");
 
 	if (sectorsize < PAGE_SIZE) {
 		struct btrfs_subpage_info *subpage_info;
-- 
2.36.1

