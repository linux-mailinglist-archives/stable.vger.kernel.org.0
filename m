Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D5A8AAB
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbfIDQAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732646AbfIDQAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9BBB2070C;
        Wed,  4 Sep 2019 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612819;
        bh=y+twx5L5mLyZA/HpEM5GdqYd/BMLorMN/INrMAODq3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMBaNGYBm6EgPOjqWqXe3pB4Guw1Hxb51IwtOwu509GGy1lhiA0AvfXGRVw4Kx7xx
         lkQ5o6KRSwiW8X6qOxT2jfe0J6thINc3o+F8AXFdW0rgkNjULdvMpGEMED/Fz9XTph
         CC4Fy8Vkl5IvNqe7cKpsrTj2PPTOU57THGyLzJb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 10/52] bus: ti-sysc: Simplify cleanup upon failures in sysc_probe()
Date:   Wed,  4 Sep 2019 11:59:22 -0400
Message-Id: <20190904160004.3671-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit a304f483b6b00d42bde41c45ca52c670945348e2 ]

The clocks are not yet parsed and prepared until after a successful
sysc_get_clocks(), so there is no need to unprepare the clocks upon
any failure of any of the prior functions in sysc_probe(). The current
code path would have been a no-op because of the clock validity checks
within sysc_unprepare(), but let's just simplify the cleanup path by
returning the error directly.

While at this, also fix the cleanup path for a sysc_init_resets()
failure which is executed after the clocks are prepared.

Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 4ca006e2137f7..e95b26319cd91 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1685,7 +1685,7 @@ static int sysc_probe(struct platform_device *pdev)
 
 	error = sysc_init_dts_quirks(ddata);
 	if (error)
-		goto unprepare;
+		return error;
 
 	error = sysc_get_clocks(ddata);
 	if (error)
@@ -1693,27 +1693,27 @@ static int sysc_probe(struct platform_device *pdev)
 
 	error = sysc_map_and_check_registers(ddata);
 	if (error)
-		goto unprepare;
+		return error;
 
 	error = sysc_init_sysc_mask(ddata);
 	if (error)
-		goto unprepare;
+		return error;
 
 	error = sysc_init_idlemodes(ddata);
 	if (error)
-		goto unprepare;
+		return error;
 
 	error = sysc_init_syss_mask(ddata);
 	if (error)
-		goto unprepare;
+		return error;
 
 	error = sysc_init_pdata(ddata);
 	if (error)
-		goto unprepare;
+		return error;
 
 	error = sysc_init_resets(ddata);
 	if (error)
-		return error;
+		goto unprepare;
 
 	pm_runtime_enable(ddata->dev);
 	error = sysc_init_module(ddata);
-- 
2.20.1

