Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FD43C384B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhGJXyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233452AbhGJXxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8FE1613D0;
        Sat, 10 Jul 2021 23:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961055;
        bh=aD8XV9XLZ4JVCmFcrM3hHPxrQLL829VsssuJS/dPJa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npxcP5Fm/wJnHUrbTA6XPcbviIJG82dmrXD5Z1FrWJPGv/SjHHlMsDEihGq6Ftp8q
         G5aPquNnjbjfcHLP4MtWkYdgdMit7YDOdDg7YlkZ4WDE2HNCA8/8vNE3IyKRvHBVIb
         IwvK/KRD4nkKjjir/GObaTllzqILjDnSjX/yilgUv4Fn8R3SVkzUxJhKcDgey7gExw
         0x+34uCzhQHVgrWwTYlRzfwMbOLcPynTXEsgkvcrURWbyT7eca2s1LEaFHHMdU0AW2
         zaYlLX0W6DL/zabs7M8xQ6yE1ya0ur7kWRzib39sHKFTYSzIFZ7+5mXmOp3lFz9vVU
         iBvkpCMOx+CWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/37] pwm: img: Fix PM reference leak in img_pwm_enable()
Date:   Sat, 10 Jul 2021 19:50:07 -0400
Message-Id: <20210710235016.3221124-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit fde25294dfd8e36e4e30b693c27a86232864002a ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-img.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-img.c b/drivers/pwm/pwm-img.c
index a34d95ed70b2..22c002e685b3 100644
--- a/drivers/pwm/pwm-img.c
+++ b/drivers/pwm/pwm-img.c
@@ -156,7 +156,7 @@ static int img_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct img_pwm_chip *pwm_chip = to_img_pwm_chip(chip);
 	int ret;
 
-	ret = pm_runtime_get_sync(chip->dev);
+	ret = pm_runtime_resume_and_get(chip->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

