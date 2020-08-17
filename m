Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADAA246B16
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbgHQPsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730667AbgHQPr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:47:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF50F20885;
        Mon, 17 Aug 2020 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679275;
        bh=vcYNCL5/9mq9ibantMeR/ePQd791tr0m4Mwn7r4lLeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqySKKxNjeq961sbjwm0Fsg0xdFJastxr80Ve2HPBfVwTZDatxSLZC++7BKyKqHN5
         X9Or7YCH4mUU/KUVLN9z3MBSD6bxrOYO1jeZh4nEeexMvEoJWfyNYG+/O2Dm4evchP
         YNcX/Fpsw9xd2y2RQzjJxhH9H8xTj91eN8knjKN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        amd-gfx@lists.freedesktop.org,
        Emil Velikov <emil.velikov@collabora.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 125/393] drm/amdgpu: use the unlocked drm_gem_object_put
Date:   Mon, 17 Aug 2020 17:12:55 +0200
Message-Id: <20200817143825.671975039@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emil Velikov <emil.velikov@collabora.com>

[ Upstream commit 1a87f67a66de4ad0c0d79fd86b6c5273143387c3 ]

The driver does not hold struct_mutex, thus using the locked version of
the helper is incorrect.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Fixes: a39414716ca0 ("drm/amdgpu: add independent DMA-buf import v9")
Signed-off-by: Emil Velikov <emil.velikov@collabora.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200515095118.2743122-8-emil.l.velikov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index ffeb20f11c07c..728f76cc536ee 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -552,7 +552,7 @@ struct drm_gem_object *amdgpu_gem_prime_import(struct drm_device *dev,
 	attach = dma_buf_dynamic_attach(dma_buf, dev->dev,
 					&amdgpu_dma_buf_attach_ops, obj);
 	if (IS_ERR(attach)) {
-		drm_gem_object_put(obj);
+		drm_gem_object_put_unlocked(obj);
 		return ERR_CAST(attach);
 	}
 
-- 
2.25.1



