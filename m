Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC0C1FB6C0
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbgFPPkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731069AbgFPPj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:39:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C53E821475;
        Tue, 16 Jun 2020 15:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321998;
        bh=rslNjUeVlj97qpEPQRjAVmForQmuPgw5erM9aaqm87g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHCQOzofcOskyBdKz1V9ZtPwOVJdSCbsS2wyXDO8Hgm5G2AHHzyVXi9JdGGbluDFJ
         ycit4+VHvKPvYTfLfGUnaCJH0XFg3GVrVpms3TWApFcv176KPnxyP4bNHcIf9jsZOh
         iycz8KkkwxWBmBk1LAUFFABpkxFp1qN2IP/VswFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Tero Kristo <t-kristo@ti.com>, Suman Anna <s-anna@ti.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.4 096/134] remoteproc: Fall back to using parent memory pool if no dedicated available
Date:   Tue, 16 Jun 2020 17:34:40 +0200
Message-Id: <20200616153105.380956788@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

commit db9178a4f8c4e523f824892cb8bab00961b07385 upstream.

In some cases, like with OMAP remoteproc, we are not creating dedicated
memory pool for the virtio device. Instead, we use the same memory pool
for all shared memories. The current virtio memory pool handling forces
a split between these two, as a separate device is created for it,
causing memory to be allocated from bad location if the dedicated pool
is not available. Fix this by falling back to using the parent device
memory pool if dedicated is not available.

Cc: stable@vger.kernel.org
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Fixes: 086d08725d34 ("remoteproc: create vdev subdevice with specific dma memory pool")
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Link: https://lore.kernel.org/r/20200420160600.10467-2-s-anna@ti.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/remoteproc_virtio.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -375,6 +375,18 @@ int rproc_add_virtio_dev(struct rproc_vd
 				goto out;
 			}
 		}
+	} else {
+		struct device_node *np = rproc->dev.parent->of_node;
+
+		/*
+		 * If we don't have dedicated buffer, just attempt to re-assign
+		 * the reserved memory from our parent. A default memory-region
+		 * at index 0 from the parent's memory-regions is assigned for
+		 * the rvdev dev to allocate from. Failure is non-critical and
+		 * the allocations will fall back to global pools, so don't
+		 * check return value either.
+		 */
+		of_reserved_mem_device_init_by_idx(dev, np, 0);
 	}
 
 	/* Allocate virtio device */


