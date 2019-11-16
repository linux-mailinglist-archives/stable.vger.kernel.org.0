Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49A5FF2BC
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731930AbfKPQVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbfKPPno (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:44 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C96CC207FA;
        Sat, 16 Nov 2019 15:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919023;
        bh=ZD3H0fXdo26K8Pbl93wipiv94kNC0IMytMi0VTXQIIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itajPg0AeJL1QCAhtt1+MIubp5mTsWR+ay/wbXIvckOE4AmSiTRxqoLE668INt2ak
         O5OReg0ERYA3jGVr4YAdKRyBEGeG4EE9IT2K7wG+TfbCl8NqgBp/jseUiW+zNN420H
         raRvYjiQKxJK2TzpBeDt2xZVFyLitscIwYLo58yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 121/237] thermal: rcar_thermal: fix duplicate IRQ request
Date:   Sat, 16 Nov 2019 10:39:16 -0500
Message-Id: <20191116154113.7417-121-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit df016bbba63743bbef9ff5c6c282561211dd72cc ]

The driver on R8A77995 requests the same IRQ twice since
platform_get_resource() is always called for the 1st IRQ resource.

Fixes: 1969d9dc2079 ("thermal: rcar_thermal: add r8a77995 support")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 8df2ce94c28d8..edaa4058686b7 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -493,7 +493,7 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 	pm_runtime_get_sync(dev);
 
 	for (i = 0; i < chip->nirqs; i++) {
-		irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+		irq = platform_get_resource(pdev, IORESOURCE_IRQ, i);
 		if (!irq)
 			continue;
 		if (!common->base) {
-- 
2.20.1

