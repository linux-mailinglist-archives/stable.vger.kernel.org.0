Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6496858D30F
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 07:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiHIFCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 01:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiHIFCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 01:02:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CEB1DA61;
        Mon,  8 Aug 2022 22:02:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 86F2A34826;
        Tue,  9 Aug 2022 05:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660021357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzuKjwsM7mL/RWMKbmyd6R2lSLhZ3tGwGd+bajpWDkY=;
        b=j7/lMetc4hpV6/BtMuRB9pil7QZfppzRySS4saEgfIFdgpUZzxf42ug1Suyr45OxeMJ7YI
        JsYBiDFwNjzIYfrGNVhcilokmvk4CBqlMBl/Cr/h3Z6XlXS3VhA2L1GXAX78YIqH9tPMRy
        CGG4zCA3YLslaDOUl/RUUq+glwAKN3A=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C2FF413A9D;
        Tue,  9 Aug 2022 05:02:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2JO/JGzq8WKaPwAAMHmgww
        (envelope-from <wqu@suse.com>); Tue, 09 Aug 2022 05:02:36 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v3 1/3] btrfs: enhance unsupported compat RO flags handling
Date:   Tue,  9 Aug 2022 13:02:16 +0800
Message-Id: <1b3011f4b1bf4e60479568fcd3e090ea8b68d253.1660021230.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660021230.git.wqu@suse.com>
References: <cover.1660021230.git.wqu@suse.com>
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

Currently there are two corner cases not handling compat RO flags
correctly:

- Remount
  We can still mount the fs RO with compat RO flags, then remount it RW.
  We should not allow any write into a fs with unsupported RO flags.

- Still try to search block group items
  In fact, behavior/on-disk format change to extent tree should not
  need a full incompat flag.

  And since we can ensure fs with unsupported RO flags never got any
  writes (with above case fixed), then we can even skip block group
  items search at mount time.

This patch will enhance the unsupported RO compat flags by:

- Reject RW remount if there is unsupported RO compat flags

- Go dummy block group items directly for unsupported RO compat flags
  In fact, only changes to chunk/subvolume/root/csum trees should go
  incompat flags.

The latter part should allow future change to extent tree to be compat
RO flags.

Thus this patch also needs to be backported to all stable trees.

Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c | 11 ++++++++++-
 fs/btrfs/super.c       |  9 +++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 38a740d5297c..4a78136bcd17 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2186,7 +2186,16 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	int need_clear = 0;
 	u64 cache_gen;
 
-	if (!root)
+	/*
+	 * Either no extent root (with ibadroots rescue option) or we have
+	 * unsupporter RO options. The fs can never be mounted RW, so no
+	 * need to waste time search block group items.
+	 *
+	 * This also allows new extent tree related changes to be RO compat,
+	 * no need for a full incompat flag.
+	 */
+	if (!root || (btrfs_super_compat_ro_flags(info->super_copy) &
+		      ~BTRFS_FEATURE_COMPAT_RO_SUPP))
 		return fill_dummy_bgs(info);
 
 	key.objectid = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4c7089b1681b..7d3213e67fb5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2110,6 +2110,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			ret = -EINVAL;
 			goto restore;
 		}
+		if (btrfs_super_compat_ro_flags(fs_info->super_copy) &
+		    ~BTRFS_FEATURE_COMPAT_RO_SUPP) {
+			btrfs_err(fs_info,
+		"can not remount read-write due to unsupported optional flags 0x%llx",
+				btrfs_super_compat_ro_flags(fs_info->super_copy) &
+				~BTRFS_FEATURE_COMPAT_RO_SUPP);
+			ret = -EINVAL;
+			goto restore;
+		}
 		if (fs_info->fs_devices->rw_devices == 0) {
 			ret = -EACCES;
 			goto restore;
-- 
2.37.0

