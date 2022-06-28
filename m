Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6BC55DFFF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345417AbiF1MQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345407AbiF1MQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCF225C7A
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98614B81D2C
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53246C341CA;
        Tue, 28 Jun 2022 12:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418593;
        bh=AINyD/ghRUKFJE4z1HfBjbxurFGx31v3O6Xc5J/0CLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQOM7rp+WRXVMRwTDWAnT+MDJeWLiSwxkvHx6rnGjoi5FfAAoKg2l4caCIWSrznjC
         pEMSvf+JuTfpSRdx4VLv/iCFJc3nyjRbmcpX7JnJWgvJVry85pjBlIMcNsXrVsaYCg
         JyEmXg/zYkZz2vWu8jAchKZ1H7Sb9tvtiEw+RMUGpyOUJvuq+59zge2EaxJc20vdvL
         vOKQHE9fZv0PRFonUjPJy/Dxywx9gHJ2lqp7RpMZZ0c65it02sRImViS6ft8upZCPP
         4maDred15NpL8cdnRVBhhAG2y66Q6gj9rKn4XyOVD5FZLDwpRGEcccx7s6M0/AJTIN
         BhjtvD62lgg8w==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 03/12] fs: tweak fsuidgid_has_mapping()
Date:   Tue, 28 Jun 2022 14:16:11 +0200
Message-Id: <20220628121620.188722-4-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2089; i=brauner@kernel.org; h=from:subject; bh=STLURryjQjjgS91zYqD7LWGrvA5awNrxFtVLL3etsto=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+shnYjpVrIa/OTP30sR1PEbB17xUv/4QvvVxlVhnRPd1 Ya9THaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPhjWdk6Ojk8Oha8IfrskR2zGR/h2 2dzwqiJ25v4NnmEKu/35v7PcNfqUzv6PUNztIzY8oWKzzITkzaPOfSEwa+9oj4nAjpz1PZAA==
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

commit 476860b3eb4a50958243158861d5340066df5af2 upstream.

If the caller's fs{g,u}id aren't mapped in the mount's idmapping we can
return early and skip the check whether the mapped fs{g,u}id also have a
mapping in the filesystem's idmapping. If the fs{g,u}id aren't mapped in
the mount's idmapping they consequently can't be mapped in the
filesystem's idmapping. So there's no point in checking that.

Link: https://lore.kernel.org/r/20211123114227.3124056-4-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-4-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-4-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 include/linux/fs.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b1d446d71c3f..ffc06557618c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1697,10 +1697,18 @@ static inline void inode_fsgid_set(struct inode *inode,
 static inline bool fsuidgid_has_mapping(struct super_block *sb,
 					struct user_namespace *mnt_userns)
 {
-	struct user_namespace *s_user_ns = sb->s_user_ns;
+	struct user_namespace *fs_userns = sb->s_user_ns;
+	kuid_t kuid;
+	kgid_t kgid;
 
-	return kuid_has_mapping(s_user_ns, mapped_fsuid(mnt_userns)) &&
-	       kgid_has_mapping(s_user_ns, mapped_fsgid(mnt_userns));
+	kuid = mapped_fsuid(mnt_userns);
+	if (!uid_valid(kuid))
+		return false;
+	kgid = mapped_fsgid(mnt_userns);
+	if (!gid_valid(kgid))
+		return false;
+	return kuid_has_mapping(fs_userns, kuid) &&
+	       kgid_has_mapping(fs_userns, kgid);
 }
 
 extern struct timespec64 current_time(struct inode *inode);
-- 
2.34.1

