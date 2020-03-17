Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDC418803C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgCQLI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgCQLI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:08:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A30220714;
        Tue, 17 Mar 2020 11:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443305;
        bh=t9QQ76NqKZgJALUj5Jije4qo+73U7SDPo0vnCf+Splo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQ8Hvg3uZhpDebFqiejxy95xDDc1jlLoDFazi4JghSgvQ+a+C4Ey0QN5DPsMoHPye
         15npOr9LvetiWrC9Pd0bmv0rPtFEfbRFh4Z9Rl6kRMk3V6IfrFoD7+2pzC3k4ey+JB
         0gNLt8/SpOwF/fS3SlHU0nyWGJUv8Pzxpd6BH8ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 041/151] fsl/fman: detect FMan erratum A050385
Date:   Tue, 17 Mar 2020 11:54:11 +0100
Message-Id: <20200317103329.535895824@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

commit b281f7b93b258ce1419043bbd898a29254d5c9c7 upstream.

Detect the presence of the A050385 erratum.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fman/Kconfig |   28 ++++++++++++++++++++++++++++
 drivers/net/ethernet/freescale/fman/fman.c  |   18 ++++++++++++++++++
 drivers/net/ethernet/freescale/fman/fman.h  |    5 +++++
 3 files changed, 51 insertions(+)

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
@@ -2518,6 +2523,14 @@ struct fman *fman_bind(struct device *fm
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
@@ -2845,6 +2858,11 @@ static struct fman *read_dts_node(struct
 		goto fman_free;
 	}
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+	fman_has_err_a050385 =
+		of_property_read_bool(fm_node, "fsl,erratum-a050385");
+#endif
+
 	return fman;
 
 fman_node_put:
--- a/drivers/net/ethernet/freescale/fman/fman.h
+++ b/drivers/net/ethernet/freescale/fman/fman.h
@@ -1,5 +1,6 @@
 /*
  * Copyright 2008-2015 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
@@ -398,6 +399,10 @@ u16 fman_get_max_frm(void);
 
 int fman_get_rx_extra_headroom(void);
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+bool fman_has_errata_a050385(void);
+#endif
+
 struct fman *fman_bind(struct device *dev);
 
 #endif /* __FM_H */


