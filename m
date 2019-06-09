Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990B63AA7C
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731465AbfFIQtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731458AbfFIQtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB11208E4;
        Sun,  9 Jun 2019 16:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098962;
        bh=PjM8XhUNVxe75X+ylHHcOfoz1DpJBfdQF8bioJZenW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQPm38OjxrRMNdc0+807x/zskML5v5ivLpXpFUxkEO0jSdoqQTIJ805uZ+G7BhEU6
         atXDrbA3DsgaCOQzXSw6Z2TN5ufrcdRkuWYts/2W58wdFi2AmiMCdRpsdHChtz/DHh
         rfX28688dALuXzpi463myI0JkIu24PZutAsdkFB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Helen Koike <helen.koike@collabora.com>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 4.19 38/51] drm/msm: fix fb references in async update
Date:   Sun,  9 Jun 2019 18:42:19 +0200
Message-Id: <20190609164129.687643766@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Koike <helen.koike@collabora.com>

commit 474d952b4870cfbdc55d3498f4d498775fe77e81 upstream.

Async update callbacks are expected to set the old_fb in the new_state
so prepare/cleanup framebuffers are balanced.

Cc: <stable@vger.kernel.org> # v4.14+
Fixes: 224a4c970987 ("drm/msm: update cursors asynchronously through atomic")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Acked-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190603165610.24614-4-helen.koike@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -503,6 +503,8 @@ static int mdp5_plane_atomic_async_check
 static void mdp5_plane_atomic_async_update(struct drm_plane *plane,
 					   struct drm_plane_state *new_state)
 {
+	struct drm_framebuffer *old_fb = plane->state->fb;
+
 	plane->state->src_x = new_state->src_x;
 	plane->state->src_y = new_state->src_y;
 	plane->state->crtc_x = new_state->crtc_x;
@@ -525,6 +527,8 @@ static void mdp5_plane_atomic_async_upda
 
 	*to_mdp5_plane_state(plane->state) =
 		*to_mdp5_plane_state(new_state);
+
+	new_state->fb = old_fb;
 }
 
 static const struct drm_plane_helper_funcs mdp5_plane_helper_funcs = {


