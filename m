Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE5D44162
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391622AbfFMQN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731198AbfFMImb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:42:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B392063F;
        Thu, 13 Jun 2019 08:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415350;
        bh=fMyvAqWhEet+kqapguNtwwh+UxadFguoNUCNXp7W0XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHAI3qjktJRQcY7k1QnAxnryYdizZL59blaGKDFd49fk2WE/rLxRjkZGzslpt9NJS
         SoUntoifRzR9JG/laAFrxfxKF6l7p38SmIIH+icOFQdySBofmI/WHUQIK8RTMnqeSZ
         uDOIUWK8tTKtlMsicysxV2Lv0c3TWONxKQYHTNkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Chang <junxiao.chang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/118] platform/x86: intel_pmc_ipc: adding error handling
Date:   Thu, 13 Jun 2019 10:33:51 +0200
Message-Id: <20190613075649.300207286@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
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
index e7edc8c63936..4ad9d127f2f5 100644
--- a/drivers/platform/x86/intel_pmc_ipc.c
+++ b/drivers/platform/x86/intel_pmc_ipc.c
@@ -776,13 +776,17 @@ static int ipc_create_pmc_devices(void)
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



