Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6656E60419B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiJSKqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbiJSKop (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75121F2CF;
        Wed, 19 Oct 2022 03:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF565B8231A;
        Wed, 19 Oct 2022 08:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56839C433D7;
        Wed, 19 Oct 2022 08:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169239;
        bh=fh45nFe3rfXMwurcMd+R47taX1sPGPQRXV1ZR1n3M1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZESqIxcZ3aXcNbkzvFGfnKqojtum0EV82/nlfKs4eABMLnEf9jfSPbn393p9pcLTy
         wuuRmfsVDIG96KiEvHN7EP0ioTUJkELHFAA+dkncML4ZnHgSFFb3bcsinFhHwnGkZE
         5SeZTTnwSTuqhXcR+AfLDDlEsE7E5glc2XY+NhOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Seth Forshee <sforshee@kernel.org>
Subject: [PATCH 6.0 206/862] acl: return EOPNOTSUPP in posix_acl_fix_xattr_common()
Date:   Wed, 19 Oct 2022 10:24:53 +0200
Message-Id: <20221019083259.111043097@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 985a6d0b3c800265a2d5312a52c549bf09254e55 ]

Return EOPNOTSUPP when the POSIX ACL version doesn't match and zero if
there are no entries. This will allow us to reuse the helper in
posix_acl_from_xattr(). This change will have no user visible effects.

Fixes: 0c5fd887d2bb ("acl: move idmapped mount fixup into vfs_{g,s}etxattr()")
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/posix_acl.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 5af33800743e..abe387700ba9 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -710,9 +710,9 @@ EXPORT_SYMBOL(posix_acl_update_mode);
 /*
  * Fix up the uids and gids in posix acl extended attributes in place.
  */
-static int posix_acl_fix_xattr_common(void *value, size_t size)
+static int posix_acl_fix_xattr_common(const void *value, size_t size)
 {
-	struct posix_acl_xattr_header *header = value;
+	const struct posix_acl_xattr_header *header = value;
 	int count;
 
 	if (!header)
@@ -720,13 +720,13 @@ static int posix_acl_fix_xattr_common(void *value, size_t size)
 	if (size < sizeof(struct posix_acl_xattr_header))
 		return -EINVAL;
 	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	count = posix_acl_xattr_count(size);
 	if (count < 0)
 		return -EINVAL;
 	if (count == 0)
-		return -EINVAL;
+		return 0;
 
 	return count;
 }
@@ -748,7 +748,7 @@ void posix_acl_getxattr_idmapped_mnt(struct user_namespace *mnt_userns,
 		return;
 
 	count = posix_acl_fix_xattr_common(value, size);
-	if (count < 0)
+	if (count <= 0)
 		return;
 
 	for (end = entry + count; entry != end; entry++) {
@@ -788,7 +788,7 @@ void posix_acl_setxattr_idmapped_mnt(struct user_namespace *mnt_userns,
 		return;
 
 	count = posix_acl_fix_xattr_common(value, size);
-	if (count < 0)
+	if (count <= 0)
 		return;
 
 	for (end = entry + count; entry != end; entry++) {
@@ -822,7 +822,7 @@ static void posix_acl_fix_xattr_userns(
 	kgid_t gid;
 
 	count = posix_acl_fix_xattr_common(value, size);
-	if (count < 0)
+	if (count <= 0)
 		return;
 
 	for (end = entry + count; entry != end; entry++) {
@@ -870,16 +870,9 @@ posix_acl_from_xattr(struct user_namespace *user_ns,
 	struct posix_acl *acl;
 	struct posix_acl_entry *acl_e;
 
-	if (!value)
-		return NULL;
-	if (size < sizeof(struct posix_acl_xattr_header))
-		 return ERR_PTR(-EINVAL);
-	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
-		return ERR_PTR(-EOPNOTSUPP);
-
-	count = posix_acl_xattr_count(size);
+	count = posix_acl_fix_xattr_common(value, size);
 	if (count < 0)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(count);
 	if (count == 0)
 		return NULL;
 	
-- 
2.35.1



