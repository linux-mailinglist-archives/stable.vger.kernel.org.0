Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB67D3CDF97
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343733AbhGSPKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345846AbhGSPJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49AC261001;
        Mon, 19 Jul 2021 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709768;
        bh=aD8XV9XLZ4JVCmFcrM3hHPxrQLL829VsssuJS/dPJa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTcMpyj+cdMOFXIgQDPNWrZJO8yfdwcx2jRvzZ16YDI4JxAWN9QEuPF9dyOgPHXSC
         zvZ4CnU9LOgV5as3yJmsyFf4ORGo7DPgzdoU/FWYvcSAfgJFXuIHcH24xG3hlgHkUr
         pSSumlrANAD1JZScWXjyj/qs3uDG+6Yg1RwMtW4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/149] pwm: img: Fix PM reference leak in img_pwm_enable()
Date:   Mon, 19 Jul 2021 16:53:17 +0200
Message-Id: <20210719144922.476555250@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



