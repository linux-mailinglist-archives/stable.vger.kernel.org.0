Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940796C17D8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjCTPRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjCTPRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:17:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AED2BF2B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61FCEB80ED7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B02C433D2;
        Mon, 20 Mar 2023 15:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325125;
        bh=36s+yBPCwCNmP3oUrD79pMYSYcEAImGt9TmYyN1OKkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N92ebbqb2FUI/5pp2Cbyg/rwUVg0oduVyb5aBtrcYYQ90eKpx+2UD7105LtHJ11/Y
         5828Nsj8DQm+t2ex51YI8moa+mZqgSuDcLWPvQ5sUfCF/bp9vXn39ukk2s4FJpA45p
         Vpkt0OLFH5/CfsQ8N23nQQoBBJwpv+m5PUK3yPDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.10 93/99] fs: move should_remove_suid()
Date:   Mon, 20 Mar 2023 15:55:11 +0100
Message-Id: <20230320145447.317102085@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit e243e3f94c804ecca9a8241b5babe28f35258ef4 upstream.

Move the helper from inode.c to attr.c. This keeps the the core of the
set{g,u}id stripping logic in one place when we add follow-up changes.
It is the better place anyway, since should_remove_suid() returns
ATTR_KILL_S{G,U}ID flags.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c  |   29 +++++++++++++++++++++++++++++
 fs/inode.c |   29 -----------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,35 @@
 
 #include "internal.h"
 
+/*
+ * The logic we want is
+ *
+ *	if suid or (sgid and xgrp)
+ *		remove privs
+ */
+int should_remove_suid(struct dentry *dentry)
+{
+	umode_t mode = d_inode(dentry)->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	/*
+	 * sgid without any exec bits is just a mandatory locking mark; leave
+	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
+	 */
+	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
+		kill |= ATTR_KILL_SGID;
+
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
+		return kill;
+
+	return 0;
+}
+EXPORT_SYMBOL(should_remove_suid);
+
 static bool chown_ok(const struct inode *inode, kuid_t uid)
 {
 	if (uid_eq(current_fsuid(), inode->i_uid) &&
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1855,35 +1855,6 @@ skip_update:
 EXPORT_SYMBOL(touch_atime);
 
 /*
- * The logic we want is
- *
- *	if suid or (sgid and xgrp)
- *		remove privs
- */
-int should_remove_suid(struct dentry *dentry)
-{
-	umode_t mode = d_inode(dentry)->i_mode;
-	int kill = 0;
-
-	/* suid always must be killed */
-	if (unlikely(mode & S_ISUID))
-		kill = ATTR_KILL_SUID;
-
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
-
-	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
-		return kill;
-
-	return 0;
-}
-EXPORT_SYMBOL(should_remove_suid);
-
-/*
  * Return mask of changes for notify_change() that need to be done as a
  * response to write or truncate. Return 0 if nothing has to be changed.
  * Negative value on error (change should be denied).


