Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C3A3A49D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 12:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfFIKIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 06:08:54 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:36945 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIKIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 06:08:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0FF853C7;
        Sun,  9 Jun 2019 06:08:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 06:08:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hFNtPi
        ij13TfEoWJwjNnPKJ4JlOKRjDPU6yF6jolqZI=; b=TzX62IVVq96Z2dQskLuUtC
        KROGxyo3I18XVzJbFqZ6GFfu+TQ8XQo6UuJ4rh4Uz5srNI3IrTGC8QHHdbWFAdgm
        oxwkHjzyIOTv9MKz8G06RAg5O3g0DKFR9PdJWAby1zY7vHbD3US4oM6K1+jD7sVk
        ey/uauqu4yk1GYFqpe4OJRcoBe1FTHo8SRmpKxv01NvHx+KNE/RFmfe2PBuLNQ8/
        sL67jL5kgHvvL1xHF2qGZJWeKAV9h/xwvjxhJstZDDdnG1DWCK/+2+BI5QgTpt/F
        oH4BXEDU+afwyp36S8+C5rbqOEo+O7FApR0oLQY0QxcVGumcGLUFldr/nRB5Htzw
        ==
X-ME-Sender: <xms:tNr8XEL4ZKHEbcBFa7luJ1Usa21Yto0mumS2gNmbTMVGi6-Ut91fZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:tNr8XPpJsLwBKzsDEH1ovZgGolozK34M8KDN5DGAPE7tIgiED15WpA>
    <xmx:tNr8XLte0gdB9XkyLB0o3eDK16auc5ki89MKjm0fKyqXLnyMqeK9Pg>
    <xmx:tNr8XKVd50zfSfBhvcTIeaYpNKJmS3g8GudWRFo5OaqXiRSKfWNRxA>
    <xmx:tNr8XGUaBA1BTTDDEffw2TItyf7ehN7V0XB7wnj8WbFAbkKFAReEPA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D40F4380073;
        Sun,  9 Jun 2019 06:08:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vc4: fix fb references in async update" failed to apply to 4.19-stable tree
To:     helen.koike@collabora.com, boris.brezillon@collabora.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 12:08:49 +0200
Message-ID: <156007492924468@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c16b85559dcfb5a348cc085a7b4c75ed49b05e2c Mon Sep 17 00:00:00 2001
From: Helen Koike <helen.koike@collabora.com>
Date: Mon, 3 Jun 2019 13:56:09 -0300
Subject: [PATCH] drm/vc4: fix fb references in async update

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

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 4d918d3e4858..afc80b245ea3 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -1025,7 +1025,7 @@ static void vc4_plane_atomic_async_update(struct drm_plane *plane,
 {
 	struct vc4_plane_state *vc4_state, *new_vc4_state;
 
-	drm_atomic_set_fb_for_plane(plane->state, state->fb);
+	swap(plane->state->fb, state->fb);
 	plane->state->crtc_x = state->crtc_x;
 	plane->state->crtc_y = state->crtc_y;
 	plane->state->crtc_w = state->crtc_w;

