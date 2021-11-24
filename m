Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB345BD9B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245102AbhKXMji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245126AbhKXMhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:37:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1709611EE;
        Wed, 24 Nov 2021 12:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756544;
        bh=Zp0agFttRGJmUwL5YIDPncoYTD7hwXxrpT78pMUNGAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+5U+7dMB/q5HKVZmlogUum8QR0y/PMFPuqX3R6Szw/7qOrgPogQrW2u+1BAqYo2E
         gpabrNAZSgopAVllnr/Dx2mo87x+ejhobwdH+6CWo79p+lKJy9hjvcEm/h4Bplw7EZ
         5c16Z4antCscNTfqWw9KNwgPFl7JNrdbOgk3KLxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 122/251] drm/msm: uninitialized variable in msm_gem_import()
Date:   Wed, 24 Nov 2021 12:56:04 +0100
Message-Id: <20211124115714.485781647@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index b9403851f37f3..072a5f150dd61 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -959,7 +959,7 @@ static struct drm_gem_object *_msm_gem_new(struct drm_device *dev,
 
 	ret = msm_gem_new_impl(dev, size, flags, NULL, &obj, struct_mutex_locked);
 	if (ret)
-		goto fail;
+		return ERR_PTR(ret);
 
 	if (use_vram) {
 		struct msm_gem_vma *vma;
@@ -1029,7 +1029,7 @@ struct drm_gem_object *msm_gem_import(struct drm_device *dev,
 
 	ret = msm_gem_new_impl(dev, size, MSM_BO_WC, dmabuf->resv, &obj, false);
 	if (ret)
-		goto fail;
+		return ERR_PTR(ret);
 
 	drm_gem_private_object_init(dev, obj, size);
 
-- 
2.33.0



