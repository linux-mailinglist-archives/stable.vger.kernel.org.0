Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BFA5410CC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355218AbiFGT3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356851AbiFGT2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4156BBBCF9;
        Tue,  7 Jun 2022 11:11:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2C4DB81F38;
        Tue,  7 Jun 2022 18:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E78C385A2;
        Tue,  7 Jun 2022 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625463;
        bh=eQJDeW28Q8lNsEGx74LsciocffWBnYZhpPkrpvgHptg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STuznUCfhjvSJWMmZ0BVlgjN+0OKkVC/zG5O0BEReiBBlCj3ITVqvwkArRalr27mR
         /AdT8FUi6MwclNAPzc3h5xWJew4M2T+lFBdpMgNN5DiKlp3ZUXXiimp23qbuLcNi3n
         n0IUMVXZOhbtz9c9Wsz/sVaOG5KiRPUi2CNlu7C8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 028/772] cifs: dont call cifs_dfs_query_info_nonascii_quirk() if nodfs was set
Date:   Tue,  7 Jun 2022 18:53:40 +0200
Message-Id: <20220607164949.848231523@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Enzo Matsumiya <ematsumiya@suse.de>

commit 421ef3d56513b2ff02e563623688cb6ab4977c4f upstream.

Also return EOPNOTSUPP if path is remote but nodfs was set.

Fixes: a2809d0e1696 ("cifs: quirk for STATUS_OBJECT_NAME_INVALID returned for non-ASCII dfs refs")
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3432,6 +3432,7 @@ static int is_path_remote(struct mount_c
 	struct cifs_tcon *tcon = mnt_ctx->tcon;
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	char *full_path;
+	bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
 
 	if (!server->ops->is_path_accessible)
 		return -EOPNOTSUPP;
@@ -3449,14 +3450,20 @@ static int is_path_remote(struct mount_c
 	rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
 					     full_path);
 #ifdef CONFIG_CIFS_DFS_UPCALL
+	if (nodfs) {
+		if (rc == -EREMOTE)
+			rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* path *might* exist with non-ASCII characters in DFS root
+	 * try again with full path (only if nodfs is not set) */
 	if (rc == -ENOENT && is_tcon_dfs(tcon))
 		rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon, cifs_sb,
 							full_path);
 #endif
-	if (rc != 0 && rc != -EREMOTE) {
-		kfree(full_path);
-		return rc;
-	}
+	if (rc != 0 && rc != -EREMOTE)
+		goto out;
 
 	if (rc != -EREMOTE) {
 		rc = cifs_are_all_path_components_accessible(server, xid, tcon,
@@ -3468,6 +3475,7 @@ static int is_path_remote(struct mount_c
 		}
 	}
 
+out:
 	kfree(full_path);
 	return rc;
 }


