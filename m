Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F8B371BF4
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhECQu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhECQrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:47:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C446191B;
        Mon,  3 May 2021 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059985;
        bh=R4z/pEi3GiFfFhP0w1RPPxuvznQ43s/lLLRKX6g9rGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvGNet3hHD8tr5J9b2NzSEtcknokLKkBpQ/IVES8DptEwku+T15ISbjW+7dFJc/F+
         6xK75NfWQEPyO15MbEHrNtTxiNCLUQaPHeXXuwYjnYAULEb+MjedcA7paLGCUxqbM0
         qvTRveQvMvwEVXinLfxlrPPOuq2ta462OboCpPeH4te5bp+Hh4MMpwbLy+/t6nd118
         BeFhVJ4easOuqoUYZKwA+us7ZALCwG6MYRQD9OA8hrMKhqrkMu7gy+hTxSPyNxzFMb
         JFYePWsurtZ/jaDmjWHQkE62oKg5THKTuhXNOFEoctXE3VOr38ppd/Da6/gXhbPqxL
         7KYshRl686zzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 02/57] drm/qxl: release shadow on shutdown
Date:   Mon,  3 May 2021 12:38:46 -0400
Message-Id: <20210503163941.2853291-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index 9abf3dc5ef99..a6ee10cbcfdd 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -1237,6 +1237,10 @@ int qxl_modeset_init(struct qxl_device *qdev)
 
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

