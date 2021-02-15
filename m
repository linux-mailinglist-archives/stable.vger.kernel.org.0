Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C5731BD08
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhBOPiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231350AbhBOPhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B486D64E9B;
        Mon, 15 Feb 2021 15:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403167;
        bh=4RtjZHLi7/YjwmChPaUuXBDuz3b+W46ekT5abyQYwU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIxmaTSoszdT+CcK0n73lcVcH27izj4ms8ON1Tg2pK2FUuBNaSeOfi22CMMPkm/cJ
         vkmOr42kvn5ZnK1qpSCRCwEUT4tew/Wjai+i4X6t2PiyRvuVoNz7/eLAXqJujkFUdg
         JjG8FIVcR9G+vuXXBjjerq9ifiG4cJqxPsXPVe38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/104] dmaengine: idxd: check device state before issue command
Date:   Mon, 15 Feb 2021 16:27:07 +0100
Message-Id: <20210215152721.221177527@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 89e3becd8f821e507052e012d2559dcda59f538e ]

Add device state check before executing command. Without the check the
command can be issued while device is in halt state and causes the driver to
block while waiting for the completion of the command.

Reported-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Fixes: 0d5c10b4c84d ("dmaengine: idxd: add work queue drain support")
Link: https://lore.kernel.org/r/161219313921.2976211.12222625226450097465.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 23 ++++++++++++++++++++++-
 drivers/dma/idxd/idxd.h   |  2 +-
 drivers/dma/idxd/init.c   |  5 ++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 663344987e3f3..a6704838ffcb7 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -325,17 +325,31 @@ static inline bool idxd_is_enabled(struct idxd_device *idxd)
 	return false;
 }
 
+static inline bool idxd_device_is_halted(struct idxd_device *idxd)
+{
+	union gensts_reg gensts;
+
+	gensts.bits = ioread32(idxd->reg_base + IDXD_GENSTATS_OFFSET);
+
+	return (gensts.state == IDXD_DEVICE_STATE_HALT);
+}
+
 /*
  * This is function is only used for reset during probe and will
  * poll for completion. Once the device is setup with interrupts,
  * all commands will be done via interrupt completion.
  */
-void idxd_device_init_reset(struct idxd_device *idxd)
+int idxd_device_init_reset(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
 	union idxd_command_reg cmd;
 	unsigned long flags;
 
+	if (idxd_device_is_halted(idxd)) {
+		dev_warn(&idxd->pdev->dev, "Device is HALTED!\n");
+		return -ENXIO;
+	}
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd = IDXD_CMD_RESET_DEVICE;
 	dev_dbg(dev, "%s: sending reset for init.\n", __func__);
@@ -346,6 +360,7 @@ void idxd_device_init_reset(struct idxd_device *idxd)
 	       IDXD_CMDSTS_ACTIVE)
 		cpu_relax();
 	spin_unlock_irqrestore(&idxd->dev_lock, flags);
+	return 0;
 }
 
 static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
@@ -355,6 +370,12 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	DECLARE_COMPLETION_ONSTACK(done);
 	unsigned long flags;
 
+	if (idxd_device_is_halted(idxd)) {
+		dev_warn(&idxd->pdev->dev, "Device is HALTED!\n");
+		*status = IDXD_CMDSTS_HW_ERR;
+		return;
+	}
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd = cmd_code;
 	cmd.operand = operand;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index d48f193daacc0..953ef6536aac4 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -281,7 +281,7 @@ void idxd_mask_msix_vector(struct idxd_device *idxd, int vec_id);
 void idxd_unmask_msix_vector(struct idxd_device *idxd, int vec_id);
 
 /* device control */
-void idxd_device_init_reset(struct idxd_device *idxd);
+int idxd_device_init_reset(struct idxd_device *idxd);
 int idxd_device_enable(struct idxd_device *idxd);
 int idxd_device_disable(struct idxd_device *idxd);
 void idxd_device_reset(struct idxd_device *idxd);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 0a4432b063b5c..fa8c4228f358a 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -289,7 +289,10 @@ static int idxd_probe(struct idxd_device *idxd)
 	int rc;
 
 	dev_dbg(dev, "%s entered and resetting device\n", __func__);
-	idxd_device_init_reset(idxd);
+	rc = idxd_device_init_reset(idxd);
+	if (rc < 0)
+		return rc;
+
 	dev_dbg(dev, "IDXD reset complete\n");
 
 	idxd_read_caps(idxd);
-- 
2.27.0



