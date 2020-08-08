Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5396123FA6C
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgHHXmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbgHHXkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:40:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC48120825;
        Sat,  8 Aug 2020 23:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596930006;
        bh=Ugj656t5RRt2/JcPvMMlruvQsjZtitRhzSD+95JsPLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHl54+v0rSLO0w+llkMth3n4bUIwE5C3b8lX4jwU3ZL1b7YoPro2yNq7VS7yqxmAr
         oOof8eJ5hyor+4O/59Rszh+60tjlwGSv12w83oW+rHPxVs9QN4SYf4wPRaxgCK1fSp
         edye+H6o9wwpGbTXA1nQBMC03cajvHmtyPSqemJI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Wei <luwei32@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/21] platform/x86: intel-vbtn: Fix return value check in check_acpi_dev()
Date:   Sat,  8 Aug 2020 19:39:36 -0400
Message-Id: <20200808233941.3619277-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233941.3619277-1-sashal@kernel.org>
References: <20200808233941.3619277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit 64dd4a5a7d214a07e3d9f40227ec30ac8ba8796e ]

In the function check_acpi_dev(), if it fails to create
platform device, the return value is ERR_PTR() or NULL.
Thus it must use IS_ERR_OR_NULL() to check return value.

Fixes: 332e081225fc ("intel-vbtn: new driver for Intel Virtual Button")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index d122f33d43acb..c7c8b432c163f 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -272,7 +272,7 @@ check_acpi_dev(acpi_handle handle, u32 lvl, void *context, void **rv)
 		return AE_OK;
 
 	if (acpi_match_device_ids(dev, ids) == 0)
-		if (acpi_create_platform_device(dev, NULL))
+		if (!IS_ERR_OR_NULL(acpi_create_platform_device(dev, NULL)))
 			dev_info(&dev->dev,
 				 "intel-vbtn: created platform device\n");
 
-- 
2.25.1

