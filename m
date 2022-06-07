Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873A45417B1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378794AbiFGVEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378665AbiFGVDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:03:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17B3145589;
        Tue,  7 Jun 2022 11:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F1BA61295;
        Tue,  7 Jun 2022 18:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA19C385A2;
        Tue,  7 Jun 2022 18:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627715;
        bh=qO2K96LJDhbirD99gp0YVHECVMdEPs1haKCeGlOd7O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XIe/dzPnfwJ/bsDQODmzGdNvbFD6ABI6/rreRtwYI/IxXPWZ2lhokRnCMTsX+sgg
         +xH4v0fd0+59idN32kj8WqBF6+0/aM4O6zCm2QsKgYfF96pycqo3xywmt1Dk5lQWJB
         RG37+kbXrSCteus25fgxG6Bd5QcylBxhbTtO/t+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.18 026/879] fs/ntfs3: In function ntfs_set_acl_ex do not change inode->i_mode if called from function ntfs_init_acl
Date:   Tue,  7 Jun 2022 18:52:24 +0200
Message-Id: <20220607165003.435264945@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 9186d472ee780fabf74424756c4c00545166157e upstream.

ntfs_init_acl sets mode. ntfs_init_acl calls ntfs_set_acl_ex.
ntfs_set_acl_ex must not change this mode.
Fixes xfstest generic/444
Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")

Reviewed-by: Joe Perches <joe@perches.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/xattr.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -541,7 +541,7 @@ struct posix_acl *ntfs_get_acl(struct in
 
 static noinline int ntfs_set_acl_ex(struct user_namespace *mnt_userns,
 				    struct inode *inode, struct posix_acl *acl,
-				    int type)
+				    int type, bool init_acl)
 {
 	const char *name;
 	size_t size, name_len;
@@ -554,8 +554,9 @@ static noinline int ntfs_set_acl_ex(stru
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		if (acl) {
-			umode_t mode = inode->i_mode;
+		/* Do not change i_mode if we are in init_acl */
+		if (acl && !init_acl) {
+			umode_t mode;
 
 			err = posix_acl_update_mode(mnt_userns, inode, &mode,
 						    &acl);
@@ -616,7 +617,7 @@ out:
 int ntfs_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
 		 struct posix_acl *acl, int type)
 {
-	return ntfs_set_acl_ex(mnt_userns, inode, acl, type);
+	return ntfs_set_acl_ex(mnt_userns, inode, acl, type, false);
 }
 
 /*
@@ -636,7 +637,7 @@ int ntfs_init_acl(struct user_namespace
 
 	if (default_acl) {
 		err = ntfs_set_acl_ex(mnt_userns, inode, default_acl,
-				      ACL_TYPE_DEFAULT);
+				      ACL_TYPE_DEFAULT, true);
 		posix_acl_release(default_acl);
 	} else {
 		inode->i_default_acl = NULL;
@@ -647,7 +648,7 @@ int ntfs_init_acl(struct user_namespace
 	else {
 		if (!err)
 			err = ntfs_set_acl_ex(mnt_userns, inode, acl,
-					      ACL_TYPE_ACCESS);
+					      ACL_TYPE_ACCESS, true);
 		posix_acl_release(acl);
 	}
 


