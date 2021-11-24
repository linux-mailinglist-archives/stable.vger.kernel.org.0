Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD3845C5D0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352820AbhKXOAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355577AbhKXN6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86CE9633CB;
        Wed, 24 Nov 2021 13:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759280;
        bh=ZNxgr+t4CJ+VIcNHmQOu3ERHalQ/1g+wguAsQXFa2ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCOMmBvGtvsqmbmZfnnW0LR+nOp9X42L5/bVz7ZyV2SRDU84i9BKiZMdcZXOMVSg1
         k2K34mDq99Uqo7UmWTVDbZtWLypFw1GHbuvNjMUob0KlTUDygNKCvvdRInbNM8cyKu
         FkmAjnXeEwoiwLRXjT0qci5i3g/oWWx/wrID5Q9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 187/279] dmaengine: remove debugfs #ifdef
Date:   Wed, 24 Nov 2021 12:57:54 +0100
Message-Id: <20211124115725.184505368@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit b3b180e735409ca0c76642014304b59482e0e653 upstream.

The ptdma driver has added debugfs support, but this fails to build
when debugfs is disabled:

drivers/dma/ptdma/ptdma-debugfs.c: In function 'ptdma_debugfs_setup':
drivers/dma/ptdma/ptdma-debugfs.c:93:54: error: 'struct dma_device' has no member named 'dbg_dev_root'
   93 |         debugfs_create_file("info", 0400, pt->dma_dev.dbg_dev_root, pt,
      |                                                      ^
drivers/dma/ptdma/ptdma-debugfs.c:96:55: error: 'struct dma_device' has no member named 'dbg_dev_root'
   96 |         debugfs_create_file("stats", 0400, pt->dma_dev.dbg_dev_root, pt,
      |                                                       ^
drivers/dma/ptdma/ptdma-debugfs.c:102:52: error: 'struct dma_device' has no member named 'dbg_dev_root'
  102 |                 debugfs_create_dir("q", pt->dma_dev.dbg_dev_root);
      |                                                    ^

Remove the #ifdef in the header, as this only saves a few bytes,
but would require ugly #ifdefs in each driver using it.
Simplify the other user while we're at it.

Fixes: e2fb2e2a33fa ("dmaengine: ptdma: Add debugfs entries for PTDMA")
Fixes: 26cf132de6f7 ("dmaengine: Create debug directories for DMA devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20210920122017.205975-1-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/xilinx/xilinx_dpdma.c |   15 +--------------
 include/linux/dmaengine.h         |    2 --
 2 files changed, 1 insertion(+), 16 deletions(-)

--- a/drivers/dma/xilinx/xilinx_dpdma.c
+++ b/drivers/dma/xilinx/xilinx_dpdma.c
@@ -271,9 +271,6 @@ struct xilinx_dpdma_device {
 /* -----------------------------------------------------------------------------
  * DebugFS
  */
-
-#ifdef CONFIG_DEBUG_FS
-
 #define XILINX_DPDMA_DEBUGFS_READ_MAX_SIZE	32
 #define XILINX_DPDMA_DEBUGFS_UINT16_MAX_STR	"65535"
 
@@ -299,7 +296,7 @@ struct xilinx_dpdma_debugfs_request {
 
 static void xilinx_dpdma_debugfs_desc_done_irq(struct xilinx_dpdma_chan *chan)
 {
-	if (chan->id == dpdma_debugfs.chan_id)
+	if (IS_ENABLED(CONFIG_DEBUG_FS) && chan->id == dpdma_debugfs.chan_id)
 		dpdma_debugfs.xilinx_dpdma_irq_done_count++;
 }
 
@@ -462,16 +459,6 @@ static void xilinx_dpdma_debugfs_init(st
 		dev_err(xdev->dev, "Failed to create debugfs testcase file\n");
 }
 
-#else
-static void xilinx_dpdma_debugfs_init(struct xilinx_dpdma_device *xdev)
-{
-}
-
-static void xilinx_dpdma_debugfs_desc_done_irq(struct xilinx_dpdma_chan *chan)
-{
-}
-#endif /* CONFIG_DEBUG_FS */
-
 /* -----------------------------------------------------------------------------
  * I/O Accessors
  */
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -944,10 +944,8 @@ struct dma_device {
 	void (*device_issue_pending)(struct dma_chan *chan);
 	void (*device_release)(struct dma_device *dev);
 	/* debugfs support */
-#ifdef CONFIG_DEBUG_FS
 	void (*dbg_summary_show)(struct seq_file *s, struct dma_device *dev);
 	struct dentry *dbg_dev_root;
-#endif
 };
 
 static inline int dmaengine_slave_config(struct dma_chan *chan,


