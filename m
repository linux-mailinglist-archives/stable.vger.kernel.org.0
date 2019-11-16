Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE42AFF3BC
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfKPQ10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbfKPPlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:37 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3041207DD;
        Sat, 16 Nov 2019 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918897;
        bh=BNG1lRWcivrcVSSJ5JADbls1JW9lsGLGjJzIes5u76M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vj6id7x1gbWWMmLcGbW+YWHyVXmVAMiK/uB94I5SJiziJun67hdQGbC1fYl6HlKDs
         Z63PM5FgkPEU8m7ZC/QbYMuTfn1Au6DeojXEslmf5dN6xTEe15Dnje9wypHIWL8Zx6
         +I3o00JmakNnLUSdxEDXdmwkCkIUfEriuBMcjxxE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 023/237] spi: sh-msiof: fix deferred probing
Date:   Sat, 16 Nov 2019 10:37:38 -0500
Message-Id: <20191116154113.7417-23-sashal@kernel.org>
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

[ Upstream commit f34c6e6257aa477cdfe7e9bbbecd3c5648ecda69 ]

Since commit 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
platform_get_irq() can return -EPROBE_DEFER. However, the driver overrides
an error returned by that function with -ENOENT which breaks the deferred
probing. Propagate upstream an error code returned by platform_get_irq()
and remove the bogus "platform" from the error message, while at it...

Fixes: 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sh-msiof.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 101cd6aae2ea5..30ea0a2068e09 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -1343,8 +1343,8 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 
 	i = platform_get_irq(pdev, 0);
 	if (i < 0) {
-		dev_err(&pdev->dev, "cannot get platform IRQ\n");
-		ret = -ENOENT;
+		dev_err(&pdev->dev, "cannot get IRQ\n");
+		ret = i;
 		goto err1;
 	}
 
-- 
2.20.1

