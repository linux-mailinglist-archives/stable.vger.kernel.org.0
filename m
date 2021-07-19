Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1413CE0D6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346921AbhGSPSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346580AbhGSPOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:14:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 914A26121F;
        Mon, 19 Jul 2021 15:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710120;
        bh=VYStZb8e9404AHNAgWv6sOmTs8wZRmv5JCZj+OUVclk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rD7QZC3+lp/aWp3pXhnGF2kAFERBKUDMAojoL0rLUXAtgHPD//ssSiGjQA+MumzMM
         uBix3l9cUMdy3Q1Ay2Fdcw0Q4GTqvXSAxoIXOnvfY7LekwAuTgZ2S2Gj1nyzl6pIP8
         Q5ccGxqLe0Z3iNve/1uYQn8KHFWqs1uLGdZ/uqc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/243] habanalabs/gaudi: set the correct cpu_id on MME2_QM failure
Date:   Mon, 19 Jul 2021 16:51:54 +0200
Message-Id: <20210719144943.640071847@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koby Elbaz <kelbaz@habana.ai>

[ Upstream commit b92c637c5f5ef7e3e21dbc7bfa7f1999450f3902 ]

This fix was applied since there was an incorrect reported CPU ID to GIC
such that an error in MME2 QMAN aliased to be an arriving from DMA0_QM.

Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 68f661aca3ff..044b2ae196f9 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -2164,7 +2164,7 @@ static void gaudi_init_mme_qman(struct hl_device *hdev, u32 mme_offset,
 
 		/* Configure RAZWI IRQ */
 		mme_id = mme_offset /
-				(mmMME1_QM_GLBL_CFG0 - mmMME0_QM_GLBL_CFG0);
+				(mmMME1_QM_GLBL_CFG0 - mmMME0_QM_GLBL_CFG0) / 2;
 
 		mme_qm_err_cfg = MME_QMAN_GLBL_ERR_CFG_MSG_EN_MASK;
 		if (hdev->stop_on_err) {
-- 
2.30.2



