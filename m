Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882012265E0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbgGTP6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732000AbgGTP6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA252065E;
        Mon, 20 Jul 2020 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260692;
        bh=0CkNs1w4+hp7Zb/ftz2DB5LZ5V5bhaCc01Eh0fyBlCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIVtB+m/Lqu7XwACKhqB9pvqSBH5WwI7Kf935WnxsuBgi6s9yyK5Sf7SLMqWc4lD1
         0Sl9Kz+TfhJtsTMOd+ibdvgek0+rLOxSqrHykpHc60lcDc/VuB/tM0RI3Nv/WfbaCJ
         3IAyWLRDiUTUrc1AK2njA0hZe6Rs0/y1O4qL6Utc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/215] drm/exynos: fix ref count leak in mic_pre_enable
Date:   Mon, 20 Jul 2020 17:35:15 +0200
Message-Id: <20200720152821.762532842@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit d4f5a095daf0d25f0b385e1ef26338608433a4c5 ]

in mic_pre_enable, pm_runtime_get_sync is called which
increments the counter even in case of failure, leading to incorrect
ref count. In case of failure, decrement the ref count before returning.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_mic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_mic.c b/drivers/gpu/drm/exynos/exynos_drm_mic.c
index b78e8c5ba553b..2aff986add899 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_mic.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_mic.c
@@ -268,8 +268,10 @@ static void mic_pre_enable(struct drm_bridge *bridge)
 		goto unlock;
 
 	ret = pm_runtime_get_sync(mic->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(mic->dev);
 		goto unlock;
+	}
 
 	mic_set_path(mic, 1);
 
-- 
2.25.1



