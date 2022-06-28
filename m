Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B8755DBF7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345462AbiF1MQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345463AbiF1MQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EF823BCA
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731E761139
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB1C341CA;
        Tue, 28 Jun 2022 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418601;
        bh=dYYRjxcyR2kJK0rl4ALAUYO3htK3X3ohnY6V9aY5nQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZXlkYFdy0nkO6/mXbKItje9cLVSndP8jUddH8VEwvUi5l3qqeDaJhaoWUha39qmJ
         7HFfVpGgQXixD+c0x11m65/Imetnxey7h8FkC3T8uzn4lGqhMK2RI2CJ/nZiL+ciYe
         jqRSTpPK/G/PgzV7P+/bWJEq79KGYzrC2su1HF3FH6taDJr8B0BA2ukhkwVrKMTcbp
         LjQTgxncTcmSbNZiKbVQIYYuWLs0R0oUGsSmp6/wv1xCFqEzMo3jXdTuKVzOVIIx4q
         Qyl7JUg/UpD0rEVAcUR3JZ2f2f83jDzvJl4+CSCtEBsZvSpqPB6w+AoKllQgOXTCVe
         m6i57mx7GMLXg==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 09/12] fs: add i_user_ns() helper
Date:   Tue, 28 Jun 2022 14:16:17 +0200
Message-Id: <20220628121620.188722-10-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2399; i=brauner@kernel.org; h=from:subject; bh=CrjNQrhBr++j/xHYjab3Pf+KTkMCDkMwcrRr+scLMNA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+iiw6OPl6a4ThU1+XL0hUZPuev592W7RCVNNFjr37yhg iiiO7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIfDAjwwKzZVw7vA9IRSz4+m9JkG /rhVdrb/5IKlm+69f8AIaAPxkM/5N0M59VMSXJGa6RsvJU+dLIN+XlNQ/p3i3GXZcfTlfLZwcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit a1ec9040a2a9122605ac26e5725c6de019184419 upstream.

Since we'll be passing the filesystem's idmapping in even more places in
the following patches and we do already dereference struct inode to get
to the filesystem's idmapping multiple times add a tiny helper.

Link: https://lore.kernel.org/r/20211123114227.3124056-10-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-10-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-10-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 include/linux/fs.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f62c1b9cd7cd..d418dffb1681 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1602,6 +1602,11 @@ struct super_block {
 	struct list_head	s_inodes_wb;	/* writeback inodes */
 } __randomize_layout;
 
+static inline struct user_namespace *i_user_ns(const struct inode *inode)
+{
+	return inode->i_sb->s_user_ns;
+}
+
 /* Helper functions so that in most cases filesystems will
  * not need to deal directly with kuid_t and kgid_t and can
  * instead deal with the raw numeric values that are stored
@@ -1609,22 +1614,22 @@ struct super_block {
  */
 static inline uid_t i_uid_read(const struct inode *inode)
 {
-	return from_kuid(inode->i_sb->s_user_ns, inode->i_uid);
+	return from_kuid(i_user_ns(inode), inode->i_uid);
 }
 
 static inline gid_t i_gid_read(const struct inode *inode)
 {
-	return from_kgid(inode->i_sb->s_user_ns, inode->i_gid);
+	return from_kgid(i_user_ns(inode), inode->i_gid);
 }
 
 static inline void i_uid_write(struct inode *inode, uid_t uid)
 {
-	inode->i_uid = make_kuid(inode->i_sb->s_user_ns, uid);
+	inode->i_uid = make_kuid(i_user_ns(inode), uid);
 }
 
 static inline void i_gid_write(struct inode *inode, gid_t gid)
 {
-	inode->i_gid = make_kgid(inode->i_sb->s_user_ns, gid);
+	inode->i_gid = make_kgid(i_user_ns(inode), gid);
 }
 
 /**
-- 
2.34.1

