Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7281654893D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358957AbiFMNRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358848AbiFMNP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:15:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800B02AE1;
        Mon, 13 Jun 2022 04:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E81D9B80E93;
        Mon, 13 Jun 2022 11:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D7BC34114;
        Mon, 13 Jun 2022 11:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119322;
        bh=4JkfOxC5gmI0LRB5f/6vslBdwhuK+DX353B085otTAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGzIptBmK7Kwx1hxH2iXpMfRAu1RdD6u43732+IRDO/v00dHe9Kni9jQbxqbTDcAG
         xSCna+RbEXKpBWggiCEBAVgzjTIy/vlhLeaLHe62cHGgVyBpS2JNQ8jHnmbbPeUiII
         XF94GYYBHAhLfODOWL0TX+dxhzH6uUdL+9q3FDR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Satadru Pramanik <satadru@gmail.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 220/247] cifs: fix reconnect on smb3 mount types
Date:   Mon, 13 Jun 2022 12:12:02 +0200
Message-Id: <20220613094929.616109209@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

commit c36ee7dab7749f7be21f7a72392744490b2a9a2b upstream.

cifs.ko defines two file system types: cifs & smb3, and
__cifs_get_super() was not including smb3 file system type when
looking up superblocks, therefore failing to reconnect tcons in
cifs_tree_connect().

Fix this by calling iterate_supers_type() on both file system types.

Link: https://lore.kernel.org/r/CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com
Cc: stable@vger.kernel.org
Tested-by: Satadru Pramanik <satadru@gmail.com>
Reported-by: Satadru Pramanik <satadru@gmail.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    2 +-
 fs/cifs/cifsfs.h |    2 +-
 fs/cifs/misc.c   |   27 ++++++++++++++++-----------
 3 files changed, 18 insertions(+), 13 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1074,7 +1074,7 @@ struct file_system_type cifs_fs_type = {
 };
 MODULE_ALIAS_FS("cifs");
 
-static struct file_system_type smb3_fs_type = {
+struct file_system_type smb3_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "smb3",
 	.init_fs_context = smb3_init_fs_context,
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -38,7 +38,7 @@ static inline unsigned long cifs_get_tim
 	return (unsigned long) dentry->d_fsdata;
 }
 
-extern struct file_system_type cifs_fs_type;
+extern struct file_system_type cifs_fs_type, smb3_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1212,18 +1212,23 @@ static struct super_block *__cifs_get_su
 		.data = data,
 		.sb = NULL,
 	};
+	struct file_system_type **fs_type = (struct file_system_type *[]) {
+		&cifs_fs_type, &smb3_fs_type, NULL,
+	};
 
-	iterate_supers_type(&cifs_fs_type, f, &sd);
-
-	if (!sd.sb)
-		return ERR_PTR(-EINVAL);
-	/*
-	 * Grab an active reference in order to prevent automounts (DFS links)
-	 * of expiring and then freeing up our cifs superblock pointer while
-	 * we're doing failover.
-	 */
-	cifs_sb_active(sd.sb);
-	return sd.sb;
+	for (; *fs_type; fs_type++) {
+		iterate_supers_type(*fs_type, f, &sd);
+		if (sd.sb) {
+			/*
+			 * Grab an active reference in order to prevent automounts (DFS links)
+			 * of expiring and then freeing up our cifs superblock pointer while
+			 * we're doing failover.
+			 */
+			cifs_sb_active(sd.sb);
+			return sd.sb;
+		}
+	}
+	return ERR_PTR(-EINVAL);
 }
 
 static void __cifs_put_super(struct super_block *sb)


