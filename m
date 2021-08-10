Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95CA3E7E77
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhHJRdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232206AbhHJRdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35D2E60F56;
        Tue, 10 Aug 2021 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616766;
        bh=U9voHKdbdy7j3vhSy8C//XOKs1jcQG0JGPELGqh0ZNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVMKrmgAbTD6YRkEzxd+MmMUXjksxyHd6ppYJUfQeH5pFLyEQp6H7K++BLyVy8/he
         SMVKxQeSWno1M2Iy3mRcSNSWLrs8gRifkkJ2cX+xdZ3w5MvmVqxBRI2dsnmhM8GcUI
         36P8Z5s1cUDal7/gt6zsoBCeAXNO+T82UUHfvYvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 4.19 36/54] tee: add tee_shm_alloc_kernel_buf()
Date:   Tue, 10 Aug 2021 19:30:30 +0200
Message-Id: <20210810172945.369365872@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

commit dc7019b7d0e188d4093b34bd0747ed0d668c63bf upstream.

Adds a new function tee_shm_alloc_kernel_buf() to allocate shared memory
from a kernel driver. This function can later be made more lightweight
by unnecessary dma-buf export.

Cc: stable@vger.kernel.org
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_shm.c   |   18 ++++++++++++++++++
 include/linux/tee_drv.h |    1 +
 2 files changed, 19 insertions(+)

--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -228,6 +228,24 @@ struct tee_shm *tee_shm_priv_alloc(struc
 }
 EXPORT_SYMBOL_GPL(tee_shm_priv_alloc);
 
+/**
+ * tee_shm_alloc_kernel_buf() - Allocate shared memory for kernel buffer
+ * @ctx:	Context that allocates the shared memory
+ * @size:	Requested size of shared memory
+ *
+ * The returned memory registered in secure world and is suitable to be
+ * passed as a memory buffer in parameter argument to
+ * tee_client_invoke_func(). The memory allocated is later freed with a
+ * call to tee_shm_free().
+ *
+ * @returns a pointer to 'struct tee_shm'
+ */
+struct tee_shm *tee_shm_alloc_kernel_buf(struct tee_context *ctx, size_t size)
+{
+	return tee_shm_alloc(ctx, size, TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+}
+EXPORT_SYMBOL_GPL(tee_shm_alloc_kernel_buf);
+
 struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 				 size_t length, u32 flags)
 {
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -317,6 +317,7 @@ void *tee_get_drvdata(struct tee_device
  * @returns a pointer to 'struct tee_shm'
  */
 struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags);
+struct tee_shm *tee_shm_alloc_kernel_buf(struct tee_context *ctx, size_t size);
 
 /**
  * tee_shm_priv_alloc() - Allocate shared memory privately


