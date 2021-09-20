Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB2C411D1E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344355AbhITRQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347610AbhITRO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:14:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97A67619F9;
        Mon, 20 Sep 2021 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157090;
        bh=89w5O5mvEhMy/uHuvN0tJIllL74mrZOos3Otfw4qbzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gy0dm4S4+IAsp/D1QPCxGSHhqfd1cMgMXDwG3XIelco3w4rV51czZJkWFyD7YyZMh
         w/IHSShIic7HKtouhcSJq7qlika7/43cLNTUVQuDl3Mm+QR/DGv09Pv5GFhLpUg7+1
         /Dg9V5cxE3tgp2dC9H8DEwNTr49YezLs2/+Q4eEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 049/217] crypto: qat - use proper type for vf_mask
Date:   Mon, 20 Sep 2021 18:41:10 +0200
Message-Id: <20210920163926.286272039@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 462354d986b6a89c6449b85f17aaacf44e455216 ]

Replace vf_mask type with unsigned long to avoid a stack-out-of-bound.

This is to fix the following warning reported by KASAN the first time
adf_msix_isr_ae() gets called.

    [  692.091987] BUG: KASAN: stack-out-of-bounds in find_first_bit+0x28/0x50
    [  692.092017] Read of size 8 at addr ffff88afdf789e60 by task swapper/32/0
    [  692.092076] Call Trace:
    [  692.092089]  <IRQ>
    [  692.092101]  dump_stack+0x9c/0xcf
    [  692.092132]  print_address_description.constprop.0+0x18/0x130
    [  692.092164]  ? find_first_bit+0x28/0x50
    [  692.092185]  kasan_report.cold+0x7f/0x111
    [  692.092213]  ? static_obj+0x10/0x80
    [  692.092234]  ? find_first_bit+0x28/0x50
    [  692.092262]  find_first_bit+0x28/0x50
    [  692.092288]  adf_msix_isr_ae+0x16e/0x230 [intel_qat]

Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_isr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 2c0be14309cf..7877ba677220 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -59,6 +59,8 @@
 #include "adf_transport_access_macros.h"
 #include "adf_transport_internal.h"
 
+#define ADF_MAX_NUM_VFS	32
+
 static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
@@ -111,7 +113,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 		struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 		void __iomem *pmisc_bar_addr = pmisc->virt_addr;
-		u32 vf_mask;
+		unsigned long vf_mask;
 
 		/* Get the interrupt sources triggered by VFs */
 		vf_mask = ((ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU5) &
@@ -132,8 +134,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 			 * unless the VF is malicious and is attempting to
 			 * flood the host OS with VF2PF interrupts.
 			 */
-			for_each_set_bit(i, (const unsigned long *)&vf_mask,
-					 (sizeof(vf_mask) * BITS_PER_BYTE)) {
+			for_each_set_bit(i, &vf_mask, ADF_MAX_NUM_VFS) {
 				vf_info = accel_dev->pf.vf_info + i;
 
 				if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
-- 
2.30.2



