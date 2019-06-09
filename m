Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033543AAB6
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfFIQp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730153AbfFIQpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A2F2083D;
        Sun,  9 Jun 2019 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098755;
        bh=Mjf7Rt6iqYHloLb1/9Qpabwbah0SAIVcdVrP/WMBHPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khT2CwfpxnTOiSgnwt/EK28J4NVrKY1QKQdFhqZW98vf2xS79vrppnOG752oD45T6
         UqOZD4CeNABqmV51SveXrLlzhjtwCCYTIO1dc5z1xJyiEOAbctoOSTz7VIQlRCy8L1
         J+rkwHsJSZ5NyuxJMc5vPBjmBcy7NgilcG6OAimc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Helen Koike <helen.koike@collabora.com>
Subject: [PATCH 5.1 50/70] drm/vc4: fix fb references in async update
Date:   Sun,  9 Jun 2019 18:42:01 +0200
Message-Id: <20190609164131.618666447@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Koike <helen.koike@collabora.com>

commit c16b85559dcfb5a348cc085a7b4c75ed49b05e2c upstream.

Async update callbacks are expected to set the old_fb in the new_state
so prepare/cleanup framebuffers are balanced.

Calling drm_atomic_set_fb_for_plane() (which gets a reference of the new
fb and put the old fb) is not required, as it's taken care by
drm_mode_cursor_universal() when calling drm_atomic_helper_update_plane().

Cc: <stable@vger.kernel.org> # v4.19+
Fixes: 539c320bfa97 ("drm/vc4: update cursors asynchronously through atomic")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190603165610.24614-5-helen.koike@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vc4/vc4_plane.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -968,7 +968,7 @@ static void vc4_plane_atomic_async_updat
 {
 	struct vc4_plane_state *vc4_state, *new_vc4_state;
 
-	drm_atomic_set_fb_for_plane(plane->state, state->fb);
+	swap(plane->state->fb, state->fb);
 	plane->state->crtc_x = state->crtc_x;
 	plane->state->crtc_y = state->crtc_y;
 	plane->state->crtc_w = state->crtc_w;


