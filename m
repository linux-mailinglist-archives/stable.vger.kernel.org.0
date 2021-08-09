Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2B53E41BF
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 10:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhHIImj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 04:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233926AbhHIImi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 04:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4816E60462;
        Mon,  9 Aug 2021 08:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628498537;
        bh=Gz7xbkkgzuTiQ00Ymgi4DMyVg0tmsMddhROilvF3/zs=;
        h=Subject:To:Cc:From:Date:From;
        b=FxO6R1/bN0ci04McVORxrOwf271CJfSfJaQVw2qKrXiPrjs86h38UAFqvdwMxIYyH
         EZyEjChfDjQf7SxTM6xRdp12OjZl94z3yXjPdQ30E6YWHL0dE/p5hC60RJL9cU5NVp
         2GRa6X10tEGza4jKVwKswqK15WwK+vm2nlQ7mFyA=
Subject: FAILED: patch "[PATCH] firmware: tee_bnxt: Release TEE shm, session, and context" failed to apply to 5.10-stable tree
To:     apais@linux.microsoft.com, f.fainelli@gmail.com,
        jens.wiklander@linaro.org, sumit.garg@linaro.org,
        tyhicks@linux.microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 10:42:15 +0200
Message-ID: <162849853529218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 914ab19e471d8fb535ed50dff108b0a615f3c2d8 Mon Sep 17 00:00:00 2001
From: Allen Pais <apais@linux.microsoft.com>
Date: Mon, 14 Jun 2021 17:33:17 -0500
Subject: [PATCH] firmware: tee_bnxt: Release TEE shm, session, and context
 during kexec

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
 

