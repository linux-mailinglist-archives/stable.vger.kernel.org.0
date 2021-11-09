Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D26F44B572
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343491AbhKIWUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245541AbhKIWUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E89036128E;
        Tue,  9 Nov 2021 22:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496246;
        bh=AgNmh373nRImckQnKKfAtbO79J1BBixqB/5YgOmYIaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOUyWGPgOqSjwDu5w3hIs5eYsC+UPsB8t5t+n28wFFdGymXimDKUkpJ044XS5sIK3
         mNNoSrLdnEFf3gXUSuccYGUbPurD6OgPnoce1yoZ2BpEfpU12UkyzikkODygqs2LqA
         xpen2WuJNrzJ5ZNzOYo7E7DNtzCPQnL7F8M2oJavOu0OJ3IZBYVg5Iy9+5XtqxS3/s
         FnxbrJ3EZbeUegoyD5D3MXTWl1/t53jBSfSKA2nHvvRm7638d0H6g9hq3v/d3cOLRA
         tDgAH8lfJDJavSBxdpZt9xF3hIifBTyUb6pHHn4kSSjRxuk9kS5TcXN5z66gKB6gXu
         mvrmovPEbctKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 20/82] bus: ti-sysc: Use context lost quirk for otg
Date:   Tue,  9 Nov 2021 17:15:38 -0500
Message-Id: <20211109221641.1233217-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9067839ff45a528bcb015cc2f24f656126b91e3f ]

Let's use SYSC_QUIRK_REINIT_ON_CTX_LOST quirk for am335x otg instead of
SYSC_QUIRK_REINIT_ON_RESUME quirk as we can now handle the context loss
in a more generic way.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index fb3af62336983..c1e562412e465 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1526,7 +1526,7 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   0xffffffff, SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY),
 	SYSC_QUIRK("usb_otg_hs", 0, 0, 0x10, -ENODEV, 0x4ea2080d, 0xffffffff,
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY |
-		   SYSC_QUIRK_REINIT_ON_RESUME),
+		   SYSC_QUIRK_REINIT_ON_CTX_LOST),
 	SYSC_QUIRK("wdt", 0, 0, 0x10, 0x14, 0x502a0500, 0xfffff0f0,
 		   SYSC_MODULE_QUIRK_WDT),
 	/* PRUSS on am3, am4 and am5 */
-- 
2.33.0

