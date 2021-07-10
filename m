Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD8D3C2E61
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhGJC06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233330AbhGJC0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 886B2613F3;
        Sat, 10 Jul 2021 02:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883825;
        bh=su+ean6I607AqDEYEzC7zDiFEXsPqEBzUVS+3JxkEHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkNAftUCx+Ikk8MEFllkOFPJTDIk1QJvHivkji8mqlovvj/MriAU7VJVIoTk2AmC/
         GbAAWgzv91gFWkBQvN6+eDV3f1G7XNj/g9lhWg+iwvAw2Nw49VxsnkZ9HJwzwpQbex
         bYQWxDoyZJisBIiwJDcb2ZpE3bFLvp4nxKWOPQJ1cLAVJykfwwjB/5+amQHH/Sawl0
         h/bKUJdtqDhExxuAke3Gk1rTlpKjwKmCvxRHNDTIqaAs897KicynSLLvhAGT8LwH9h
         O9tbLV2PcIXQI4bH+7D0aPBSr1TbIG1FOoMkGsFiOkc52/PHwZ8+KdiR/0AxRzn4Cg
         fdXX+IpCs0zIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koby Elbaz <kelbaz@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 073/104] habanalabs/gaudi: set the correct cpu_id on MME2_QM failure
Date:   Fri,  9 Jul 2021 22:21:25 -0400
Message-Id: <20210710022156.3168825-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ecdedd87f8cc..a03f13aa47f8 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -2801,7 +2801,7 @@ static void gaudi_init_mme_qman(struct hl_device *hdev, u32 mme_offset,
 
 		/* Configure RAZWI IRQ */
 		mme_id = mme_offset /
-				(mmMME1_QM_GLBL_CFG0 - mmMME0_QM_GLBL_CFG0);
+				(mmMME1_QM_GLBL_CFG0 - mmMME0_QM_GLBL_CFG0) / 2;
 
 		mme_qm_err_cfg = MME_QMAN_GLBL_ERR_CFG_MSG_EN_MASK;
 		if (hdev->stop_on_err) {
-- 
2.30.2

