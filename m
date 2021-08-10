Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366083E7F69
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhHJRkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234815AbhHJRiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:38:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4186A60F94;
        Tue, 10 Aug 2021 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616986;
        bh=rGZAAZud7g183QE05V55OSjEt/5Nazlr+Sqq49jwqSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlP4WRw+aDeSGMtB+MuV3dDK8AHbb2zJfmARkye8tIcYNd99q57ZlMJfMhBDTAfsj
         fhNGRqD5i953e4Yc3sL62eUe328f/ixdYyck2v3JWJP8p9olOGv4JMIjilvWU5ndF6
         Yluk8x9iGcymdjnw+5d9KKcG0N19CRHUlHOPWFM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.4 53/85] tee: add tee_shm_alloc_kernel_buf()
Date:   Tue, 10 Aug 2021 19:30:26 +0200
Message-Id: <20210810172950.035313191@linuxfoundation.org>
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
@@ -219,6 +219,24 @@ struct tee_shm *tee_shm_priv_alloc(struc
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


