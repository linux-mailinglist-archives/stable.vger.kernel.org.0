Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A33243F50
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389088AbfFMP4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731529AbfFMIvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D369A20851;
        Thu, 13 Jun 2019 08:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415880;
        bh=JuA+z/E8J/GcS987WlH7req4HxY+VEuIEI+xBM47yDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTseQMrNAVhEHbQ4M/oFJP7goWiyUu1E1pOWo+9MaSXHvWKFLxNchHho8UYsLpVUy
         m9lHZhUr0G0q3gJm0/RwGdDICe0cdWYBJRYG1ojdtcRRAuQTNk2/rN+94hqTXhEydF
         m6nC3XSTi4KxkU92fQIoWNJwJxR1v/4IxA15hG18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Chang <junxiao.chang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 120/155] platform/x86: intel_pmc_ipc: adding error handling
Date:   Thu, 13 Jun 2019 10:33:52 +0200
Message-Id: <20190613075659.589229049@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
index 7964ba22ef8d..d37cbd1cf58c 100644
--- a/drivers/platform/x86/intel_pmc_ipc.c
+++ b/drivers/platform/x86/intel_pmc_ipc.c
@@ -771,13 +771,17 @@ static int ipc_create_pmc_devices(void)
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



