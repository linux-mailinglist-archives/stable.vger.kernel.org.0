Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF0612EBB7
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgABWLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbgABWLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82A5821D7D;
        Thu,  2 Jan 2020 22:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003093;
        bh=NXLY67IDTMu6Jlymy/bPZRDp/GZiSr3IJHRem+6GoO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVdZzZDZR7wH2EnbUH8NZE4/DcUVM4VfYd6Xkf8cMKirRBIe+C3BFevELsqc90im+
         82UvDCkfkFK5bOxv7bGVOYBilZmAfHbBWaO/bID9fsJFMI/a5tU//gRG+VFQN6XPpe
         Z9riFut5G+fe3plMTBITBwWHkC1LXtmkBv7Z/Rek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Graumann <nick.graumann@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/191] dmaengine: xilinx_dma: Clear desc_pendingcount in xilinx_dma_reset
Date:   Thu,  2 Jan 2020 23:04:59 +0100
Message-Id: <20200102215831.673206199@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Graumann <nick.graumann@gmail.com>

[ Upstream commit 8a631a5a0f7d4a4a24dba8587d5d9152be0871cc ]

Whenever we reset the channel, we need to clear desc_pendingcount
along with desc_submitcount. Otherwise when a new transaction is
submitted, the irq coalesce level could be programmed to an incorrect
value in the axidma case.

This behavior can be observed when terminating pending transactions
with xilinx_dma_terminate_all() and then submitting new transactions
without releasing and requesting the channel.

Signed-off-by: Nicholas Graumann <nick.graumann@gmail.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1571150904-3988-8-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 5d56f1e4d332..43acba2a1c0e 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1433,6 +1433,7 @@ static int xilinx_dma_reset(struct xilinx_dma_chan *chan)
 
 	chan->err = false;
 	chan->idle = true;
+	chan->desc_pendingcount = 0;
 	chan->desc_submitcount = 0;
 
 	return err;
-- 
2.20.1



