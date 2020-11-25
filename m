Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1A02C4357
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbgKYPhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730988AbgKYPhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:37:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F12221EB;
        Wed, 25 Nov 2020 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318638;
        bh=oyAliAb+r1d1FgAbyRqcN+imWJ8VIKhFjlTvOEeWGmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmZQjVlUWDi23GsZFcJX6jH57ir3VxqIW8WpgZT3t6mwdwoINh5E77E7UkX4monMP
         12gDuVauuAcEPLBWF9B5Wahp4HZqFtc4klsbI1gbMVLRXUVNv8/G+jWhi+f9488R1q
         /osHNocoA5rGqf03j0wIVKxKL8Roa3LDy2Gj0jFs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Ceballos <pceballos@google.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/15] HID: hid-sensor-hub: Fix issue with devices with no report ID
Date:   Wed, 25 Nov 2020 10:37:01 -0500
Message-Id: <20201125153712.810655-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153712.810655-1-sashal@kernel.org>
References: <20201125153712.810655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Ceballos <pceballos@google.com>

[ Upstream commit 34a9fa2025d9d3177c99351c7aaf256c5f50691f ]

Some HID devices don't use a report ID because they only have a single
report. In those cases, the report ID in struct hid_report will be zero
and the data for the report will start at the first byte, so don't skip
over the first byte.

Signed-off-by: Pablo Ceballos <pceballos@google.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sensor-hub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 4256fdc5cd6d5..21fbdcde1faa1 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -496,7 +496,8 @@ static int sensor_hub_raw_event(struct hid_device *hdev,
 		return 1;
 
 	ptr = raw_data;
-	ptr++; /* Skip report id */
+	if (report->id)
+		ptr++; /* Skip report id */
 
 	spin_lock_irqsave(&pdata->lock, flags);
 
-- 
2.27.0

