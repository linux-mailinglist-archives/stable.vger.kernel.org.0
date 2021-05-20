Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFCB38AABB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239742AbhETLQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240588AbhETLO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE7D261D53;
        Thu, 20 May 2021 10:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505320;
        bh=mm6V7jTVqyfkYM37+H9mcbPuLHSTEq9joh/dDz7BSXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuAvh9em52bdiATjHKzPL86ICwiDSngRcaSfWgFnVn38MfUZOspAJixVKV75A22Mj
         S8A4f3a1r6zzY6s1Z+NG34daaItuP+fNZrEJjJP3m2srz5FZX86+rtkWBREpIrLSFA
         xYJP/waOkgEkGPlq4WYMs+Lw2abuiu2NSHZdyKqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 082/190] crypto: qat - dont release uninitialized resources
Date:   Thu, 20 May 2021 11:22:26 +0200
Message-Id: <20210520092104.907887953@linuxfoundation.org>
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
 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c b/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
index 87c5d8adb125..32f9c2b79681 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
@@ -243,16 +243,25 @@ int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
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
-- 
2.30.2



