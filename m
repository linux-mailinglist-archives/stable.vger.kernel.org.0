Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E3217132
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgGGPZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgGGPZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 707DA20663;
        Tue,  7 Jul 2020 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135505;
        bh=CRsp8Ec+JpsS3ZUjCJ42n8X82VJfnOI53L8lqcpxqto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/V4TTyT8GdBAsl5fIxFLqu0GddUHQ50/P1N3m+HkndMGsyK2FDjOAosdN+aWe25t
         a+dJGIH1FI5z+u0NOw0AibQV8fX3TUCYYah28JAsL7TY3cFmMQrLDjfJ/uFRw6Gvk+
         2gLCjKlUgu4fSvtnAtgs07Ccx9Y2S+hg/64K78Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 068/112] thermal/drivers/sprd: Fix return value of sprd_thm_probe()
Date:   Tue,  7 Jul 2020 17:17:13 +0200
Message-Id: <20200707145804.233688901@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit b4147917ad4ff2c755e01a7ca296b14030d2d507 ]

When call function devm_platform_ioremap_resource(), we should use IS_ERR()
to check the return value and return PTR_ERR() if failed.

Fixes: 554fdbaf19b1 ("thermal: sprd: Add Spreadtrum thermal driver support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1590371941-25430-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/sprd_thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/sprd_thermal.c b/drivers/thermal/sprd_thermal.c
index a340374e8c51a..4cde70dcf6556 100644
--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -348,8 +348,8 @@ static int sprd_thm_probe(struct platform_device *pdev)
 
 	thm->var_data = pdata;
 	thm->base = devm_platform_ioremap_resource(pdev, 0);
-	if (!thm->base)
-		return -ENOMEM;
+	if (IS_ERR(thm->base))
+		return PTR_ERR(thm->base);
 
 	thm->nr_sensors = of_get_child_count(np);
 	if (thm->nr_sensors == 0 || thm->nr_sensors > SPRD_THM_MAX_SENSOR) {
-- 
2.25.1



