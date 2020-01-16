Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A937513F7D1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgAPQ4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733255AbgAPQ4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84EFB20730;
        Thu, 16 Jan 2020 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193796;
        bh=OZl7IZgkwyMRmVRuwE0X41/L3zEhmaK/dbmjNhpb7nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RejDn44MhvciSExXVIx4y3NH4OE7S+keTf+kJnUcJr8Q/ZByrqGtxae5twH3cuPfZ
         6DHFQ4QuPL9D6QfmEwksZnRhlL5uy+/NEfME/Zy3poxOe2nTmuL2tRWET/ly3ZBvx7
         PZn3akPj9zaHzHkKCez+QRhH41hUdF1+qFhBMW6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kelvin Cao <kelvin.cao@microchip.com>,
        Wesley Sheng <wesley.sheng@microchip.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 066/671] switchtec: Remove immediate status check after submitting MRPC command
Date:   Thu, 16 Jan 2020 11:44:57 -0500
Message-Id: <20200116165502.8838-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kelvin Cao <kelvin.cao@microchip.com>

[ Upstream commit 526180408b815aa7b96fd48bd23cdd33ef04e38e ]

After submitting a Firmware Download MRPC command, Switchtec firmware will
delay Management EP BAR MemRd TLP responses by more than 10ms.  This is a
firmware limitation.  Delayed MemRd completions are a problem for systems
with a low Completion Timeout (CTO).

The current driver checks the MRPC status immediately after submitting an
MRPC command, which results in a delayed MemRd completion that may cause a
Completion Timeout.

Remove the immediate status check and rely on the check after receiving an
interrupt or timing out.

This is only a software workaround to the READ issue and a proper fix of
this should be done in firmware.

Fixes: 080b47def5e5 ("MicroSemi Switchtec management interface driver")
Signed-off-by: Kelvin Cao <kelvin.cao@microchip.com>
Signed-off-by: Wesley Sheng <wesley.sheng@microchip.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 5aaa4ce04ec3..ceb7ab3ba3d0 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -134,10 +134,6 @@ static void mrpc_cmd_submit(struct switchtec_dev *stdev)
 		    stuser->data, stuser->data_len);
 	iowrite32(stuser->cmd, &stdev->mmio_mrpc->cmd);
 
-	stuser->status = ioread32(&stdev->mmio_mrpc->status);
-	if (stuser->status != SWITCHTEC_MRPC_STATUS_INPROGRESS)
-		mrpc_complete_cmd(stdev);
-
 	schedule_delayed_work(&stdev->mrpc_timeout,
 			      msecs_to_jiffies(500));
 }
-- 
2.20.1

