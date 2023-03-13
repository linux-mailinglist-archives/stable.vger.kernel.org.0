Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334436B8498
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 23:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCMWPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 18:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCMWO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 18:14:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67603637E5;
        Mon, 13 Mar 2023 15:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17A5AB81200;
        Mon, 13 Mar 2023 22:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C12C4339B;
        Mon, 13 Mar 2023 22:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678745695;
        bh=zvmdnOguTfDqdiHnoYELVOIodEHEhZGnF56sAJiM7Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzVPS94eSnz40BVL80XJ1ikdaJ5Q9eWNwhszlVJVAMSTvhEVj+jtUZvZfykglblFl
         Z77i8g2BTkuZiMfLtiu+7kOSf7SYLWhQ3xYZiKFe1UrKzGHt9Je5GOq2alB+j2R9iy
         4r6AREpNy87oiQfk+vysEfaaMCOtJ98YY70aCZGuEemnQ1oy07jVu+5AMo5KBu42pn
         J5VerWN7idgs1bfmM8AaHJgcLqP+i1ousYohJ4L2EDPT+gv7HxgpZl8H5nJE2ICm3r
         J3nfN16DQ0BjxNkZXQuAPtiFpX6Y8h2HIX0Nfkwv6w+oa7HXbN2tbY5cj2qD31hBCo
         uDDMGkQnX8DGg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        syzbot+93e495f6a4f748827c88@syzkaller.appspotmail.com
Subject: [PATCH 1/3] fscrypt: destroy keyring after security_sb_delete()
Date:   Mon, 13 Mar 2023 15:12:29 -0700
Message-Id: <20230313221231.272498-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313221231.272498-1-ebiggers@kernel.org>
References: <20230313221231.272498-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/super.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 84332d5cb817a..04bc62ab7dfea 100644
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
-- 
2.39.2

