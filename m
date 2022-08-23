Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB58859DD40
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347520AbiHWLX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357885AbiHWLVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:21:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A418B8E454;
        Tue, 23 Aug 2022 02:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E52606098A;
        Tue, 23 Aug 2022 09:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E8CC433D7;
        Tue, 23 Aug 2022 09:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246587;
        bh=lIKT57QeWRi638sIGVBA/9+tdx4JPlHNpzq6o4TTZaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nphevtqmVIvj44DjQbFnQCm2Mz0mbyCG+fRyjAryA04JEneQw2dcYhOR+zIbWYQ6x
         8YIAcb8lg5qtlkwxI/zmHfqWTwpY0nXqFfQNDR0png1LAxz3u8oNBYQ6Iah3TTINzI
         fI1TeIkxLvg71XhCoXJZJsEnR+MP/iH3CGVn+xas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Liang Yang <liang.yang@amlogic.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/389] mtd: rawnand: meson: Fix a potential double free issue
Date:   Tue, 23 Aug 2022 10:23:54 +0200
Message-Id: <20220823080122.116857697@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ec0da06337751b18f6dee06b6526e0f0d6e80369 ]

When meson_nfc_nand_chip_cleanup() is called, it will call:
	meson_nfc_free_buffer(&meson_chip->nand);
	nand_cleanup(&meson_chip->nand);

nand_cleanup() in turn will call nand_detach() which calls the
.detach_chip() which is here meson_nand_detach_chip().

meson_nand_detach_chip() already calls meson_nfc_free_buffer(), so we
could double free some memory.

Fix it by removing the unneeded explicit call to meson_nfc_free_buffer().

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Liang Yang <liang.yang@amlogic.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/ec15c358b8063f7c50ff4cd628cf0d2e14e43f49.1653064877.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index ab7ab6a279aa..28dc26e1a20a 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -1304,7 +1304,6 @@ static int meson_nfc_nand_chip_cleanup(struct meson_nfc *nfc)
 		if (ret)
 			return ret;
 
-		meson_nfc_free_buffer(&meson_chip->nand);
 		nand_cleanup(&meson_chip->nand);
 		list_del(&meson_chip->node);
 	}
-- 
2.35.1



