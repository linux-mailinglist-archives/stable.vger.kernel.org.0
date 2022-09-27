Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9695EC518
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 15:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiI0N44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 09:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiI0N44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 09:56:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9EE13F284;
        Tue, 27 Sep 2022 06:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664287014; x=1695823014;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SDMxe83gnt58tmE+Iut0WAx9U5SvA9TL7jaqPINFCTU=;
  b=BPpZ0bVkxz7V3iuGeLOVRm9MJk/ADTIKiex9pMdwwTP4YpP+sQkA1ijB
   46m+rzDqPtLSaT3hDVjn7vVXVHEELvjXftqlz2p3UsII2QhaaxJ+trZ/u
   DSbp6bVY+rskMLEUrF5giu7ZrsMUL/t40QHgh2IYDETdffyqXw9m/7lBM
   i0+w4sL1mVn+DCEq4XBef5duVjYtJZgz+0WKVFcB9N2vcsRYTqAi1e5zC
   xetbW6m4dT6JPKgjZes6LGNOIbCJQ9Qp9g9y6a9KaYhKt9hzgok4Py0X5
   awey0pM9QYpK8x6Zk5Ji/GDN9ZHg1U/rbFsq1+oAac3gBPYqf/iFgP7o0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="387607861"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="387607861"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 06:56:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="654732513"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="654732513"
Received: from mylly.fi.intel.com (HELO mylly.fi.intel.com.) ([10.237.72.51])
  by orsmga001.jf.intel.com with ESMTP; 27 Sep 2022 06:56:51 -0700
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
To:     linux-i2c@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Samuel Clark <slc2015@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] i2c: designware: Fix handling of real but unexpected device interrupts
Date:   Tue, 27 Sep 2022 16:56:44 +0300
Message-Id: <20220927135644.1656369-1-jarkko.nikula@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
Hans: Are you able to test this on your Baytrail collection with shared
I2C controller and PUNIT so that patch doesn't break anything? I believe
even if the Linux interrupt for such shared I2C controller is shared e.g.
with the i2c-i801 the PUNIT access should not get affected by this
interrupt masking. I think PUNIT access won't use interrupts but you
never know... We have a MRD7 that has shared I2C controller with PUNIT
but Linux interrupt is not shared. I.e. unexpected interrupt case and
masking doesn't get hit.
i2c-designware-slave.c is not fully in sync with this new status flag since
STATUS_ACTIVE gets overwritten there and unexpected interrupt case is
needlessly hit in case of shared interrupt and this controller is
suspended but both of those can go to an another patchset.
---
 drivers/i2c/busses/i2c-designware-core.h   |  7 +++++--
 drivers/i2c/busses/i2c-designware-master.c | 13 +++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 70b80e710990..4d3a3b464ecd 100644
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
@@ -334,12 +335,14 @@ void i2c_dw_disable_int(struct dw_i2c_dev *dev);
 
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
diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index 44a94b225ed8..dc3c5a15a95b 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -716,6 +716,19 @@ static int i2c_dw_irq_handler_master(struct dw_i2c_dev *dev)
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
-- 
2.35.1

