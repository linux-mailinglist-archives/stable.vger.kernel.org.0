Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADAB364277
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbhDSNJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239513AbhDSNJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C94EB61246;
        Mon, 19 Apr 2021 13:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837715;
        bh=9fit+ZwLq+cZsxsHwump4B0ialnZx1ujVbYkJm6BlLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJ73KC4+9F/Ps7T3Q6cOYr7uGlgHifPfMa4WftdxPC1DURepFIDg3MRa3oG0IWcjk
         QJ19raYmR/KZCXe1UhJvfmUj6LLuZeXOnZraTU8jKHvHd4KM2HRnxfmcy5A/buhGA2
         TPCrUieZN0A7TWNv9B1x+oSYNvAfwIvN6Qwf0vLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 007/122] dmaengine: idxd: Fix clobbering of SWERR overflow bit on writeback
Date:   Mon, 19 Apr 2021 15:04:47 +0200
Message-Id: <20210419130530.423797059@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit ea941ac294d75d0ace50797aebf0056f6f8f7a7f ]

Current code blindly writes over the SWERR and the OVERFLOW bits. Write
back the bits actually read instead so the driver avoids clobbering the
OVERFLOW bit that comes after the register is read.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Reported-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161352082229.3511254.1002151220537623503.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index a60ca11a5784..f1463fc58112 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -124,7 +124,9 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 		for (i = 0; i < 4; i++)
 			idxd->sw_err.bits[i] = ioread64(idxd->reg_base +
 					IDXD_SWERR_OFFSET + i * sizeof(u64));
-		iowrite64(IDXD_SWERR_ACK, idxd->reg_base + IDXD_SWERR_OFFSET);
+
+		iowrite64(idxd->sw_err.bits[0] & IDXD_SWERR_ACK,
+			  idxd->reg_base + IDXD_SWERR_OFFSET);
 
 		if (idxd->sw_err.valid && idxd->sw_err.wq_idx_valid) {
 			int id = idxd->sw_err.wq_idx;
-- 
2.30.2



