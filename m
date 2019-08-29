Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC3DA25BD
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfH2Sb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbfH2SOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1281233FF;
        Thu, 29 Aug 2019 18:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102474;
        bh=8Dh0VjqQRCbHaTfzo0/ighO2kEf8okUvbAZrdEr+2Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xITAsaJEXqjstOoDB9xqL8sIFBVfdDLvaI1eI7Eee3/3zztSo1A3//Zlf+/8rksKc
         9EcPrSfLWUJN5PTHLnt7Aq5UiECron0eeCLA3RdheXgB97t1ToDZalJOOihBtt39bz
         iJgyT3gnMeUec+rG/SOBkMlDGaVEYd/vjOZed8J4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 38/76] clk: Fix potential NULL dereference in clk_fetch_parent_index()
Date:   Thu, 29 Aug 2019 14:12:33 -0400
Message-Id: <20190829181311.7562-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 24876f09a7dfe36a82f53d304d8c1bceb3257a0f ]

Don't compare the parent clock name with a NULL name in the
clk_parent_map. This prevents a kernel crash when passing NULL
core->parents[i].name to strcmp().

An example which triggered this is a mux clock with four parents when
each of them is referenced in the clock driver using
clk_parent_data.fw_name and then calling clk_set_parent(clk, 3rd_parent)
on this mux.
In this case the first parent is also the HW default so
core->parents[i].hw is populated when the clock is registered. Calling
clk_set_parent(clk, 3rd_parent) will then go through all parents and
skip the first parent because it's hw pointer doesn't match. For the
second parent no hw pointer is cached yet and clk_core_get(core, 1)
returns a non-matching pointer (which is correct because we are comparing
the second with the third parent). Comparing the result of
clk_core_get(core, 2) with the requested parent gives a match. However
we don't reach this point because right after the clk_core_get(core, 1)
mismatch the old code tried to !strcmp(parent->name, NULL) (where the
second argument is actually core->parents[i].name, but that was never
populated by the clock driver).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lkml.kernel.org/r/20190815223155.21384-1-martin.blumenstingl@googlemail.com
Fixes: fc0c209c147f ("clk: Allow parents to be specified without string names")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 498cd7bbe8984..3a4961dc58313 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1657,7 +1657,8 @@ static int clk_fetch_parent_index(struct clk_core *core,
 			break;
 
 		/* Fallback to comparing globally unique names */
-		if (!strcmp(parent->name, core->parents[i].name))
+		if (core->parents[i].name &&
+		    !strcmp(parent->name, core->parents[i].name))
 			break;
 	}
 
-- 
2.20.1

