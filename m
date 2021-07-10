Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB553C38AE
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhGJXzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233909AbhGJXy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A991F61184;
        Sat, 10 Jul 2021 23:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961094;
        bh=aD8XV9XLZ4JVCmFcrM3hHPxrQLL829VsssuJS/dPJa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5hFVtOrqYAgFDcKQrjowi601p9HnARuwfvTN9NPnc55690unnT2cRDcj0z1wirtU
         EfIGMBGyuHeXUlY1edblrzcdbRhtA5m1O2Jg1RavNNVFe9Vt+q4VDnkH3co5jokZGb
         hDkkFLEKAnaFXrxXe9Tvj4+hd9xNs+yY+NlF7Ct5x9agVBC5mXIoXp1DS5zevIJKN8
         5zbMcCYPelIx+N6n1p5cNnV+M6gr1j+b2VEbQdQDmEkazV+yeRqYkdBkOCKT0A5PLL
         9Vg1pvdH+AgU/vyAatkTU0/nSzpITKQdbSN6KT060KsgciD4HeE+u10vqaJ77Zz7qp
         uw0XtpNwpSF3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/28] pwm: img: Fix PM reference leak in img_pwm_enable()
Date:   Sat, 10 Jul 2021 19:51:00 -0400
Message-Id: <20210710235107.3221840-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
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

