Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552D231BCD5
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhBOPgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231384AbhBOPdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 716BB64E5A;
        Mon, 15 Feb 2021 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403064;
        bh=XixZMLnlHvk8zaKCY/TQx/rhJuSwY/wSMAFOQEPqm8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkqVa2+KCY6Xz6EH+hGzSNurFduyJSbZfH7fl5DZN2Yd5YbpMn5L/5J9JWzntTW3p
         gbD4S1eq3DzCQi1hvInR/vVWOPbVoyaoGhkkAi9POSAbZHiTEn2JWMqsTqbrXyexHB
         DHR36PQSg7PKHVmn70z9cqPbRyg+ZmAAP2fYBRKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radhey Shyam Pandey <radheys@xilinx.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 014/104] dmaengine: move channel device_node deletion to driver
Date:   Mon, 15 Feb 2021 16:26:27 +0100
Message-Id: <20210215152719.925684080@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

commit e594443196d6e0ef3d3b30320c49b3a4d4f9a547 upstream.

Channel device_node deletion is managed by the device driver rather than
the dmaengine core. The deletion was accidentally introduced when making
channel unregister dynamic. It causes xilinx_dma module to crash on unload
as reported by Radhey. Remove chan->device_node delete in dmaengine and
also fix up idxd driver.

[   42.142705] Internal error: Oops: 96000044 [#1] SMP
[   42.147566] Modules linked in: xilinx_dma(-) clk_xlnx_clock_wizard uio_pdrv_genirq
[   42.155139] CPU: 1 PID: 2075 Comm: rmmod Not tainted 5.10.1-00026-g3a2e6dd7a05-dirty #192
[   42.163302] Hardware name: Enclustra XU5 SOM (DT)
[   42.167992] pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=--)
[   42.173996] pc : xilinx_dma_chan_remove+0x74/0xa0 [xilinx_dma]
[   42.179815] lr : xilinx_dma_chan_remove+0x70/0xa0 [xilinx_dma]
[   42.185636] sp : ffffffc01112bca0
[   42.188935] x29: ffffffc01112bca0 x28: ffffff80402ea640

xilinx_dma_chan_remove+0x74/0xa0:
__list_del at ./include/linux/list.h:112 (inlined by)
__list_del_entry at./include/linux/list.h:135 (inlined by)
list_del at ./include/linux/list.h:146 (inlined by)
xilinx_dma_chan_remove at drivers/dma/xilinx/xilinx_dma.c:2546

Fixes: e81274cd6b52 ("dmaengine: add support to dynamic register/unregister of channels")
Reported-by: Radhey Shyam Pandey <radheys@xilinx.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/161099092469.2495902.5064826526660062342.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dmaengine.c |    1 -
 drivers/dma/idxd/dma.c  |    5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1110,7 +1110,6 @@ static void __dma_async_device_channel_u
 		  "%s called while %d clients hold a reference\n",
 		  __func__, chan->client_count);
 	mutex_lock(&dma_list_mutex);
-	list_del(&chan->device_node);
 	device->chancnt--;
 	chan->dev->chan = NULL;
 	mutex_unlock(&dma_list_mutex);
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -214,5 +214,8 @@ int idxd_register_dma_channel(struct idx
 
 void idxd_unregister_dma_channel(struct idxd_wq *wq)
 {
-	dma_async_device_channel_unregister(&wq->idxd->dma_dev, &wq->dma_chan);
+	struct dma_chan *chan = &wq->dma_chan;
+
+	dma_async_device_channel_unregister(&wq->idxd->dma_dev, chan);
+	list_del(&chan->device_node);
 }


