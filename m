Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DD1F708
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbfD3Ltm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731039AbfD3Ltm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D989C20449;
        Tue, 30 Apr 2019 11:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624981;
        bh=7GntyMXcWt4UU0gvioaIi9lga+nZyYFukfanMAnLfzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kC47u7pG+/KX/WAdJv4eb7B1UnmWKBuY2lazb4AhCUrdBUGl/NDwAMZ/A134F1e7U
         CF6iax2fuGRdfPz2Rf+1XmMFa8EzfevPR2MvYHShufh7g/LaY3OJP1jncvN072f11u
         cKg+Sq79Gyrfy93wAJhV7yuPfZTNiqC3eB3deXFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.0 44/89] Revert "drm/i915/fbdev: Actually configure untiled displays"
Date:   Tue, 30 Apr 2019 13:38:35 +0200
Message-Id: <20190430113611.821040876@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit 9fa246256e09dc30820524401cdbeeaadee94025 upstream.

This reverts commit d179b88deb3bf6fed4991a31fd6f0f2cad21fab5.

This commit is documented to break userspace X.org modesetting driver in certain configurations.

The X.org modesetting userspace driver is broken. No fixes are available yet. In order for this patch to be applied it either needs a config option or a workaround developed.

This has been reported a few times, saying it's a userspace problem is clearly against the regression rules.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=109806
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: <stable@vger.kernel.org> # v3.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_fbdev.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/intel_fbdev.c
@@ -336,8 +336,8 @@ static bool intel_fb_initial_config(stru
 				    bool *enabled, int width, int height)
 {
 	struct drm_i915_private *dev_priv = to_i915(fb_helper->dev);
+	unsigned long conn_configured, conn_seq, mask;
 	unsigned int count = min(fb_helper->connector_count, BITS_PER_LONG);
-	unsigned long conn_configured, conn_seq;
 	int i, j;
 	bool *save_enabled;
 	bool fallback = true, ret = true;
@@ -355,9 +355,10 @@ static bool intel_fb_initial_config(stru
 		drm_modeset_backoff(&ctx);
 
 	memcpy(save_enabled, enabled, count);
-	conn_seq = GENMASK(count - 1, 0);
+	mask = GENMASK(count - 1, 0);
 	conn_configured = 0;
 retry:
+	conn_seq = conn_configured;
 	for (i = 0; i < count; i++) {
 		struct drm_fb_helper_connector *fb_conn;
 		struct drm_connector *connector;
@@ -370,8 +371,7 @@ retry:
 		if (conn_configured & BIT(i))
 			continue;
 
-		/* First pass, only consider tiled connectors */
-		if (conn_seq == GENMASK(count - 1, 0) && !connector->has_tile)
+		if (conn_seq == 0 && !connector->has_tile)
 			continue;
 
 		if (connector->status == connector_status_connected)
@@ -475,10 +475,8 @@ retry:
 		conn_configured |= BIT(i);
 	}
 
-	if (conn_configured != conn_seq) { /* repeat until no more are found */
-		conn_seq = conn_configured;
+	if ((conn_configured & mask) != mask && conn_configured != conn_seq)
 		goto retry;
-	}
 
 	/*
 	 * If the BIOS didn't enable everything it could, fall back to have the


