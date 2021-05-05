Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CBF373A6C
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhEEMKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233321AbhEEMJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC8E6139A;
        Wed,  5 May 2021 12:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216521;
        bh=Yf0zVo/dlPirZVH2nGeno4UG/jo8lP2Tgi6DLoz+/rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0epiyvyeoc8Beba7TZ7PTZHIQT9m7MmHJO7tH8hzGzkhMOIUe4RswY6a27FBs+9U6
         JnnMTlhtqy6hfALG2idg/OJus2Hzc3DD2/S/fUzqsrG0RVBb9vc+91BuL8LAbyvA8m
         4kYUROC1exkzG3ktESnLDvz22bjmEQd6bdZEyHxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianxiong Gao <jxgao@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5.11 13/31] driver core: add a min_align_mask field to struct device_dma_parameters
Date:   Wed,  5 May 2021 14:06:02 +0200
Message-Id: <20210505112327.097349074@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianxiong Gao <jxgao@google.com>

commit: 36950f2da1ea4cb683be174f6f581e25b2d33e71

Some devices rely on the address offset in a page to function
correctly (NVMe driver as an example). These devices may use
a different page size than the Linux kernel. The address offset
has to be preserved upon mapping, and in order to do so, we
need to record the page_offset_mask first.

Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h      |    1 +
 include/linux/dma-mapping.h |   16 ++++++++++++++++
 2 files changed, 17 insertions(+)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -291,6 +291,7 @@ struct device_dma_parameters {
 	 * sg limitations.
 	 */
 	unsigned int max_segment_size;
+	unsigned int min_align_mask;
 	unsigned long segment_boundary_mask;
 };
 
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -500,6 +500,22 @@ static inline int dma_set_seg_boundary(s
 	return -EIO;
 }
 
+static inline unsigned int dma_get_min_align_mask(struct device *dev)
+{
+	if (dev->dma_parms)
+		return dev->dma_parms->min_align_mask;
+	return 0;
+}
+
+static inline int dma_set_min_align_mask(struct device *dev,
+		unsigned int min_align_mask)
+{
+	if (WARN_ON_ONCE(!dev->dma_parms))
+		return -EIO;
+	dev->dma_parms->min_align_mask = min_align_mask;
+	return 0;
+}
+
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_DMA_MINALIGN


