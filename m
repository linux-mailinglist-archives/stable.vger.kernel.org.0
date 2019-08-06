Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9FB83C86
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbfHFVmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbfHFVfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:35:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70A4C21874;
        Tue,  6 Aug 2019 21:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127300;
        bh=0/I9yaWwLfbVKWZtR4EeIsv5AWU4gyl+tYZMLtkaT/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3eA7Ptb2ZX3rT3jh+daN44b6WbHR2C8pT0EDF1OjPDpy0fOw/Z/lLwfUjqd/0foG
         0v6OerFKBZm0LSG6w8RYNaAewa/SxJnYcUnUC3GRqWHos9K7hxaFpoBZogDQeLPLpx
         IHm4RQ2btxo2qMxqToQvYFIbMP3xrfS9DhPQNDds=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 51/59] drm/exynos: fix missing decrement of retry counter
Date:   Tue,  6 Aug 2019 17:33:11 -0400
Message-Id: <20190806213319.19203-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 1bbbab097a05276e312dd2462791d32b21ceb1ee ]

Currently the retry counter is not being decremented, leading to a
potential infinite spin if the scalar_reads don't change state.

Addresses-Coverity: ("Infinite loop")
Fixes: 280e54c9f614 ("drm/exynos: scaler: Reset hardware before starting the operation")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_scaler.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_scaler.c b/drivers/gpu/drm/exynos/exynos_drm_scaler.c
index ec9c1b7d31033..8989f8af716b7 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_scaler.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_scaler.c
@@ -94,12 +94,12 @@ static inline int scaler_reset(struct scaler_context *scaler)
 	scaler_write(SCALER_CFG_SOFT_RESET, SCALER_CFG);
 	do {
 		cpu_relax();
-	} while (retry > 1 &&
+	} while (--retry > 1 &&
 		 scaler_read(SCALER_CFG) & SCALER_CFG_SOFT_RESET);
 	do {
 		cpu_relax();
 		scaler_write(1, SCALER_INT_EN);
-	} while (retry > 0 && scaler_read(SCALER_INT_EN) != 1);
+	} while (--retry > 0 && scaler_read(SCALER_INT_EN) != 1);
 
 	return retry ? 0 : -EIO;
 }
-- 
2.20.1

