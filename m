Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FEB608976
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiJVIgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiJVIfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:35:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914BB3685C;
        Sat, 22 Oct 2022 01:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66CC960AE4;
        Sat, 22 Oct 2022 07:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EF6C433C1;
        Sat, 22 Oct 2022 07:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424216;
        bh=HHK5F+bVk5ccs/l91De+g7lQ4jXHY0mt5/MgFWT9rdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuWuGVfUpk0oC0jLmlvlrDttaioyricwrErANZ5ux1k/r7IWjVk6ZfnVPea9x8ZaB
         u+uK7g5YMdd9PZaguqWqFk32rlxpOJRARai9LZPTASb7eFhpVCI8xhjiiQN1wCy0f9
         Zyo0qYilrL43PUMZp5nB6x+z2ZlCLrvBf4xUx56w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Clark <slc2015@gmail.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.19 035/717] i2c: designware: Fix handling of real but unexpected device interrupts
Date:   Sat, 22 Oct 2022 09:18:34 +0200
Message-Id: <20221022072421.381452549@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 301c8f5c32c8fb79c67539bc23972dc3ef48024c upstream.

Commit c7b79a752871 ("mfd: intel-lpss: Add Intel Alder Lake PCH-S PCI
IDs") caused a regression on certain Gigabyte motherboards for Intel
Alder Lake-S where system crashes to NULL pointer dereference in
i2c_dw_xfer_msg() when system resumes from S3 sleep state ("deep").

I was able to debug the issue on Gigabyte Z690 AORUS ELITE and made
following notes:

- Issue happens when resuming from S3 but not when resuming from
  "s2idle"
- PCI device 00:15.0 == i2c_designware.0 is already in D0 state when
  system enters into pci_pm_resume_noirq() while all other i2c_designware
  PCI devices are in D3. Devices were runtime suspended and in D3 prior
  entering into suspend
- Interrupt comes after pci_pm_resume_noirq() when device interrupts are
  re-enabled
- According to register dump the interrupt really comes from the
  i2c_designware.0. Controller is enabled, I2C target address register
  points to a one detectable I2C device address 0x60 and the
  DW_IC_RAW_INTR_STAT register START_DET, STOP_DET, ACTIVITY and
  TX_EMPTY bits are set indicating completed I2C transaction.

My guess is that the firmware uses this controller to communicate with
an on-board I2C device during resume but does not disable the controller
before giving control to an operating system.

I was told the UEFI update fixes this but never the less it revealed the
driver is not ready to handle TX_EMPTY (or RX_FULL) interrupt when device
is supposed to be idle and state variables are not set (especially the
dev->msgs pointer which may point to NULL or stale old data).

Introduce a new software status flag STATUS_ACTIVE indicating when the
controller is active in driver point of view. Now treat all interrupts
that occur when is not set as unexpected and mask all interrupts from
the controller.

Fixes: c7b79a752871 ("mfd: intel-lpss: Add Intel Alder Lake PCH-S PCI IDs")
Reported-by: Samuel Clark <slc2015@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215907
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-core.h   |    7 +++++--
 drivers/i2c/busses/i2c-designware-master.c |   13 +++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -126,8 +126,9 @@
  * status codes
  */
 #define STATUS_IDLE			0x0
-#define STATUS_WRITE_IN_PROGRESS	0x1
-#define STATUS_READ_IN_PROGRESS		0x2
+#define STATUS_ACTIVE			0x1
+#define STATUS_WRITE_IN_PROGRESS	0x2
+#define STATUS_READ_IN_PROGRESS		0x4
 
 /*
  * operation modes
@@ -334,12 +335,14 @@ void i2c_dw_disable_int(struct dw_i2c_de
 
 static inline void __i2c_dw_enable(struct dw_i2c_dev *dev)
 {
+	dev->status |= STATUS_ACTIVE;
 	regmap_write(dev->map, DW_IC_ENABLE, 1);
 }
 
 static inline void __i2c_dw_disable_nowait(struct dw_i2c_dev *dev)
 {
 	regmap_write(dev->map, DW_IC_ENABLE, 0);
+	dev->status &= ~STATUS_ACTIVE;
 }
 
 void __i2c_dw_disable(struct dw_i2c_dev *dev);
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -716,6 +716,19 @@ static int i2c_dw_irq_handler_master(str
 	u32 stat;
 
 	stat = i2c_dw_read_clear_intrbits(dev);
+
+	if (!(dev->status & STATUS_ACTIVE)) {
+		/*
+		 * Unexpected interrupt in driver point of view. State
+		 * variables are either unset or stale so acknowledge and
+		 * disable interrupts for suppressing further interrupts if
+		 * interrupt really came from this HW (E.g. firmware has left
+		 * the HW active).
+		 */
+		regmap_write(dev->map, DW_IC_INTR_MASK, 0);
+		return 0;
+	}
+
 	if (stat & DW_IC_INTR_TX_ABRT) {
 		dev->cmd_err |= DW_IC_ERR_TX_ABRT;
 		dev->status = STATUS_IDLE;


