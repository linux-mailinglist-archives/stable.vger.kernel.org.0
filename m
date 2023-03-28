Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD896CBE2D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjC1LzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjC1LzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF547693
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 04:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59B1F60B24
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 11:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F496C433EF;
        Tue, 28 Mar 2023 11:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680004516;
        bh=du5U+Gfq/Bxs1QD5m0iknl61ZyxQL/X3mJrtx0AxB5A=;
        h=Subject:To:Cc:From:Date:From;
        b=jGYMVwkgSX/GC2zQ/kQVJYzmv946MnrdGp0AphufmdF6VGQe6IkvgMvRWwnhc6bVG
         XRSXCDQ0sOvnCY1DieXfUhWETP9YMC/nina98Mk5l1ay+uoZgXpE5F+8/sw2jF24rD
         WTevrbpzCLUc9Akbu/uTwUdAGaPWkFRKmIV7h5W8=
Subject: FAILED: patch "[PATCH] fscrypt: destroy keyring after security_sb_delete()" failed to apply to 5.10-stable tree
To:     ebiggers@google.com, brauner@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:55:13 +0200
Message-ID: <168000451363159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x ccb820dc7d2236b1af0d54ae038a27b5b6d5ae5a
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000451363159@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

ccb820dc7d22 ("fscrypt: destroy keyring after security_sb_delete()")
83e804f0bfee ("fs,security: Add sb_delete hook")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ccb820dc7d2236b1af0d54ae038a27b5b6d5ae5a Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Mon, 13 Mar 2023 15:12:29 -0700
Subject: [PATCH] fscrypt: destroy keyring after security_sb_delete()

fscrypt_destroy_keyring() must be called after all potentially-encrypted
inodes were evicted; otherwise it cannot safely destroy the keyring.
Since inodes that are in-use by the Landlock LSM don't get evicted until
security_sb_delete(), this means that fscrypt_destroy_keyring() must be
called *after* security_sb_delete().

This fixes a WARN_ON followed by a NULL dereference, only possible if
Landlock was being used on encrypted files.

Fixes: d7e7b9af104c ("fscrypt: stop using keyrings subsystem for fscrypt_master_key")
Cc: stable@vger.kernel.org
Reported-by: syzbot+93e495f6a4f748827c88@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/00000000000044651705f6ca1e30@google.com
Reviewed-by: Christian Brauner <brauner@kernel.org>
Link: https://lore.kernel.org/r/20230313221231.272498-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/super.c b/fs/super.c
index 84332d5cb817..04bc62ab7dfe 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -475,13 +475,22 @@ void generic_shutdown_super(struct super_block *sb)
 
 		cgroup_writeback_umount();
 
-		/* evict all inodes with zero refcount */
+		/* Evict all inodes with zero refcount. */
 		evict_inodes(sb);
-		/* only nonzero refcount inodes can have marks */
+
+		/*
+		 * Clean up and evict any inodes that still have references due
+		 * to fsnotify or the security policy.
+		 */
 		fsnotify_sb_delete(sb);
-		fscrypt_destroy_keyring(sb);
 		security_sb_delete(sb);
 
+		/*
+		 * Now that all potentially-encrypted inodes have been evicted,
+		 * the fscrypt keyring can be destroyed.
+		 */
+		fscrypt_destroy_keyring(sb);
+
 		if (sb->s_dio_done_wq) {
 			destroy_workqueue(sb->s_dio_done_wq);
 			sb->s_dio_done_wq = NULL;

