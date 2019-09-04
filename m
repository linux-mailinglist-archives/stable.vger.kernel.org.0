Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36941A89F8
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbfIDP6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731737AbfIDP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A938320820;
        Wed,  4 Sep 2019 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612684;
        bh=P61d7vQAF7kIVJkuTM20VyYtHx9B6Qw/zHAPMhHkpuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8ZpGCgfT0UFdcsQtcjYlh+MYMDuwoXrcAYTupFVBYRnnU+iGRiSGUmhsxKNnKRre
         qsHRfal1++IOMVV6h+LUDLA9joIUNnNA5hb6xGM8HX8F12NsCbz6TAm3rHuu60OZF3
         R2P/2Dpj6vqw6TAit+zXf0ZrGlevUgRxOMQLXhns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 15/94] bus: ti-sysc: Simplify cleanup upon failures in sysc_probe()
Date:   Wed,  4 Sep 2019 11:56:20 -0400
Message-Id: <20190904155739.2816-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
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
index 58b38630171ff..0d122440d1111 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2079,27 +2079,27 @@ static int sysc_probe(struct platform_device *pdev)
 
 	error = sysc_init_dts_quirks(ddata);
 	if (error)
-		goto unprepare;
+		return error;
 
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
 
 	sysc_init_early_quirks(ddata);
 
@@ -2109,7 +2109,7 @@ static int sysc_probe(struct platform_device *pdev)
 
 	error = sysc_init_resets(ddata);
 	if (error)
-		return error;
+		goto unprepare;
 
 	error = sysc_init_module(ddata);
 	if (error)
-- 
2.20.1

