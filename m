Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C2B11039A
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 18:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfLCRhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 12:37:01 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33266 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfLCRhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 12:37:01 -0500
Received: by mail-yb1-f193.google.com with SMTP id o63so1872606ybc.0
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 09:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xeeGZfYufHDDThZZkCNhlPdUw/ATxZKnbtQlImLeHzE=;
        b=e+99GIhkG7gRu6w9n+9FiPQorXrVx8PolI+WOX4gxHjKQ9kjN2F1VF3MMA6BAWBMKD
         CSbaSMkvgQyXIYY++ltCrFJlhhmHx9vO3XOs2WjgIt0bAUFZDmyKqeyxmpTg/R4nq318
         pKEGZRj2IxAEtzQWhINvN0CMBxqD0DowE5gbKDu5XmucGX3Arx1ZDv73Ale6RY9laPmV
         uddaWK7vJNA7K3uEfUbUKRIwPugVjjVdCYsOlTNJLLiAirqWjNy0O4wAEvWo79vO7ma8
         R+r8OqDesE4VQTAlm4Dysii+kmQz5wj0V+HHs0uPgKxNlvb27APnDlvwSdkCgSVjW1S7
         FWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xeeGZfYufHDDThZZkCNhlPdUw/ATxZKnbtQlImLeHzE=;
        b=ZTnT1DG/mGGaXEsqOkoVRuZIuI2ObxhT/nNzq3YTVNODCYNJup9IxtO1JbkFXO2Rg4
         /LAl3h6hyDt/sIskdr2fzDtohB/9JFPYfEKqO0DQTzF92dQPGwfTOoEW5IwpcmoDOUSU
         UGvnUCFKUVwR2czuXI8/iSLzlQhruN5OPRLHmPeEu/Dmeit8bMktv/gha0zUFSfBC2Gc
         pBZYAepNStyYFZu4e42QXWL6SJpC6RBit3tH8OYhe5fbvyEq/Fs+JktW8O8mQzG0E9Ee
         GpCdsDlKlLtQEgETqFNKRsWO4+Rq2sNxRmWa/jm5yTHLwKNUJAgRy4lLXzrAmd5mDhe2
         YoQg==
X-Gm-Message-State: APjAAAV3Ywgp++1ms1dhdTMelumQJxn51sykRVA5P8BdBph3Z78FC1ct
        bbEH8/qbxk80wNdFUQNyltEv3g==
X-Google-Smtp-Source: APXvYqxiMpI/ZJUJfq+HWSgGaFlb7XMaUvg3BmERIw0yoe2xI8QAmfiQBaq40Bq/2cNOSz3TCr1yeQ==
X-Received: by 2002:a25:ae12:: with SMTP id a18mr5204934ybj.120.1575394618477;
        Tue, 03 Dec 2019 09:36:58 -0800 (PST)
Received: from rosewood.cam.corp.google.com ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id g190sm1729426ywf.41.2019.12.03.09.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 09:36:58 -0800 (PST)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        ramalingm.c@intel.com
Cc:     Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, Sean Paul <sean@poorly.run>
Subject: [PATCH 01/11] drm/i915: Fix sha_text population code
Date:   Tue,  3 Dec 2019 12:36:24 -0500
Message-Id: <20191203173638.94919-2-sean@poorly.run>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191203173638.94919-1-sean@poorly.run>
References: <20191203173638.94919-1-sean@poorly.run>
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

The upside is that all of the "HDCP supported" HDMI repeaters I could
find on Amazon just strip HDCP anyways, so it turns out to be _really_
hard to hit any of these cases without an MST hub, which is not (yet)
supported. Oh, and the sha_leftovers == 1 case works perfectly!

Fixes: ee5e5e7a5e0f ("drm/i915: Add HDCP framework + base implementation")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ramalingam C <ramalingm.c@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 25 +++++++++++++++++------
 include/drm/drm_hdcp.h                    |  3 +++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index f1f41ca8402b..8325bf9501e4 100644
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

