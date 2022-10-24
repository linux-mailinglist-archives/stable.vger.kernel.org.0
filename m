Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1031B60ABED
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiJXOAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbiJXN7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:59:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDD48E987;
        Mon, 24 Oct 2022 05:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B676D612DD;
        Mon, 24 Oct 2022 12:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6731C433D6;
        Mon, 24 Oct 2022 12:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615610;
        bh=2aSqJ9LbDxNENvjzdwzi9Im+SVsBxTeYEvCqP3aIeus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raBJl8RBb8dlqIa2Ea9s9QOstx4siqG/H8YqhCAO9hZ1rhBD7Su/yn38lg7958LIg
         M7r33EfzKJ0tQiMp8XsoisES4qCbaxvYAM6X1PEl3WGc8DbY2D1VSdvwoCnrSL/kkO
         mGHbkQAOrVB9JRu/HxGjdCHkTqK/QqpeAAuuBxv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Liang Yang <liang.yang@amlogic.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/530] mtd: rawnand: meson: fix bit map use in meson_nfc_ecc_correct()
Date:   Mon, 24 Oct 2022 13:31:00 +0200
Message-Id: <20221024113059.322843498@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3e4ad3212cf22687410b1e8f4e68feec50646113 ]

The meson_nfc_ecc_correct() function accidentally does a right shift
instead of a left shift so it only works for BIT(0).  Also use
BIT_ULL() because "correct_bitmap" is a u64 and we want to avoid
shift wrapping bugs.

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Liang Yang <liang.yang@amlogic.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/YuI2zF1hP65+LE7r@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 032180183339..b97adeee4cc1 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -454,7 +454,7 @@ static int meson_nfc_ecc_correct(struct nand_chip *nand, u32 *bitflips,
 		if (ECC_ERR_CNT(*info) != ECC_UNCORRECTABLE) {
 			mtd->ecc_stats.corrected += ECC_ERR_CNT(*info);
 			*bitflips = max_t(u32, *bitflips, ECC_ERR_CNT(*info));
-			*correct_bitmap |= 1 >> i;
+			*correct_bitmap |= BIT_ULL(i);
 			continue;
 		}
 		if ((nand->options & NAND_NEED_SCRAMBLING) &&
@@ -800,7 +800,7 @@ static int meson_nfc_read_page_hwecc(struct nand_chip *nand, u8 *buf,
 			u8 *data = buf + i * ecc->size;
 			u8 *oob = nand->oob_poi + i * (ecc->bytes + 2);
 
-			if (correct_bitmap & (1 << i))
+			if (correct_bitmap & BIT_ULL(i))
 				continue;
 			ret = nand_check_erased_ecc_chunk(data,	ecc->size,
 							  oob, ecc->bytes + 2,
-- 
2.35.1



