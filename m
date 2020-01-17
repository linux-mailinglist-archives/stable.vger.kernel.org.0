Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A9D1411AE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 20:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgAQTbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 14:31:08 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44938 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgAQTbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 14:31:08 -0500
Received: by mail-yb1-f193.google.com with SMTP id f136so6635081ybg.11
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 11:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xPTHjBNu4VtrBqVG645UC3saugAIeeYvWqQHdj1RQv8=;
        b=WRgjs5pj49zUBNIMSyXl9tVuSN+7o7BgdpC354+E4WQJ4t0c57InPhpTyGs+b328QZ
         Vg3jjzAf8GF+ofEYo98E2EIsEvyPvSWuI5YoaqR5beXC/RTRXLV6igIYxCSl62hul/z5
         6u+w2DtPKhGpxmCAm9U5V3WLQNkL9A9qHNhDGEIWs8O1wwRM7+/OdMZC3I+B/zZXY1oW
         8BdvohDH2uYzNlEdb0GVHKb/kpeGPrL7GMrqkFuOVU14VlYWx7ZJVWdGWLEJGFPDLXtR
         x4bTx6ayuZK0SBw6xjYAsN4WCHoOyuo8VhO7b9tGloc/Zjo78kFW4MyRjENWeWn1gSLa
         BGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xPTHjBNu4VtrBqVG645UC3saugAIeeYvWqQHdj1RQv8=;
        b=avZgJg0F9JcE4/1q6FxM1AO7IeHJ4TO63nPDbJXCE2B77B/djQk/jAr5742dfASU/+
         HblhA8pF67nUYQoxLWvi2lOZh7WiRDyIqg8Pfwrk8M8254gct8VjLIGsd3iapNyU+82l
         BxbdBM88jG1vSB+JDZkzH2sdh0Udz2mYSRV5V5Jwzf583WAx5s3Qe0kpU2nC7j9yvwF/
         4XE6mP6iz6Ma1/A5ivtorml+ABFHkglOIcNiEno+mFPdp4I1/UDiDVRHB2bO/Gd64wIv
         fOGOmLncM4AgdsRXdTpR/1+skRVZrrXwlgG7iC5fm3wQbs63uhx+CgIyG6kU4iJGL2Cg
         Ic2Q==
X-Gm-Message-State: APjAAAXF21zCpxjdGsGR1gemNfg0c/qlzmaqea9o5Ccj5qlrCkgd4Ofz
        EUEANYKhB98XLO9fsQ7keILWrA==
X-Google-Smtp-Source: APXvYqzRVcaz7/l6y+QVAuOboyL2N4672gbqDsMbqJqbM3Q9ACDCJQK4eEiJt8ttUqC0oI1W1+3omw==
X-Received: by 2002:a25:a444:: with SMTP id f62mr26316922ybi.235.1579289466659;
        Fri, 17 Jan 2020 11:31:06 -0800 (PST)
Received: from localhost ([2620:0:1013:11:1e1:4760:6ce4:fc64])
        by smtp.gmail.com with ESMTPSA id h193sm11418485ywc.88.2020.01.17.11.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 11:31:06 -0800 (PST)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     ramalingam.c@intel.com, ville.syrjala@linux.intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, daniel.vetter@ffwll.ch,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v3 01/12] drm/i915: Fix sha_text population code
Date:   Fri, 17 Jan 2020 14:30:52 -0500
Message-Id: <20200117193103.156821-2-sean@poorly.run>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
In-Reply-To: <20200117193103.156821-1-sean@poorly.run>
References: <20200117193103.156821-1-sean@poorly.run>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

This patch fixes a few bugs:

1- We weren't taking into account sha_leftovers when adding multiple
   ksvs to sha_text. As such, we were or'ing the end of ksv[j - 1] with
   the beginning of ksv[j]

2- In the sha_leftovers == 2 and sha_leftovers == 3 case, bstatus was
   being placed on the wrong half of sha_text, overlapping the leftover
   ksv value

3- In the sha_leftovers == 2 case, we need to manually terminate the
   byte stream with 0x80 since the hardware doesn't have enough room to
   add it after writing M0

The upside is that all of the HDCP supported HDMI repeaters I could
find on Amazon just strip HDCP anyways, so it turns out to be _really_
hard to hit any of these cases without an MST hub, which is not (yet)
supported. Oh, and the sha_leftovers == 1 case works perfectly!

Fixes: ee5e5e7a5e0f (drm/i915: Add HDCP framework + base implementation)
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.17+
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191203173638.94919-2-sean@poorly.run #v1
Link: https://patchwork.freedesktop.org/patch/msgid/20191212190230.188505-2-sean@poorly.run #v2

Changes in v2:
-None
Changes in v3:
-None
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 25 +++++++++++++++++------
 include/drm/drm_hdcp.h                    |  3 +++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 0fdbd39f6641..eaab9008feef 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -335,8 +335,10 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 
 		/* Fill up the empty slots in sha_text and write it out */
 		sha_empty = sizeof(sha_text) - sha_leftovers;
-		for (j = 0; j < sha_empty; j++)
-			sha_text |= ksv[j] << ((sizeof(sha_text) - j - 1) * 8);
+		for (j = 0; j < sha_empty; j++) {
+			u8 off = ((sizeof(sha_text) - j - 1 - sha_leftovers) * 8);
+			sha_text |= ksv[j] << off;
+		}
 
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
@@ -426,7 +428,7 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 	} else if (sha_leftovers == 2) {
 		/* Write 32 bits of text */
 		I915_WRITE(HDCP_REP_CTL, rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24 | bstatus[1] << 16;
+		sha_text |= bstatus[0] << 8 | bstatus[1];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
@@ -440,16 +442,27 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 				return ret;
 			sha_idx += sizeof(sha_text);
 		}
+
+		/*
+		 * Terminate the SHA-1 stream by hand. For the other leftover
+		 * cases this is appended by the hardware.
+		 */
+		I915_WRITE(HDCP_REP_CTL, rep_ctl | HDCP_SHA1_TEXT_32);
+		sha_text = DRM_HDCP_SHA1_TERMINATOR << 24;
+		ret = intel_write_sha_text(dev_priv, sha_text);
+		if (ret < 0)
+			return ret;
+		sha_idx += sizeof(sha_text);
 	} else if (sha_leftovers == 3) {
-		/* Write 32 bits of text */
+		/* Write 32 bits of text (filled from LSB) */
 		I915_WRITE(HDCP_REP_CTL, rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24;
+		sha_text |= bstatus[0];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
 		sha_idx += sizeof(sha_text);
 
-		/* Write 8 bits of text, 24 bits of M0 */
+		/* Write 8 bits of text (filled from LSB), 24 bits of M0 */
 		I915_WRITE(HDCP_REP_CTL, rep_ctl | HDCP_SHA1_TEXT_8);
 		ret = intel_write_sha_text(dev_priv, bstatus[1]);
 		if (ret < 0)
diff --git a/include/drm/drm_hdcp.h b/include/drm/drm_hdcp.h
index 06a11202a097..20498c822204 100644
--- a/include/drm/drm_hdcp.h
+++ b/include/drm/drm_hdcp.h
@@ -29,6 +29,9 @@
 /* Slave address for the HDCP registers in the receiver */
 #define DRM_HDCP_DDC_ADDR			0x3A
 
+/* Value to use at the end of the SHA-1 bytestream used for repeaters */
+#define DRM_HDCP_SHA1_TERMINATOR		0x80
+
 /* HDCP register offsets for HDMI/DVI devices */
 #define DRM_HDCP_DDC_BKSV			0x00
 #define DRM_HDCP_DDC_RI_PRIME			0x08
-- 
Sean Paul, Software Engineer, Google / Chromium OS

