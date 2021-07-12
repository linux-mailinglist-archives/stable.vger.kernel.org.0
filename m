Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43B53C49D0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbhGLGqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237160AbhGLGqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5EBB6102A;
        Mon, 12 Jul 2021 06:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072102;
        bh=LfojesEne9kT7QOl6Hk3evd0yWzDxdJJCl5+B0grj8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lf+djoNeaPrH4pLAV1eKL0y8umzKuGhdXIIOaOjNwORz6pC4QTDzkv/YuBjEuxQvC
         3ij2X80dkVBNjqO9lp2aZaTDJp/bMKAaYaPnNc5Z0TpM9UWzm5RE2i3ej78nQaPWU4
         E4JnUcc4XcGHlCbREQ6ibtyALXdVyW/GdXDBeqp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/593] drm: qxl: ensure surf.data is ininitialized
Date:   Mon, 12 Jul 2021 08:08:18 +0200
Message-Id: <20210712060923.153729978@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit fbbf23ddb2a1cc0c12c9f78237d1561c24006f50 ]

The object surf is not fully initialized and the uninitialized
field surf.data is being copied by the call to qxl_bo_create
via the call to qxl_gem_object_create. Set surf.data to zero
to ensure garbage data from the stack is not being copied.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: f64122c1f6ad ("drm: add new QXL driver. (v1.4)")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210608161313.161922-1-colin.king@canonical.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_dumb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_dumb.c b/drivers/gpu/drm/qxl/qxl_dumb.c
index c04cd5a2553c..e377bdbff90d 100644
--- a/drivers/gpu/drm/qxl/qxl_dumb.c
+++ b/drivers/gpu/drm/qxl/qxl_dumb.c
@@ -58,6 +58,8 @@ int qxl_mode_dumb_create(struct drm_file *file_priv,
 	surf.height = args->height;
 	surf.stride = pitch;
 	surf.format = format;
+	surf.data = 0;
+
 	r = qxl_gem_object_create_with_handle(qdev, file_priv,
 					      QXL_GEM_DOMAIN_SURFACE,
 					      args->size, &surf, &qobj,
-- 
2.30.2



