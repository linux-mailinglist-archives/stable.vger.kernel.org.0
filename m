Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A955E371967
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhECQgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231347AbhECQgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:36:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFFF8611AE;
        Mon,  3 May 2021 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059718;
        bh=qzBd5KFoOot3ymsfol1NFk7ANSu/74D3rjHu6RHVPIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAn7YxtKdPBrcs9+YJfal4I9UZrfD2SiScAIYnaPZHv+9KDgi2VL4zb+PPk1WT9iZ
         dtI4BbMLz7yQVI+5NwhIzXSK8xMCS4HPoHdqWFpqoqJw0nlTb/D644Wpolnp6RZ53J
         MDnINpjqCnLGP7QXjlwarMN3cu7O6OGI9Jr+kaDCQfwJ0Lq6k2o5Or00xkW4ucrJzu
         fblzzCFaHFo71GgjPIqpHlZ9an/rm+tpCEEZGkYX53fy7YIfrFeDVcRMLYwYXEfp3x
         xmuloAMPb63LCIlAbxIbYZeSJyy+hkvnG3+TShHxD5xtilBwdOyIMqeTH9xUuDJyFV
         Z4IvoMFOZe9ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 003/134] drm/qxl: release shadow on shutdown
Date:   Mon,  3 May 2021 12:33:02 -0400
Message-Id: <20210503163513.2851510-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Upstream commit 4ca77c513537700d3fae69030879f781dde1904c ]

In case we have a shadow surface on shutdown release
it so it doesn't leak.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: http://patchwork.freedesktop.org/patch/msgid/20210204145712.1531203-6-kraxel@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_display.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index 10738e04c09b..56e0c6c625e9 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -1228,6 +1228,10 @@ int qxl_modeset_init(struct qxl_device *qdev)
 
 void qxl_modeset_fini(struct qxl_device *qdev)
 {
+	if (qdev->dumb_shadow_bo) {
+		drm_gem_object_put(&qdev->dumb_shadow_bo->tbo.base);
+		qdev->dumb_shadow_bo = NULL;
+	}
 	qxl_destroy_monitors_object(qdev);
 	drm_mode_config_cleanup(&qdev->ddev);
 }
-- 
2.30.2

