Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD5139E3B8
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhFGQ1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234002AbhFGQZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F99E61945;
        Mon,  7 Jun 2021 16:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082568;
        bh=MK2RLPG3XOilwa4pmuYUNOPAOn+IIYnUet178azp21g=;
        h=From:To:Cc:Subject:Date:From;
        b=g6AwI73Bt7k0M2HVzE6EY/YUa/WVh3PJK1nmwz5cwQCTxjEwuEfqT/G/gtgJEsglJ
         IscsTYRrNk76ZwUUSmJbhoIbQPcVAoZ91MplVQZcBl79jSL1/DY85rFKkt2oUc9NaG
         rmG+2ScoW5c85okJZzs1Ubf3uPEHoa3yuQKleIuYKJEJfTYz89RijSzEmwJcIyfWYO
         EW0Y0KC+JD0zgogSYn54SoVN3w0M187eSzsUrLKvxj8NbfRmS5zicC/S0Du2tNxNlH
         6khz+YwguDTdNpamGXpmhXQqKlrx+UTAOKx7rW8EMYIei3UriewaoroQFHxgxiTuwX
         6Vn4Giu9FIpxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/14] HID: hid-sensor-hub: Return error for hid_set_field() failure
Date:   Mon,  7 Jun 2021 12:15:52 -0400
Message-Id: <20210607161605.3584954-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 83e45d5801a9..ce4e9b34af98 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -222,16 +222,21 @@ int sensor_hub_set_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
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

