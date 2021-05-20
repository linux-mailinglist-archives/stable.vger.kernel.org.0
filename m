Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF0338AAC3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240288AbhETLRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240670AbhETLPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 816BE61D59;
        Thu, 20 May 2021 10:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505338;
        bh=ou+ENJV3i4smoiBloGJ1ZtjRG07d5GSqNtGIYXSHB/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpxObpozKvb/bTkrdFoC8CkLTZuY6qdb0Rt9IlSmedp3kkK4glhbQDiCtT9QsqnJ8
         /ksOtNw0dOq1Gv4zAt/rOdvmiC9W78fNyq9jj9EOQVXxvG2+FLX27mCZMM85pwc75G
         4Y6B6cSaGCdwDwhmHIYLpBqZJ0RnD0LqR2JfjxTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 090/190] crypto: qat - fix error path in adf_isr_resource_alloc()
Date:   Thu, 20 May 2021 11:22:34 +0200
Message-Id: <20210520092105.182195486@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c | 29 ++++++++++++++++-------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
index 5570f78795c1..ddbb43da1a13 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
@@ -315,18 +315,31 @@ int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 
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
-- 
2.30.2



