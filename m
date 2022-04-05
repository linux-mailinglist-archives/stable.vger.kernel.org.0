Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB824F2566
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiDEHtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiDEHrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC6B9AE42;
        Tue,  5 Apr 2022 00:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FF99616D9;
        Tue,  5 Apr 2022 07:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43660C340EE;
        Tue,  5 Apr 2022 07:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144573;
        bh=tWANHQHbcE1gOVX+QGv3inRTJJbYxPoiShgmtCsrN2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNu6dePrrUzsfg8wbgtw6nc9P+Wab3aBGWVOPi3qMxAw10HL21sB//fUhDGbpGN7u
         XJqZcA1glA2LhoGBd8mFu0tWStQht6Wn0uVRC3zlDbSZraoaeiF3yK2CnJ9b1UMVwU
         UI1+8OIeUJllwU+lykkvsClOmKRbU1nCnFNAPdAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 0092/1126] cifs: do not skip link targets when an I/O fails
Date:   Tue,  5 Apr 2022 09:13:59 +0200
Message-Id: <20220405070410.268808231@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Paulo Alcantara <pc@cjr.nz>

commit 5d7e282541fc91b831a5c4477c5d72881c623df9 upstream.

When I/O fails in one of the currently connected DFS targets, retry it
from other targets as specified in MS-DFSC "3.1.5.2 I/O Operation to
+Target Fails with an Error Other Than STATUS_PATH_NOT_COVERED."

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3473,6 +3473,9 @@ static int connect_dfs_target(struct mou
 	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
 	char *oldmnt = cifs_sb->ctx->mount_options;
 
+	cifs_dbg(FYI, "%s: full_path=%s ref_path=%s target=%s\n", __func__, full_path, ref_path,
+		 dfs_cache_get_tgt_name(tit));
+
 	rc = dfs_cache_get_tgt_referral(ref_path, tit, &ref);
 	if (rc)
 		goto out;
@@ -3571,13 +3574,18 @@ static int __follow_dfs_link(struct moun
 	if (rc)
 		goto out;
 
-	/* Try all dfs link targets */
+	/* Try all dfs link targets.  If an I/O fails from currently connected DFS target with an
+	 * error other than STATUS_PATH_NOT_COVERED (-EREMOTE), then retry it from other targets as
+	 * specified in MS-DFSC "3.1.5.2 I/O Operation to Target Fails with an Error Other Than
+	 * STATUS_PATH_NOT_COVERED."
+	 */
 	for (rc = -ENOENT, tit = dfs_cache_get_tgt_iterator(&tl);
 	     tit; tit = dfs_cache_get_next_tgt(&tl, tit)) {
 		rc = connect_dfs_target(mnt_ctx, full_path, mnt_ctx->leaf_fullpath + 1, tit);
 		if (!rc) {
 			rc = is_path_remote(mnt_ctx);
-			break;
+			if (!rc || rc == -EREMOTE)
+				break;
 		}
 	}
 
@@ -3651,7 +3659,7 @@ int cifs_mount(struct cifs_sb_info *cifs
 		goto error;
 
 	rc = is_path_remote(&mnt_ctx);
-	if (rc == -EREMOTE)
+	if (rc)
 		rc = follow_dfs_link(&mnt_ctx);
 	if (rc)
 		goto error;


