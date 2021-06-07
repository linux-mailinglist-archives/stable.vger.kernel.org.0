Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6139E2C7
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhFGQTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232648AbhFGQRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0A9061465;
        Mon,  7 Jun 2021 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082456;
        bh=gWJ1yRLZGxnhleLBM3oUql+Jg14/ZcrDxag8D74fKKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+Fl/5eCYed/uxunAwglv7FaK5wAwZOnVxu341hv9grAnPd4deGr6rRRgSbDZi6ei
         AGGHYnwrWehlVp4fhOTO2BzmzMT6gRM4GBadD8oUS+LD13Xx079pESJda+87/Gnswg
         j/fHvVk6nRSyN/4Bv17nIZK/MDUsyIC/n1d++CYuyPGi4QUo7Lf5qTx08iHypuDPl2
         3CNvlqIXkGZm4El0gXS7MVj3S1dX15GxW8kMFfjHJbpl/d1oixDasHUc2ISvfSiCMd
         hwenY7whY2xLY2SJbZuFgP7aflf1I+pWwzNXLZaLVOTh+05QAOcrbXjCSu/gNbgMMu
         evIYO8qXIejCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/29] HID: hid-sensor-hub: Return error for hid_set_field() failure
Date:   Mon,  7 Jun 2021 12:13:45 -0400
Message-Id: <20210607161410.3584036-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
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

