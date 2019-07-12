Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77FF66E34
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfGLMau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbfGLMat (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:30:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66B7A208E4;
        Fri, 12 Jul 2019 12:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934648;
        bh=rXRNbh8gFJXrcUfJ44byTu2hgd8LB8LUIugDhTjpGEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NM0AI47KN670ZNr0v2J4BfpBssvDZxi1AOy17MbXjlkzyFW91jXf3nHxyIYFn5z4f
         vk4UFXYCRtJG+OH7k0A7FdezJsgDaWui6IUSNTUiuwBJDyJ58Rcfx9sFAwaxPGW1wh
         YD+pxQC9GzTgafS0PHf3dJWU5HR/0fKg760U32LY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 081/138] net: lio_core: fix potential sign-extension overflow on large shift
Date:   Fri, 12 Jul 2019 14:19:05 +0200
Message-Id: <20190712121631.844221707@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9476274093a0e79b905f4cd6cf6d149f65e02c17 ]

Left shifting the signed int value 1 by 31 bits has undefined behaviour
and the shift amount oq_no can be as much as 63.  Fix this by using
BIT_ULL(oq_no) instead.

Addresses-Coverity: ("Bad shift operation")
Fixes: f21fb3ed364b ("Add support of Cavium Liquidio ethernet adapters")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 1c50c10b5a16..d7e805749a5b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -964,7 +964,7 @@ static void liquidio_schedule_droq_pkt_handlers(struct octeon_device *oct)
 
 			if (droq->ops.poll_mode) {
 				droq->ops.napi_fn(droq);
-				oct_priv->napi_mask |= (1 << oq_no);
+				oct_priv->napi_mask |= BIT_ULL(oq_no);
 			} else {
 				tasklet_schedule(&oct_priv->droq_tasklet);
 			}
-- 
2.20.1



