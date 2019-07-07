Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F261728
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfGGTpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:45:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57056 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727513AbfGGTiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:05 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0006ff-Pp; Sun, 07 Jul 2019 20:38:01 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz2-0005ZE-G4; Sun, 07 Jul 2019 20:38:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Richard Weinberger" <richard@nod.at>,
        "Brian Norris" <computersforpeace@gmail.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.691006377@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 037/129] mtd: docg3: Don't leak docg3->bbt in error path
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 45c2ebd702a468d5037cf16aa4f8ea8d67776f6a upstream.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/devices/docg3.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1907,7 +1907,7 @@ doc_probe_device(struct docg3_cascade *c
 
 	ret = 0;
 	if (chip_id != (u16)(~chip_id_inv)) {
-		goto nomem3;
+		goto nomem4;
 	}
 
 	switch (chip_id) {
@@ -1917,7 +1917,7 @@ doc_probe_device(struct docg3_cascade *c
 		break;
 	default:
 		doc_err("Chip id %04x is not a DiskOnChip G3 chip\n", chip_id);
-		goto nomem3;
+		goto nomem4;
 	}
 
 	doc_set_driver_info(chip_id, mtd);
@@ -1926,6 +1926,8 @@ doc_probe_device(struct docg3_cascade *c
 	doc_reload_bbt(docg3);
 	return mtd;
 
+nomem4:
+	kfree(docg3->bbt);
 nomem3:
 	kfree(mtd);
 nomem2:

