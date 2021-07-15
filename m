Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F43CA934
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbhGOTFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243670AbhGOTEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65DE7613E9;
        Thu, 15 Jul 2021 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375628;
        bh=Eo8Jbmb8tL5W0zT3vAsE3KWlJekJz4W0Ag3DYmH9gQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKsdVKz44dg4J6oJqWmXhZ9tjDGEHhRKJ93BUCGxXYGc+/TfLAfScdlv8UfPJXZ8p
         Y9tBb2r4r3qQEQLj7dFVepRQSCKpctwZgGPEpgpXWyiDm/Y2VUsV7e88thkVWZ6aVe
         XCyBysGC+7izrOol15labCwVKrXsx2rHa97Nw0IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.12 169/242] drm/vc4: crtc: Skip the TXP
Date:   Thu, 15 Jul 2021 20:38:51 +0200
Message-Id: <20210715182622.996843908@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit 47a50743031ad4138050ae6d266ddd3dfe845ead upstream.

The vc4_set_crtc_possible_masks is meant to run over all the encoders
and then set their possible_crtcs mask to their associated pixelvalve.

However, since the commit 39fcb2808376 ("drm/vc4: txp: Turn the TXP into
a CRTC of its own"), the TXP has been turned to a CRTC and encoder of
its own, and while it does indeed register an encoder, it no longer has
an associated pixelvalve. The code will thus run over the TXP encoder
and set a bogus possible_crtcs mask, overriding the one set in the TXP
bind function.

In order to fix this, let's skip any virtual encoder.

Cc: <stable@vger.kernel.org> # v5.9+
Fixes: 39fcb2808376 ("drm/vc4: txp: Turn the TXP into a CRTC of its own")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210507150515.257424-3-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vc4/vc4_crtc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -1076,6 +1076,9 @@ static void vc4_set_crtc_possible_masks(
 		struct vc4_encoder *vc4_encoder;
 		int i;
 
+		if (encoder->encoder_type == DRM_MODE_ENCODER_VIRTUAL)
+			continue;
+
 		vc4_encoder = to_vc4_encoder(encoder);
 		for (i = 0; i < ARRAY_SIZE(pv_data->encoder_types); i++) {
 			if (vc4_encoder->type == encoder_types[i]) {


