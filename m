Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDBB3CA7D5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbhGOS4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241909AbhGOS4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C5C2613C4;
        Thu, 15 Jul 2021 18:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375188;
        bh=pJZwj/2qO08ARvSq+wP2r6Sdm1b7xs+2pt2ITJOuBXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7khkaJqDqaNJ/rVsE9aIS25AOqx3JuZws3XjGnrho6rsKq2isqkenu7YreYZBhS6
         ZEQ4WZCwPYXTZ3RLhz7KV2lh4eNYnCsFp0GZwyYUZI15KKDMHjg5DUt1o3IXGLF6W4
         9Wb1kamu4NlKcuDzv0Uc1pOsA9JSdlRPwTUL/6v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.10 154/215] drm/vc4: crtc: Skip the TXP
Date:   Thu, 15 Jul 2021 20:38:46 +0200
Message-Id: <20210715182626.726856393@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
@@ -1042,6 +1042,9 @@ static void vc4_set_crtc_possible_masks(
 		struct vc4_encoder *vc4_encoder;
 		int i;
 
+		if (encoder->encoder_type == DRM_MODE_ENCODER_VIRTUAL)
+			continue;
+
 		vc4_encoder = to_vc4_encoder(encoder);
 		for (i = 0; i < ARRAY_SIZE(pv_data->encoder_types); i++) {
 			if (vc4_encoder->type == encoder_types[i]) {


