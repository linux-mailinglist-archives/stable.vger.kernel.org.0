Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25913E8023
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhHJRqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236183AbhHJRof (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D0F461101;
        Tue, 10 Aug 2021 17:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617182;
        bh=A+ZmOuKwtpvP7/Z98qWtfl5PW+bujj7O8LS/Hqb3aoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8W8slFzXzlnBTS55laRl5zbmJfgBY8JmKHW56NkIzZs/XTqUlEG/9na5LDCjpxiq
         N6nOspOhFNeqKNmK6sSdHzy9yqmk2dNuD82q7+kSoILlzSWJEQK90YTaGcWG/43DRN
         9GESciNv4z7xwf3PfwsSMgEmuz1za3UyoUlLwEgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.10 082/135] tee: add tee_shm_alloc_kernel_buf()
Date:   Tue, 10 Aug 2021 19:30:16 +0200
Message-Id: <20210810172958.531581012@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
@@ -193,6 +193,24 @@ err_dev_put:
 }
 EXPORT_SYMBOL_GPL(tee_shm_alloc);
 
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
@@ -332,6 +332,7 @@ void *tee_get_drvdata(struct tee_device
  * @returns a pointer to 'struct tee_shm'
  */
 struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags);
+struct tee_shm *tee_shm_alloc_kernel_buf(struct tee_context *ctx, size_t size);
 
 /**
  * tee_shm_register() - Register shared memory buffer


