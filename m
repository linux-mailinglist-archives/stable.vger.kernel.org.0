Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058AD3FDC8C
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbhIAMvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346377AbhIAMty (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 850BF611AD;
        Wed,  1 Sep 2021 12:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500089;
        bh=CdRcFy2cVarRpNp79J7awKdCMkQH/R2IxvEQu7u/jW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofEnJRLslPlzNsfFyhIpGMCO1RJzLMc6jIxqN/bKczpJysCWTSw/gEmwi+BTXjSKX
         fIjZrcYrQnuvkGyfqQDbc51ux+LqZEKzcnENabVKrj5XtRYn4pBQ/TniRTeN0/P1p8
         xc/ffzDaMlxZch9YRyNS3IWs+CV1NHP+WTf3JgEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 065/113] media: ipu3-cio2: Drop reference on error path in cio2_bridge_connect_sensor()
Date:   Wed,  1 Sep 2021 14:28:20 +0200
Message-Id: <20210901122304.140896701@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 294c34e704e78d641b039064ce72d4531afe0088 ]

The commit 71f642833284 ("ACPI: utils: Fix reference counting in
for_each_acpi_dev_match()") moved adev assignment outside of error
path and hence made acpi_dev_put(sensor->adev) a no-op. We still
need to drop reference count on error path, and to achieve that,
replace sensor->adev by locally assigned adev.

Fixes: 71f642833284 ("ACPI: utils: Fix reference counting in for_each_acpi_dev_match()")
Depends-on: fc68f42aa737 ("ACPI: fix NULL pointer dereference")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/cio2-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu3/cio2-bridge.c b/drivers/media/pci/intel/ipu3/cio2-bridge.c
index 59a36f922675..30d29b96a339 100644
--- a/drivers/media/pci/intel/ipu3/cio2-bridge.c
+++ b/drivers/media/pci/intel/ipu3/cio2-bridge.c
@@ -226,7 +226,7 @@ static int cio2_bridge_connect_sensor(const struct cio2_sensor_config *cfg,
 err_free_swnodes:
 	software_node_unregister_nodes(sensor->swnodes);
 err_put_adev:
-	acpi_dev_put(sensor->adev);
+	acpi_dev_put(adev);
 	return ret;
 }
 
-- 
2.30.2



