Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1115051D3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiDRMll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240270AbiDRMiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:38:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDD027CE2;
        Mon, 18 Apr 2022 05:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 286E960F7C;
        Mon, 18 Apr 2022 12:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033B8C385A1;
        Mon, 18 Apr 2022 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284970;
        bh=60V9n3F/8YQM6yXHDBJ4XdgIZTw+UUdv3AXJFOGfAVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoH2roBBDqqCwnZOmTqreQ9HIn1IPBr6Gq5YYjTvzhKlrJXQTgicrqTCs4jtvahVY
         E/KEF0LJ2vTZlXXK/O/DHeMgsN2Sp0/3rIuVgewJGnPZcuo3yvtP4gtwRZkgsBDCvc
         lNlqqUG/CgxHMeOLOY2jj1qp2xNe0U5hsn7ErSU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/189] cifs: release cached dentries only if mount is complete
Date:   Mon, 18 Apr 2022 14:11:26 +0200
Message-Id: <20220418121202.382430356@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit d788e51636462e61c6883f7d96b07b06bc291650 ]

During cifs_kill_sb, we first dput all the dentries that we have cached.
However this function can also get called for mount failures.
So dput the cached dentries only if the filesystem mount is complete.
i.e. cifs_sb->root is populated.

Fixes: 5e9c89d43fa6 ("cifs: Grab a reference for the dentry of the cached directory during the lifetime of the cache")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ed220daca3e1..92fd1a7e83dc 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -266,22 +266,24 @@ static void cifs_kill_sb(struct super_block *sb)
 	 * before we kill the sb.
 	 */
 	if (cifs_sb->root) {
+		node = rb_first(root);
+		while (node != NULL) {
+			tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+			tcon = tlink_tcon(tlink);
+			cfid = &tcon->crfid;
+			mutex_lock(&cfid->fid_mutex);
+			if (cfid->dentry) {
+				dput(cfid->dentry);
+				cfid->dentry = NULL;
+			}
+			mutex_unlock(&cfid->fid_mutex);
+			node = rb_next(node);
+		}
+
+		/* finally release root dentry */
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
 	}
-	node = rb_first(root);
-	while (node != NULL) {
-		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
-		tcon = tlink_tcon(tlink);
-		cfid = &tcon->crfid;
-		mutex_lock(&cfid->fid_mutex);
-		if (cfid->dentry) {
-			dput(cfid->dentry);
-			cfid->dentry = NULL;
-		}
-		mutex_unlock(&cfid->fid_mutex);
-		node = rb_next(node);
-	}
 
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);
-- 
2.35.1



