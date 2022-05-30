Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5831D537E96
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbiE3OKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbiE3OEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A22D994DA;
        Mon, 30 May 2022 06:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED6A560F14;
        Mon, 30 May 2022 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1D1C3411C;
        Mon, 30 May 2022 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918017;
        bh=dnVq8A+QaRcFBuWkdXsDnNqK0ZQ2F6cv/bJXs+evh2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hM18Es5Og0yTGTcG0wNKJIpL9Ewa0lh/6JXA8x0ZcgdT5JAqApV/EqVhwQQIiCvJb
         920ztV99vq/NK+MFFAKysV73CoY1cjPBPGART5judgbgtX2G6uKZt1bkjYwZn2jdLG
         G2tyAtt/cC0qE8OWzD2CPj/ADY2uZASoGg4fQqqflJ40wjOGGs8WcmU2GuiShfgx94
         XKA/p6x6iSrBYdDl6WXlPNZfmlnw6aVXVtb+3xiYtsSmBIxWEKGG0MlRu2frTe9qox
         QLWJIzKlU69qUfG32NlB988BsVPt1aRkJMDYf5M76XkP21WC5zKkc861m/W6inurPG
         tAUAglNG4B0mQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 033/109] media: pci: cx23885: Fix the error handling in cx23885_initdev()
Date:   Mon, 30 May 2022 09:37:09 -0400
Message-Id: <20220530133825.1933431-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit e8123311cf06d7dae71e8c5fe78e0510d20cd30b ]

When the driver fails to call the dma_set_mask(), the driver will get
the following splat:

[   55.853884] BUG: KASAN: use-after-free in __process_removed_driver+0x3c/0x240
[   55.854486] Read of size 8 at addr ffff88810de60408 by task modprobe/590
[   55.856822] Call Trace:
[   55.860327]  __process_removed_driver+0x3c/0x240
[   55.861347]  bus_for_each_dev+0x102/0x160
[   55.861681]  i2c_del_driver+0x2f/0x50

This is because the driver has initialized the i2c related resources
in cx23885_dev_setup() but not released them in error handling, fix this
bug by modifying the error path that jumps after failing to call the
dma_set_mask().

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index f8f2ff3b00c3..a07b18f2034e 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2165,7 +2165,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	err = dma_set_mask(&pci_dev->dev, 0xffffffff);
 	if (err) {
 		pr_err("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		goto fail_ctrl;
+		goto fail_dma_set_mask;
 	}
 
 	err = request_irq(pci_dev->irq, cx23885_irq,
@@ -2173,7 +2173,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
-		goto fail_irq;
+		goto fail_dma_set_mask;
 	}
 
 	switch (dev->board) {
@@ -2195,7 +2195,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 
 	return 0;
 
-fail_irq:
+fail_dma_set_mask:
 	cx23885_dev_unregister(dev);
 fail_ctrl:
 	v4l2_ctrl_handler_free(hdl);
-- 
2.35.1

