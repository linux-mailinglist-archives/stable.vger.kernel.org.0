Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A483E83C4
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 21:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhHJTbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 15:31:53 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51940 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhHJTbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 15:31:53 -0400
Received: from sequoia.work.tihix.com (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 115A020B36ED;
        Tue, 10 Aug 2021 12:31:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 115A020B36ED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628623890;
        bh=Jo4bkU3JZ48IzKSd+0Xf1Zqzji5HYoMooXi1IpZfjs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R71lx7gV5BV0Ak/eWr254/bnZJNQ+azTAWUPGAyVZYshd+h7CvQA02Mb2qm29B6Gi
         Tf/Gix3qoC7pUuwYAJlkt4c2HTyslD7ln2Cwy8wRZqOTAJiMdyJSi/sOnvKCbbeLqp
         mf8n5qSz1sJTONfxm8qCXl+Ji/8aeuq+ce4izfLQ=
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     gregkh@linuxfoundation.org
Cc:     apais@linux.microsoft.com, f.fainelli@gmail.com,
        sumit.garg@linaro.org, jens.wiklander@linaro.org,
        stable@vger.kernel.org
Subject: [PATCH] firmware: tee_bnxt: Release TEE shm, session, and context during kexec
Date:   Tue, 10 Aug 2021 14:31:17 -0500
Message-Id: <20210810193117.1748334-1-tyhicks@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <162849853529218@kroah.com>
References: <162849853529218@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

commit 914ab19e471d8fb535ed50dff108b0a615f3c2d8 upstream.

Implement a .shutdown hook that will be called during a kexec operation
so that the TEE shared memory, session, and context that were set up
during .probe can be properly freed/closed.

Additionally, don't use dma-buf backed shared memory for the
fw_shm_pool. dma-buf backed shared memory cannot be reliably freed and
unregistered during a kexec operation even when tee_shm_free() is called
on the shm from a .shutdown hook. The problem occurs because
dma_buf_put() calls fput() which then uses task_work_add(), with the
TWA_RESUME parameter, to queue tee_shm_release() to be called before the
current task returns to user mode. However, the current task never
returns to user mode before the kexec completes so the memory is never
freed nor unregistered.

Use tee_shm_alloc_kernel_buf() to avoid dma-buf backed shared memory
allocation so that tee_shm_free() can directly call tee_shm_release().
This will ensure that the shm can be freed and unregistered during a
kexec operation.

Fixes: 246880958ac9 ("firmware: broadcom: add OP-TEE based BNXT f/w manager")
Cc: stable@vger.kernel.org # 5.10.x, 5.13.x
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
Co-developed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---

Hi Greg - Please include this backported patch in the 5.10-stable and
5.13-stable queues since the upstream commit couldn't be automatically
backported. We've been using this backported version of the patch on top
of 5.10.54 and it has received real world usage in production
environments.

 drivers/firmware/broadcom/tee_bnxt_fw.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
index ed10da5313e8..a5bf4c3f6dc7 100644
--- a/drivers/firmware/broadcom/tee_bnxt_fw.c
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -212,10 +212,9 @@ static int tee_bnxt_fw_probe(struct device *dev)
 
 	pvt_data.dev = dev;
 
-	fw_shm_pool = tee_shm_alloc(pvt_data.ctx, MAX_SHM_MEM_SZ,
-				    TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+	fw_shm_pool = tee_shm_alloc_kernel_buf(pvt_data.ctx, MAX_SHM_MEM_SZ);
 	if (IS_ERR(fw_shm_pool)) {
-		dev_err(pvt_data.dev, "tee_shm_alloc failed\n");
+		dev_err(pvt_data.dev, "tee_shm_alloc_kernel_buf failed\n");
 		err = PTR_ERR(fw_shm_pool);
 		goto out_sess;
 	}
@@ -242,6 +241,14 @@ static int tee_bnxt_fw_remove(struct device *dev)
 	return 0;
 }
 
+static void tee_bnxt_fw_shutdown(struct device *dev)
+{
+	tee_shm_free(pvt_data.fw_shm_pool);
+	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
+	tee_client_close_context(pvt_data.ctx);
+	pvt_data.ctx = NULL;
+}
+
 static const struct tee_client_device_id tee_bnxt_fw_id_table[] = {
 	{UUID_INIT(0x6272636D, 0x2019, 0x0716,
 		    0x42, 0x43, 0x4D, 0x5F, 0x53, 0x43, 0x48, 0x49)},
@@ -257,6 +264,7 @@ static struct tee_client_driver tee_bnxt_fw_driver = {
 		.bus		= &tee_bus_type,
 		.probe		= tee_bnxt_fw_probe,
 		.remove		= tee_bnxt_fw_remove,
+		.shutdown	= tee_bnxt_fw_shutdown,
 	},
 };
 
-- 
2.25.1

