Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D466A37C42B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhELP3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234224AbhELPXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EADB619B1;
        Wed, 12 May 2021 15:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832182;
        bh=yAmlWdb299FJodNRN8GhWQJ1o+7IO7byyt8e5N+4DBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6vO0B5+XysC9H0kh66LkT+SS4AG6qp49Sp97BPRuqi5ncObw1B0VAVvABpZRkQkB
         Bxz0BOGXV2UbrPs9/YxlmeJohejxRbfcF4l0yjebC9M1l8ItfmikPCDqT6m1LJ7Kq4
         YB5pVSJhMVKpzIA9dast51MsPb8kMPcmNVFIA2+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/530] crypto: qat - dont release uninitialized resources
Date:   Wed, 12 May 2021 16:44:44 +0200
Message-Id: <20210512144825.550766240@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit b66accaab3791e15ac99c92f236d0d3a6d5bd64e ]

adf_vf_isr_resource_alloc() is not unwinding correctly when error
happens and it want to release uninitialized resources.
To fix this, only release initialized resources.

[    1.792845] Trying to free already-free IRQ 11
[    1.793091] WARNING: CPU: 0 PID: 182 at kernel/irq/manage.c:1821 free_irq+0x202/0x380
[    1.801340] Call Trace:
[    1.801477]  adf_vf_isr_resource_free+0x32/0xb0 [intel_qat]
[    1.801785]  adf_vf_isr_resource_alloc+0x14d/0x150 [intel_qat]
[    1.802105]  adf_dev_init+0xba/0x140 [intel_qat]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Fixes: dd0f368398ea ("crypto: qat - Add qat dh895xcc VF driver")
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index c4a44dc6af3e..31a36288623a 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -260,17 +260,26 @@ int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 		goto err_out;
 
 	if (adf_setup_pf2vf_bh(accel_dev))
-		goto err_out;
+		goto err_disable_msi;
 
 	if (adf_setup_bh(accel_dev))
-		goto err_out;
+		goto err_cleanup_pf2vf_bh;
 
 	if (adf_request_msi_irq(accel_dev))
-		goto err_out;
+		goto err_cleanup_bh;
 
 	return 0;
+
+err_cleanup_bh:
+	adf_cleanup_bh(accel_dev);
+
+err_cleanup_pf2vf_bh:
+	adf_cleanup_pf2vf_bh(accel_dev);
+
+err_disable_msi:
+	adf_disable_msi(accel_dev);
+
 err_out:
-	adf_vf_isr_resource_free(accel_dev);
 	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(adf_vf_isr_resource_alloc);
-- 
2.30.2



