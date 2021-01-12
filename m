Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C602F3141
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389851AbhALM5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389785AbhALM5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A549423131;
        Tue, 12 Jan 2021 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456162;
        bh=BLAwquNKZXLn8diNN8LutklPMIW3oudpGbujxE4AkKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqfI9v5R7NX03E4V3UyhYgbw+VqK4H4eWE4luU2htmHXZZe8mUynEpS2luU4a4zOq
         iyQpLf9NxZOGt3/QAGMkKz8LW19xBpiNB2IqyemuI1tlu6DcKwSr2hGuNbN3VJAmEJ
         lAsOZN4tYCQvimYWBg2M1J85Fs9x4l2i8hQ/ROekrS8EJTLBonCjxf/FxZ43pmtuM/
         7sFNWVXou5Qh1k/rmZC4wo2I/fD74fs48xMCzOYgyxOHi9D4aygo4NXhyYYxx0dkRz
         QlGY9PQtvQVnP1UdqYUgu1b3EmZzcNkuHjVpNlmOGZGsd5lLprfRIe9ByN7Sf49dRL
         TquB9s5hBrzFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <ogabbay@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 20/51] habanalabs/gaudi: retry loading TPC f/w on -EINTR
Date:   Tue, 12 Jan 2021 07:55:02 -0500
Message-Id: <20210112125534.70280-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit 98e8781f008372057bd5cb059ca6b507371e473d ]

If loading the firmware file for the TPC f/w was interrupted, try
to do it again, up to 5 times.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 36f0bb7154ab9..ed1bd41262ecd 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -754,11 +754,17 @@ static int gaudi_init_tpc_mem(struct hl_device *hdev)
 	size_t fw_size;
 	void *cpu_addr;
 	dma_addr_t dma_handle;
-	int rc;
+	int rc, count = 5;
 
+again:
 	rc = request_firmware(&fw, GAUDI_TPC_FW_FILE, hdev->dev);
+	if (rc == -EINTR && count-- > 0) {
+		msleep(50);
+		goto again;
+	}
+
 	if (rc) {
-		dev_err(hdev->dev, "Firmware file %s is not found!\n",
+		dev_err(hdev->dev, "Failed to load firmware file %s\n",
 				GAUDI_TPC_FW_FILE);
 		goto out;
 	}
-- 
2.27.0

