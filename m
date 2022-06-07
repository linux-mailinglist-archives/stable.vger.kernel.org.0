Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA44B54119B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355787AbiFGTjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356530AbiFGTiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:38:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4486161C;
        Tue,  7 Jun 2022 11:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51712B82374;
        Tue,  7 Jun 2022 18:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E90FC34115;
        Tue,  7 Jun 2022 18:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625636;
        bh=dnVq8A+QaRcFBuWkdXsDnNqK0ZQ2F6cv/bJXs+evh2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrD0qkkWfApi3F8vmxRiwefb386vEaM0UXEJQrAgNbNOX8tJDP7VZjp7ZGUilUUNR
         M17oVJs6ZhLpaJ08qYj/1XAoJXu7Hle7g2v/euVyCdeGTN7cQAIsXAOD3pWA3pN+7Y
         ueosCbY8oTkakj09UCvAxT4FBE1Pj1cvkpPXoZc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 090/772] media: pci: cx23885: Fix the error handling in cx23885_initdev()
Date:   Tue,  7 Jun 2022 18:54:42 +0200
Message-Id: <20220607164951.699328066@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



