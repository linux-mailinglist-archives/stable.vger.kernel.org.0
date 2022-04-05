Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434EC4F33A3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbiDEJBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237664AbiDEInE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:43:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BFA17E3E;
        Tue,  5 Apr 2022 01:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08F08B81A32;
        Tue,  5 Apr 2022 08:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633A9C385A0;
        Tue,  5 Apr 2022 08:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147732;
        bh=MCow+EIfs9h55hYNTV4RqMgF0B+/1q8tBPB3QDPDfrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2RtNzokccjlzS/JYEGVf7jePVnvthzTrI0/I64rpkn1tTKVa4NQFDbHLHTHYlDtA
         ddv5SReSF+nW3CuwzaWuzhqxTN/TU+mtbp0hKLoM37SxGIyyHS5RldiUb3ru2FCUlh
         RZi3acsaGhndGhTWiI4WnwFcoRuUT4NW/lbGHAFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 0101/1017] cifs: do not skip link targets when an I/O fails
Date:   Tue,  5 Apr 2022 09:16:54 +0200
Message-Id: <20220405070357.194710436@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -3401,6 +3401,9 @@ static int connect_dfs_target(struct mou
 	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
 	char *oldmnt = cifs_sb->ctx->mount_options;
 
+	cifs_dbg(FYI, "%s: full_path=%s ref_path=%s target=%s\n", __func__, full_path, ref_path,
+		 dfs_cache_get_tgt_name(tit));
+
 	rc = dfs_cache_get_tgt_referral(ref_path, tit, &ref);
 	if (rc)
 		goto out;
@@ -3499,13 +3502,18 @@ static int __follow_dfs_link(struct moun
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
 
@@ -3579,7 +3587,7 @@ int cifs_mount(struct cifs_sb_info *cifs
 		goto error;
 
 	rc = is_path_remote(&mnt_ctx);
-	if (rc == -EREMOTE)
+	if (rc)
 		rc = follow_dfs_link(&mnt_ctx);
 	if (rc)
 		goto error;


