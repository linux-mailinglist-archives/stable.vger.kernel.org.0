Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E904F36426F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbhDSNIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239416AbhDSNIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B273F6127C;
        Mon, 19 Apr 2021 13:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837690;
        bh=5vSnftBv7TEoHBYxI8JgxnbeUIjXD2E0W4N0IsgOYck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPY4oVZuwCRSl/1x0ABlfzlOvE+llhN1g67iLMw6gOkgcaAme/MLyE2q4HDfo3odv
         oJdwoaXIqWvdMzeyfCWlljrAvVxE0h/y3s7jmB/tuKVk77OuCXQSuR9jMq+FKvAsiq
         8DwKd26cGJo9IAHRwmLvTuGwDBf+BbuCLv5pyFfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Neumann <mail@richard-neumann.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 002/122] AMD_SFH: Add sensor_mask module parameter
Date:   Mon, 19 Apr 2021 15:04:42 +0200
Message-Id: <20210419130530.257445795@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 952f7d10c6b1685c6700fb24cf4ecbcf26ede77e ]

Add a sensor_mask module parameter which can be used to override the
sensor-mask read from the activestatus bits of the AMD_P2C_MSG3
registers. Some BIOS-es do not program the activestatus bits, leading
to the AMD-SFH driver not registering any HID devices even though the
laptop in question does actually have sensors.

While at it also fix the wrong indentation of the MAGNO_EN define.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=199715
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1651886
Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
Suggested-by: Richard Neumann <mail@richard-neumann.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Sandeep Singh <sandeep.singh@amd.com
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index f3cdb4ea33da..ab0a9443e252 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -22,9 +22,13 @@
 
 #define ACEL_EN		BIT(0)
 #define GYRO_EN		BIT(1)
-#define MAGNO_EN		BIT(2)
+#define MAGNO_EN	BIT(2)
 #define ALS_EN		BIT(19)
 
+static int sensor_mask_override = -1;
+module_param_named(sensor_mask, sensor_mask_override, int, 0444);
+MODULE_PARM_DESC(sensor_mask, "override the detected sensors mask");
+
 void amd_start_sensor(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info)
 {
 	union sfh_cmd_param cmd_param;
@@ -78,8 +82,12 @@ int amd_mp2_get_sensor_num(struct amd_mp2_dev *privdata, u8 *sensor_id)
 	int activestatus, num_of_sensors = 0;
 	u32 activecontrolstatus;
 
-	activecontrolstatus = readl(privdata->mmio + AMD_P2C_MSG3);
-	activestatus = activecontrolstatus >> 4;
+	if (sensor_mask_override >= 0) {
+		activestatus = sensor_mask_override;
+	} else {
+		activecontrolstatus = readl(privdata->mmio + AMD_P2C_MSG3);
+		activestatus = activecontrolstatus >> 4;
+	}
 
 	if (ACEL_EN  & activestatus)
 		sensor_id[num_of_sensors++] = accel_idx;
-- 
2.30.2



