Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5891215812D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 18:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgBJRSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 12:18:33 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36233 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgBJRSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 12:18:32 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so4245288pgu.3
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 09:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y6NmftjpxuU8DIHGcF8Sy6nUgdGg3I29+tYuS1oxLVc=;
        b=rogV0YJkzU1ao2gnQPW49AalMlJ2mtJolftGxbH+FXdo/mzq7cNP0H90bQgc8ZY4yk
         gT+xeKZNIbRUNiYfbfNxU6v1YjcA8CBksGsRz8/IT7kzvfDUJNJ9gdk5hFYtcICEMKUC
         ahYGcq+Dae59aRsMqHbDLqvcPTyCQ1xgxtLgqaLIxoQ58qzRYvDfkkgqdClxIebLa1c9
         m3gYKwnQQ7ajCg3iVviaSn9WwuOkNCF5Nh2aiQmDNdtUKIybjTorv5YbjtIMrBbENxMH
         BJVtFO4w0V9D7i0dNublxOnLwwyWTwQJOk5oeZg5/NmHVTEoi40abdgs2AKUqH4QTzMR
         kfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6NmftjpxuU8DIHGcF8Sy6nUgdGg3I29+tYuS1oxLVc=;
        b=WZcI7IT1GJrYXwmg/y+0mSbmd3EZW04kN7MTbZNilvFMvVDdq2JLaBFRIgGWMGRx9N
         Y/Buz46RHZ/NTaz4yEwoBRg1blZgUt+RCARRchxv4ugXChXk7Yj18feBfulr77IUuRgU
         BDsvh9cdmAAkjKQybtuT4KnVuReta1gSJyXzT/d2dN91UQ304j7KGM5MmQMBQI7UsI80
         qsSL3CYDa8LLMfsFjQbEYWrFpR2e/8erqtTBx5D8+f0tRWKqj1Xz0J3N/n64sMByTbRN
         Z0QnPP1JzHVg+NhkLgrDDrG96opEU+d4cJAyfr+bgpWzKORYG147LSW3B2HkVTSXGcsR
         Mvkw==
X-Gm-Message-State: APjAAAXqdvr4wLMybDkwVOimiOzvxfP17yj99IMo6BRA1HgJHgJyVyJW
        dA6LfLsOfmYXmQTR/Lf9iTGdXC5sdpM=
X-Google-Smtp-Source: APXvYqwEzPFJUiu91QKzrTWysfxXYr68FlfUXMzEpLWsF11zCAznVjYcTcZw3640+4NDjZugKTSu8Q==
X-Received: by 2002:a63:e545:: with SMTP id z5mr2609769pgj.209.1581355111947;
        Mon, 10 Feb 2020 09:18:31 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u12sm927912pfm.165.2020.02.10.09.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 09:18:31 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [stable 4.19][PATCH 3/3] spi: spi-mem: Add extra sanity checks on the op param
Date:   Mon, 10 Feb 2020 10:18:27 -0700
Message-Id: <20200210171827.29693-4-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200210171827.29693-1-mathieu.poirier@linaro.org>
References: <20200210171827.29693-1-mathieu.poirier@linaro.org>
MIME-Version: 1.0
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
---
 drivers/spi/spi-mem.c | 54 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index eb72dba71d83..cc3d425aae56 100644
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

