Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF221FDFA8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgFRBmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731708AbgFRB30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:29:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 686C922209;
        Thu, 18 Jun 2020 01:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443766;
        bh=03fCVU5g+JP9egRymhbYN0IgM6S53R3OBv/GHqButBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKRAVZ7ktGdUMrbz3FCXiAN6ZIbJUm+HKEMAmfzbT0cBuippokiHVU4BWecPAKRPL
         GKsgIvM/7mPYSQQBQeKEWAagMfrUPEhMYxACWehhKOCcBsXUm0XfS5/qbxvBEWq+pE
         VqkXyhv0JAIa6zJubkMS47CKPd77DxZJii7Xtvls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roy Spliet <nouveau@spliet.org>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 51/80] drm/msm/mdp5: Fix mdp5_init error path for failed mdp5_kms allocation
Date:   Wed, 17 Jun 2020 21:27:50 -0400
Message-Id: <20200618012819.609778-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012819.609778-1-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
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
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
index ed7143d35b25..6224aca7cd29 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
@@ -769,7 +769,8 @@ static int mdp5_init(struct platform_device *pdev, struct drm_device *dev)
 
 	return 0;
 fail:
-	mdp5_destroy(pdev);
+	if (mdp5_kms)
+		mdp5_destroy(pdev);
 	return ret;
 }
 
-- 
2.25.1

