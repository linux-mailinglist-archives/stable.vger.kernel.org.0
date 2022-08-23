Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3923859DF05
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354625AbiHWK23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354859AbiHWK0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:26:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D6183F2D;
        Tue, 23 Aug 2022 02:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 134D5B81C53;
        Tue, 23 Aug 2022 09:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FBAC433C1;
        Tue, 23 Aug 2022 09:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245548;
        bh=gXJeB+CKeDu7TiKFHWZPHO1BsLZegk9X3IBL5reKvkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ML0v913R0zmyW9YZ/KLVBqzMqdDKuC3EFnDwz37x/NVatVOVDZsi+tzEqDN048dYU
         VdyAGgRdAjIwVJ2mGL91UfEqpDKpPQltAzcc0zhOFzGso8JE8Qz/eJIoq70fcHoeDB
         45N/4d6OxylNo84njDuF6yAJKUv5P2KQzbjnAGko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/287] mtd: maps: Fix refcount leak in of_flash_probe_versatile
Date:   Tue, 23 Aug 2022 10:24:43 +0200
Message-Id: <20220823080104.218462230@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 33ec82a6d2b119938f26e5c8040ed5d92378eb54 ]

of_find_matching_node_and_match() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: b0afd44bc192 ("mtd: physmap_of: add a hook for Versatile write protection")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220523140205.48625-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/physmap_of_versatile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/maps/physmap_of_versatile.c b/drivers/mtd/maps/physmap_of_versatile.c
index 03f2b6e7bc7e..961704228dd2 100644
--- a/drivers/mtd/maps/physmap_of_versatile.c
+++ b/drivers/mtd/maps/physmap_of_versatile.c
@@ -221,6 +221,7 @@ int of_flash_probe_versatile(struct platform_device *pdev,
 
 		versatile_flashprot = (enum versatile_flashprot)devid->data;
 		rmap = syscon_node_to_regmap(sysnp);
+		of_node_put(sysnp);
 		if (IS_ERR(rmap))
 			return PTR_ERR(rmap);
 
-- 
2.35.1



