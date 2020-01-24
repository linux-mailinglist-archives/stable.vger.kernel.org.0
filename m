Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05D4147FC9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388762AbgAXLFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388109AbgAXLFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:05:07 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F2D2071A;
        Fri, 24 Jan 2020 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863906;
        bh=Q/imQNWJc/u+kqaGrCdMn5Hb7bV/yzpvtxjtsY49jq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2zM3Zkp/tN+OlhUBQ9atnoZadKU+o/e1Rhi1FT9YjQWJVVAZnEE37/DErBR/xdKt
         p6mPAfMDl3c70R/xnw+z6Dka/tzKQ08taw/eolXGV8lzrDG4vmT9Z8WdV0R0AXi8S+
         D6GRv7JWa1j12QDqyBWhd6b4ueV5rSXgw91j4RKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/639] drm: Fix error handling in drm_legacy_addctx
Date:   Fri, 24 Jan 2020 10:24:49 +0100
Message-Id: <20200124093102.211273878@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f973d287696a6..da5abf24f59ff 100644
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



