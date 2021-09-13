Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1E9408DFE
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbhIMNa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240145AbhIMNT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:19:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1220C610F9;
        Mon, 13 Sep 2021 13:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539070;
        bh=Hsm9mGM0x9JEMYCfLLTPajKcPJITFrpKcTBZMtoxeFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlw71hc2P6XcMmSPzlEWOmKNaZX644h/z7V836N4o+Meo0jorsCp1vLcHDHa2KriJ
         hVFxQ09ScohZaF/mhaGbHIo3k4mo06U+JyHQO6XZYmOdLgt7Y84c+JFEDTbR6YCbGF
         d1pjzTqYYpmcR8nK+9hhz1kTSQ6r6NyNkYigh13o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/144] crypto: qat - handle both source of interrupt in VF ISR
Date:   Mon, 13 Sep 2021 15:13:24 +0200
Message-Id: <20210913131048.728316324@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index df9a1f35b832..ef90902c8200 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -203,6 +203,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+	bool handled = false;
 	u32 v_int;
 
 	/* Read VF INT source CSR to determine the source of VF interrupt */
@@ -215,7 +216,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 
 		/* Schedule tasklet to handle interrupt BH */
 		tasklet_hi_schedule(&accel_dev->vf.pf2vf_bh_tasklet);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
 	/* Check bundle interrupt */
@@ -227,10 +228,10 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 		WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
 					   0);
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



