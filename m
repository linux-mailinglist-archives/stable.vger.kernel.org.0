Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D338101882
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfKSFaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfKSFae (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:30:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49547208C3;
        Tue, 19 Nov 2019 05:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141433;
        bh=V7Y1dJQO8mOAP60zX3u5fffB0gbGPVIIu4AGNz9dDsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3vfLCEOPEF832r+xlPgPX42j+MlsEZqpduGGrS4bHQy1N2qiG1Tj4d4hAVTscIIR
         CjE5GH/NOm9qNKMzNV40QP6q3HtvEQkJyK+zgb35CvxaY6yf8TnEbXT2Fk8lFx9jkv
         ajY2ZqUz/YAeZSNgPGeWL33PpT6kxPqSq+jHZv/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/422] dmaengine: at_xdmac: remove a stray bottom half unlock
Date:   Tue, 19 Nov 2019 06:15:56 +0100
Message-Id: <20191119051408.822410477@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



