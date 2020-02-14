Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B3515E548
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393355AbgBNQkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:40:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405532AbgBNQWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5775246D4;
        Fri, 14 Feb 2020 16:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697365;
        bh=3gwgFUqvJ8N/VlvUVeaLWqEWpiO5LJUZARXPEDPwzPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9R0hlrLI5+vGGLi/8odzx2iu0v5kjK5GJlDJdjqZ/A8Tk3iDEOefYXDPYe9uLXav
         QVmPuMg70Qo4bXcWd3BSgsipBT7VPU+P3UpvecfqbggmXljmIG2N7XGLa267CSfddm
         RSd2GBOEvWFO6u4kDnhFJ39hTiAJr/KTVZ2HCu/A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 065/141] bcma: remove set but not used variable 'sizel'
Date:   Fri, 14 Feb 2020 11:20:05 -0500
Message-Id: <20200214162122.19794-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit f427939391f290cbeabe0231eb8a116429d823f0 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/bcma/scan.c: In function ‘bcma_erom_get_addr_desc’:

drivers/bcma/scan.c:222:20: warning: variable ‘sizel’ set but
not used [-Wunused-but-set-variable]

It is never used, and so can be removed.

Fixes: 8369ae33b705 ("bcma: add Broadcom specific AMBA bus driver")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bcma/scan.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 4a2d1b235fb5a..1f2de714b4017 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -219,7 +219,7 @@ static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 __iomem **eromptr)
 static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 				  u32 type, u8 port)
 {
-	u32 addrl, addrh, sizel, sizeh = 0;
+	u32 addrl, addrh, sizeh = 0;
 	u32 size;
 
 	u32 ent = bcma_erom_get_ent(bus, eromptr);
@@ -239,12 +239,9 @@ static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 
 	if ((ent & SCAN_ADDR_SZ) == SCAN_ADDR_SZ_SZD) {
 		size = bcma_erom_get_ent(bus, eromptr);
-		sizel = size & SCAN_SIZE_SZ;
 		if (size & SCAN_SIZE_SG32)
 			sizeh = bcma_erom_get_ent(bus, eromptr);
-	} else
-		sizel = SCAN_ADDR_SZ_BASE <<
-				((ent & SCAN_ADDR_SZ) >> SCAN_ADDR_SZ_SHIFT);
+	}
 
 	return addrl;
 }
-- 
2.20.1

