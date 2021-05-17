Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DE8383492
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239607AbhEQPKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241637AbhEQPG4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:06:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD55B613DF;
        Mon, 17 May 2021 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261750;
        bh=xLutIPXd40xSoRJUslveawDzG4kGbUS0s7SQymDKaeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkhswymTxC50ATrkZyRMu4dN3DvGJwM+axLwve2Uo7TMQQhC4+jaFR+NW22P4f5l7
         jVoVRk+SbQy0BCUZEAPJ1H99/7GDFwTLtTR53KP/nQ6yLMgZRykTpZpoX4fmUbK/Jd
         7U3rNDU/qekZdNd+LWDOhi3h2yigwwhZDJ4n71EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Suman Anna <s-anna@ti.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 144/329] remoteproc: pru: Fix and cleanup firmware interrupt mapping logic
Date:   Mon, 17 May 2021 16:00:55 +0200
Message-Id: <20210517140306.982532096@linuxfoundation.org>
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

[ Upstream commit 880a66e026fbe6a17cd59fe0ee942bbad62a6c26 ]

The PRU firmware interrupt mappings are configured and unconfigured in
.start() and .stop() callbacks respectively using the variables 'evt_count'
and a 'mapped_irq' pointer. These variables are modified only during these
callbacks but are not re-initialized/reset properly during unwind or
failure paths. These stale values caused a kernel crash while stopping a
PRU remoteproc running a different firmware with no events on a subsequent
run after a previous run that was running a firmware with events.

Fix this crash by ensuring that the evt_count is 0 and the mapped_irq
pointer is set to NULL in pru_dispose_irq_mapping(). Also, reset these
variables properly during any failures in the .start() callback. While
at this, the pru_dispose_irq_mapping() callsites are all made to look
the same, moving any conditional logic to inside the function.

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: c75c9fdac66e ("remoteproc: pru: Add support for PRU specific interrupt configuration")
Reported-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Link: https://lore.kernel.org/r/20210407155641.5501-4-s-anna@ti.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/pru_rproc.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
index dcd5ea0d1f37..549ed3fed625 100644
--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -266,12 +266,17 @@ static void pru_rproc_create_debug_entries(struct rproc *rproc)
 
 static void pru_dispose_irq_mapping(struct pru_rproc *pru)
 {
-	while (pru->evt_count--) {
+	if (!pru->mapped_irq)
+		return;
+
+	while (pru->evt_count) {
+		pru->evt_count--;
 		if (pru->mapped_irq[pru->evt_count] > 0)
 			irq_dispose_mapping(pru->mapped_irq[pru->evt_count]);
 	}
 
 	kfree(pru->mapped_irq);
+	pru->mapped_irq = NULL;
 }
 
 /*
@@ -307,8 +312,10 @@ static int pru_handle_intrmap(struct rproc *rproc)
 	pru->evt_count = rsc->num_evts;
 	pru->mapped_irq = kcalloc(pru->evt_count, sizeof(unsigned int),
 				  GFP_KERNEL);
-	if (!pru->mapped_irq)
+	if (!pru->mapped_irq) {
+		pru->evt_count = 0;
 		return -ENOMEM;
+	}
 
 	/*
 	 * parse and fill in system event to interrupt channel and
@@ -317,13 +324,19 @@ static int pru_handle_intrmap(struct rproc *rproc)
 	 * corresponding sibling PRUSS INTC node.
 	 */
 	parent = of_get_parent(dev_of_node(pru->dev));
-	if (!parent)
+	if (!parent) {
+		kfree(pru->mapped_irq);
+		pru->mapped_irq = NULL;
+		pru->evt_count = 0;
 		return -ENODEV;
+	}
 
 	irq_parent = of_get_child_by_name(parent, "interrupt-controller");
 	of_node_put(parent);
 	if (!irq_parent) {
 		kfree(pru->mapped_irq);
+		pru->mapped_irq = NULL;
+		pru->evt_count = 0;
 		return -ENODEV;
 	}
 
@@ -398,8 +411,7 @@ static int pru_rproc_stop(struct rproc *rproc)
 	pru_control_write_reg(pru, PRU_CTRL_CTRL, val);
 
 	/* dispose irq mapping - new firmware can provide new mapping */
-	if (pru->mapped_irq)
-		pru_dispose_irq_mapping(pru);
+	pru_dispose_irq_mapping(pru);
 
 	return 0;
 }
-- 
2.30.2



