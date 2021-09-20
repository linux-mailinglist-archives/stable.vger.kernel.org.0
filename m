Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E128D41209F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354596AbhITR4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355067AbhITRwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 667DE61BF3;
        Mon, 20 Sep 2021 17:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157974;
        bh=bbwQ7qaaek0b1eGHS5zbSzr0sQq1cumGAQxaFHr5mcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEbxxLUSJbCrsfZxWuek6B5y5Fqw++H+jlIZt1PXiv53vQTAEI8ry+cQ5aEiFSUqo
         4KCvCz1QEMG8caCDfGCj8WzQbhU3sJWNnextuB7mc0ixzbJd5NE9HvBSsehsVbn1Cb
         BUIh2SRZ4pq8udCumtIUEdUxm0HRyEIsSzxQ31m8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 210/293] media: tegra-cec: Handle errors of clk_prepare_enable()
Date:   Mon, 20 Sep 2021 18:42:52 +0200
Message-Id: <20210920163940.461021383@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 38367073c796a37a61549b1f66a71b3adb03802d ]

tegra_cec_probe() and tegra_cec_resume() ignored possible errors of
clk_prepare_enable(). The patch fixes this.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index aba488cd0e64..a2c20ca799c4 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -383,7 +383,11 @@ static int tegra_cec_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_prepare_enable(cec->clk);
+	ret = clk_prepare_enable(cec->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to prepare clock for CEC\n");
+		return ret;
+	}
 
 	/* set context info. */
 	cec->dev = &pdev->dev;
@@ -462,9 +466,7 @@ static int tegra_cec_resume(struct platform_device *pdev)
 
 	dev_notice(&pdev->dev, "Resuming\n");
 
-	clk_prepare_enable(cec->clk);
-
-	return 0;
+	return clk_prepare_enable(cec->clk);
 }
 #endif
 
-- 
2.30.2



