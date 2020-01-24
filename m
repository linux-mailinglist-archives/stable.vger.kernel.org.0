Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC75147F99
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbgAXLDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388348AbgAXLDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:03:36 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39DC52071A;
        Fri, 24 Jan 2020 11:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863816;
        bh=Cb+67RHWaiR8x3D2sAd/KGPR4Zt9gdxQz+rLJHNr7t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvClaLhNRNs6WQwLPHc/JqoWJOXDo6REOYShG0zXx8JaG39r6/j/qyCAcszM3wxdw
         lMLvvaWydMlK2zULQuWtaAncrzyO2FsMzStKtg48aiqO/qFsVf2IVTlB1QNwq24hzB
         4f8ilRcXlktfQgcsU12uhwsvVSOwUroZLCyzf2Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kelvin Cao <kelvin.cao@microchip.com>,
        Wesley Sheng <wesley.sheng@microchip.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/639] switchtec: Remove immediate status check after submitting MRPC command
Date:   Fri, 24 Jan 2020 10:24:13 +0100
Message-Id: <20200124093057.770531375@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5aaa4ce04ec3d..ceb7ab3ba3d09 100644
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



