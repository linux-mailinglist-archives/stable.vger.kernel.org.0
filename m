Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6142E3EA6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503731AbgL1Oap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503708AbgL1Oae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E715C20791;
        Mon, 28 Dec 2020 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165818;
        bh=lMgZnTW8lRXAthM3O6g19JlnkWU8bTM5YTCcDXiKfrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRWaYf7JiY09rRDU+A7aSHYaZM0l+d5XePhCZoTiFQF5tQ3A02AqWVcnZ2v/8r27C
         h0GX+bzZEneRatVsky6Ar9V7Q+PYxvIp4wvehZT7GEImxQv5szmjpLw4c9+CJWvhx/
         MHGvD90SaqZC4jas3+PcWGv+me34HjZFRJaLTtKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ron Minnich <rminnich@google.com>,
        Sven Eckelmann <sven@narfation.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 665/717] mtd: parser: cmdline: Fix parsing of part-names with colons
Date:   Mon, 28 Dec 2020 13:51:03 +0100
Message-Id: <20201228125052.838948559@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
 drivers/mtd/parsers/cmdlinepart.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

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


