Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4379959D61C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbiHWImo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346666AbiHWIk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE555F9B0;
        Tue, 23 Aug 2022 01:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35087B81C35;
        Tue, 23 Aug 2022 08:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81493C433C1;
        Tue, 23 Aug 2022 08:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242727;
        bh=kKw0EQi2ulodqozznFOd8OGQqbXzsUcSA+YuSD2WhII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bC/JhT1/C3VVC8ZoWknpxpDgJpbei8XwIDpGfCxl2+ktuxb1X0haKxgzmHSe4/gwT
         thODX4uBai2yZNnPSFbbRGXzkziYEgpo+saesRKsBvuEOQ/Mn54z+jRDqrG8qt2KKj
         Sbv4gQ9cB0GgFLBqpONR3SFxfCcCvGp95WVQPujQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.19 164/365] fs/ntfs3: Do not change mode if ntfs_set_ea failed
Date:   Tue, 23 Aug 2022 10:01:05 +0200
Message-Id: <20220823080125.075969620@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 460bbf2990b3fdc597601c2cf669a3371c069242 upstream.

ntfs_set_ea can fail with NOSPC, so we don't need to
change mode in this situation.
Fixes xfstest generic/449
Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/xattr.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -547,28 +547,23 @@ static noinline int ntfs_set_acl_ex(stru
 {
 	const char *name;
 	size_t size, name_len;
-	void *value = NULL;
-	int err = 0;
+	void *value;
+	int err;
 	int flags;
+	umode_t mode;
 
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
+	mode = inode->i_mode;
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		/* Do not change i_mode if we are in init_acl */
 		if (acl && !init_acl) {
-			umode_t mode;
-
 			err = posix_acl_update_mode(mnt_userns, inode, &mode,
 						    &acl);
 			if (err)
 				goto out;
-
-			if (inode->i_mode != mode) {
-				inode->i_mode = mode;
-				mark_inode_dirty(inode);
-			}
 		}
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
 		name_len = sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1;
@@ -604,8 +599,13 @@ static noinline int ntfs_set_acl_ex(stru
 	err = ntfs_set_ea(inode, name, name_len, value, size, flags, 0);
 	if (err == -ENODATA && !size)
 		err = 0; /* Removing non existed xattr. */
-	if (!err)
+	if (!err) {
 		set_cached_acl(inode, type, acl);
+		if (inode->i_mode != mode) {
+			inode->i_mode = mode;
+			mark_inode_dirty(inode);
+		}
+	}
 
 out:
 	kfree(value);


