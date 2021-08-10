Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABC93E7F4D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhHJRjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234993AbhHJRix (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:38:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D72D61153;
        Tue, 10 Aug 2021 17:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617004;
        bh=K0wODNoz+RecPUHNbQX1zVaU8w3RmzPHCktPrvzONCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRNwGX5IDez9QAjw1WOyL3EgaA2vaEnq2kHKB555NNpLK76SlM9hK+3t2RZQxsMtr
         MCHhuixhJx03TbfW1hssVq7w+ZgO4Uziu/B11RNVDMutQaKpClHcfjqc3BnNrryQi9
         cbDiUTW/bZZV+zFtTWo/ey3oq0H3LlPdFf4khJQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.4 55/85] tpm_ftpm_tee: Free and unregister TEE shared memory during kexec
Date:   Tue, 10 Aug 2021 19:30:28 +0200
Message-Id: <20210810172950.097063274@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit dfb703ad2a8d366b829818a558337be779746575 upstream.

dma-buf backed shared memory cannot be reliably freed and unregistered
during a kexec operation even when tee_shm_free() is called on the shm
from a .shutdown hook. The problem occurs because dma_buf_put() calls
fput() which then uses task_work_add(), with the TWA_RESUME parameter,
to queue tee_shm_release() to be called before the current task returns
to user mode. However, the current task never returns to user mode
before the kexec completes so the memory is never freed nor
unregistered.

Use tee_shm_alloc_kernel_buf() to avoid dma-buf backed shared memory
allocation so that tee_shm_free() can directly call tee_shm_release().
This will ensure that the shm can be freed and unregistered during a
kexec operation.

Fixes: 09e574831b27 ("tpm/tpm_ftpm_tee: A driver for firmware TPM running inside TEE")
Fixes: 1760eb689ed6 ("tpm/tpm_ftpm_tee: add shutdown call back")
Cc: stable@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_ftpm_tee.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/tpm/tpm_ftpm_tee.c
+++ b/drivers/char/tpm/tpm_ftpm_tee.c
@@ -255,11 +255,11 @@ static int ftpm_tee_probe(struct platfor
 	pvt_data->session = sess_arg.session;
 
 	/* Allocate dynamic shared memory with fTPM TA */
-	pvt_data->shm = tee_shm_alloc(pvt_data->ctx,
-				      MAX_COMMAND_SIZE + MAX_RESPONSE_SIZE,
-				      TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+	pvt_data->shm = tee_shm_alloc_kernel_buf(pvt_data->ctx,
+						 MAX_COMMAND_SIZE +
+						 MAX_RESPONSE_SIZE);
 	if (IS_ERR(pvt_data->shm)) {
-		dev_err(dev, "%s: tee_shm_alloc failed\n", __func__);
+		dev_err(dev, "%s: tee_shm_alloc_kernel_buf failed\n", __func__);
 		rc = -ENOMEM;
 		goto out_shm_alloc;
 	}


