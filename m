Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C434591E7D
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 07:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiHNFkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 01:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiHNFkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 01:40:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82AF33432;
        Sat, 13 Aug 2022 22:40:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7195C60217;
        Sun, 14 Aug 2022 05:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660455601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=CEjboMcdqsMdJyrDKToa7VObRYscq/R9KI6TJJDGEqk=;
        b=n6kAIleK5B1SbnlSA+KrB3OEH8k+CMa2NCBwA8dUyWG8+Lk4WNVVPrSlaeDga6tEmBdsTB
        9yV0PQDuW9zd3/rQQ3gNTtbDa5OWMv6QQhS8iVI/z0RqZQ7H4en33cAsf2yboG4PwsFMbC
        m/mC8caSz3k6/EyT2fZ6/OSXg1zadiY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 485DC13305;
        Sun, 14 Aug 2022 05:40:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /t/PA7CK+GI3CgAAMHmgww
        (envelope-from <wqu@suse.com>); Sun, 14 Aug 2022 05:40:00 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE v5.10] btrfs: reject log replay if there is unsupported RO compat flag
Date:   Sun, 14 Aug 2022 13:39:42 +0800
Message-Id: <08ae6c89c11423933bb95bc04f603bdcbb9afc87.1660455547.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.1
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

commit dc4d31684974d140250f3ee612c3f0cab13b3146 upstream.

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
Just reject the mount unless rescue=nologreplay is provided:

  BTRFS error (device dm-1): cannot replay dirty log with unsupport optional features (0x40000000), try rescue=nologreplay instead

We don't want to set rescue=nologreply directly, as this would make the
end user to read the old data, and cause confusion.

Since the such case is really rare, we're mostly fine to just reject the
mount with an error message, which also includes the proper workaround.

CC: stable@vger.kernel.org #5.10
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 35acdab56a1c..2c7e50980a70 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3104,6 +3104,20 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		err = -EINVAL;
 		goto fail_alloc;
 	}
+	/*
+	 * We have unsupported RO compat features, although RO mounted, we
+	 * should not cause any metadata write, including log replay.
+	 * Or we could screw up whatever the new feature requires.
+	 */
+	if (unlikely(features && btrfs_super_log_root(disk_super) &&
+		     !btrfs_test_opt(fs_info, NOLOGREPLAY))) {
+		btrfs_err(fs_info,
+"cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
+			  features);
+		err = -EINVAL;
+		goto fail_alloc;
+	}
+
 
 	ret = btrfs_init_workqueues(fs_info, fs_devices);
 	if (ret) {
-- 
2.37.1

