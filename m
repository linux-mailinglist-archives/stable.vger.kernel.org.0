Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1742D071D
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 21:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgLFUXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 15:23:17 -0500
Received: from lilium.sigma-star.at ([109.75.188.150]:55386 "EHLO
        lilium.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbgLFUXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 15:23:15 -0500
Received: from localhost (localhost [127.0.0.1])
        by lilium.sigma-star.at (Postfix) with ESMTP id D6C8C18172F00;
        Sun,  6 Dec 2020 21:22:32 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id aAMwD0WYdS66; Sun,  6 Dec 2020 21:22:32 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OQctWJ3k0AqL; Sun,  6 Dec 2020 21:22:32 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     miquel.raynal@bootlin.com
Cc:     vigneshr@ti.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        stable@vger.kernel.org
Subject: [PATCH] mtd: core: Fix refcounting for unpartitioned MTDs
Date:   Sun,  6 Dec 2020 21:22:20 +0100
Message-Id: <20201206202220.27290-1-richard@nod.at>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apply changes to usecount also the the master partition.
Otherwise we have no refcounting at all if an MTD has no partitions.

Cc: stable@vger.kernel.org
Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/mtdcore.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index e9e163ae9d86..b07cbb0661fb 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -993,6 +993,8 @@ int __get_mtd_device(struct mtd_info *mtd)
 		}
 	}
=20
+	master->usecount++;
+
 	while (mtd->parent) {
 		mtd->usecount++;
 		mtd =3D mtd->parent;
@@ -1059,6 +1061,8 @@ void __put_mtd_device(struct mtd_info *mtd)
 		mtd =3D mtd->parent;
 	}
=20
+	master->usecount--;
+
 	if (master->_put_device)
 		master->_put_device(master);
=20
--=20
2.26.2

