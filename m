Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA872C9DA6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgLAJ0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387983AbgLAJFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:05:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2580F21D7F;
        Tue,  1 Dec 2020 09:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813479;
        bh=uOekAwoa5nNQ8ROk2QR8D+nSv/F4MyHfZEL3hys9E8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11L8/EpIj2EyjK2djmLI/qyeUV8jHND2G910W/ZO6L+2QwV7H5g3y8MVzXknMblGx
         w3vjufFpgc7v9/Uo7Wqkzj5NPpGYIzf86v4SCV4o2shIldSLDg5WTNyMBFNI9kcRjp
         v6rdGpa23gRcfu9FVgR3Jq053+Ugn0Eqt5U73BqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Ceballos <pceballos@google.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/98] HID: hid-sensor-hub: Fix issue with devices with no report ID
Date:   Tue,  1 Dec 2020 09:53:03 +0100
Message-Id: <20201201084655.977113941@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 94c7398b5c279..3dd7d32467378 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -483,7 +483,8 @@ static int sensor_hub_raw_event(struct hid_device *hdev,
 		return 1;
 
 	ptr = raw_data;
-	ptr++; /* Skip report id */
+	if (report->id)
+		ptr++; /* Skip report id */
 
 	spin_lock_irqsave(&pdata->lock, flags);
 
-- 
2.27.0



