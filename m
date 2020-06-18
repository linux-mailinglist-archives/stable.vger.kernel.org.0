Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6221FE72A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732903AbgFRCjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgFRBNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1DD2214DB;
        Thu, 18 Jun 2020 01:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442787;
        bh=tgmLfevUX9lI0PeC7Z40erGfpQqe3mE/JRPlDRFsIrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WQ90H61O20dVOwtNT9TICp1+7r5j8WLvzyKy3fdpRlCO1MqKU5ycFcHlpCAWq0Zv
         AhONtsJBGg3WWwvCwoD4QKEwCm+K4Ft8ixNJ/kf8OT9WEYFWpXOLP+XCmzUctik9dj
         UgRZqoxm9oaRcJlhsIPx2no5MiIU0mYocRXXIPsw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roy Spliet <nouveau@spliet.org>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 231/388] drm/msm/mdp5: Fix mdp5_init error path for failed mdp5_kms allocation
Date:   Wed, 17 Jun 2020 21:05:28 -0400
Message-Id: <20200618010805.600873-231-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roy Spliet <nouveau@spliet.org>

[ Upstream commit e4337877c5d578722c0716f131fb774522013cf5 ]

When allocation for mdp5_kms fails, calling mdp5_destroy() leads to undefined
behaviour, likely a nullptr exception or use-after-free troubles.

Signed-off-by: Roy Spliet <nouveau@spliet.org>
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
index 47b989834af1..c23a2fa13fb9 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
@@ -943,7 +943,8 @@ static int mdp5_init(struct platform_device *pdev, struct drm_device *dev)
 
 	return 0;
 fail:
-	mdp5_destroy(pdev);
+	if (mdp5_kms)
+		mdp5_destroy(pdev);
 	return ret;
 }
 
-- 
2.25.1

