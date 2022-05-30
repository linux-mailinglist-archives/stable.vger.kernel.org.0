Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C993B538231
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiE3OWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241591AbiE3ORs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFA8562DD;
        Mon, 30 May 2022 06:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C457EB80DE5;
        Mon, 30 May 2022 13:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A72C3411A;
        Mon, 30 May 2022 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918463;
        bh=gn/eCdmqB5fJjArNNAufz7ZEKjtYcJ3DdUYMiiTIDg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cS1+PB10GrexYBxF4CnFcRuwKmCE8Mtq9h9O8RRWT9uy1qB8yorkPXYbNtM9IVOaf
         dhSYi1u4vPt9ERRr4B+NPL39MYIly0x8/nC0ZTyp3oMhetgSdnpVw8VGGXn5fKC+ha
         jtMTAD/5iHvmmqvmXMGCVCCcJ5I35ETgB2JjzSvJFohYmDgC2e24Fw6JojuLymWqz0
         3vV6C9cYV8YuceT2c49tvG/ICrRejU496Es2qnZZmigggTWwO+lDAFl+48S6uj/ISo
         U+KzAE+6MBI5AmwCWI/x9CPn7D3tNRumkMsBwb1/sDML4bV1Jdyq27KFuSPdeJ873/
         yZpMQAZAHI+/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/55] media: pci: cx23885: Fix the error handling in cx23885_initdev()
Date:   Mon, 30 May 2022 09:46:22 -0400
Message-Id: <20220530134701.1935933-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
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
index ead0acb7807c..6747ecb4911b 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2154,7 +2154,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	err = pci_set_dma_mask(pci_dev, 0xffffffff);
 	if (err) {
 		pr_err("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		goto fail_ctrl;
+		goto fail_dma_set_mask;
 	}
 
 	err = request_irq(pci_dev->irq, cx23885_irq,
@@ -2162,7 +2162,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
-		goto fail_irq;
+		goto fail_dma_set_mask;
 	}
 
 	switch (dev->board) {
@@ -2184,7 +2184,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 
 	return 0;
 
-fail_irq:
+fail_dma_set_mask:
 	cx23885_dev_unregister(dev);
 fail_ctrl:
 	v4l2_ctrl_handler_free(hdl);
-- 
2.35.1

