Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BAC1FB9DA
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732298AbgFPPrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732294AbgFPPrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:47:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 224BE21475;
        Tue, 16 Jun 2020 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322430;
        bh=Ww/3zxU6fbSSh6OUodW4LyHhRVCSyKXuqOzIlIhcuJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7YOepvPI6Cz7Uk7/oWLgovUDCIXOE45tXh7BC5tQtHFUgTYABpPrq+6V/5LDO7gm
         vqX72KNbfuLoF4Z2rSdH95bi3fGvrE+hukeRrjyJ+Gcz6X4i9Jq7wniH2WKebyVp4p
         kJfaf+X2W1bv4wHgVjNZ+/NOKWWq3qiPDq7R/eEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.7 121/163] remoteproc: Fix and restore the parenting hierarchy for vdev
Date:   Tue, 16 Jun 2020 17:34:55 +0200
Message-Id: <20200616153112.607448077@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

commit c774ad010873bb89dcc0cdcb1e96aef6664d8caf upstream.

The commit 086d08725d34 ("remoteproc: create vdev subdevice with specific
dma memory pool") has introduced a new vdev subdevice for each vdev
declared in the firmware resource table and made it as the parent for the
created virtio rpmsg devices instead of the previous remoteproc device.
This changed the overall parenting hierarchy for the rpmsg devices, which
were children of virtio devices, and does not allow the corresponding
rpmsg drivers to retrieve the parent rproc device through the
rproc_get_by_child() API.

Fix this by restoring the remoteproc device as the parent. The new vdev
subdevice can continue to inherit the DMA attributes from the remoteproc's
parent device (actual platform device).

Cc: stable@vger.kernel.org
Fixes: 086d08725d34 ("remoteproc: create vdev subdevice with specific dma memory pool")
Signed-off-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Link: https://lore.kernel.org/r/20200420160600.10467-3-s-anna@ti.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/remoteproc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -517,7 +517,7 @@ static int rproc_handle_vdev(struct rpro
 
 	/* Initialise vdev subdevice */
 	snprintf(name, sizeof(name), "vdev%dbuffer", rvdev->index);
-	rvdev->dev.parent = rproc->dev.parent;
+	rvdev->dev.parent = &rproc->dev;
 	rvdev->dev.dma_pfn_offset = rproc->dev.parent->dma_pfn_offset;
 	rvdev->dev.release = rproc_rvdev_release;
 	dev_set_name(&rvdev->dev, "%s#%s", dev_name(rvdev->dev.parent), name);


