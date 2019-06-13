Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D1D43FE5
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbfFMQBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731445AbfFMIsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:48:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F5B920851;
        Thu, 13 Jun 2019 08:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415715;
        bh=hb/yPd0jay9VD9wOzIBZBggrne/PATPTlnErEp2gjZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzMMQcoe32FF/oSzOS0av34IcHqw+Pa2SIp/C9iIxJtH7XABF4lhm7aeUYHcscoBs
         YU2e2gDlbVdQe4PLbNVVXo9VnASXlVaHnMtZyTGyuuRwh2nyKKTvkWllJsARYEa+SX
         8TfIbrH9iPhSmQ98D+atBnMKTw79TvQ7t7FdVwf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 093/155] soc/tegra: pmc: Remove reset sysfs entries on error
Date:   Thu, 13 Jun 2019 10:33:25 +0200
Message-Id: <20190613075658.287981807@linuxfoundation.org>
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

[ Upstream commit a46b51cd2a57d52d5047e1d48240536243eeab34 ]

Commit 5f84bb1a4099 ("soc/tegra: pmc: Add sysfs entries for reset info")
added sysfs entries for Tegra reset source and level. However, these
sysfs are not removed on error and so if the registering of PMC device
is probe deferred, then the next time we attempt to probe the PMC device
warnings such as the following will be displayed on boot ...

  sysfs: cannot create duplicate filename '/devices/platform/7000e400.pmc/reset_reason'

Fix this by calling device_remove_file() for each sysfs entry added on
failure. Note that we call device_remove_file() unconditionally without
checking if the sysfs entry was created in the first place, but this
should be OK because kernfs_remove_by_name_ns() will fail silently.

Fixes: 5f84bb1a4099 ("soc/tegra: pmc: Add sysfs entries for reset info")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index 0df258518693..2fba8cdbe3bd 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -1999,7 +1999,7 @@ static int tegra_pmc_probe(struct platform_device *pdev)
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_powergate_debugfs_init();
 		if (err < 0)
-			return err;
+			goto cleanup_sysfs;
 	}
 
 	err = register_restart_handler(&tegra_pmc_restart_handler);
@@ -2030,6 +2030,9 @@ cleanup_restart_handler:
 	unregister_restart_handler(&tegra_pmc_restart_handler);
 cleanup_debugfs:
 	debugfs_remove(pmc->debugfs);
+cleanup_sysfs:
+	device_remove_file(&pdev->dev, &dev_attr_reset_reason);
+	device_remove_file(&pdev->dev, &dev_attr_reset_level);
 	return err;
 }
 
-- 
2.20.1



