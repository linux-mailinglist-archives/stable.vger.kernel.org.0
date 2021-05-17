Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B999383418
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241249AbhEQPF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242520AbhEQPDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A436619FE;
        Mon, 17 May 2021 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261677;
        bh=tFNyq10aFjLKxkdQfvVDMHcpsWrHdWyO27jFvNNyyKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7X/qWCUdQFCNr7e+D/sNMvN/yA+TM0xBRqWEhod4CS/pHDUWOCinrepIcMl894nU
         UQaS9VRQDxOZZ0HuczXBeiP8jtZCjgibkxUT0/awtz4TibZRcbHAXxvebh5GpRDqnc
         tiURiFUD87uh7irqlvK4GzEVXDIisC7z6fAF+2rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 142/329] remoteproc: pru: Fixup interrupt-parent logic for fw events
Date:   Mon, 17 May 2021 16:00:53 +0200
Message-Id: <20210517140306.917198255@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit 6d1f2803cb6b414c2e45fa64d1fdad6b581e1e88 ]

The PRU firmware interrupt mapping logic in pru_handle_intrmap() uses
of_irq_find_parent() with PRU device node to get a handle to the PRUSS
Interrupt Controller at present. This logic however requires that the
PRU nodes always define a interrupt-parent property. This property is
neither a required/defined property as per the PRU remoteproc binding,
nor is relevant from a DT node point of view without any associated
interrupts. The current logic finds a wrong interrupt controller and
fails to perform proper mapping without any interrupt-parent property
in the PRU nodes.

Fix this logic to always find and use the sibling interrupt controller.
Also, while at this, fix the acquired interrupt controller device node
reference properly.

Fixes: c75c9fdac66e ("remoteproc: pru: Add support for PRU specific interrupt configuration")
Signed-off-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210407155641.5501-2-s-anna@ti.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/pru_rproc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
index dcb380e868df..9226b8f3fe14 100644
--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -284,7 +284,7 @@ static int pru_handle_intrmap(struct rproc *rproc)
 	struct pru_rproc *pru = rproc->priv;
 	struct pru_irq_rsc *rsc = pru->pru_interrupt_map;
 	struct irq_fwspec fwspec;
-	struct device_node *irq_parent;
+	struct device_node *parent, *irq_parent;
 	int i, ret = 0;
 
 	/* not having pru_interrupt_map is not an error */
@@ -312,9 +312,16 @@ static int pru_handle_intrmap(struct rproc *rproc)
 
 	/*
 	 * parse and fill in system event to interrupt channel and
-	 * channel-to-host mapping
+	 * channel-to-host mapping. The interrupt controller to be used
+	 * for these mappings for a given PRU remoteproc is always its
+	 * corresponding sibling PRUSS INTC node.
 	 */
-	irq_parent = of_irq_find_parent(pru->dev->of_node);
+	parent = of_get_parent(dev_of_node(pru->dev));
+	if (!parent)
+		return -ENODEV;
+
+	irq_parent = of_get_child_by_name(parent, "interrupt-controller");
+	of_node_put(parent);
 	if (!irq_parent) {
 		kfree(pru->mapped_irq);
 		return -ENODEV;
@@ -337,11 +344,13 @@ static int pru_handle_intrmap(struct rproc *rproc)
 			goto map_fail;
 		}
 	}
+	of_node_put(irq_parent);
 
 	return ret;
 
 map_fail:
 	pru_dispose_irq_mapping(pru);
+	of_node_put(irq_parent);
 
 	return ret;
 }
-- 
2.30.2



