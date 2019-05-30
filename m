Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BAD2F33A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbfE3E11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728154AbfE3DOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 471E7244EF;
        Thu, 30 May 2019 03:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186060;
        bh=BCc15NeOx4Irdj+ofRsABC8wNfwE3dbtR0v/5IB/peg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Auz2xXd7L3a3uyV7zzC7tpj/5uzvDMUONujntAvtXEYKtzb2y5F5igzrbcs1Pq+bo
         1DMmrWLlR1ulga34KRdNhsmmrY1vuq5V8vgrlQUW/tNoMJGx8dtup+VWlyeg8+BzFw
         xgYNdY+THxkPslXBw32yE0N1FNIT2ifS9t7VGm7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Mamta Shukla <mamtashukla555@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sharat Masetty <smasetty@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 158/346] drm/msm: a5xx: fix possible object reference leak
Date:   Wed, 29 May 2019 20:03:51 -0700
Message-Id: <20190530030549.183893460@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6cd5235c3135ea84b32469ea51b2aae384eda8af ]

The call to of_get_child_by_name returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
drivers/gpu/drm/msm/adreno/a5xx_gpu.c:57:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 47, but without a corresponding object release within this function.
drivers/gpu/drm/msm/adreno/a5xx_gpu.c:66:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 47, but without a corresponding object release within this function.
drivers/gpu/drm/msm/adreno/a5xx_gpu.c:118:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 47, but without a corresponding object release within this function.
drivers/gpu/drm/msm/adreno/a5xx_gpu.c:57:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 51, but without a corresponding object release within this function.
drivers/gpu/drm/msm/adreno/a5xx_gpu.c:66:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 51, but without a corresponding object release within this function.
drivers/gpu/drm/msm/adreno/a5xx_gpu.c:118:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 51, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Sean Paul <sean@poorly.run>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Jordan Crouse <jcrouse@codeaurora.org>
Cc: Mamta Shukla <mamtashukla555@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sharat Masetty <smasetty@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: freedreno@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org (open list)
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index d5f5e56422f57..270da14cba673 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -34,7 +34,7 @@ static int zap_shader_load_mdt(struct msm_gpu *gpu, const char *fwname)
 {
 	struct device *dev = &gpu->pdev->dev;
 	const struct firmware *fw;
-	struct device_node *np;
+	struct device_node *np, *mem_np;
 	struct resource r;
 	phys_addr_t mem_phys;
 	ssize_t mem_size;
@@ -48,11 +48,13 @@ static int zap_shader_load_mdt(struct msm_gpu *gpu, const char *fwname)
 	if (!np)
 		return -ENODEV;
 
-	np = of_parse_phandle(np, "memory-region", 0);
-	if (!np)
+	mem_np = of_parse_phandle(np, "memory-region", 0);
+	of_node_put(np);
+	if (!mem_np)
 		return -EINVAL;
 
-	ret = of_address_to_resource(np, 0, &r);
+	ret = of_address_to_resource(mem_np, 0, &r);
+	of_node_put(mem_np);
 	if (ret)
 		return ret;
 
-- 
2.20.1



