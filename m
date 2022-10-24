Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ABC60B1EC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiJXQks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbiJXQkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:40:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D8EDDA0E;
        Mon, 24 Oct 2022 08:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 157EFCE149D;
        Mon, 24 Oct 2022 12:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9FAC433C1;
        Mon, 24 Oct 2022 12:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614851;
        bh=yxQPSSffzMmACFPBzlZUpDEyUBxPsFySEtUkQ5VYgMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wb2Wu7VC57qV2dYwiJiq2i+ylWntLZ0u46TZkVxP1mEeS8V/mTIEKCYZugEoFt8jO
         hw+k1aMjYevO+1wPFz15lBqdkvPhs2802IRVCVlDkNJfjgpsBlqAxFvud3iF00V4p/
         CttEJSfCwqv2t2ipodyK4OkoWDM8fsLphRIAwjnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Clark <slc2015@gmail.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 027/530] i2c: designware: Fix handling of real but unexpected device interrupts
Date:   Mon, 24 Oct 2022 13:26:11 +0200
Message-Id: <20221024113046.235903901@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -322,12 +323,14 @@ void i2c_dw_disable_int(struct dw_i2c_de
 
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
@@ -720,6 +720,19 @@ static int i2c_dw_irq_handler_master(str
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


