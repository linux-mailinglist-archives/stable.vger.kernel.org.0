Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE40022EED3
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgG0OLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbgG0OLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:11:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F13A02083E;
        Mon, 27 Jul 2020 14:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859063;
        bh=LBn9Xwobhg/JDOcAvZgo6y0lgAMYmGyI+0wKy31ZQCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fppLgiVe/tWaajErj8TnpdHO9kViBAEtEnTbLrH5xVo2XXmnJAVQdVlpdjnFJuvyL
         UncJrZ33J9vTVxlQHwD6SYTwbrWP9jNil5oiooQQs4J9zZHNzN93P/tE4CT3Saq1bO
         oSGUPnRYGJCRUv0vL/s5lzCZzzBQYDdhbkqNwEo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonid Ravich <Leonid.Ravich@emc.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/86] dmaengine: ioat setting ioat timeout as module parameter
Date:   Mon, 27 Jul 2020 16:04:26 +0200
Message-Id: <20200727134917.027996958@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonid Ravich <Leonid.Ravich@emc.com>

[ Upstream commit 87730ccbddcb48478b1b88e88b14e73424130764 ]

DMA transaction time to completion is a function of PCI bandwidth,
transaction size and a queue depth.  So hard coded value for timeouts
might be wrong for some scenarios.

Signed-off-by: Leonid Ravich <Leonid.Ravich@emc.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20200701184816.29138-1-leonid.ravich@dell.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/dma.c | 12 ++++++++++++
 drivers/dma/ioat/dma.h |  2 --
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index b94cece58b984..890cadf3ec5d8 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -38,6 +38,18 @@
 
 #include "../dmaengine.h"
 
+int completion_timeout = 200;
+module_param(completion_timeout, int, 0644);
+MODULE_PARM_DESC(completion_timeout,
+		"set ioat completion timeout [msec] (default 200 [msec])");
+int idle_timeout = 2000;
+module_param(idle_timeout, int, 0644);
+MODULE_PARM_DESC(idle_timeout,
+		"set ioat idel timeout [msec] (default 2000 [msec])");
+
+#define IDLE_TIMEOUT msecs_to_jiffies(idle_timeout)
+#define COMPLETION_TIMEOUT msecs_to_jiffies(completion_timeout)
+
 static char *chanerr_str[] = {
 	"DMA Transfer Source Address Error",
 	"DMA Transfer Destination Address Error",
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 1ab42ec2b7ff1..b061db2013324 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -111,8 +111,6 @@ struct ioatdma_chan {
 	#define IOAT_RUN 5
 	#define IOAT_CHAN_ACTIVE 6
 	struct timer_list timer;
-	#define COMPLETION_TIMEOUT msecs_to_jiffies(100)
-	#define IDLE_TIMEOUT msecs_to_jiffies(2000)
 	#define RESET_DELAY msecs_to_jiffies(100)
 	struct ioatdma_device *ioat_dma;
 	dma_addr_t completion_dma;
-- 
2.25.1



