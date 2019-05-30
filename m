Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812312F375
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbfE3DOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729709AbfE3DOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:05 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0B0224569;
        Thu, 30 May 2019 03:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186045;
        bh=RENOjVEFjiCntOy06c0lzxelXW0npR/E5wJKKONC29g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Np1h7V+/j5VlL728UOAnkGnxNLAVDGcoy/o2scNLLkL2/FxM3+I739TZiYZhTKSMv
         /jMqhCMDyfDKLGAcoZr7whlkOoRY8q3IDsoGZUBsSYeLCnT8BWoysdyBCb/3vTx1+A
         NmA5FnCzr+mJYS+KVNkxaAPZWbpJQmv/DNAM8pfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 137/346] dmaengine: at_xdmac: remove BUG_ON macro in tasklet
Date:   Wed, 29 May 2019 20:03:30 -0700
Message-Id: <20190530030548.081689538@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e2c114c06da2d9ffad5b16690abf008d6696f689 ]

Even if this case shouldn't happen when controller is properly programmed,
it's still better to avoid dumping a kernel Oops for this.
As the sequence may happen only for debugging purposes, log the error and
just finish the tasklet call.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index fe69dccfa0c05..37a2694204351 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1606,7 +1606,11 @@ static void at_xdmac_tasklet(unsigned long data)
 					struct at_xdmac_desc,
 					xfer_node);
 		dev_vdbg(chan2dev(&atchan->chan), "%s: desc 0x%p\n", __func__, desc);
-		BUG_ON(!desc->active_xfer);
+		if (!desc->active_xfer) {
+			dev_err(chan2dev(&atchan->chan), "Xfer not active: exiting");
+			spin_unlock_bh(&atchan->lock);
+			return;
+		}
 
 		txd = &desc->tx_dma_desc;
 
-- 
2.20.1



