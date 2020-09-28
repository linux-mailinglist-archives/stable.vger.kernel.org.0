Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0042D27B51A
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 21:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgI1TPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 15:15:07 -0400
Received: from lilium.sigma-star.at ([109.75.188.150]:41100 "EHLO
        lilium.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgI1TPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 15:15:07 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 15:15:06 EDT
Received: from localhost (localhost [127.0.0.1])
        by lilium.sigma-star.at (Postfix) with ESMTP id D95401816FACD;
        Mon, 28 Sep 2020 21:06:24 +0200 (CEST)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id RyaKbBkj8g-T; Mon, 28 Sep 2020 21:06:24 +0200 (CEST)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id C2466gc1w1W9; Mon, 28 Sep 2020 21:06:24 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     linux-mtd@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Kristof Havasi <havasiefr@gmail.com>
Subject: [PATCH] ubifs: journal: Make sure to not dirty twice for auth nodes
Date:   Mon, 28 Sep 2020 21:06:12 +0200
Message-Id: <20200928190612.12074-1-richard@nod.at>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When removing the last reference of an inode the size of an auth node
is already part of write_len. So we must not call ubifs_add_auth_dirt().
Call it only when needed.

Cc: <stable@vger.kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Kristof Havasi <havasiefr@gmail.com>
Fixes: 6a98bc4614de ("ubifs: Add authentication nodes to journal")
Reported-by: Kristof Havasi <havasiefr@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index cb1fa0c37322..091c2ad8f211 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -938,8 +938,6 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const=
 struct inode *inode)
 					  inode->i_ino);
 	release_head(c, BASEHD);
=20
-	ubifs_add_auth_dirt(c, lnum);
-
 	if (last_reference) {
 		err =3D ubifs_tnc_remove_ino(c, inode->i_ino);
 		if (err)
@@ -949,6 +947,8 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const=
 struct inode *inode)
 	} else {
 		union ubifs_key key;
=20
+		ubifs_add_auth_dirt(c, lnum);
+
 		ino_key_init(c, &key, inode->i_ino);
 		err =3D ubifs_tnc_add(c, &key, lnum, offs, ilen, hash);
 	}
--=20
2.26.2

