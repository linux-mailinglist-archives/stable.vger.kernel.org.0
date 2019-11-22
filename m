Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5A1060D8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfKVFwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:52:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728485AbfKVFwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636A520717;
        Fri, 22 Nov 2019 05:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401938;
        bh=SuHJO9KBBvsWwPusjwAJI4z2nSO4KEDYibgE4E+Y0e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDtzdJbY4BrMkC5TLNllgu+iAe1XBMCFDLfrlcwQmaoL+xEf3KcAtU/FhW2PrQDds
         T4l7CEvxy7ytSDiWMwqVp8OYbp45tg8lorVW16l5lm4oyhyAbL8U7Ayqzan9IclFd7
         NuqSJJ/HdrSVnrhUhFwv45xepaaFV5NU3shgwDAM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 163/219] firmware: arm_sdei: Fix DT platform device creation
Date:   Fri, 22 Nov 2019 00:48:15 -0500
Message-Id: <20191122054911.1750-156-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit acafce48b07bf5f9994a38e7fe237193d43d092e ]

It turns out the dt-probing part of this wasn't tested properly after it
was merged. commit 3aa0582fdb82 ("of: platform: populate /firmware/ node
from of_platform_default_populate_init()") changed the core-code to
generate the platform devices, meaning the driver's attempt fails, and it
bails out.

Fix this by removing the manual platform-device creation for DT systems,
core code has always done this for us.

CC: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_sdei.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index dffb47c6b4801..c64c7da738297 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -1009,7 +1009,6 @@ static struct platform_driver sdei_driver = {
 
 static bool __init sdei_present_dt(void)
 {
-	struct platform_device *pdev;
 	struct device_node *np, *fw_np;
 
 	fw_np = of_find_node_by_name(NULL, "firmware");
@@ -1019,11 +1018,7 @@ static bool __init sdei_present_dt(void)
 	np = of_find_matching_node(fw_np, sdei_of_match);
 	if (!np)
 		return false;
-
-	pdev = of_platform_device_create(np, sdei_driver.driver.name, NULL);
 	of_node_put(np);
-	if (!pdev)
-		return false;
 
 	return true;
 }
-- 
2.20.1

