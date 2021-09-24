Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EF841745D
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345999AbhIXNFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344249AbhIXNDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF75561423;
        Fri, 24 Sep 2021 12:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488103;
        bh=t6Z3enAqwHwMvkrL5+4T1jz9TrJJwxTIErdIbY99Spc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02Mo9asjgUYkOPNUjqi0Yr4cB/Lvys3GmV0TfdlIB88knZreWxclOZO56ncw2CgQ3
         4ZL6m1ilK259WjWQhK6hxZrc7bLM/xx7Cs+VzSLwb8tq06JKcggoFRF6lKn2bn2I4X
         sP1PQ4Be7UJzbg05Xf9WP4FTj0ttwG8XjOjSolcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 086/100] habanalabs: add "in device creation" status
Date:   Fri, 24 Sep 2021 14:44:35 +0200
Message-Id: <20210924124344.351280791@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



