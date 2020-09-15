Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0A526B437
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgIOXTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2D122581;
        Tue, 15 Sep 2020 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180192;
        bh=nXF2EjRsDyXF2BVeXg6+pPHvvV1eApRGioivUuOmVSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6bnTtht+sRzxEdaOZq+31AidUlw5lI46L4H5YEAh9dV14zSU6WnijvQGjBKRZrCP
         7AO33OThOFoaEqrVNSJEzTJzKt8gBZ6SckGk7Qh8hxQn6aur+LtgsY8B0LB5SuI7SF
         p9sgvWIyOyc+grnxjY5YWomPk+eklnrWaKsxOXnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.8 144/177] drm/msm: Disable preemption on all 5xx targets
Date:   Tue, 15 Sep 2020 16:13:35 +0200
Message-Id: <20200915140700.560603331@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Crouse <jcrouse@codeaurora.org>

commit 7b3f3948c8b7053d771acc9f79810cc410f5e2e0 upstream.

Temporarily disable preemption on a5xx targets pending some improvements
to protect the RPTR shadow from being corrupted.

Cc: stable@vger.kernel.org
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1510,7 +1510,8 @@ struct msm_gpu *a5xx_gpu_init(struct drm
 
 	check_speed_bin(&pdev->dev);
 
-	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, 4);
+	/* Restricting nr_rings to 1 to temporarily disable preemption */
+	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, 1);
 	if (ret) {
 		a5xx_destroy(&(a5xx_gpu->base.base));
 		return ERR_PTR(ret);


