Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A694239E1D6
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhFGQOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhFGQOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D1AC6136D;
        Mon,  7 Jun 2021 16:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082345;
        bh=gWJ1yRLZGxnhleLBM3oUql+Jg14/ZcrDxag8D74fKKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvcrCsm+JuDoTf/p9Hw8YrrshhK0eVPGgMfWTZNYB/G8/H278DHHe0k8Ccb12VE/J
         Uoy8FZ2Yl5i4x0pmX7Ow7UjpNHIQAPwAcb2cCilOkp2S7f/9azx7R4Dax/knlbye7o
         6ZtqxGNs9DJCok3SJZKCCrrP5ij/2RoYk3Z/edbm0qoH1eTZvA1VCf3Qqdwc+ICqwD
         gqFMsHYfEinqTttGksfLv8I6CdU+vTbh6+L5ggWhOv4Xj0PUHTM6oMCoRLTuPu/W86
         tEtI89GPZjUcqg7nBaIAXlsHME21O5ldCdP7P8zsgTpGdqyZXhA+JCPYa15lF7UK7l
         EftorNTCALItw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 07/49] HID: hid-sensor-hub: Return error for hid_set_field() failure
Date:   Mon,  7 Jun 2021 12:11:33 -0400
Message-Id: <20210607161215.3583176-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
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
index 3dd7d3246737..f9983145d4e7 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -210,16 +210,21 @@ int sensor_hub_set_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
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

