Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E2608855
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiJVIQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiJVIOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:14:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28BE18F275;
        Sat, 22 Oct 2022 00:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92B0DB82E1F;
        Sat, 22 Oct 2022 07:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F0BC433C1;
        Sat, 22 Oct 2022 07:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425307;
        bh=WFVjG+q3vUFosN6VOG2U+vIcJlTIVoQCqEg0IL9VlxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1t5E43vE5o/Dp2mito80Rv7OfYpC7QPbFKT7+gxpAdj1aQttrd1U8U4i3eqy4B12c
         4K9+SLt+TIS8XHhYvlUooLa9V9OKpSAWosm9QN98VyyrN8mJMVS8+3kvL2dK+tRD65
         nMxQGev8LVr7La4v1Pc2uSareaurSG/prBSdHX00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 428/717] mtd: rawnand: fsl_elbc: Fix none ECC mode
Date:   Sat, 22 Oct 2022 09:25:07 +0200
Message-Id: <20221022072517.367302516@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 049e43b9fd8fd2966940485da163d67e96ee3fea ]

Commit f6424c22aa36 ("mtd: rawnand: fsl_elbc: Make SW ECC work") added
support for specifying ECC mode via DTS and skipping autodetection.

But it broke explicit specification of HW ECC mode in DTS as correct
settings for HW ECC mode are applied only when NONE mode or nothing was
specified in DTS file.

Also it started aliasing NONE mode to be same as when ECC mode was not
specified and disallowed usage of ON_DIE mode.

Fix all these issues. Use autodetection of ECC mode only in case when mode
was really not specified in DTS file by checking that ecc value is invalid.
Set HW ECC settings either when HW ECC was specified in DTS or it was
autodetected. And do not fail when ON_DIE mode is set.

Fixes: f6424c22aa36 ("mtd: rawnand: fsl_elbc: Make SW ECC work")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220707184328.3845-1-pali@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/fsl_elbc_nand.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/raw/fsl_elbc_nand.c b/drivers/mtd/nand/raw/fsl_elbc_nand.c
index aab93b9e6052..a18d121396aa 100644
--- a/drivers/mtd/nand/raw/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_elbc_nand.c
@@ -726,36 +726,40 @@ static int fsl_elbc_attach_chip(struct nand_chip *chip)
 	struct fsl_lbc_regs __iomem *lbc = ctrl->regs;
 	unsigned int al;
 
-	switch (chip->ecc.engine_type) {
 	/*
 	 * if ECC was not chosen in DT, decide whether to use HW or SW ECC from
 	 * CS Base Register
 	 */
-	case NAND_ECC_ENGINE_TYPE_NONE:
+	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_INVALID) {
 		/* If CS Base Register selects full hardware ECC then use it */
 		if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
 		    BR_DECC_CHK_GEN) {
-			chip->ecc.read_page = fsl_elbc_read_page;
-			chip->ecc.write_page = fsl_elbc_write_page;
-			chip->ecc.write_subpage = fsl_elbc_write_subpage;
-
 			chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_ON_HOST;
-			mtd_set_ooblayout(mtd, &fsl_elbc_ooblayout_ops);
-			chip->ecc.size = 512;
-			chip->ecc.bytes = 3;
-			chip->ecc.strength = 1;
 		} else {
 			/* otherwise fall back to default software ECC */
 			chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
 			chip->ecc.algo = NAND_ECC_ALGO_HAMMING;
 		}
+	}
+
+	switch (chip->ecc.engine_type) {
+	/* if HW ECC was chosen, setup ecc and oob layout */
+	case NAND_ECC_ENGINE_TYPE_ON_HOST:
+		chip->ecc.read_page = fsl_elbc_read_page;
+		chip->ecc.write_page = fsl_elbc_write_page;
+		chip->ecc.write_subpage = fsl_elbc_write_subpage;
+		mtd_set_ooblayout(mtd, &fsl_elbc_ooblayout_ops);
+		chip->ecc.size = 512;
+		chip->ecc.bytes = 3;
+		chip->ecc.strength = 1;
 		break;
 
-	/* if SW ECC was chosen in DT, we do not need to set anything here */
+	/* if none or SW ECC was chosen, we do not need to set anything here */
+	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
+	case NAND_ECC_ENGINE_TYPE_ON_DIE:
 		break;
 
-	/* should we also implement *_ECC_ENGINE_CONTROLLER to do as above? */
 	default:
 		return -EINVAL;
 	}
-- 
2.35.1



