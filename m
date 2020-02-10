Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24E6157AA9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgBJNY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgBJMhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:05 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BCC02051A;
        Mon, 10 Feb 2020 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338224;
        bh=Cii59v+tE1D5Tcds59Ldt4r2lnGyvOzYXC1dTbz939M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDzWT/Nz0M6CQx8phgxFxGso7SpL0cGlmshWngtohztnMmnSzSRvklHeYwsFlPX7r
         Q2f3t2GoFFN8CUBtXfWKdwqDn0iVHIdlnwUUJhS5ZTvhR+cttdiYBFE9UNQ5IeZ2GG
         8cPml7VKgYaw5N8jS2CnR1+emQ/FJYgaI15cD2uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 061/309] platform/x86: intel_scu_ipc: Fix interrupt support
Date:   Mon, 10 Feb 2020 04:30:17 -0800
Message-Id: <20200210122411.814933888@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit e48b72a568bbd641c91dad354138d3c17d03ee6f upstream.

Currently the driver has disabled interrupt support for Tangier but
actually interrupt works just fine if the command is not written twice
in a row. Also we need to ack the interrupt in the handler.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel_scu_ipc.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -67,26 +67,22 @@
 struct intel_scu_ipc_pdata_t {
 	u32 i2c_base;
 	u32 i2c_len;
-	u8 irq_mode;
 };
 
 static const struct intel_scu_ipc_pdata_t intel_scu_ipc_lincroft_pdata = {
 	.i2c_base = 0xff12b000,
 	.i2c_len = 0x10,
-	.irq_mode = 0,
 };
 
 /* Penwell and Cloverview */
 static const struct intel_scu_ipc_pdata_t intel_scu_ipc_penwell_pdata = {
 	.i2c_base = 0xff12b000,
 	.i2c_len = 0x10,
-	.irq_mode = 1,
 };
 
 static const struct intel_scu_ipc_pdata_t intel_scu_ipc_tangier_pdata = {
 	.i2c_base  = 0xff00d000,
 	.i2c_len = 0x10,
-	.irq_mode = 0,
 };
 
 struct intel_scu_ipc_dev {
@@ -99,6 +95,9 @@ struct intel_scu_ipc_dev {
 
 static struct intel_scu_ipc_dev  ipcdev; /* Only one for now */
 
+#define IPC_STATUS		0x04
+#define IPC_STATUS_IRQ		BIT(2)
+
 /*
  * IPC Read Buffer (Read Only):
  * 16 byte buffer for receiving data from SCU, if IPC command
@@ -120,11 +119,8 @@ static DEFINE_MUTEX(ipclock); /* lock us
  */
 static inline void ipc_command(struct intel_scu_ipc_dev *scu, u32 cmd)
 {
-	if (scu->irq_mode) {
-		reinit_completion(&scu->cmd_complete);
-		writel(cmd | IPC_IOC, scu->ipc_base);
-	}
-	writel(cmd, scu->ipc_base);
+	reinit_completion(&scu->cmd_complete);
+	writel(cmd | IPC_IOC, scu->ipc_base);
 }
 
 /*
@@ -610,9 +606,10 @@ EXPORT_SYMBOL(intel_scu_ipc_i2c_cntrl);
 static irqreturn_t ioc(int irq, void *dev_id)
 {
 	struct intel_scu_ipc_dev *scu = dev_id;
+	int status = ipc_read_status(scu);
 
-	if (scu->irq_mode)
-		complete(&scu->cmd_complete);
+	writel(status | IPC_STATUS_IRQ, scu->ipc_base + IPC_STATUS);
+	complete(&scu->cmd_complete);
 
 	return IRQ_HANDLED;
 }
@@ -638,8 +635,6 @@ static int ipc_probe(struct pci_dev *pde
 	if (!pdata)
 		return -ENODEV;
 
-	scu->irq_mode = pdata->irq_mode;
-
 	err = pcim_enable_device(pdev);
 	if (err)
 		return err;


