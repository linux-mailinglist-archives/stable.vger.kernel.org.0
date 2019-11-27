Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E3010B9CD
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfK0U4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730524AbfK0U4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99C7520862;
        Wed, 27 Nov 2019 20:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888207;
        bh=BNG1lRWcivrcVSSJ5JADbls1JW9lsGLGjJzIes5u76M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCKAEGJAxeO+yB+6PA/Ywfn0li+QPN6rBogWIQDsYrJ3qedELMX3eyUCtMTGGgWe4
         YN9c0nCHkHq75Cpr2fZvznl4H3v+sAcn79FKWZbg5pjBsfpH2c/NIwmx5Ug+peARRF
         ELv3UXUBjLKLNBJovxoW9kKIJt/NBuW74tSQjhfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/306] spi: sh-msiof: fix deferred probing
Date:   Wed, 27 Nov 2019 21:28:14 +0100
Message-Id: <20191127203118.046197316@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



