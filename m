Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0E596164
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfHTNrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730297AbfHTNlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:41:04 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DD702339E;
        Tue, 20 Aug 2019 13:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308463;
        bh=xDZTjVoZvCxRb8ybEkwNFnJ33mOFuIrB+A1ci7N1Izg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Su9UAqdjURdyJ739zQeWYkm3uiEWc4rmvcOhRPRjRy4+d0Xur+3RaMSbF07vg9Vmx
         XBMEeujy9OksFBYjDpnJ9yZJo7O72dYEDmersSDV1vEYO3Sg+iY3zRJ4TT+5Lo0iLX
         QeUTPZu5YQkz3MDiBdpEM6peGcDh/nSbXkXZEMhQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Atish Patra <atish.patra@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.2 27/44] dma-direct: don't truncate dma_required_mask to bus addressing capabilities
Date:   Tue, 20 Aug 2019 09:40:11 -0400
Message-Id: <20190820134028.10829-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit d8ad55538abe443919e20e0bb996561bca9cad84 ]

The dma required_mask needs to reflect the actual addressing capabilities
needed to handle the whole system RAM. When truncated down to the bus
addressing capabilities dma_addressing_limited() will incorrectly signal
no limitations for devices which are restricted by the bus_dma_mask.

Fixes: b4ebe6063204 (dma-direct: implement complete bus_dma_mask handling)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 2c2772e9702ab..9912be7a970de 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -55,9 +55,6 @@ u64 dma_direct_get_required_mask(struct device *dev)
 {
 	u64 max_dma = phys_to_dma_direct(dev, (max_pfn - 1) << PAGE_SHIFT);
 
-	if (dev->bus_dma_mask && dev->bus_dma_mask < max_dma)
-		max_dma = dev->bus_dma_mask;
-
 	return (1ULL << (fls64(max_dma) - 1)) * 2 - 1;
 }
 
-- 
2.20.1

