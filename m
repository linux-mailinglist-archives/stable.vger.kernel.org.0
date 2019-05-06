Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED7D14D39
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfEFOtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfEFOtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:49:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F04D121019;
        Mon,  6 May 2019 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154162;
        bh=qW0yTp0Bkwnm33rylBQl14Ex1/xlNSpFb9hZF9+Snsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXv8VZ3D23gRk57JxVQqb5kQ/v1APK7NibJPWqfyhZcRa0Um65Ws6VdPDcdrpA4iA
         yXNZ9mlY0hOuiRwv8wYfTUOPpezSXMp6KcuZH6N7U6fM811Zhb6fPzTWPYFf10tCQe
         +5kAbamJR/bVFgf39Ivb+XPNmwzsTjhdVPSm5Vzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.9 60/62] selinux: never allow relabeling on context mounts
Date:   Mon,  6 May 2019 16:33:31 +0200
Message-Id: <20190506143056.624747476@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit a83d6ddaebe541570291205cb538e35ad4ff94f9 upstream.

In the SECURITY_FS_USE_MNTPOINT case we never want to allow relabeling
files/directories, so we should never set the SBLABEL_MNT flag. The
'special handling' in selinux_is_sblabel_mnt() is only intended for when
the behavior is set to SECURITY_FS_USE_GENFS.

While there, make the logic in selinux_is_sblabel_mnt() more explicit
and add a BUILD_BUG_ON() to make sure that introducing a new
SECURITY_FS_USE_* forces a review of the logic.

Fixes: d5f3a5f6e7e7 ("selinux: add security in-core xattr support for pstore and debugfs")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -467,21 +467,43 @@ static int may_context_mount_inode_relab
 	return rc;
 }
 
-static int selinux_is_sblabel_mnt(struct super_block *sb)
+static int selinux_is_genfs_special_handling(struct super_block *sb)
 {
-	struct superblock_security_struct *sbsec = sb->s_security;
-
-	return sbsec->behavior == SECURITY_FS_USE_XATTR ||
-		sbsec->behavior == SECURITY_FS_USE_TRANS ||
-		sbsec->behavior == SECURITY_FS_USE_TASK ||
-		sbsec->behavior == SECURITY_FS_USE_NATIVE ||
-		/* Special handling. Genfs but also in-core setxattr handler */
-		!strcmp(sb->s_type->name, "sysfs") ||
+	/* Special handling. Genfs but also in-core setxattr handler */
+	return	!strcmp(sb->s_type->name, "sysfs") ||
 		!strcmp(sb->s_type->name, "pstore") ||
 		!strcmp(sb->s_type->name, "debugfs") ||
 		!strcmp(sb->s_type->name, "rootfs");
 }
 
+static int selinux_is_sblabel_mnt(struct super_block *sb)
+{
+	struct superblock_security_struct *sbsec = sb->s_security;
+
+	/*
+	 * IMPORTANT: Double-check logic in this function when adding a new
+	 * SECURITY_FS_USE_* definition!
+	 */
+	BUILD_BUG_ON(SECURITY_FS_USE_MAX != 7);
+
+	switch (sbsec->behavior) {
+	case SECURITY_FS_USE_XATTR:
+	case SECURITY_FS_USE_TRANS:
+	case SECURITY_FS_USE_TASK:
+	case SECURITY_FS_USE_NATIVE:
+		return 1;
+
+	case SECURITY_FS_USE_GENFS:
+		return selinux_is_genfs_special_handling(sb);
+
+	/* Never allow relabeling on context mounts */
+	case SECURITY_FS_USE_MNTPOINT:
+	case SECURITY_FS_USE_NONE:
+	default:
+		return 0;
+	}
+}
+
 static int sb_finish_set_opts(struct super_block *sb)
 {
 	struct superblock_security_struct *sbsec = sb->s_security;


