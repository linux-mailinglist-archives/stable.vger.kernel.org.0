Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2585310DA6
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 17:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhBEOax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 09:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhBEO2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:28:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6922365013;
        Fri,  5 Feb 2021 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534248;
        bh=9erNqEszCSdiqeuy4x4zFS4PPl6fhA4J97iiuei19+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/SX+qsbYZdd5h93+5vDwuVYpCQRyhFJxfoORIcXtHifQT6APTXiJW+fQmbJ91pyd
         ArCtVQQMVPcZq5L0M7pspRcw/H9J4bZpEgIwbmtFYHt6vbbhNtO+Pdi6hSqS60mOVE
         I0utAjRyfDU18wynJ2hMijf7hKhyisUV7N/xEiu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Klaus Jensen <k.jensen@samsung.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/57] nvme-pci: allow use of cmb on v1.4 controllers
Date:   Fri,  5 Feb 2021 15:07:08 +0100
Message-Id: <20210205140657.782495653@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Klaus Jensen <k.jensen@samsung.com>

[ Upstream commit 20d3bb92e84d417b0494a3b6867f0c86713db257 ]

Since NVMe v1.4 the Controller Memory Buffer must be explicitly enabled
by the host.

Signed-off-by: Klaus Jensen <k.jensen@samsung.com>
[hch: avoid a local variable and add a comment]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 14 ++++++++++++++
 include/linux/nvme.h    |  6 ++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 77f615568194d..a3486c1c27f0c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -23,6 +23,7 @@
 #include <linux/t10-pi.h>
 #include <linux/types.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/sed-opal.h>
 #include <linux/pci-p2pdma.h>
 
@@ -1825,6 +1826,9 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (dev->cmb_size)
 		return;
 
+	if (NVME_CAP_CMBS(dev->ctrl.cap))
+		writel(NVME_CMBMSC_CRE, dev->bar + NVME_REG_CMBMSC);
+
 	dev->cmbsz = readl(dev->bar + NVME_REG_CMBSZ);
 	if (!dev->cmbsz)
 		return;
@@ -1838,6 +1842,16 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (offset > bar_size)
 		return;
 
+	/*
+	 * Tell the controller about the host side address mapping the CMB,
+	 * and enable CMB decoding for the NVMe 1.4+ scheme:
+	 */
+	if (NVME_CAP_CMBS(dev->ctrl.cap)) {
+		hi_lo_writeq(NVME_CMBMSC_CRE | NVME_CMBMSC_CMSE |
+			     (pci_bus_address(pdev, bar) + offset),
+			     dev->bar + NVME_REG_CMBMSC);
+	}
+
 	/*
 	 * Controllers may support a CMB size larger than their BAR,
 	 * for example, due to being behind a bridge. Reduce the CMB to
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index d925359976873..bfed36e342ccb 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -116,6 +116,9 @@ enum {
 	NVME_REG_BPMBL	= 0x0048,	/* Boot Partition Memory Buffer
 					 * Location
 					 */
+	NVME_REG_CMBMSC = 0x0050,	/* Controller Memory Buffer Memory
+					 * Space Control
+					 */
 	NVME_REG_PMRCAP	= 0x0e00,	/* Persistent Memory Capabilities */
 	NVME_REG_PMRCTL	= 0x0e04,	/* Persistent Memory Region Control */
 	NVME_REG_PMRSTS	= 0x0e08,	/* Persistent Memory Region Status */
@@ -135,6 +138,7 @@ enum {
 #define NVME_CAP_CSS(cap)	(((cap) >> 37) & 0xff)
 #define NVME_CAP_MPSMIN(cap)	(((cap) >> 48) & 0xf)
 #define NVME_CAP_MPSMAX(cap)	(((cap) >> 52) & 0xf)
+#define NVME_CAP_CMBS(cap)	(((cap) >> 57) & 0x1)
 
 #define NVME_CMB_BIR(cmbloc)	((cmbloc) & 0x7)
 #define NVME_CMB_OFST(cmbloc)	(((cmbloc) >> 12) & 0xfffff)
@@ -192,6 +196,8 @@ enum {
 	NVME_CSTS_SHST_OCCUR	= 1 << 2,
 	NVME_CSTS_SHST_CMPLT	= 2 << 2,
 	NVME_CSTS_SHST_MASK	= 3 << 2,
+	NVME_CMBMSC_CRE		= 1 << 0,
+	NVME_CMBMSC_CMSE	= 1 << 1,
 };
 
 struct nvme_id_power_state {
-- 
2.27.0



