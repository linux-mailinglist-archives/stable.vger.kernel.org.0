Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0582FA2DF
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404851AbhAROWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390561AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7770022DFB;
        Mon, 18 Jan 2021 11:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970253;
        bh=BLAwquNKZXLn8diNN8LutklPMIW3oudpGbujxE4AkKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ot5i3JhNYkkNpiLoZBlnY554ClT/8hj1xwxs6OPHO+Wfb0MKgF0cSWM2ZzojWrgcw
         gCUlWZBp6+48GVePBk2d2F3fbWXuf9520q+6C8cKP3AevNfNgeWU/FYplgO/5zI6vW
         qTy7RdD4ZaUMMB+5xm6hYYJ2EkRyFsk929pywtQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/152] habanalabs/gaudi: retry loading TPC f/w on -EINTR
Date:   Mon, 18 Jan 2021 12:34:05 +0100
Message-Id: <20210118113356.141406587@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



