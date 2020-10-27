Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA76A29C31B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821367AbgJ0RnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902297AbgJ0OcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6780A22264;
        Tue, 27 Oct 2020 14:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809130;
        bh=CarXUol4ius3zcQ5mRKza32zmL/tiUNWnjM1Ueti1xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBhE33PuDXk8FvEUzGfwsTzBq7FaRh5PTeouom/Vt3EaU3DdhcvShJvj7Z2oS+j2t
         DNFEqJoeu4CwBi0nUe1h8y9JheRXc8Xx7iMqDtolwLyaJlXGByyHzOwZQTuQJzXtkc
         u3vij+pcIgkPJIs5nIHO+1YA1iRacEKJoe1dqwJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Stefan Schaeckeler <schaecsn@gmx.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/408] EDAC/aspeed: Fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:49:54 +0100
Message-Id: <20201027135457.663956457@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit afce6996943be265fa39240b67025cfcb1bcdfb1 ]

platform_get_irq() returns a negative error number on error. In such a
case, comparison to 0 would pass the check therefore check the return
value properly, whether it is negative.

 [ bp: Massage commit message. ]

Fixes: 9b7e6242ee4e ("EDAC, aspeed: Add an Aspeed AST2500 EDAC driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Stefan Schaeckeler <schaecsn@gmx.net>
Link: https://lkml.kernel.org/r/20200827070743.26628-1-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/aspeed_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/aspeed_edac.c b/drivers/edac/aspeed_edac.c
index 5634437bb39d2..66669f9d690be 100644
--- a/drivers/edac/aspeed_edac.c
+++ b/drivers/edac/aspeed_edac.c
@@ -209,8 +209,8 @@ static int config_irq(void *ctx, struct platform_device *pdev)
 	/* register interrupt handler */
 	irq = platform_get_irq(pdev, 0);
 	dev_dbg(&pdev->dev, "got irq %d\n", irq);
-	if (!irq)
-		return -ENODEV;
+	if (irq < 0)
+		return irq;
 
 	rc = devm_request_irq(&pdev->dev, irq, mcr_isr, IRQF_TRIGGER_HIGH,
 			      DRV_NAME, ctx);
-- 
2.25.1



