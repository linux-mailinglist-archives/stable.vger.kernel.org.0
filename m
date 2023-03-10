Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A2B6B43F8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbjCJOUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjCJOTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:19:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F76F1A964
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:18:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE3D61771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFB9C4339B;
        Fri, 10 Mar 2023 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457905;
        bh=fTvMYjHSrKeOLYyPL6cibvRcB37xx1eXLzePgAPQ7FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjfyPjN/rQUXD/hwKtriMoAra1OG1zc/bHWbc3p+DLCO5lOibihLdG2moM9YbSv/h
         FzK53lIvgrdDFG9nGMxgCRwJIcJxtZgS81KK6urcQtHPeiHWcZT/SPONrpaDMYomTO
         IE7ZJxwKiZX313XLYvjEQWvprpPMn9ggaYUU9UfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Samuel Holland <samuel@sholland.org>,
        Dhruva Gole <d-gole@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/252] mtd: rawnand: sunxi: Fix the size of the last OOB region
Date:   Fri, 10 Mar 2023 14:37:49 +0100
Message-Id: <20230310133721.813198306@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 34569d869532b54d6e360d224a0254dcdd6a1785 ]

The previous code assigned to the wrong structure member.

Fixes: c66811e6d350 ("mtd: nand: sunxi: switch to mtd_ooblayout_ops")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-By: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221229181526.53766-6-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 88075e420f907..fe7bfcdf7c69c 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1670,7 +1670,7 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 	if (section < ecc->steps)
 		oobregion->length = 4;
 	else
-		oobregion->offset = mtd->oobsize - oobregion->offset;
+		oobregion->length = mtd->oobsize - oobregion->offset;
 
 	return 0;
 }
-- 
2.39.2



