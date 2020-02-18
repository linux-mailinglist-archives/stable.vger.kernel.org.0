Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B251635A4
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 23:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgBRWDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 17:03:30 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34335 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgBRWDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 17:03:30 -0500
Received: by mail-yw1-f66.google.com with SMTP id b186so10168321ywc.1
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 14:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cmEv6KYeIZ/itTi4Tb2yD0Ax+KLuuOVxjE5ac+Oou1Q=;
        b=epgew5uQNxLRoaIaCHs5pjx5HAoV2sUOXIVFAmZHlbT6lWtkSao4PFI7tch/wT6lKY
         nDCVDLFmL4b1oCjWmAfqrhY9KiAIafJPsITlDHhH5q5SeuRyiIjFij8sk6B4osXsrH8E
         UEOHj86nlOnNMS6Wg48FbPSO8iIxHSQzwz4p7XuyDhyJRvuduuvAKgYdHA3Cgsm04Q3s
         1JUuS8P6By/j+Fo5is5rVw4AwtB7hXg72WZ5CwgeLLJ/lpOjN7oUrfFBh5iG2XUHFRnx
         x1BqCQz7Jw3fRBVa6U73cfUoGNpWy8WDxh/Kn+VkLei8JG5FBqMMIY2EnN1S3S3PetM+
         bDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cmEv6KYeIZ/itTi4Tb2yD0Ax+KLuuOVxjE5ac+Oou1Q=;
        b=X7swXeohsVK/F3D4/qNm51SrLI/SpHfb2zFhU11EmsZ86uKEAY0Kr33MEs9VBwmDtg
         hKHYzmAIESVupl4uWcSH1ykUHqddf1O8jVESZFCBiVlf49qXk/vm09cExJk1aHSgqhPO
         LX+Bq8nKQKa23mYhVo1/rMNp3YpViAdZMGJbE3sXZPTyDTRU2glFLhVm6b52aLdJPeJR
         MY7u53iGWajlygT94FMcy4QxV37EJE+0V2b881l1hN5l0fdSu/8xTzO4Up7M360RA+Gr
         i7YTxBBdvJ/pW1+2zBaAYLlizhF2o6yV1r+OBb+y3axi0+c3F8I4V9Rn1Z1Hd0vf2aKy
         vk1g==
X-Gm-Message-State: APjAAAWZF8//oE+sR7GSp8UDHiCwDwwYQKhLdnP1/rOugSBMLu35zsoe
        yRcrZ8Xi5gARL6FhX5vjnnxS7w==
X-Google-Smtp-Source: APXvYqwV1SVHQrglY5ZjNw0BIqPSTUVQoEHyY+37gVGqJ8yZPu7K2f0g7J89NYU7Zqf/RqVm/8q56A==
X-Received: by 2002:a81:2550:: with SMTP id l77mr18000249ywl.347.1582063409523;
        Tue, 18 Feb 2020 14:03:29 -0800 (PST)
Received: from localhost ([2620:0:1013:11:1e1:4760:6ce4:fc64])
        by smtp.gmail.com with ESMTPSA id a124sm8230ywc.104.2020.02.18.14.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 14:03:28 -0800 (PST)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     juston.li@intel.com, ramalingam.c@intel.com,
        ville.syrjala@linux.intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        daniel.vetter@ffwll.ch, Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v4 01/14] drm/i915: Fix sha_text population code
Date:   Tue, 18 Feb 2020 17:02:29 -0500
Message-Id: <20200218220242.107265-2-sean@poorly.run>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200218220242.107265-1-sean@poorly.run>
References: <20200218220242.107265-1-sean@poorly.run>
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
Link: https://patchwork.freedesktop.org/patch/msgid/20200117193103.156821-2-sean@poorly.run #v3

Changes in v2:
-None
Changes in v3:
-None
Changes in v4:
-Rebased on intel_de_write changes
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 26 +++++++++++++++++------
 include/drm/drm_hdcp.h                    |  3 +++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 30e0a3aa9d574..de996f4f56997 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -337,8 +337,10 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 
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
@@ -436,7 +438,7 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 		/* Write 32 bits of text */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24 | bstatus[1] << 16;
+		sha_text |= bstatus[0] << 8 | bstatus[1];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
@@ -451,17 +453,29 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 				return ret;
 			sha_idx += sizeof(sha_text);
 		}
+
+		/*
+		 * Terminate the SHA-1 stream by hand. For the other leftover
+		 * cases this is appended by the hardware.
+		 */
+		intel_de_write(dev_priv, HDCP_REP_CTL,
+			       rep_ctl | HDCP_SHA1_TEXT_32);
+		sha_text = DRM_HDCP_SHA1_TERMINATOR << 24;
+		ret = intel_write_sha_text(dev_priv, sha_text);
+		if (ret < 0)
+			return ret;
+		sha_idx += sizeof(sha_text);
 	} else if (sha_leftovers == 3) {
-		/* Write 32 bits of text */
+		/* Write 32 bits of text (filled from LSB) */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24;
+		sha_text |= bstatus[0];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
 		sha_idx += sizeof(sha_text);
 
-		/* Write 8 bits of text, 24 bits of M0 */
+		/* Write 8 bits of text (filled from LSB), 24 bits of M0 */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_8);
 		ret = intel_write_sha_text(dev_priv, bstatus[1]);
diff --git a/include/drm/drm_hdcp.h b/include/drm/drm_hdcp.h
index 06a11202a0976..20498c8222046 100644
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

