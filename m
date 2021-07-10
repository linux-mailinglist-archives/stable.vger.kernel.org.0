Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6763C2F60
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhGJCbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234435AbhGJC31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEEC8613ED;
        Sat, 10 Jul 2021 02:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883991;
        bh=VYStZb8e9404AHNAgWv6sOmTs8wZRmv5JCZj+OUVclk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jndfw1CRQVLWY/BiLcQs6Blb1OGzlbXHioxsKuuPlcp/IKoN01ByH8OA8m7u/Xd5W
         odM0w2RQaPglRLsl/ZiS9SD+6kY0J8aQZWCM6xWpwdovBsYjf3ZFKrUBngtO2ZRZdV
         nyBD27IN/4Gq3KGL3zQCsmDHOOjEaOmqZrWbalL2OxI0yTZIhXa4rkaOWu3Gd4fbrK
         ylNCOvo7YGdF6oU85yr0RAM6uYkpS90P+Uds4Vp2/hgVOuHVSx0QQva6RMOAuUf9HD
         qtRk66UhE741disoU3QGU5zsRpieaG94Qot4SMDrXCjZ+Kch8OZBHGK6qQhPiHZ9ci
         ZysbMx95MtO1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koby Elbaz <kelbaz@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 67/93] habanalabs/gaudi: set the correct cpu_id on MME2_QM failure
Date:   Fri,  9 Jul 2021 22:24:01 -0400
Message-Id: <20210710022428.3169839-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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

