Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A881A111E86
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbfLCWyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730246AbfLCWyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41DB12053B;
        Tue,  3 Dec 2019 22:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413647;
        bh=SuHJO9KBBvsWwPusjwAJI4z2nSO4KEDYibgE4E+Y0e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBZjwf4VzLslMR5TPfbEzStmLfYaxFIx9CTm26VOYX8MOk3UHMf7wZ0MBlwsuEfkD
         Nuy+BCz5Nk+ERSCRAg4pjV2/Jc/Qiq2fR/YK5Tkrf9hij1Zd5BRo/1PNSs7MSG/frh
         CDLhvdlTFOJEWE1nkgWTtt4g5xRq+HG5Xu4AbZ6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 207/321] firmware: arm_sdei: Fix DT platform device creation
Date:   Tue,  3 Dec 2019 23:34:33 +0100
Message-Id: <20191203223437.891760322@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



