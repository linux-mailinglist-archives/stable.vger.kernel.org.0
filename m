Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E4429C1BD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819055AbgJ0R06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775404AbgJ0Owr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:52:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B5A20679;
        Tue, 27 Oct 2020 14:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810366;
        bh=RqoNtxLvZDXjwWq65NRmbyJOPlcrRK3br0R+j9qvFIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryLVsTDrw9NTzLCvxyYO/RgWl3CV76ODEm59X07Gb8EWDlw+T0vJ/82hRYwZ8e6hg
         JkfO5pTS/JUOyTeOjjqcy4BsZ1Qmx8m+lQsG08M7qywhQaPeRyfRTxOS/uWgCoXEa/
         u0r95XhCPhL6ZMhAy40eIMFU5zgkbnp/TL23OWL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Stefan Schaeckeler <schaecsn@gmx.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 083/633] EDAC/aspeed: Fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:47:06 +0100
Message-Id: <20201027135526.587186049@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index b194658b8b5c9..fbec28dc661d7 100644
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



