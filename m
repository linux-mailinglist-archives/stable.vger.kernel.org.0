Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3294829BFAE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816434AbgJ0RGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793532AbgJ0PGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9303421D24;
        Tue, 27 Oct 2020 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811208;
        bh=2feg3muA8Euj01Bgw8grGB9U/yK1bGesHqI5fFCEQcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv1U4y3txlxaY+0kMOVEfUfiJZvqqYPmAXR5XdD88chQErj7gDqrW5yoMd+5vIluC
         MT5fqLAuiGkssQBGCO5R6F7WyTPOdSfe8pZTCpu6Iv0qSuQfgn9Q7pEcvD45WIjd6L
         MK9R53Iut3jZ37SBouseNWxYUKGCuDN/if5oRJPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 410/633] maiblox: mediatek: Fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:52:33 +0100
Message-Id: <20201027135541.957724451@linuxfoundation.org>
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

[ Upstream commit 558e4c36ec9f2722af4fe8ef84dc812bcdb5c43a ]

platform_get_irq() returns -ERRNO on error.  In such case casting to u32
and comparing to 0 would pass the check.

Fixes: 623a6143a845 ("mailbox: mediatek: Add Mediatek CMDQ driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index b24822ad8409c..9963bb9cd74fa 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -69,7 +69,7 @@ struct cmdq_task {
 struct cmdq {
 	struct mbox_controller	mbox;
 	void __iomem		*base;
-	u32			irq;
+	int			irq;
 	u32			thread_nr;
 	u32			irq_mask;
 	struct cmdq_thread	*thread;
@@ -466,10 +466,8 @@ static int cmdq_probe(struct platform_device *pdev)
 	}
 
 	cmdq->irq = platform_get_irq(pdev, 0);
-	if (!cmdq->irq) {
-		dev_err(dev, "failed to get irq\n");
-		return -EINVAL;
-	}
+	if (cmdq->irq < 0)
+		return cmdq->irq;
 
 	cmdq->thread_nr = (u32)(unsigned long)of_device_get_match_data(dev);
 	cmdq->irq_mask = GENMASK(cmdq->thread_nr - 1, 0);
-- 
2.25.1



