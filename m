Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C249F6D8E96
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 07:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjDFFA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 01:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjDFFA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 01:00:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DFF8A54;
        Wed,  5 Apr 2023 22:00:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EFA102284C;
        Thu,  6 Apr 2023 05:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680757252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kWDJgouJrvhYF7FEYgGshtSNFA53LMk9113xz1L11q0=;
        b=TiiLdTYer6A8sN8zDAJ4Y+rmNNeodhzAGTNxx2CRiakSOvyYXPi2ic/e7fJq+4/m5Cvil+
        AYwUHv5LhVDwLZBwJjhqlWK2iZLb9ByQdD2a4DL3tLF/3e2Vg+I5IzNRB8cp5ouCrNgjHy
        a22H4Lpto8MPZyJdR+Bu2J+QtAUJfHQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 295521351F;
        Thu,  6 Apr 2023 05:00:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RXKvOQNSLmS7AQAAMHmgww
        (envelope-from <wqu@suse.com>); Thu, 06 Apr 2023 05:00:51 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: scrub: reject unsupported scrub flags
Date:   Thu,  6 Apr 2023 13:00:34 +0800
Message-Id: <df2418c0b26dc12913d5f542caf977bc3d1f28b2.1680757087.git.wqu@suse.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the introduction of scrub interface, the only flag that we support
is BTRFS_SCRUB_READONLY.

Thus there is no sanity checks, if there are some undefined flags passed
in, we just ignore them.

This is problematic if we want to introduce new scrub flags, as we have
no way to determine if such flags are supported.

Thus this patch would address the problem by introducing a check for the
flags, and if unsupported flags are set, return -EOPNOTSUPP to inform
the user space.

This check should be backported for all supported kernels before any new
scrub flags are introduced.

CC: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c           | 5 +++++
 include/uapi/linux/btrfs.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ba769a1eb87a..25833b4eeaf5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3161,6 +3161,11 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 	if (IS_ERR(sa))
 		return PTR_ERR(sa);
 
+	if (sa->flags & ~BTRFS_SCRUB_SUPPORTED_FLAGS) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!(sa->flags & BTRFS_SCRUB_READONLY)) {
 		ret = mnt_want_write_file(file);
 		if (ret)
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index ada0a489bf2b..dbb8b96da50d 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -187,6 +187,7 @@ struct btrfs_scrub_progress {
 };
 
 #define BTRFS_SCRUB_READONLY	1
+#define BTRFS_SCRUB_SUPPORTED_FLAGS	(BTRFS_SCRUB_READONLY)
 struct btrfs_ioctl_scrub_args {
 	__u64 devid;				/* in */
 	__u64 start;				/* in */
-- 
2.39.2

