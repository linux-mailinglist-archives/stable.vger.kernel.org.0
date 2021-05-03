Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2210C371AC1
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhECQlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhECQjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D4D960FD7;
        Mon,  3 May 2021 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059825;
        bh=qzBd5KFoOot3ymsfol1NFk7ANSu/74D3rjHu6RHVPIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNcfoylACspnbkSLp3yhVbzrnk1CYsmQaKawvF8bEOcEeiqJNa0nYYu0nxUbDr7Zg
         jGsL18hpI4AKwYZ6ZhdpHeZQT89OSBJmHYB5qhkt9wtvuY9VcQzg908T+d/yBmkJQi
         fbooIIPtH+WHtXDZbatjC648oKPdiprHWqlh6llj7ITi++mRKSqyJnwlliZTQ1iZW0
         UiRB36R27NsHJKxME5+G+DFS02beiiikkVoCjiUr9/asTUARe+M/ptilBaqlKMl5yg
         3rcIB3eYSJ7UvoQ67AuRypla8P+MdwT2YnjYbPGLChoODCDi6m73eHyynrfuloEnhl
         woaRs/EWqxakw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 003/115] drm/qxl: release shadow on shutdown
Date:   Mon,  3 May 2021 12:35:07 -0400
Message-Id: <20210503163700.2852194-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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

