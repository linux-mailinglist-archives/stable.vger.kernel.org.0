Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1428300F00
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 22:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbhAVVe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 16:34:27 -0500
Received: from lilium.sigma-star.at ([109.75.188.150]:32920 "EHLO
        lilium.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729342AbhAVVcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 16:32:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by lilium.sigma-star.at (Postfix) with ESMTP id 2D753181CBE03;
        Fri, 22 Jan 2021 22:22:35 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id sQ4Lpq5mXoJP; Fri, 22 Jan 2021 22:22:34 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vxMwvqs7u1ha; Fri, 22 Jan 2021 22:22:34 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     linux-mtd@lists.infradead.org
Cc:     david@sigma-star.at, richard@nod.at, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/4] ubifs: Correctly set inode size in ubifs_link()
Date:   Fri, 22 Jan 2021 22:22:26 +0100
Message-Id: <20210122212229.17072-2-richard@nod.at>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122212229.17072-1-richard@nod.at>
References: <20210122212229.17072-1-richard@nod.at>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We need to use fscrypt filename handling wrappers
when calculating the size of a directory entry, otherwise
UBIFS will report the wrong value (size of plain instead of cihper text)
for st_size of a directory if fscrypt is enabled.

Cc: stable@vger.kernel.org
Fixes: f4f61d2cc6d8 ("ubifs: Implement encrypted filenames")
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/dir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 9a6b8660425a..04912dedca48 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -693,7 +693,7 @@ static int ubifs_link(struct dentry *old_dentry, stru=
ct inode *dir,
 	struct inode *inode =3D d_inode(old_dentry);
 	struct ubifs_inode *ui =3D ubifs_inode(inode);
 	struct ubifs_inode *dir_ui =3D ubifs_inode(dir);
-	int err, sz_change =3D CALC_DENT_SIZE(dentry->d_name.len);
+	int err, sz_change;
 	struct ubifs_budget_req req =3D { .new_dent =3D 1, .dirtied_ino =3D 2,
 				.dirtied_ino_d =3D ALIGN(ui->data_len, 8) };
 	struct fscrypt_name nm;
@@ -731,6 +731,8 @@ static int ubifs_link(struct dentry *old_dentry, stru=
ct inode *dir,
 	if (inode->i_nlink =3D=3D 0)
 		ubifs_delete_orphan(c, inode->i_ino);
=20
+	sz_change =3D CALC_DENT_SIZE(fname_len(&nm));
+
 	inc_nlink(inode);
 	ihold(inode);
 	inode->i_ctime =3D current_time(inode);
--=20
2.26.2

