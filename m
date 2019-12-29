Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74DD12C8C0
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbfL2R5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733240AbfL2R5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DEC21744;
        Sun, 29 Dec 2019 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642242;
        bh=jFThN6yy7EUlmrUYE9DyczwrL3SAyXJRmPqEdaC4uGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVbliGB6vqZkymj43I2Vi/tDY0FGQBVUwBCqII4Ym2l1750caGYvkS/I4EMfsymex
         RwIagSa6SS3LqYvgFb0Qp+FXY+tuU2V3z26ytxcytILmgbBssfYhoE6YwDM0QUTIMr
         4D/Ww4YgHA4O04tmgcfhA2/OsbHL8fY9I0S8r8tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>
Subject: [PATCH 5.4 400/434] intel_th: Fix freeing IRQs
Date:   Sun, 29 Dec 2019 18:27:33 +0100
Message-Id: <20191229172729.047900379@linuxfoundation.org>
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

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit ab832e38e4f0f45b16c3633714d868b7ec6b33b4 upstream.

Commit aac8da65174a ("intel_th: msu: Start handling IRQs") implicitly
relies on the use of devm_request_irq() to subsequently free the irqs on
device removal, but in case of the pci_free_irq_vectors() API, the
handlers need to be freed before it is called. Therefore, at the moment
the driver's remove path trips a BUG_ON(irq_has_action()):

> kernel BUG at drivers/pci/msi.c:375!
> invalid opcode: 0000 1 SMP
> CPU: 2 PID: 818 Comm: rmmod Not tainted 5.5.0-rc1+ #1
> RIP: 0010:free_msi_irqs+0x67/0x1c0
> pci_disable_msi+0x116/0x150
> pci_free_irq_vectors+0x1b/0x20
> intel_th_pci_remove+0x22/0x30 [intel_th_pci]
> pci_device_remove+0x3e/0xb0
> device_release_driver_internal+0xf0/0x1c0
> driver_detach+0x4c/0x8f
> bus_remove_driver+0x5c/0xd0
> driver_unregister+0x31/0x50
> pci_unregister_driver+0x40/0x90
> intel_th_pci_driver_exit+0x10/0xad6 [intel_th_pci]
> __x64_sys_delete_module+0x147/0x290
> ? exit_to_usermode_loop+0xd7/0x120
> do_syscall_64+0x57/0x1b0
> entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by explicitly freeing irqs before freeing the vectors. We keep
using the devm_* variants because they are still useful in early error
paths.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: aac8da65174a ("intel_th: msu: Start handling IRQs")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Ammy Yi <ammy.yi@intel.com>
Cc: stable@vger.kernel.org # v5.2+
Link: https://lore.kernel.org/r/20191217115527.74383-4-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/core.c     |    7 ++++---
 drivers/hwtracing/intel_th/intel_th.h |    2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -834,9 +834,6 @@ static irqreturn_t intel_th_irq(int irq,
 			ret |= d->irq(th->thdev[i]);
 	}
 
-	if (ret == IRQ_NONE)
-		pr_warn_ratelimited("nobody cared for irq\n");
-
 	return ret;
 }
 
@@ -887,6 +884,7 @@ intel_th_alloc(struct device *dev, struc
 
 			if (th->irq == -1)
 				th->irq = devres[r].start;
+			th->num_irqs++;
 			break;
 		default:
 			dev_warn(dev, "Unknown resource type %lx\n",
@@ -940,6 +938,9 @@ void intel_th_free(struct intel_th *th)
 
 	th->num_thdevs = 0;
 
+	for (i = 0; i < th->num_irqs; i++)
+		devm_free_irq(th->dev, th->irq + i, th);
+
 	pm_runtime_get_sync(th->dev);
 	pm_runtime_forbid(th->dev);
 
--- a/drivers/hwtracing/intel_th/intel_th.h
+++ b/drivers/hwtracing/intel_th/intel_th.h
@@ -261,6 +261,7 @@ enum th_mmio_idx {
  * @num_thdevs:	number of devices in the @thdev array
  * @num_resources:	number of resources in the @resource array
  * @irq:	irq number
+ * @num_irqs:	number of IRQs is use
  * @id:		this Intel TH controller's device ID in the system
  * @major:	device node major for output devices
  */
@@ -277,6 +278,7 @@ struct intel_th {
 	unsigned int		num_thdevs;
 	unsigned int		num_resources;
 	int			irq;
+	int			num_irqs;
 
 	int			id;
 	int			major;


