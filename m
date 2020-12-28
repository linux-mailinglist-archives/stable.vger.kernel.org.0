Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81012E66A8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732580AbgL1QOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:14:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731795AbgL1NSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:18:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB3420719;
        Mon, 28 Dec 2020 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161482;
        bh=4FLg/tRKbiYKuEHf1ONFKkPAmAa3l7zTo+kJRelJwxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1l6ARmWd9zpjdSgMfQSQFKAlXVcrX+OhS6C14OqLwK8jz/0ZclhNENuk/Q5fCbqiA
         mZfa6uMnGMrRwx8v11nJ+csBkxO14Iamr6rWyvxNK2TiAaUBEZ31UqFTU5gmucrNpY
         dK1FWeQ48bcjdVDqarI89kDJlyJUT6aUIV9/XCz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ron Minnich <rminnich@google.com>,
        Sven Eckelmann <sven@narfation.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.14 227/242] mtd: parser: cmdline: Fix parsing of part-names with colons
Date:   Mon, 28 Dec 2020 13:50:32 +0100
Message-Id: <20201228124915.847375889@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 639a82434f16a6df0ce0e7c8595976f1293940fd upstream.

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
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20201124062506.185392-1-sven@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/cmdlinepart.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -228,7 +228,7 @@ static int mtdpart_setup_real(char *s)
 		struct cmdline_mtd_partition *this_mtd;
 		struct mtd_partition *parts;
 		int mtd_id_len, num_parts;
-		char *p, *mtd_id, *semicol;
+		char *p, *mtd_id, *semicol, *open_parenth;
 
 		/*
 		 * Replace the first ';' by a NULL char so strrchr can work
@@ -238,6 +238,14 @@ static int mtdpart_setup_real(char *s)
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
@@ -247,6 +255,10 @@ static int mtdpart_setup_real(char *s)
 		 */
 		p = strrchr(s, ':');
 
+		/* Restore the '(' now. */
+		if (open_parenth)
+			*open_parenth = '(';
+
 		/* Restore the ';' now. */
 		if (semicol)
 			*semicol = ';';


