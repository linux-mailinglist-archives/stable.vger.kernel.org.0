Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB9D2C1E44
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 07:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgKXGbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 01:31:50 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:59184 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729737AbgKXGbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 01:31:50 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2020 01:31:49 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1606199132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=93U9HTwir3MyESStXqylZH/Q5z8YATBcSDxn3s56cbo=;
        b=bUlz8ChrZE60d/IAoRJZG6KDQWjYAsBh/+hah+X9OmYHlfdQiYVAmDlpTTazHRVp1RtWOW
        PE03BjCp3y68P2hObttcpZdDcLLS93G2DaDLBOyuRSBlBULUY+8OCTfQdFVpk9/TRcAktW
        Akem4MIzhp7BsNm5sbu1/0Ud0WUsp6I=
From:   Sven Eckelmann <sven@narfation.org>
To:     linux-mtd@lists.infradead.org
Cc:     rminnich@google.com, boris.brezillon@collabora.com,
        vigneshr@ti.com, richard@nod.at, miquel.raynal@bootlin.com,
        Sven Eckelmann <sven@narfation.org>, stable@vger.kernel.org
Subject: [PATCH v2] mtd: parser: cmdline: Fix parsing of part-names with colons
Date:   Tue, 24 Nov 2020 07:25:06 +0100
Message-Id: <20201124062506.185392-1-sven@narfation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some devices (especially QCA ones) are already using hardcoded partition
names with colons in it. The OpenMesh A62 for example provides following
mtd relevant information via cmdline:

  root=31:11 mtdparts=spi0.0:256k(0:SBL1),128k(0:MIBIB),384k(0:QSEE),64k(0:CDT),64k(0:DDRPARAMS),64k(0:APPSBLENV),512k(0:APPSBL),64k(0:ART),64k(custom),64k(0:KEYS),0x002b0000(kernel),0x00c80000(rootfs),15552k(inactive) rootfsname=rootfs rootwait

The change to split only on the last colon between mtd-id and partitions
will cause newpart to see following string for the first partition:

  KEYS),0x002b0000(kernel),0x00c80000(rootfs),15552k(inactive)

Such a partition list cannot be parsed and thus the device fails to boot.

Avoid this behavior by making sure that the start of the first part-name
("(") will also be the last byte the mtd-id split algorithm is using for
its colon search.

Fixes: eb13fa022741 ("mtd: parser: cmdline: Support MTD names containing one or more colons")
Cc: stable@vger.kernel.org
Cc: Ron Minnich <rminnich@google.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
v2:

* switch from net's multi-line comment style to mtd's multiline comment style
* Add Ron Minnich as explicit Cc as we are missing his Tested-by

 drivers/mtd/parsers/cmdlinepart.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/cmdlinepart.c b/drivers/mtd/parsers/cmdlinepart.c
index a79e4d866b08..0ddff1a4b51f 100644
--- a/drivers/mtd/parsers/cmdlinepart.c
+++ b/drivers/mtd/parsers/cmdlinepart.c
@@ -226,7 +226,7 @@ static int mtdpart_setup_real(char *s)
 		struct cmdline_mtd_partition *this_mtd;
 		struct mtd_partition *parts;
 		int mtd_id_len, num_parts;
-		char *p, *mtd_id, *semicol;
+		char *p, *mtd_id, *semicol, *open_parenth;
 
 		/*
 		 * Replace the first ';' by a NULL char so strrchr can work
@@ -236,6 +236,14 @@ static int mtdpart_setup_real(char *s)
 		if (semicol)
 			*semicol = '\0';
 
+		/*
+		 * make sure that part-names with ":" will not be handled as
+		 * part of the mtd-id with an ":"
+		 */
+		open_parenth = strchr(s, '(');
+		if (open_parenth)
+			*open_parenth = '\0';
+
 		mtd_id = s;
 
 		/*
@@ -245,6 +253,10 @@ static int mtdpart_setup_real(char *s)
 		 */
 		p = strrchr(s, ':');
 
+		/* Restore the '(' now. */
+		if (open_parenth)
+			*open_parenth = '(';
+
 		/* Restore the ';' now. */
 		if (semicol)
 			*semicol = ';';
-- 
2.29.2

