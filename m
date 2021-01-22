Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2632B300F24
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 22:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbhAVVdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 16:33:55 -0500
Received: from lilium.sigma-star.at ([109.75.188.150]:32914 "EHLO
        lilium.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbhAVVcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 16:32:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by lilium.sigma-star.at (Postfix) with ESMTP id AD32B181CBE05;
        Fri, 22 Jan 2021 22:22:35 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id gZrYYPdzlWYm; Fri, 22 Jan 2021 22:22:35 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id U1pPPa_0HFNy; Fri, 22 Jan 2021 22:22:35 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     linux-mtd@lists.infradead.org
Cc:     david@sigma-star.at, richard@nod.at, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 3/4] ubifs: Update directory size when creating whiteouts
Date:   Fri, 22 Jan 2021 22:22:28 +0100
Message-Id: <20210122212229.17072-4-richard@nod.at>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122212229.17072-1-richard@nod.at>
References: <20210122212229.17072-1-richard@nod.at>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Although whiteouts are unlinked files they will get re-linked later,
therefore the size of the parent directory needs to be updated too.

Cc: stable@vger.kernel.org
Fixes: 9e0a1fff8db5 ("ubifs: Implement RENAME_WHITEOUT")
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 8a34e0118ee9..b5d523e5854f 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -361,6 +361,7 @@ static int do_tmpfile(struct inode *dir, struct dentr=
y *dentry,
 	struct ubifs_budget_req ino_req =3D { .dirtied_ino =3D 1 };
 	struct ubifs_inode *ui, *dir_ui =3D ubifs_inode(dir);
 	int err, instantiated =3D 0;
+	int sz_change =3D 0;
 	struct fscrypt_name nm;
=20
 	/*
@@ -411,6 +412,8 @@ static int do_tmpfile(struct inode *dir, struct dentr=
y *dentry,
 		mark_inode_dirty(inode);
 		drop_nlink(inode);
 		*whiteout =3D inode;
+		sz_change =3D CALC_DENT_SIZE(fname_len(&nm));
+		dir->i_size +=3D sz_change;
 	} else {
 		d_tmpfile(dentry, inode);
 	}
@@ -430,6 +433,7 @@ static int do_tmpfile(struct inode *dir, struct dentr=
y *dentry,
 	return 0;
=20
 out_cancel:
+	dir->i_size -=3D sz_change;
 	mutex_unlock(&dir_ui->ui_mutex);
 out_inode:
 	make_bad_inode(inode);
--=20
2.26.2

