Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8AD12C625
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfL2Rnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730552AbfL2Rns (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99578206DB;
        Sun, 29 Dec 2019 17:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641428;
        bh=+3MOMKgc5xOdkZZ2k6be+KdZ2hmpuRW+zJy7i1i9Ibw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GM1dHS+PWAjEGClrLDRH2UKVUqtAcjcKUuKUYRXrIUFnFBDUlAYR3Ql71cjiDPnGL
         mc8muKlmCLFvtQxWD9yvL2vaeYT2kqOt6sdcTaA9xHosxbBboRl0ee3Wufz5APge1+
         JdqxZqsmg4f/eTrQGf5G8/pJHOR01oOeffdcqEGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 022/434] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Date:   Sun, 29 Dec 2019 18:21:15 +0100
Message-Id: <20191229172703.607101905@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit daa6eb5a149519583c8a8cb31945f06417d21902 ]

Upon reusing the ptp_qoriq driver, the ptp_qoriq_free() function was
used on the remove path to free any allocated resources.
The ptp_qoriq IRQ is among these resources that are freed in
ptp_qoriq_free() even though it is also a managed one (allocated using
devm_request_threaded_irq).

Drop the resource managed version of requesting the IRQ in order to not
trigger a double free of the interrupt as below:

[  226.731005] Trying to free already-free IRQ 126
[  226.735533] WARNING: CPU: 6 PID: 749 at kernel/irq/manage.c:1707
__free_irq+0x9c/0x2b8
[  226.743435] Modules linked in:
[  226.746480] CPU: 6 PID: 749 Comm: bash Tainted: G        W
5.4.0-03629-gfd7102c32b2c-dirty #912
[  226.755857] Hardware name: NXP Layerscape LX2160ARDB (DT)
[  226.761244] pstate: 40000085 (nZcv daIf -PAN -UAO)
[  226.766022] pc : __free_irq+0x9c/0x2b8
[  226.769758] lr : __free_irq+0x9c/0x2b8
[  226.773493] sp : ffff8000125039f0
(...)
[  226.856275] Call trace:
[  226.858710]  __free_irq+0x9c/0x2b8
[  226.862098]  free_irq+0x30/0x70
[  226.865229]  devm_irq_release+0x14/0x20
[  226.869054]  release_nodes+0x1b0/0x220
[  226.872790]  devres_release_all+0x34/0x50
[  226.876790]  device_release_driver_internal+0x100/0x1c0

Fixes: d346c9e86d86 ("dpaa2-ptp: reuse ptp_qoriq driver")
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -160,10 +160,10 @@ static int dpaa2_ptp_probe(struct fsl_mc
 	irq = mc_dev->irqs[0];
 	ptp_qoriq->irq = irq->msi_desc->irq;
 
-	err = devm_request_threaded_irq(dev, ptp_qoriq->irq, NULL,
-					dpaa2_ptp_irq_handler_thread,
-					IRQF_NO_SUSPEND | IRQF_ONESHOT,
-					dev_name(dev), ptp_qoriq);
+	err = request_threaded_irq(ptp_qoriq->irq, NULL,
+				   dpaa2_ptp_irq_handler_thread,
+				   IRQF_NO_SUSPEND | IRQF_ONESHOT,
+				   dev_name(dev), ptp_qoriq);
 	if (err < 0) {
 		dev_err(dev, "devm_request_threaded_irq(): %d\n", err);
 		goto err_free_mc_irq;
@@ -173,18 +173,20 @@ static int dpaa2_ptp_probe(struct fsl_mc
 				   DPRTC_IRQ_INDEX, 1);
 	if (err < 0) {
 		dev_err(dev, "dprtc_set_irq_enable(): %d\n", err);
-		goto err_free_mc_irq;
+		goto err_free_threaded_irq;
 	}
 
 	err = ptp_qoriq_init(ptp_qoriq, base, &dpaa2_ptp_caps);
 	if (err)
-		goto err_free_mc_irq;
+		goto err_free_threaded_irq;
 
 	dpaa2_phc_index = ptp_qoriq->phc_index;
 	dev_set_drvdata(dev, ptp_qoriq);
 
 	return 0;
 
+err_free_threaded_irq:
+	free_irq(ptp_qoriq->irq, ptp_qoriq);
 err_free_mc_irq:
 	fsl_mc_free_irqs(mc_dev);
 err_unmap:


