Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75A55407E7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347784AbiFGRw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349761AbiFGRvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4006013C4F9;
        Tue,  7 Jun 2022 10:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D432FB80B66;
        Tue,  7 Jun 2022 17:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C61BC385A5;
        Tue,  7 Jun 2022 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623532;
        bh=tSC+E6Ip0e3nHbhE+0OYcMB4fRbht580sqkCUlEtkZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFfZEYPilumljv/sU9D5rl5Q9EO05aSv9RdK0yvmPcOAD4/kM2gG8hJYYyBfJastY
         A43EQ8nCk4NVGLUNTqrbe2ltFrc7OoyDt48vJMA/2BY3ZaY2IewBxk9rZ5tGcjxcgp
         ZBvEjvebcimx2FkiU6Vp/hfvTlYQAsT6tI3bvsnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 451/452] ext4: only allow test_dummy_encryption when supported
Date:   Tue,  7 Jun 2022 19:05:08 +0200
Message-Id: <20220607164922.010945458@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 5f41fdaea63ddf96d921ab36b2af4a90ccdb5744 upstream.

Make the test_dummy_encryption mount option require that the encrypt
feature flag be already enabled on the filesystem, rather than
automatically enabling it.  Practically, this means that "-O encrypt"
will need to be included in MKFS_OPTIONS when running xfstests with the
test_dummy_encryption mount option.  (ext4/053 also needs an update.)

Moreover, as long as the preconditions for test_dummy_encryption are
being tightened anyway, take the opportunity to start rejecting it when
!CONFIG_FS_ENCRYPTION rather than ignoring it.

The motivation for requiring the encrypt feature flag is that:

- Having the filesystem auto-enable feature flags is problematic, as it
  bypasses the usual sanity checks.  The specific issue which came up
  recently is that in kernel versions where ext4 supports casefold but
  not encrypt+casefold (v5.1 through v5.10), the kernel will happily add
  the encrypt flag to a filesystem that has the casefold flag, making it
  unmountable -- but only for subsequent mounts, not the initial one.
  This confused the casefold support detection in xfstests, causing
  generic/556 to fail rather than be skipped.

- The xfstests-bld test runners (kvm-xfstests et al.) already use the
  required mkfs flag, so they will not be affected by this change.  Only
  users of test_dummy_encryption alone will be affected.  But, this
  option has always been for testing only, so it should be fine to
  require that the few users of this option update their test scripts.

- f2fs already requires it (for its equivalent feature flag).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Link: https://lore.kernel.org/r/20220519204437.61645-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h  |    6 ------
 fs/ext4/super.c |   18 ++++++++++--------
 2 files changed, 10 insertions(+), 14 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1419,12 +1419,6 @@ struct ext4_super_block {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_FS_ENCRYPTION
-#define DUMMY_ENCRYPTION_ENABLED(sbi) ((sbi)->s_dummy_enc_policy.policy != NULL)
-#else
-#define DUMMY_ENCRYPTION_ENABLED(sbi) (0)
-#endif
-
 /* Number of quota types we support */
 #define EXT4_MAXQUOTAS 3
 
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2084,6 +2084,12 @@ static int ext4_set_test_dummy_encryptio
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int err;
 
+	if (!ext4_has_feature_encrypt(sb)) {
+		ext4_msg(sb, KERN_WARNING,
+			 "test_dummy_encryption requires encrypt feature");
+		return -1;
+	}
+
 	/*
 	 * This mount option is just for testing, and it's not worthwhile to
 	 * implement the extra complexity (e.g. RCU protection) that would be
@@ -2111,11 +2117,13 @@ static int ext4_set_test_dummy_encryptio
 		return -1;
 	}
 	ext4_msg(sb, KERN_WARNING, "Test dummy encryption mode enabled");
+	return 1;
 #else
 	ext4_msg(sb, KERN_WARNING,
-		 "Test dummy encryption mount option ignored");
+		 "test_dummy_encryption option not supported");
+	return -1;
+
 #endif
-	return 1;
 }
 
 static int handle_mount_opt(struct super_block *sb, char *opt, int token,
@@ -4929,12 +4937,6 @@ no_journal:
 		goto failed_mount_wq;
 	}
 
-	if (DUMMY_ENCRYPTION_ENABLED(sbi) && !sb_rdonly(sb) &&
-	    !ext4_has_feature_encrypt(sb)) {
-		ext4_set_feature_encrypt(sb);
-		ext4_commit_super(sb, 1);
-	}
-
 	/*
 	 * Get the # of file system overhead blocks from the
 	 * superblock if present.


