Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEF13289A9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbhCASCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:02:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238831AbhCAR4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AE726518E;
        Mon,  1 Mar 2021 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618633;
        bh=ckxHLvFKvoF17lImaw2sSva6+o8neRVfvEyUBkftZxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llAmt715uodpyzAsuboyubVMUMQKB/1QSDTjL+ZeMi492NZAMiLJAE4VHzRMBSRkO
         bQrhBenz53GcPktVFBLUvbC2ZFoKnJCZhEBNBNco1MZomipgS6BaXTuUVJ3FSYuAi6
         jiBQKk8gFpA5O8kECBG8kCY7cACLBH9fT/MOYQYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/663] drm/fourcc: fix Amlogic format modifier masks
Date:   Mon,  1 Mar 2021 17:06:46 +0100
Message-Id: <20210301161149.587987259@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit cc3283f8f41f741fbaef63d0503d8fb4a7919100 ]

The comment says the layout and options use 8 bits, and the shift
uses 8 bits. However the mask is 0xf, ie. 0b00001111 (4 bits).

This could be surprising when introducing new layouts or options
that take more than 4 bits, as this would silently drop the high
bits.

Make the masks consistent with the comment and the shift.

Found when writing a drm_info patch [1].

[1]: https://github.com/ascent12/drm_info/pull/67

Signed-off-by: Simon Ser <contact@emersion.fr>
Fixes: d6528ec88309 ("drm/fourcc: Add modifier definitions for describing Amlogic Video Framebuffer Compression")
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Kevin Hilman <khilman@baylibre.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210110125103.15447-1-contact@emersion.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/drm_fourcc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 82f3278012677..5498d7a6556a7 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -997,9 +997,9 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
  * Not all combinations are valid, and different SoCs may support different
  * combinations of layout and options.
  */
-#define __fourcc_mod_amlogic_layout_mask 0xf
+#define __fourcc_mod_amlogic_layout_mask 0xff
 #define __fourcc_mod_amlogic_options_shift 8
-#define __fourcc_mod_amlogic_options_mask 0xf
+#define __fourcc_mod_amlogic_options_mask 0xff
 
 #define DRM_FORMAT_MOD_AMLOGIC_FBC(__layout, __options) \
 	fourcc_mod_code(AMLOGIC, \
-- 
2.27.0



