Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594323AAB9
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfFIQqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730223AbfFIQqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEB020833;
        Sun,  9 Jun 2019 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098760;
        bh=0w8EPY/CHDH5XzP9DrRziVgz6vAycpXOVTkTfLm0cYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8p3Yl/bht597szCHk549rIJrLzsN/UNM3RbqjV3QK2p5iSdo+iwfYTiP5s4uTvFp
         ORshFH1dar/LKMKC1xDdunIhsnuE4qvec8xWBiIaQI9ScS1uuTN9uu+CZvttp/hVAP
         J90rVlj6SRtB5DLBl6HOeZYv4fI11UBKcXItPips=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Helen Koike <helen.koike@collabora.com>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 5.1 52/70] drm/msm: fix fb references in async update
Date:   Sun,  9 Jun 2019 18:42:03 +0200
Message-Id: <20190609164131.797339670@linuxfoundation.org>
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
@@ -502,6 +502,8 @@ static int mdp5_plane_atomic_async_check
 static void mdp5_plane_atomic_async_update(struct drm_plane *plane,
 					   struct drm_plane_state *new_state)
 {
+	struct drm_framebuffer *old_fb = plane->state->fb;
+
 	plane->state->src_x = new_state->src_x;
 	plane->state->src_y = new_state->src_y;
 	plane->state->crtc_x = new_state->crtc_x;
@@ -524,6 +526,8 @@ static void mdp5_plane_atomic_async_upda
 
 	*to_mdp5_plane_state(plane->state) =
 		*to_mdp5_plane_state(new_state);
+
+	new_state->fb = old_fb;
 }
 
 static const struct drm_plane_helper_funcs mdp5_plane_helper_funcs = {


