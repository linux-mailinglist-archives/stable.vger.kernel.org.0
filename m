Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90DA13E2F1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAPQ7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387507AbgAPQ5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA39521582;
        Thu, 16 Jan 2020 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193850;
        bh=loheZiKuFd82TFuV3kzeUih75ENh/ikI0zT5Mo6oE5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0DzWE/hc1xl00uHZ04zFYvwWHTa5foSQHvRNc9gklXLaUWDoI1Bu2bwYy2djQikw
         YHakyJxl2jMHl6WqRhisWqaesXv97e6Tmrc5dIgp++JTgMHPETMch8gNpWFvscA8lz
         Dbh8576q0m1h/MmDvF6fom8IAUmm3INhvSI0JpjE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 102/671] drm: Fix error handling in drm_legacy_addctx
Date:   Thu, 16 Jan 2020 11:45:33 -0500
Message-Id: <20200116165502.8838-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c39191feed4540fed98badeb484833dcf659bb96 ]

'ctx->handle' is unsigned, it never less than zero.
This patch use int 'tmp_handle' to handle the err condition.

Fixes: 62968144e673 ("drm: convert drm context code to use Linux idr")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20181229024907.12852-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_context.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_context.c b/drivers/gpu/drm/drm_context.c
index f973d287696a..da5abf24f59f 100644
--- a/drivers/gpu/drm/drm_context.c
+++ b/drivers/gpu/drm/drm_context.c
@@ -361,23 +361,26 @@ int drm_legacy_addctx(struct drm_device *dev, void *data,
 {
 	struct drm_ctx_list *ctx_entry;
 	struct drm_ctx *ctx = data;
+	int tmp_handle;
 
 	if (!drm_core_check_feature(dev, DRIVER_KMS_LEGACY_CONTEXT) &&
 	    !drm_core_check_feature(dev, DRIVER_LEGACY))
 		return -EINVAL;
 
-	ctx->handle = drm_legacy_ctxbitmap_next(dev);
-	if (ctx->handle == DRM_KERNEL_CONTEXT) {
+	tmp_handle = drm_legacy_ctxbitmap_next(dev);
+	if (tmp_handle == DRM_KERNEL_CONTEXT) {
 		/* Skip kernel's context and get a new one. */
-		ctx->handle = drm_legacy_ctxbitmap_next(dev);
+		tmp_handle = drm_legacy_ctxbitmap_next(dev);
 	}
-	DRM_DEBUG("%d\n", ctx->handle);
-	if (ctx->handle < 0) {
+	DRM_DEBUG("%d\n", tmp_handle);
+	if (tmp_handle < 0) {
 		DRM_DEBUG("Not enough free contexts.\n");
 		/* Should this return -EBUSY instead? */
-		return -ENOMEM;
+		return tmp_handle;
 	}
 
+	ctx->handle = tmp_handle;
+
 	ctx_entry = kmalloc(sizeof(*ctx_entry), GFP_KERNEL);
 	if (!ctx_entry) {
 		DRM_DEBUG("out of memory\n");
-- 
2.20.1

