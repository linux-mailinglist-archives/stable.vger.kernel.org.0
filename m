Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CF83AABC
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbfFIQqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730337AbfFIQqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 730C32081C;
        Sun,  9 Jun 2019 16:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098774;
        bh=xZk6V8W47holid3x8sEAl6DZJWT45f42r7gly3AseKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQ18AyBjCnfSORN4gXbYQ8iRohdH0bv+pvNM7o/1asCIyMPNCW0xCFLZDtLkWgfpl
         Q9xUVTJeG3EVrDW1JKBvttIqS4/EG0xqdFDExH9hrYDc1vX4hYFEuhLiIGv8ieMEFI
         OJgpqdaahKBsFbgCxZ/bmFU8jrjSxMwUtxkJbgpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.1 56/70] drm: Fix timestamp docs for variable refresh properties.
Date:   Sun,  9 Jun 2019 18:42:07 +0200
Message-Id: <20190609164132.173948370@linuxfoundation.org>
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

From: Mario Kleiner <mario.kleiner.de@gmail.com>

commit 0cbd0adc4429930567083d18cc8c0fbc5f635d96 upstream.

As discussed with Nicholas and Daniel Vetter (patchwork
link to discussion below), the VRR timestamping behaviour
produced utterly useless and bogus vblank/pageflip
timestamps. We have found a way to fix this and provide
sane behaviour.

As of Linux 5.2, the amdgpu driver will be able to
provide exactly the same vblank / pageflip timestamp
semantic in variable refresh rate mode as in standard
fixed refresh rate mode. This is achieved by deferring
core vblank handling (drm_crtc_handle_vblank()) until
the end of front porch, and also defer the sending of
pageflip completion events until end of front porch,
when we can safely compute correct pageflip/vblank
timestamps.

The same approach will be possible for other VRR
capable kms drivers, so we can actually have sane
and useful timestamps in VRR mode.

This patch removes the section of the docs that
describes the broken timestamp behaviour present
in Linux 5.0/5.1.

Fixes: ab7a664f7a2d ("drm: Document variable refresh properties")
Link: https://patchwork.freedesktop.org/patch/285333/
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190418060157.18968-1-mario.kleiner.de@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_connector.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -1385,12 +1385,6 @@ EXPORT_SYMBOL(drm_mode_create_scaling_mo
  *
  *	The driver may place further restrictions within these minimum
  *	and maximum bounds.
- *
- *	The semantics for the vertical blank timestamp differ when
- *	variable refresh rate is active. The vertical blank timestamp
- *	is defined to be an estimate using the current mode's fixed
- *	refresh rate timings. The semantics for the page-flip event
- *	timestamp remain the same.
  */
 
 /**


