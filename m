Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4E02DFAB6
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 11:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgLUKCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 05:02:20 -0500
Received: from first.geanix.com ([116.203.34.67]:58062 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgLUKCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 05:02:12 -0500
Received: from zen.. (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id DDFF6487688;
        Mon, 21 Dec 2020 10:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1608544889; bh=QoIAAJdcJ2xARRst3umA4sJ7s7wi/Qvh4ASN+q/gFmw=;
        h=From:To:Cc:Subject:Date;
        b=L61J9MVQVz0CvG/ywTsNVAhA8yuwqWZizP0l97nYX2IXq3mbR8d5YhcUzSkxw035V
         TLufyfev/ejpinvQjGC4r7+9+6+uwY15YNG05diQtfYwtgHpuJgyaPIxS06Rt6kD9b
         jnO/y0TcfMcNl1diIUnbX/hdpLsCwnLofqYw5kT2jFIC0KqjGjIHyp+yD3VCe4flAo
         f9Mvtfl0KkkSGPu00dN4yEvZCnAtgY3+Jdy9sRX3HCL3UtWqW9YoV/hOLdSPapaE++
         X/ZeTV/CjXZDCq4prHW5P7u2wXwB+/xppvFg/LKrrHOM7b7HJRYryTXKeJ4FfAm+ia
         uZBkJDrx0zoWQ==
From:   Sean Nyekjaer <sean@geanix.com>
To:     Han Xu <han.xu@nxp.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Sean Nyekjaer <sean@geanix.com>, stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: rawnand: gpmi: fix dst bit offset when extracting raw payload
Date:   Mon, 21 Dec 2020 11:00:13 +0100
Message-Id: <20201221100013.2715675-1-sean@geanix.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on ff3d05386fc5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Re-add the multiply by 8 to "step * eccsize" to correct the destination bit offset
when extracting the data payload in gpmi_ecc_read_page_raw().

Fixes: e5e5631cc889 ("mtd: rawnand: gpmi: Use nand_extract_bits()")
Cc: stable@vger.kernel.org
Reported-by: Martin Hundebøll <martin@geanix.com>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index dc8104e67506..f0726e69a312 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -1611,7 +1611,7 @@ static int gpmi_ecc_read_page_raw(struct nand_chip *chip, uint8_t *buf,
 	/* Extract interleaved payload data and ECC bits */
 	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
 		if (buf)
-			nand_extract_bits(buf, step * eccsize, tmp_buf,
+			nand_extract_bits(buf, step * eccsize * 8, tmp_buf,
 					  src_bit_off, eccsize * 8);
 		src_bit_off += eccsize * 8;
 
-- 
2.29.2

