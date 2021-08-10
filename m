Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E608A3E812C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhHJR4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236665AbhHJRxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:53:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B0E2603E7;
        Tue, 10 Aug 2021 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617429;
        bh=j1a6Z+n+QRy7CFaUYhg8hxITUPRiaBKuXeJkfzOuPSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOGVytGdKZnlKLeFVuwLVUAboKd+Vs3AQjeddAgaMDFP9zOvglr1FZeJqttXmfJ75
         HOiOtObPMfUywvNv9Zc+pQyo8Y+hfsq4Oud1c+/c+aJk3TG90iXT7PdcbF3RH+D709
         fPwq4/AIw9piwizjzFcx4lEobVSUzV6+Y2a5l9x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 027/175] dmaengine: uniphier-xdmac: Use readl_poll_timeout_atomic() in atomic state
Date:   Tue, 10 Aug 2021 19:28:55 +0200
Message-Id: <20210810173001.853221605@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 55f24c27b6c1a840b62fe297616f1f9ea3576cb7 ]

The function uniphier_xdmac_chan_stop() is only called in atomic state.
Should use readl_poll_timeout_atomic() there instead of
readl_poll_timeout().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 667b9251440b ("dmaengine: uniphier-xdmac: Add UniPhier external DMA controller driver")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/1627364852-28432-1-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/uniphier-xdmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/uniphier-xdmac.c b/drivers/dma/uniphier-xdmac.c
index 16b19654873d..d6b8a202474f 100644
--- a/drivers/dma/uniphier-xdmac.c
+++ b/drivers/dma/uniphier-xdmac.c
@@ -209,8 +209,8 @@ static int uniphier_xdmac_chan_stop(struct uniphier_xdmac_chan *xc)
 	writel(0, xc->reg_ch_base + XDMAC_TSS);
 
 	/* wait until transfer is stopped */
-	return readl_poll_timeout(xc->reg_ch_base + XDMAC_STAT, val,
-				  !(val & XDMAC_STAT_TENF), 100, 1000);
+	return readl_poll_timeout_atomic(xc->reg_ch_base + XDMAC_STAT, val,
+					 !(val & XDMAC_STAT_TENF), 100, 1000);
 }
 
 /* xc->vc.lock must be held by caller */
-- 
2.30.2



