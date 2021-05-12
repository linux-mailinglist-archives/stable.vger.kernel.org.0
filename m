Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB0737C17D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhELPA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhELO6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:58:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 478B761461;
        Wed, 12 May 2021 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831383;
        bh=PE01LIyECFqPjnY0GUwIa/Tan1yqYuihELgMAWizvOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XG9lEOJnCo7qBkCSEtIl2IsSNX0v2tHJZgPv88zwauZMrH1wqTAW/0YYs0KerWNXn
         SNAAixm7tffdPsgK4s4ACm9o/Y4fbnmsqsP8Mu1qlFOLkr37wAXU+bYX9f/tE5NCsE
         mCBo+KhopyjImaGc5J3JYDa6b15YPgIzSMjNCIUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/244] crypto: qat - fix error path in adf_isr_resource_alloc()
Date:   Wed, 12 May 2021 16:47:50 +0200
Message-Id: <20210512144746.203822670@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 83dc1173d73f80cbce2fee4d308f51f87b2f26ae ]

The function adf_isr_resource_alloc() is not unwinding correctly in case
of error.
This patch fixes the error paths and propagate the errors to the caller.

Fixes: 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc accelerator")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_isr.c | 29 ++++++++++++++++++-------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index cd1cdf5305bc..4898ef41fd9f 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -330,19 +330,32 @@ int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 
 	ret = adf_isr_alloc_msix_entry_table(accel_dev);
 	if (ret)
-		return ret;
-	if (adf_enable_msix(accel_dev))
 		goto err_out;
 
-	if (adf_setup_bh(accel_dev))
-		goto err_out;
+	ret = adf_enable_msix(accel_dev);
+	if (ret)
+		goto err_free_msix_table;
 
-	if (adf_request_irqs(accel_dev))
-		goto err_out;
+	ret = adf_setup_bh(accel_dev);
+	if (ret)
+		goto err_disable_msix;
+
+	ret = adf_request_irqs(accel_dev);
+	if (ret)
+		goto err_cleanup_bh;
 
 	return 0;
+
+err_cleanup_bh:
+	adf_cleanup_bh(accel_dev);
+
+err_disable_msix:
+	adf_disable_msix(&accel_dev->accel_pci_dev);
+
+err_free_msix_table:
+	adf_isr_free_msix_entry_table(accel_dev);
+
 err_out:
-	adf_isr_resource_free(accel_dev);
-	return -EFAULT;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_isr_resource_alloc);
-- 
2.30.2



