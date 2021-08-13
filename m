Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310453EB8E5
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242417AbhHMPSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242786AbhHMPQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:16:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2064160E9B;
        Fri, 13 Aug 2021 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867703;
        bh=E7wxtjAb81PF0LND7bzdoKazKry0KsHM2b7YkjrrFg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zp+m8zIzEWmERV1F1h2maCVxO7pXBWQKTp/xhAkXGalFCn5vdc5jirGHtvb9W4pdH
         uD0Gh/mJEtlByLy0zDO92GNV0eGI+NBzc994UcYLDrdDlP3ZLloRKuOE7jUUG9dwaf
         R3L6cXkfrlr3KmrkAbdZ6TMLcBUwrYu+DpIUgyRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 1/8] firmware: tee_bnxt: Release TEE shm, session, and context during kexec
Date:   Fri, 13 Aug 2021 17:07:38 +0200
Message-Id: <20210813150520.136583590@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.090373732@linuxfoundation.org>
References: <20210813150520.090373732@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

[ Upstream commit 914ab19e471d8fb535ed50dff108b0a615f3c2d8 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
Co-developed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/broadcom/tee_bnxt_fw.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/firmware/broadcom/tee_bnxt_fw.c
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -212,10 +212,9 @@ static int tee_bnxt_fw_probe(struct devi
 
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
@@ -242,6 +241,14 @@ static int tee_bnxt_fw_remove(struct dev
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
@@ -257,6 +264,7 @@ static struct tee_client_driver tee_bnxt
 		.bus		= &tee_bus_type,
 		.probe		= tee_bnxt_fw_probe,
 		.remove		= tee_bnxt_fw_remove,
+		.shutdown	= tee_bnxt_fw_shutdown,
 	},
 };
 


