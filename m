Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDA74012B1
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbhIFBWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238892AbhIFBVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 160FE610CC;
        Mon,  6 Sep 2021 01:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891230;
        bh=QGnjh3XPIh8bYFm4lHeIH8Vrts5kHz0cIN/fyO2v4Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuGr88kqtes/9Dm4Mi8gh8XxUcJ3tyheQJ1F8U1EedmIe9Y8/FJxYGd+g9eblRzpA
         td1xEi5bLPo3ErJ5bELRbDWuTi8VKe2HyxohBiqkmxqoeKkTk+4UuLQ5w9iFUqzbiX
         93RwKr5ZGRXt49BJBRjS/kd+lmhcd/Fvq8dV1ltUIaaL3eusrh69M2AkWmTBrhDUY7
         YE3MQVsOMmEcvJiv+Cu1lgOgoUhU1JwXn9sy9Qp9FNKLLWf/zKkj0PQqih7tBlf5pm
         6VhaCzviZ+OrXxfy56f0ZXqQ6DxrUMOt7W0Rkh9H2sm6GTQoIWGKk7HsmCOWD3YX1A
         dZGPXfMowIFhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 31/47] crypto: qat - handle both source of interrupt in VF ISR
Date:   Sun,  5 Sep 2021 21:19:35 -0400
Message-Id: <20210906011951.928679-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 0a73c762e1eee33a5e5dc0e3488f1b7cd17249b3 ]

The top half of the VF drivers handled only a source at the time.
If an interrupt for PF2VF and bundle occurred at the same time, the ISR
scheduled only the bottom half for PF2VF.
This patch fixes the VF top half so that if both sources of interrupt
trigger at the same time, both bottom halves are scheduled.

This patch is based on earlier work done by Conor McLoughlin.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 888388acb6bd..3e4f64d248f9 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -160,6 +160,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+	bool handled = false;
 	u32 v_int;
 
 	/* Read VF INT source CSR to determine the source of VF interrupt */
@@ -172,7 +173,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 
 		/* Schedule tasklet to handle interrupt BH */
 		tasklet_hi_schedule(&accel_dev->vf.pf2vf_bh_tasklet);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
 	/* Check bundle interrupt */
@@ -184,10 +185,10 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 		csr_ops->write_csr_int_flag_and_col(bank->csr_addr,
 						    bank->bank_number, 0);
 		tasklet_hi_schedule(&bank->resp_handler);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
-	return IRQ_NONE;
+	return handled ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int adf_request_msi_irq(struct adf_accel_dev *accel_dev)
-- 
2.30.2

