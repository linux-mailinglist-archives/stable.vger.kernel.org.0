Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751BA6CC455
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbjC1PDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbjC1PDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:03:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F869E1A3
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AD22B81D7A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A628DC433EF;
        Tue, 28 Mar 2023 15:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015733;
        bh=UCOUbbinkANOkKeBF2oBYAEPjBNp5ACM0g1MCyUk5RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzeJKYtlOBTktfUH027uGTMTCIzdU22uCwsaQDO6R5SP67GuhmvT7P7p40uruvwqD
         AGJ5srnu1XnqWPDZiKoPdTfz5TRde7tcb0phPXvJJ+NHQamZLRluizbLGRE0PzdeQU
         fdp3f4Lctygqdq89Kewkct1BMCJ5h+57TLSpoBis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 156/224] cifs: fix dentry lookups in directory handle cache
Date:   Tue, 28 Mar 2023 16:42:32 +0200
Message-Id: <20230328142623.885551538@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@manguebit.com>

commit be4fde79812f02914e350bde0bc4cfeae8429378 upstream.

Get rid of any prefix paths in @path before lookup_positive_unlocked()
as it will call ->lookup() which already adds those prefix paths
through build_path_from_dentry().

This has caused a performance regression when mounting shares with a
prefix path where readdir(2) would end up retrying several times to
open bad directory names that contained duplicate prefix paths.

Fix this by skipping any prefix paths in @path before calling
lookup_positive_unlocked().

Fixes: e4029e072673 ("cifs: find and use the dentry for cached non-root directories also")
Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cached_dir.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -99,6 +99,23 @@ path_to_dentry(struct cifs_sb_info *cifs
 	return dentry;
 }
 
+static const char *path_no_prefix(struct cifs_sb_info *cifs_sb,
+				  const char *path)
+{
+	size_t len = 0;
+
+	if (!*path)
+		return path;
+
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+	    cifs_sb->prepath) {
+		len = strlen(cifs_sb->prepath) + 1;
+		if (unlikely(len > strlen(path)))
+			return ERR_PTR(-EINVAL);
+	}
+	return path + len;
+}
+
 /*
  * Open the and cache a directory handle.
  * If error then *cfid is not initialized.
@@ -125,6 +142,7 @@ int open_cached_dir(unsigned int xid, st
 	struct dentry *dentry = NULL;
 	struct cached_fid *cfid;
 	struct cached_fids *cfids;
+	const char *npath;
 
 	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
 	    is_smb1_server(tcon->ses->server))
@@ -161,6 +179,20 @@ int open_cached_dir(unsigned int xid, st
 	}
 
 	/*
+	 * Skip any prefix paths in @path as lookup_positive_unlocked() ends up
+	 * calling ->lookup() which already adds those through
+	 * build_path_from_dentry().  Also, do it earlier as we might reconnect
+	 * below when trying to send compounded request and then potentially
+	 * having a different prefix path (e.g. after DFS failover).
+	 */
+	npath = path_no_prefix(cifs_sb, path);
+	if (IS_ERR(npath)) {
+		rc = PTR_ERR(npath);
+		kfree(utf16_path);
+		return rc;
+	}
+
+	/*
 	 * We do not hold the lock for the open because in case
 	 * SMB2_open needs to reconnect.
 	 * This is safe because no other thread will be able to get a ref
@@ -252,10 +284,10 @@ int open_cached_dir(unsigned int xid, st
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 
-	if (!path[0])
+	if (!npath[0])
 		dentry = dget(cifs_sb->root);
 	else {
-		dentry = path_to_dentry(cifs_sb, path);
+		dentry = path_to_dentry(cifs_sb, npath);
 		if (IS_ERR(dentry)) {
 			rc = -ENOENT;
 			goto oshr_free;


