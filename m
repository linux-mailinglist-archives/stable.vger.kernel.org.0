Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64581797ED
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389998AbfG2Tpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389995AbfG2Tpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA92205F4;
        Mon, 29 Jul 2019 19:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429543;
        bh=Nm+DdMfrx22BmpitA66yxbqrvKT69xec84px/qKygiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Af3XWxHrNzh4IRoWY3TTzcWkqCLTc/zD/Wcf+83WVBCBn8EvbvXI7XPKbyry0AEC
         fFRjGvcSO5fJ+FbNuprlSIYrwSO6v61ZXVa52d+hqY6DuoSU1oM5mcXev591yaqOv9
         PUklM5GK1V2IML9CaB6Gukygd7uuYgXATV5bkeuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Crouse <jcrouse@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 018/215] drm/msm/a6xx: Check for ERR or NULL before iounmap
Date:   Mon, 29 Jul 2019 21:20:14 +0200
Message-Id: <20190729190742.759232009@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5ca4a094ba7e1369363dcbcbde8baf06ddcdc2d1 ]

pdcptr and seqptr aren't necessarily valid, check them before trying to
unmap them.

Changes in v2:
- None

Cc: Jordan Crouse <jcrouse@codeaurora.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190523171653.138678-3-sean@poorly.run
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 38e2cfa9cec7..418bb08bbed7 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -504,8 +504,10 @@ static void a6xx_gmu_rpmh_init(struct a6xx_gmu *gmu)
 	wmb();
 
 err:
-	devm_iounmap(gmu->dev, pdcptr);
-	devm_iounmap(gmu->dev, seqptr);
+	if (!IS_ERR_OR_NULL(pdcptr))
+		devm_iounmap(gmu->dev, pdcptr);
+	if (!IS_ERR_OR_NULL(seqptr))
+		devm_iounmap(gmu->dev, seqptr);
 }
 
 /*
-- 
2.20.1



