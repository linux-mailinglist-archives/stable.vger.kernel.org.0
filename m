Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BE12469EC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgHQP1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729942AbgHQP1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:27:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B48012395A;
        Mon, 17 Aug 2020 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678062;
        bh=Be9bnFR/qhCB1VOcb3WJyzG81zm0wVIlrCEePGk53wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJGGHDrHTcEVB0uCZJSvPQBsZyhpg7tGvnERrTwPGYAMwbL2Pu7l0usSyRiCb9rB9
         7kb37VhI42w3uXInOjKjIf0zSm11AirYqHoah7/DY6QUMQAyM9YAv43adD9tgq+cpi
         GVqzs12s/okjS8DI6ilEPRJtzSZQTP2SoBRSbkUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 205/464] media: allegro: Fix some NULL vs IS_ERR() checks in probe
Date:   Mon, 17 Aug 2020 17:12:38 +0200
Message-Id: <20200817143843.634712149@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d93d45ab716e4107056be54969c8c70e50a8346d ]

The devm_ioremap() function doesn't return error pointers, it returns
NULL on error.

Fixes: f20387dfd065 ("media: allegro: add Allegro DVT video IP core driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/allegro-dvt/allegro-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/allegro-dvt/allegro-core.c b/drivers/staging/media/allegro-dvt/allegro-core.c
index 70f133a842ddf..3ed66aae741d5 100644
--- a/drivers/staging/media/allegro-dvt/allegro-core.c
+++ b/drivers/staging/media/allegro-dvt/allegro-core.c
@@ -3065,9 +3065,9 @@ static int allegro_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 	regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (IS_ERR(regs)) {
+	if (!regs) {
 		dev_err(&pdev->dev, "failed to map registers\n");
-		return PTR_ERR(regs);
+		return -ENOMEM;
 	}
 	dev->regmap = devm_regmap_init_mmio(&pdev->dev, regs,
 					    &allegro_regmap_config);
@@ -3085,9 +3085,9 @@ static int allegro_probe(struct platform_device *pdev)
 	sram_regs = devm_ioremap(&pdev->dev,
 				 sram_res->start,
 				 resource_size(sram_res));
-	if (IS_ERR(sram_regs)) {
+	if (!sram_regs) {
 		dev_err(&pdev->dev, "failed to map sram\n");
-		return PTR_ERR(sram_regs);
+		return -ENOMEM;
 	}
 	dev->sram = devm_regmap_init_mmio(&pdev->dev, sram_regs,
 					  &allegro_sram_config);
-- 
2.25.1



