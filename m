Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46B819B2FE
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbgDAQsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389669AbgDAQqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:46:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 738D121D7F;
        Wed,  1 Apr 2020 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759569;
        bh=5fy+DpjSqmh99XFyScJ450EPzLn3lYCObsESE/dMIBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xomS0Lm91rKHPhzjOr7pjVSuiKdRr4XNTIfFqywg+W0skD0LKnG+QaGeratf4pmLI
         zUjfFwUjVQyLt7VNZDnT7MkmuH07cZ1LjIn99+BwWcDxH+yGHELfX3ptSp5qgs/bSC
         IHbiCLpjrfhGH+UTqt3aMHgbFc5aEXim8G368SZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 080/148] fsl/fman: detect FMan erratum A050385
Date:   Wed,  1 Apr 2020 18:17:52 +0200
Message-Id: <20200401161600.921135761@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

[ Upstream commit b281f7b93b258ce1419043bbd898a29254d5c9c7 ]

Detect the presence of the A050385 erratum.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/Kconfig | 28 +++++++++++++++++++++
 drivers/net/ethernet/freescale/fman/fman.c  | 18 +++++++++++++
 drivers/net/ethernet/freescale/fman/fman.h  |  5 ++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/Kconfig b/drivers/net/ethernet/freescale/fman/Kconfig
index 8870a9a798ca4..91437b94bfcb6 100644
--- a/drivers/net/ethernet/freescale/fman/Kconfig
+++ b/drivers/net/ethernet/freescale/fman/Kconfig
@@ -8,3 +8,31 @@ config FSL_FMAN
 	help
 		Freescale Data-Path Acceleration Architecture Frame Manager
 		(FMan) support
+
+config DPAA_ERRATUM_A050385
+	bool
+	depends on ARM64 && FSL_DPAA
+	default y
+	help
+		DPAA FMan erratum A050385 software workaround implementation:
+		align buffers, data start, SG fragment length to avoid FMan DMA
+		splits.
+		FMAN DMA read or writes under heavy traffic load may cause FMAN
+		internal resource leak thus stopping further packet processing.
+		The FMAN internal queue can overflow when FMAN splits single
+		read or write transactions into multiple smaller transactions
+		such that more than 17 AXI transactions are in flight from FMAN
+		to interconnect. When the FMAN internal queue overflows, it can
+		stall further packet processing. The issue can occur with any
+		one of the following three conditions:
+		1. FMAN AXI transaction crosses 4K address boundary (Errata
+		A010022)
+		2. FMAN DMA address for an AXI transaction is not 16 byte
+		aligned, i.e. the last 4 bits of an address are non-zero
+		3. Scatter Gather (SG) frames have more than one SG buffer in
+		the SG list and any one of the buffers, except the last
+		buffer in the SG list has data size that is not a multiple
+		of 16 bytes, i.e., other than 16, 32, 48, 64, etc.
+		With any one of the above three conditions present, there is
+		likelihood of stalled FMAN packet processing, especially under
+		stress with multiple ports injecting line-rate traffic.
diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index 97425d94e280d..9080d2332d030 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2008-2015 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
@@ -566,6 +567,10 @@ struct fman_cfg {
 	u32 qmi_def_tnums_thresh;
 };
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+static bool fman_has_err_a050385;
+#endif
+
 static irqreturn_t fman_exceptions(struct fman *fman,
 				   enum fman_exceptions exception)
 {
@@ -2517,6 +2522,14 @@ struct fman *fman_bind(struct device *fm_dev)
 }
 EXPORT_SYMBOL(fman_bind);
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+bool fman_has_errata_a050385(void)
+{
+	return fman_has_err_a050385;
+}
+EXPORT_SYMBOL(fman_has_errata_a050385);
+#endif
+
 static irqreturn_t fman_err_irq(int irq, void *handle)
 {
 	struct fman *fman = (struct fman *)handle;
@@ -2843,6 +2856,11 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 		goto fman_free;
 	}
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+	fman_has_err_a050385 =
+		of_property_read_bool(fm_node, "fsl,erratum-a050385");
+#endif
+
 	return fman;
 
 fman_node_put:
diff --git a/drivers/net/ethernet/freescale/fman/fman.h b/drivers/net/ethernet/freescale/fman/fman.h
index bfa02e0014ae0..693401994fa2d 100644
--- a/drivers/net/ethernet/freescale/fman/fman.h
+++ b/drivers/net/ethernet/freescale/fman/fman.h
@@ -1,5 +1,6 @@
 /*
  * Copyright 2008-2015 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
@@ -397,6 +398,10 @@ u16 fman_get_max_frm(void);
 
 int fman_get_rx_extra_headroom(void);
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+bool fman_has_errata_a050385(void);
+#endif
+
 struct fman *fman_bind(struct device *dev);
 
 #endif /* __FM_H */
-- 
2.20.1



