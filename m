Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E55442A2
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbfFMQYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730999AbfFMIhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:37:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14D320851;
        Thu, 13 Jun 2019 08:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415037;
        bh=tsq33OGpH8Ed+bhP/jNlUP6cW0WzhPE3CsVbsnYAJg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCJ4ZEw8BPDlTPNl4QPGVleVaQ7HiIdJmyrqcyVaGRdZ9Qwl1t/vUMBaggHBk6HQ2
         wAdKcm66eio52l2Ld2etXSS0HvVEZl04vX0PhAMs5k1TUWDk1dVXoRAkNG7Jpywc1F
         x7bvpY+mbxLQkf07z/uWYHhmNyiIZ5EXBydXmZHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Chang <junxiao.chang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 62/81] platform/x86: intel_pmc_ipc: adding error handling
Date:   Thu, 13 Jun 2019 10:33:45 +0200
Message-Id: <20190613075653.637257140@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e61985d0550df8c2078310202aaad9b41049c36c ]

If punit or telemetry device initialization fails, pmc driver should
unregister and return failure.

This change is to fix a kernel panic when removing kernel module
intel_pmc_ipc.

Fixes: 48c1917088ba ("platform:x86: Add Intel telemetry platform device")
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_ipc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_pmc_ipc.c b/drivers/platform/x86/intel_pmc_ipc.c
index e03fa31446ca..c9b3ef333743 100644
--- a/drivers/platform/x86/intel_pmc_ipc.c
+++ b/drivers/platform/x86/intel_pmc_ipc.c
@@ -747,13 +747,17 @@ static int ipc_create_pmc_devices(void)
 	if (ret) {
 		dev_err(ipcdev.dev, "Failed to add punit platform device\n");
 		platform_device_unregister(ipcdev.tco_dev);
+		return ret;
 	}
 
 	if (!ipcdev.telem_res_inval) {
 		ret = ipc_create_telemetry_device();
-		if (ret)
+		if (ret) {
 			dev_warn(ipcdev.dev,
 				"Failed to add telemetry platform device\n");
+			platform_device_unregister(ipcdev.punit_dev);
+			platform_device_unregister(ipcdev.tco_dev);
+		}
 	}
 
 	return ret;
-- 
2.20.1



