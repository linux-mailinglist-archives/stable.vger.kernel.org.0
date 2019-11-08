Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF585F4A09
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391850AbfKHMGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389140AbfKHLlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F69721D7F;
        Fri,  8 Nov 2019 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213264;
        bh=V7Y1dJQO8mOAP60zX3u5fffB0gbGPVIIu4AGNz9dDsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEjY9uqpXOQ3PG/YiNqBhuDM7gWuOKBWjnvzE4sbT+NBi6FO6FRUTAmEV13tNCRsI
         d1vAZJNzadTAURT8eufNSBz8uoga5LyI8CZdUnBH77mmPYopSICTlmaAmTKDu6bZgt
         IqWjvDw1TTfM9OqgiW2Yw8/kCIVQXOum7XGxaJaU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 128/205] dmaengine: at_xdmac: remove a stray bottom half unlock
Date:   Fri,  8 Nov 2019 06:36:35 -0500
Message-Id: <20191108113752.12502-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 0b515abb6b7eb08e90bdfc01fc8fbdd112c15d81 ]

We switched this code from spin_lock_bh() to vanilla spin_lock() but
there was one stray spin_unlock_bh() that was overlooked.  This
patch converts it to spin_unlock() as well.

Fixes: d8570d018f69 ("dmaengine: at_xdmac: move spin_lock_bh to spin_lock in tasklet")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index db5b8fe1dd4ab..7db66f974041e 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1608,7 +1608,7 @@ static void at_xdmac_tasklet(unsigned long data)
 		dev_vdbg(chan2dev(&atchan->chan), "%s: desc 0x%p\n", __func__, desc);
 		if (!desc->active_xfer) {
 			dev_err(chan2dev(&atchan->chan), "Xfer not active: exiting");
-			spin_unlock_bh(&atchan->lock);
+			spin_unlock(&atchan->lock);
 			return;
 		}
 
-- 
2.20.1

