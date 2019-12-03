Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9582F111D5D
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfLCWwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:52:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729596AbfLCWwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 942F320866;
        Tue,  3 Dec 2019 22:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413562;
        bh=gfYG8PSKYvVW0V3yrLGpwROl9jB8I2nldpT5C/XItRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLfYxoTYjiWxkRclVolHJYtORyx19pso7XfLBLOIH4+xV4PZMC/QojsxF0lBlxiYM
         56o/Tiy+61QrbuqR/JiTn3vGLNYDJqPxfW8oInj5m/zHccauxMTlgcUQm18fYydWrg
         V6W0/W5Zi8rQAqk3xFimjrHrz9IfyRzGy5N9BLK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/321] exofs_mount(): fix leaks on failure exits
Date:   Tue,  3 Dec 2019 23:33:21 +0100
Message-Id: <20191203223434.184307718@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 26cb5a328c6b2bda9e859307ce4cfc60df3a2c28 ]

... and don't abuse mount_nodev(), while we are at it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exofs/super.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 7d61e3fa378c2..8fb98bb942372 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -705,21 +705,18 @@ out:
 /*
  * Read the superblock from the OSD and fill in the fields
  */
-static int exofs_fill_super(struct super_block *sb, void *data, int silent)
+static int exofs_fill_super(struct super_block *sb,
+				struct exofs_mountopt *opts,
+				struct exofs_sb_info *sbi,
+				int silent)
 {
 	struct inode *root;
-	struct exofs_mountopt *opts = data;
-	struct exofs_sb_info *sbi;	/*extended info                  */
 	struct osd_dev *od;		/* Master device                 */
 	struct exofs_fscb fscb;		/*on-disk superblock info        */
 	struct ore_comp comp;
 	unsigned table_count;
 	int ret;
 
-	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
-		return -ENOMEM;
-
 	/* use mount options to fill superblock */
 	if (opts->is_osdname) {
 		struct osd_dev_info odi = {.systemid_len = 0};
@@ -863,7 +860,9 @@ static struct dentry *exofs_mount(struct file_system_type *type,
 			  int flags, const char *dev_name,
 			  void *data)
 {
+	struct super_block *s;
 	struct exofs_mountopt opts;
+	struct exofs_sb_info *sbi;
 	int ret;
 
 	ret = parse_options(data, &opts);
@@ -872,9 +871,31 @@ static struct dentry *exofs_mount(struct file_system_type *type,
 		return ERR_PTR(ret);
 	}
 
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	if (!sbi) {
+		kfree(opts.dev_name);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	s = sget(type, NULL, set_anon_super, flags, NULL);
+
+	if (IS_ERR(s)) {
+		kfree(opts.dev_name);
+		kfree(sbi);
+		return ERR_CAST(s);
+	}
+
 	if (!opts.dev_name)
 		opts.dev_name = dev_name;
-	return mount_nodev(type, flags, &opts, exofs_fill_super);
+
+
+	ret = exofs_fill_super(s, &opts, sbi, flags & SB_SILENT ? 1 : 0);
+	if (ret) {
+		deactivate_locked_super(s);
+		return ERR_PTR(ret);
+	}
+	s->s_flags |= SB_ACTIVE;
+	return dget(s->s_root);
 }
 
 /*
-- 
2.20.1



