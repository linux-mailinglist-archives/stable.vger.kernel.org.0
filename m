Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC7815C410
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgBMP0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbgBMP0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:41 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E8562467C;
        Thu, 13 Feb 2020 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607599;
        bh=+QVZnJtxlSCcPybvmNQSvwJeR8KZBx8DCb6YD5bcGNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7kmCvv6bl9qp7HAyNL/NQF04SxodMHOs1HOuz+FAGdWVHjXc/rvDeMPxFdC8pdBI
         dI7qrOa8jldOWvo/nYbVFc7LFEI6YKx1vF0FkHHZ0ERGGhFjA4GIvE8OEpHjUrr0bi
         Tl4J+CYhYE1aSL0aXOwQG8pmmw+kTLk58Rjv2P2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/52] spi: spi-mem: Add extra sanity checks on the op param
Date:   Thu, 13 Feb 2020 07:20:59 -0800
Message-Id: <20200213151818.209846675@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@bootlin.com>

commit 380583227c0c7f52383b0cd5c0e2de93ed31d553 upstream

Some combinations are simply not valid and should be rejected before
the op is passed to the SPI controller driver.

Add an spi_mem_check_op() helper and use it in spi_mem_exec_op() and
spi_mem_supports_op() to make sure the spi-mem operation is valid.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c | 54 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index eb72dba71d832..cc3d425aae56c 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -12,6 +12,8 @@
 
 #include "internals.h"
 
+#define SPI_MEM_MAX_BUSWIDTH		4
+
 /**
  * spi_controller_dma_map_mem_op_data() - DMA-map the buffer attached to a
  *					  memory operation
@@ -149,6 +151,44 @@ static bool spi_mem_default_supports_op(struct spi_mem *mem,
 }
 EXPORT_SYMBOL_GPL(spi_mem_default_supports_op);
 
+static bool spi_mem_buswidth_is_valid(u8 buswidth)
+{
+	if (hweight8(buswidth) > 1 || buswidth > SPI_MEM_MAX_BUSWIDTH)
+		return false;
+
+	return true;
+}
+
+static int spi_mem_check_op(const struct spi_mem_op *op)
+{
+	if (!op->cmd.buswidth)
+		return -EINVAL;
+
+	if ((op->addr.nbytes && !op->addr.buswidth) ||
+	    (op->dummy.nbytes && !op->dummy.buswidth) ||
+	    (op->data.nbytes && !op->data.buswidth))
+		return -EINVAL;
+
+	if (spi_mem_buswidth_is_valid(op->cmd.buswidth) ||
+	    spi_mem_buswidth_is_valid(op->addr.buswidth) ||
+	    spi_mem_buswidth_is_valid(op->dummy.buswidth) ||
+	    spi_mem_buswidth_is_valid(op->data.buswidth))
+		return -EINVAL;
+
+	return 0;
+}
+
+static bool spi_mem_internal_supports_op(struct spi_mem *mem,
+					 const struct spi_mem_op *op)
+{
+	struct spi_controller *ctlr = mem->spi->controller;
+
+	if (ctlr->mem_ops && ctlr->mem_ops->supports_op)
+		return ctlr->mem_ops->supports_op(mem, op);
+
+	return spi_mem_default_supports_op(mem, op);
+}
+
 /**
  * spi_mem_supports_op() - Check if a memory device and the controller it is
  *			   connected to support a specific memory operation
@@ -166,12 +206,10 @@ EXPORT_SYMBOL_GPL(spi_mem_default_supports_op);
  */
 bool spi_mem_supports_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
-	struct spi_controller *ctlr = mem->spi->controller;
-
-	if (ctlr->mem_ops && ctlr->mem_ops->supports_op)
-		return ctlr->mem_ops->supports_op(mem, op);
+	if (spi_mem_check_op(op))
+		return false;
 
-	return spi_mem_default_supports_op(mem, op);
+	return spi_mem_internal_supports_op(mem, op);
 }
 EXPORT_SYMBOL_GPL(spi_mem_supports_op);
 
@@ -196,7 +234,11 @@ int spi_mem_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 	u8 *tmpbuf;
 	int ret;
 
-	if (!spi_mem_supports_op(mem, op))
+	ret = spi_mem_check_op(op);
+	if (ret)
+		return ret;
+
+	if (!spi_mem_internal_supports_op(mem, op))
 		return -ENOTSUPP;
 
 	if (ctlr->mem_ops) {
-- 
2.20.1



