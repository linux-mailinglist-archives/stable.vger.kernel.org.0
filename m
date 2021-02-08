Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6955631379F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhBHP2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233882AbhBHPX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DD264F0D;
        Mon,  8 Feb 2021 15:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797259;
        bh=VCP2BdcDMCLOM2jMjfkSqwT1vdsv3Yzv0WvdlgvYLgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbuJNaVJcazXntSz2ns0hQr/v5vZqZk4NkvBae+Hjh/Traa+Ax7XDpiri3Bo0wb4m
         H06RoWdaCs4Y78fO+OCp6aqvjLuPsDg94MgP4nLvoAJ5Em+OOskox8Hq1V0zNQTGZr
         YiJLbb/UoF7oOEooh2yFOenMyuqcSfz4CSy9FKMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/120] net: ipa: pass correct dma_handle to dma_free_coherent()
Date:   Mon,  8 Feb 2021 16:00:34 +0100
Message-Id: <20210208145820.298703097@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4ace7a6e287b7e3b33276cd9fe870c326f880480 ]

The "ring->addr = addr;" assignment is done a few lines later so we
can't use "ring->addr" yet.  The correct dma_handle is "addr".

Fixes: 650d1603825d ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/YBjpTU2oejkNIULT@mwanda
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 6bfac1efe037c..4a68da7115d19 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1256,7 +1256,7 @@ static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
 	/* Hardware requires a 2^n ring size, with alignment equal to size */
 	ring->virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
 	if (ring->virt && addr % size) {
-		dma_free_coherent(dev, size, ring->virt, ring->addr);
+		dma_free_coherent(dev, size, ring->virt, addr);
 		dev_err(dev, "unable to alloc 0x%zx-aligned ring buffer\n",
 			size);
 		return -EINVAL;	/* Not a good error value, but distinct */
-- 
2.27.0



