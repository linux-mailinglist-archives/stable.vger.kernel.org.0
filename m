Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6473B6211
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhF1Ol2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235364AbhF1Ojx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:39:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7A6D61C77;
        Mon, 28 Jun 2021 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890790;
        bh=Xxu1GXIuEAn9iK7BKOtVUnfRz/LmbSEDUzga1/oJ9sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToQTzRXWCupOJJSUEFq2b9ypvJXffb0rfC4yv6ShBoUjoL4YGOU4PZKhcGqUUFILl
         T9MeRmiPDBzvHuXntfIZZRPy4h5Y6iMnURfkWMmMQ/oaQHyD6eC+maM0PsXyGR7Qiq
         zsiVkVE6hUTwUWCUB354KNL2hItYSeb8FPpJF1jTOcb6uirGDXzpvCpZD3UqD30OZ9
         Exuk14OVV0WUTd3S2VdJcfMnYWfK5ulBLodMfbJsB4MccQM/prHqMzHKtvexbxvmHX
         LWw/Cq1HOA3MNQF82jh9ncS7Fg0tTFMHZzWlcAkqvIO4HC3EC6io/oVsWgN23FJAnQ
         ebrJ4fa7VxcWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/109] HID: hid-sensor-hub: Return error for hid_set_field() failure
Date:   Mon, 28 Jun 2021 10:31:19 -0400
Message-Id: <20210628143305.32978-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit edb032033da0dc850f6e7740fa1023c73195bc89 ]

In the function sensor_hub_set_feature(), return error when hid_set_field()
fails.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sensor-hub.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 21fbdcde1faa..ef62f36ebcf9 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -223,16 +223,21 @@ int sensor_hub_set_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
 	buffer_size = buffer_size / sizeof(__s32);
 	if (buffer_size) {
 		for (i = 0; i < buffer_size; ++i) {
-			hid_set_field(report->field[field_index], i,
-				      (__force __s32)cpu_to_le32(*buf32));
+			ret = hid_set_field(report->field[field_index], i,
+					    (__force __s32)cpu_to_le32(*buf32));
+			if (ret)
+				goto done_proc;
+
 			++buf32;
 		}
 	}
 	if (remaining_bytes) {
 		value = 0;
 		memcpy(&value, (u8 *)buf32, remaining_bytes);
-		hid_set_field(report->field[field_index], i,
-			      (__force __s32)cpu_to_le32(value));
+		ret = hid_set_field(report->field[field_index], i,
+				    (__force __s32)cpu_to_le32(value));
+		if (ret)
+			goto done_proc;
 	}
 	hid_hw_request(hsdev->hdev, report, HID_REQ_SET_REPORT);
 	hid_hw_wait(hsdev->hdev);
-- 
2.30.2

