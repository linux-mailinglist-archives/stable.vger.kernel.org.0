Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691E838A8E5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238576AbhETKzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239225AbhETKws (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5E406162F;
        Thu, 20 May 2021 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504833;
        bh=mNUqNGiKV212dBD9fc785TCFIjxireFpvZyBcHMWFQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKeF3lT+tYfuwzLUWkKaYITb9/o7nR9z3K+TjYBsLggNAM4lmNIanujy5c7TFH3eX
         r9gAlVe7v+swKMlRACG8uMq/hA4jVbPVzuwaU7+efyKGmeAM7et/JxwEQaCVUKORHr
         FlGfQyhVY2qhTS+rApBvrzG9lFz15HUXJ4QvYohc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 100/240] crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init
Date:   Thu, 20 May 2021 11:21:32 +0200
Message-Id: <20210520092112.056611052@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 8609f5cfdc872fc3a462efa6a3eca5cb1e2f6446 ]

ADF_STATUS_PF_RUNNING is (only) used and checked by adf_vf2pf_shutdown()
before calling adf_iov_putmsg()->mutex_lock(vf2pf_lock), however the
vf2pf_lock is initialized in adf_dev_init(), which can fail and when it
fail, the vf2pf_lock is either not initialized or destroyed, a subsequent
use of vf2pf_lock will cause issue.
To fix this issue, only set this flag if adf_dev_init() returns 0.

[    7.178404] BUG: KASAN: user-memory-access in __mutex_lock.isra.0+0x1ac/0x7c0
[    7.180345] Call Trace:
[    7.182576]  mutex_lock+0xc9/0xd0
[    7.183257]  adf_iov_putmsg+0x118/0x1a0 [intel_qat]
[    7.183541]  adf_vf2pf_shutdown+0x4d/0x7b [intel_qat]
[    7.183834]  adf_dev_shutdown+0x172/0x2b0 [intel_qat]
[    7.184127]  adf_probe+0x5e9/0x600 [qat_dh895xccvf]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Fixes: 25c6ffb249f6 ("crypto: qat - check if PF is running")
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 4 ++--
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 4 ++--
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 0dd8d2dc2ec1..26931325dfa2 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -238,12 +238,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index cd9e63468b18..722a06aac9fa 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -238,12 +238,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 15de9cbed3bf..cc3f5171a523 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -238,12 +238,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
-- 
2.30.2



