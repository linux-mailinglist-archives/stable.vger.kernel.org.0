Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156DE451DC9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345563AbhKPAeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343909AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06311633A3;
        Mon, 15 Nov 2021 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002108;
        bh=Jqqs2JsX1RDMyz1K0QdyYUP2KhcTbRPxPU15WVe6Vn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eW87uUDHJD0n8EVqLaDonKBgzFuX95TZCRuluQM0PFIaY7QcTye/ZA2YtRKGA4sps
         WMyeMJXCalWTrVhBqgMf3wses57F1rqGPUz/1WbKnMP+pnDrgK7/BJ9A2X/c/X/5dW
         MtJY7hqNyYGEghIN/ikDftrf0auZD1x0ci9h7KMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/917] drm/msm: uninitialized variable in msm_gem_import()
Date:   Mon, 15 Nov 2021 17:58:56 +0100
Message-Id: <20211115165443.735252462@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 2203bd0e5c12ffc53ffdd4fbd7b12d6ba27e0424 ]

The msm_gem_new_impl() function cleans up after itself so there is no
need to call drm_gem_object_put().  Conceptually, it does not make sense
to call a kref_put() function until after the reference counting has
been initialized which happens immediately after this call in the
drm_gem_(private_)object_init() functions.

In the msm_gem_import() function the "obj" pointer is uninitialized, so
it will lead to a crash.

Fixes: 05b849111c07 ("drm/msm: prime support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211013081315.GG6010@kili
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index fd398a4eaf46e..bd6ec04f345e1 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -1167,7 +1167,7 @@ struct drm_gem_object *msm_gem_new(struct drm_device *dev, uint32_t size, uint32
 
 	ret = msm_gem_new_impl(dev, size, flags, &obj);
 	if (ret)
-		goto fail;
+		return ERR_PTR(ret);
 
 	msm_obj = to_msm_bo(obj);
 
@@ -1251,7 +1251,7 @@ struct drm_gem_object *msm_gem_import(struct drm_device *dev,
 
 	ret = msm_gem_new_impl(dev, size, MSM_BO_WC, &obj);
 	if (ret)
-		goto fail;
+		return ERR_PTR(ret);
 
 	drm_gem_private_object_init(dev, obj, size);
 
-- 
2.33.0



