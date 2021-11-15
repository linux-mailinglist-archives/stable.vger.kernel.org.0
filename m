Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8A5450B70
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhKORYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237456AbhKORVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:21:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9343363260;
        Mon, 15 Nov 2021 17:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996673;
        bh=jQvvg21ZeU47m2ul6km2pLito+11k3tAFYEop3tNm7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HqDB1cGcd4cmYUw0GQPyInrsyMNdLoPYqubMD2buzLfeeBqHZQSlLEisXCDktglR
         r4LENCBp1xigPWypxnqpYQib3BKWhowpvgOTLjs8PuC7DYEioluJLvljRGp04XElnE
         8lHvNxuy3R4az80OjwLyYalk7qJTU+BtxMPF3MRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 225/355] drm/msm: uninitialized variable in msm_gem_import()
Date:   Mon, 15 Nov 2021 18:02:29 +0100
Message-Id: <20211115165321.037821621@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index d92a0ffe2a767..8e6a4d5f3a405 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -1036,7 +1036,7 @@ static struct drm_gem_object *_msm_gem_new(struct drm_device *dev,
 
 	ret = msm_gem_new_impl(dev, size, flags, &obj);
 	if (ret)
-		goto fail;
+		return ERR_PTR(ret);
 
 	msm_obj = to_msm_bo(obj);
 
@@ -1124,7 +1124,7 @@ struct drm_gem_object *msm_gem_import(struct drm_device *dev,
 
 	ret = msm_gem_new_impl(dev, size, MSM_BO_WC, &obj);
 	if (ret)
-		goto fail;
+		return ERR_PTR(ret);
 
 	drm_gem_private_object_init(dev, obj, size);
 
-- 
2.33.0



