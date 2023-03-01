Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536C36A731D
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCASMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCASMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:12:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126C34BE81
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:12:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBF40B810D2
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB23C433D2;
        Wed,  1 Mar 2023 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694363;
        bh=UpvzY9tzOo5TEf5owJe7gbtFviAeVMsHrRQMC8n3Kac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTsOBG0lRQnPKIpGK3jJsvim0FVW3gOjMV2gbkmcmzN2ML3ilZ89TypJH7Pt/jFQV
         H07Ojwxz/27vuWn0upfz4aXfvDB4XDxW9CM9UWeTs5VVEhgZhE4StdIZ1/YF5l6BRZ
         wds9wFtFDNLtAjaos6eWCp0iB0ZEI/QAaxlYJcQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 6.1 37/42] fs: move should_remove_suid()
Date:   Wed,  1 Mar 2023 19:08:58 +0100
Message-Id: <20230301180658.698136273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

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
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1949,35 +1949,6 @@ skip_update:
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


