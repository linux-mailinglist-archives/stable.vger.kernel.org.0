Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E614F28D3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiDEIXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiDEIRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204CAAF1E4;
        Tue,  5 Apr 2022 01:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A1ABB81A32;
        Tue,  5 Apr 2022 08:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1444C385A1;
        Tue,  5 Apr 2022 08:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145883;
        bh=pUXd/odrjqglX+qTSbsO6wGpyhmHpt2EgqG6TEgFfPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOFhOI+U4FPUNYmN0twqMPeWTE8vkt0m7G4pARkKT4qV+OPR8uEDEYVf7xCbVI6dn
         MEks7T8m9rUrPuBfTWWTrmzeJ/Y3Z3sRj5N20zisfgLQT+YOUTWvQ1czSLN+VFg3Pc
         p19cWtt7x7MqGs3KvU9oJlyqG3psdXX+p4x3HRKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0565/1126] mtd: rawnand: pl353: Set the nand chip node as the flash node
Date:   Tue,  5 Apr 2022 09:21:52 +0200
Message-Id: <20220405070424.217402117@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>

[ Upstream commit a1fe2ace2c39dcdc7c053705459a73b7598b1e4f ]

In devicetree the flash information is embedded within nand chip node,
so during nand chip initialization the nand chip node should be passed
to nand_set_flash_node() api, instead of nand controller node.

Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220209053427.27676-1-amit.kumar-mahapatra@xilinx.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 8a91e069ee2e..3c6f6aff649f 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -1062,7 +1062,7 @@ static int pl35x_nand_chip_init(struct pl35x_nandc *nfc,
 	chip->controller = &nfc->controller;
 	mtd = nand_to_mtd(chip);
 	mtd->dev.parent = nfc->dev;
-	nand_set_flash_node(chip, nfc->dev->of_node);
+	nand_set_flash_node(chip, np);
 	if (!mtd->name) {
 		mtd->name = devm_kasprintf(nfc->dev, GFP_KERNEL,
 					   "%s", PL35X_NANDC_DRIVER_NAME);
-- 
2.34.1



