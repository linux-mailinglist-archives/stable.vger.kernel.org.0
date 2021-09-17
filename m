Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6483D40EF64
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243013AbhIQCfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:32986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243028AbhIQCfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96F7B610C8;
        Fri, 17 Sep 2021 02:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846055;
        bh=0A+JFIOtCSlvC0yONArh33EwnvlE1ohNrVmX1feetWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGRFxCXmSaKpVfemfmWIAcHYjpe6CER8mm6BAQ28UbbsUCvBUOjzG0Feayaia8XPv
         E4s+/zcuPOwrKEnUx5aZ9Gz1wo88ORMNGxt84+4++YhFw+sc9nRdDPgP5U59jWxes6
         brWs+aqqHxbQmszo7W8TyJu9TKKOYgsbvxbI2wkIo2LCg3LbOy/+M7xn2NQOziBQhE
         hjw42R7PqfWCflofiZHKoyNQF8UN6sQ+ZEEyAyqFIG8N9FLxECwHIxnHiuMlI8zeKZ
         tx/bk1A7E1lIx8K273nUxJMO+CvshANK62Mdvmsz6gC4msP194UJBuC/fBbrMCCMfq
         ruFx85xiRckjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd@vger.kernel.org,
        gregkh@linuxfoundation.org, obitton@habana.ai, ttayar@habana.ai,
        kelbaz@habana.ai, osharabi@habana.ai, fkassabri@habana.ai,
        ynudelman@habana.ai, mhaimovski@habana.ai,
        yang.lee@linux.alibaba.com, amizrahi@habana.ai, bjauhari@habana.ai
Subject: [PATCH AUTOSEL 5.14 09/21] habanalabs: add "in device creation" status
Date:   Thu, 16 Sep 2021 22:33:03 -0400
Message-Id: <20210917023315.816225-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

[ Upstream commit 71731090ab17a208a58020e4b342fdfee280458a ]

On init, the disabled state is cleared right before hw_init and that
causes the device to report on "Operational" state before the device
initialization is finished. Although the char device is not yet exposed
to the user at this stage, the sysfs entries are exposed.

This can cause errors in monitoring applications that use the sysfs
entries.

In order to avoid this, a new state "in device creation" is introduced
to ne reported when the device is not disabled but is still in init
flow.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c       |  3 +++
 drivers/misc/habanalabs/common/habanalabs.h   |  2 +-
 .../misc/habanalabs/common/habanalabs_drv.c   |  8 ++++++--
 drivers/misc/habanalabs/common/sysfs.c        | 20 +++++++------------
 include/uapi/misc/habanalabs.h                |  4 +++-
 5 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 0a788a13f2c1..846a7e78582c 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -23,6 +23,8 @@ enum hl_device_status hl_device_status(struct hl_device *hdev)
 		status = HL_DEVICE_STATUS_NEEDS_RESET;
 	else if (hdev->disabled)
 		status = HL_DEVICE_STATUS_MALFUNCTION;
+	else if (!hdev->init_done)
+		status = HL_DEVICE_STATUS_IN_DEVICE_CREATION;
 	else
 		status = HL_DEVICE_STATUS_OPERATIONAL;
 
@@ -44,6 +46,7 @@ bool hl_device_operational(struct hl_device *hdev,
 	case HL_DEVICE_STATUS_NEEDS_RESET:
 		return false;
 	case HL_DEVICE_STATUS_OPERATIONAL:
+	case HL_DEVICE_STATUS_IN_DEVICE_CREATION:
 	default:
 		return true;
 	}
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index c63e26da5135..c48d130a9049 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -1798,7 +1798,7 @@ struct hl_dbg_device_entry {
 
 #define HL_STR_MAX	32
 
-#define HL_DEV_STS_MAX (HL_DEVICE_STATUS_NEEDS_RESET + 1)
+#define HL_DEV_STS_MAX (HL_DEVICE_STATUS_LAST + 1)
 
 /* Theoretical limit only. A single host can only contain up to 4 or 8 PCIe
  * x16 cards. In extreme cases, there are hosts that can accommodate 16 cards.
diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index 4194cda2d04c..536451a9a16c 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -318,12 +318,16 @@ int create_hdev(struct hl_device **dev, struct pci_dev *pdev,
 		hdev->asic_prop.fw_security_enabled = false;
 
 	/* Assign status description string */
-	strncpy(hdev->status[HL_DEVICE_STATUS_MALFUNCTION],
-					"disabled", HL_STR_MAX);
+	strncpy(hdev->status[HL_DEVICE_STATUS_OPERATIONAL],
+					"operational", HL_STR_MAX);
 	strncpy(hdev->status[HL_DEVICE_STATUS_IN_RESET],
 					"in reset", HL_STR_MAX);
+	strncpy(hdev->status[HL_DEVICE_STATUS_MALFUNCTION],
+					"disabled", HL_STR_MAX);
 	strncpy(hdev->status[HL_DEVICE_STATUS_NEEDS_RESET],
 					"needs reset", HL_STR_MAX);
+	strncpy(hdev->status[HL_DEVICE_STATUS_IN_DEVICE_CREATION],
+					"in device creation", HL_STR_MAX);
 
 	hdev->major = hl_major;
 	hdev->reset_on_lockup = reset_on_lockup;
diff --git a/drivers/misc/habanalabs/common/sysfs.c b/drivers/misc/habanalabs/common/sysfs.c
index db72df282ef8..34f9f2779962 100644
--- a/drivers/misc/habanalabs/common/sysfs.c
+++ b/drivers/misc/habanalabs/common/sysfs.c
@@ -9,8 +9,7 @@
 
 #include <linux/pci.h>
 
-long hl_get_frequency(struct hl_device *hdev, u32 pll_index,
-								bool curr)
+long hl_get_frequency(struct hl_device *hdev, u32 pll_index, bool curr)
 {
 	struct cpucp_packet pkt;
 	u32 used_pll_idx;
@@ -44,8 +43,7 @@ long hl_get_frequency(struct hl_device *hdev, u32 pll_index,
 	return (long) result;
 }
 
-void hl_set_frequency(struct hl_device *hdev, u32 pll_index,
-								u64 freq)
+void hl_set_frequency(struct hl_device *hdev, u32 pll_index, u64 freq)
 {
 	struct cpucp_packet pkt;
 	u32 used_pll_idx;
@@ -285,16 +283,12 @@ static ssize_t status_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
 	struct hl_device *hdev = dev_get_drvdata(dev);
-	char *str;
+	char str[HL_STR_MAX];
 
-	if (atomic_read(&hdev->in_reset))
-		str = "In reset";
-	else if (hdev->disabled)
-		str = "Malfunction";
-	else if (hdev->needs_reset)
-		str = "Needs Reset";
-	else
-		str = "Operational";
+	strscpy(str, hdev->status[hl_device_status(hdev)], HL_STR_MAX);
+
+	/* use uppercase for backward compatibility */
+	str[0] = 'A' + (str[0] - 'a');
 
 	return sprintf(buf, "%s\n", str);
 }
diff --git a/include/uapi/misc/habanalabs.h b/include/uapi/misc/habanalabs.h
index a47a731e4527..b4b681b81df8 100644
--- a/include/uapi/misc/habanalabs.h
+++ b/include/uapi/misc/habanalabs.h
@@ -276,7 +276,9 @@ enum hl_device_status {
 	HL_DEVICE_STATUS_OPERATIONAL,
 	HL_DEVICE_STATUS_IN_RESET,
 	HL_DEVICE_STATUS_MALFUNCTION,
-	HL_DEVICE_STATUS_NEEDS_RESET
+	HL_DEVICE_STATUS_NEEDS_RESET,
+	HL_DEVICE_STATUS_IN_DEVICE_CREATION,
+	HL_DEVICE_STATUS_LAST = HL_DEVICE_STATUS_IN_DEVICE_CREATION
 };
 
 /* Opcode for management ioctl
-- 
2.30.2

