Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74ED3A6300
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbhFNLH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232847AbhFNLFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:05:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EFDF61925;
        Mon, 14 Jun 2021 10:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667518;
        bh=ho0bdOq5GnYwMGb1t/qr3DNJ4ESJIT4cUkcZnEaefuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZoQlvvz7jEIEmVuX721qsl0tEQIjnZ4pD+DcNRwY/O69mu5qVYozDnKQvZE4KxE8
         /IzOED0EfxwAJ/QS9tyZ+zWwOu4GGCnA2brFhiqZknY3gDZrul6jyFmBE+N0TurnAR
         vDZUJnuJMCQ7uP+rhy4By44tGHWBgT1m6ryneIYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.10 102/131] drm/msm/a6xx: avoid shadow NULL reference in failure path
Date:   Mon, 14 Jun 2021 12:27:43 +0200
Message-Id: <20210614102656.466490738@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

commit ce86c239e4d218ae6040bec18e6d19a58edb8b7c upstream.

If a6xx_hw_init() fails before creating the shadow_bo, the a6xx_pm_suspend
code referencing it will crash. Change the condition to one that avoids
this problem (note: creation of shadow_bo is behind this same condition)

Fixes: e8b0b994c3a5 ("drm/msm/a6xx: Clear shadow on suspend")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20210513171431.18632-6-jonathan@marek.ca
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1128,7 +1128,7 @@ static int a6xx_pm_suspend(struct msm_gp
 	if (ret)
 		return ret;
 
-	if (adreno_gpu->base.hw_apriv || a6xx_gpu->has_whereami)
+	if (a6xx_gpu->shadow_bo)
 		for (i = 0; i < gpu->nr_rings; i++)
 			a6xx_gpu->shadow[i] = 0;
 


