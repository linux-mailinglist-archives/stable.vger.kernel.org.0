Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8E5499F94
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841617AbiAXW7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588114AbiAXWbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:31:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802BDC047CD5;
        Mon, 24 Jan 2022 12:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 471E0B811FB;
        Mon, 24 Jan 2022 20:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B56EC340E5;
        Mon, 24 Jan 2022 20:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057758;
        bh=JtuOwGjrs+4E0N1ONfB/JKaOLTOJtjSWdNVu1Zx8gZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwqv7bgQQXywz3tLgwsHYf5C6JZBWPVnHsmZGEEC3wlsGI8IZKZijUFd/9hstYG3C
         W7vbhMbtdXqL5NoIQE8LK8ynnkZcUnhhRQj6XSDE7SoXLWr312zuB+lq9y4z6aJZeH
         rPcTThsE3F/NHNKPE1k59ZJM1YE75TNACaFYA850=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.16 0069/1039] gpu: host1x: Add back arm_iommu_detach_device()
Date:   Mon, 24 Jan 2022 19:30:58 +0100
Message-Id: <20220124184127.487355503@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit d5185965c3b59073c4520bad7dd2adf725b9abba upstream.

Host1x DMA buffer isn't mapped properly when CONFIG_ARM_DMA_USE_IOMMU=y.
The memory management code of Host1x driver has a longstanding overhaul
overdue and it's not obvious where the problem is in this case. Hence
let's add back the old workaround which we already had sometime before.
It explicitly detaches Host1x device from the offending implicit IOMMU
domain. This fixes a completely broken Host1x DMA in case of ARM32
multiplatform kernel config.

Cc: stable@vger.kernel.org
Fixes: af1cbfb9bf0f ("gpu: host1x: Support DMA mapping of buffers")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/host1x/dev.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -18,6 +18,10 @@
 #include <trace/events/host1x.h>
 #undef CREATE_TRACE_POINTS
 
+#if IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)
+#include <asm/dma-iommu.h>
+#endif
+
 #include "bus.h"
 #include "channel.h"
 #include "debug.h"
@@ -238,6 +242,17 @@ static struct iommu_domain *host1x_iommu
 	struct iommu_domain *domain = iommu_get_domain_for_dev(host->dev);
 	int err;
 
+#if IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)
+	if (host->dev->archdata.mapping) {
+		struct dma_iommu_mapping *mapping =
+				to_dma_iommu_mapping(host->dev);
+		arm_iommu_detach_device(host->dev);
+		arm_iommu_release_mapping(mapping);
+
+		domain = iommu_get_domain_for_dev(host->dev);
+	}
+#endif
+
 	/*
 	 * We may not always want to enable IOMMU support (for example if the
 	 * host1x firewall is already enabled and we don't support addressing


