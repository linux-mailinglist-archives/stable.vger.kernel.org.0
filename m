Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBCB2E3BF1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406536AbgL1N4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406531AbgL1N4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A2A12064B;
        Mon, 28 Dec 2020 13:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163754;
        bh=tI9wce+BunvcXZ1k12lQIL1jSlbuXYGqwp+jozGk0AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0jc7FPdKmqDQm87ObkcRJerwz7nQqclTN5mKqrCxQns8bN3te+1e0mxmKvgwrfK0
         0SWnY3eTvhN0CTB+rp9jJG+/pP2FlLaDRHZYB6hY0n7Fv/KfL+JrQfkactVvRaevp9
         kC/7OAMOxUDMXAJ1OtRrAbS4ZJxL+jzxBjfmZxGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lizhe <lizhe67@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 395/453] jffs2: Fix ignoring mounting options problem during remounting
Date:   Mon, 28 Dec 2020 13:50:31 +0100
Message-Id: <20201228124956.210657737@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: lizhe <lizhe67@huawei.com>

commit 08cd274f9b8283a1da93e2ccab216a336da83525 upstream.

The jffs2 mount options will be ignored when remounting jffs2.
It can be easily reproduced with the steps listed below.
1. mount -t jffs2 -o compr=none /dev/mtdblockx /mnt
2. mount -o remount compr=zlib /mnt

Since ec10a24f10c8, the option parsing happens before fill_super and
then pass fc, which contains the options parsing results, to function
jffs2_reconfigure during remounting. But function jffs2_reconfigure do
not update c->mount_opts.

This patch add a function jffs2_update_mount_opts to fix this problem.

By the way, I notice that tmpfs use the same way to update remounting
options. If it is necessary to unify them?

Cc: <stable@vger.kernel.org>
Fixes: ec10a24f10c8 ("vfs: Convert jffs2 to use the new mount API")
Signed-off-by: lizhe <lizhe67@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jffs2/super.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -221,11 +221,28 @@ static int jffs2_parse_param(struct fs_c
 	return 0;
 }
 
+static inline void jffs2_update_mount_opts(struct fs_context *fc)
+{
+	struct jffs2_sb_info *new_c = fc->s_fs_info;
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(fc->root->d_sb);
+
+	mutex_lock(&c->alloc_sem);
+	if (new_c->mount_opts.override_compr) {
+		c->mount_opts.override_compr = new_c->mount_opts.override_compr;
+		c->mount_opts.compr = new_c->mount_opts.compr;
+	}
+	if (new_c->mount_opts.rp_size)
+		c->mount_opts.rp_size = new_c->mount_opts.rp_size;
+	mutex_unlock(&c->alloc_sem);
+}
+
 static int jffs2_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb = fc->root->d_sb;
 
 	sync_filesystem(sb);
+	jffs2_update_mount_opts(fc);
+
 	return jffs2_do_remount_fs(sb, fc);
 }
 


