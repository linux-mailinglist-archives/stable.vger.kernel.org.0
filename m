Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFE017AF6F
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 21:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgCEUMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 15:12:40 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45143 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgCEUMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 15:12:39 -0500
Received: by mail-yw1-f65.google.com with SMTP id d206so6851796ywa.12
        for <stable@vger.kernel.org>; Thu, 05 Mar 2020 12:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=agpuoYC7BHD+Tt3XfzGrEBY6MziAOhla0gjbqTAABjc=;
        b=WfUCX+aLHh+lM/T9KeSW8Wr+dO38C1R/Oy41S/hc6AfjEJXPwy/xyeGkX15rU0Xcfc
         j4RYNYNO7dkAkeXKgYEc8e22Svd7vL96DmNhPYobbIRzU+rHTD33ZCh7DjWSpbq1rgd8
         NHB3q/5QqKWXa37cDE0yDFEJzoDVd7t7X7UYbxj/1Jd78XMgJbxkNByi7Ra+shLT5KwQ
         PnG/Zv1l6bZZXzVuUiyn6LAQwVRrZwFRkSFGNGLT5Wd4eRnr6W3fmX0f6cLdXVSBoyWR
         5w8fbdTYuEsss0M58oKbeWbpuaNlLgt4SP2w4Lry2cl0LONK170vLIHf35R8yWi4GfMT
         oIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=agpuoYC7BHD+Tt3XfzGrEBY6MziAOhla0gjbqTAABjc=;
        b=OjgwhSPiTIj4Hm4HIzdZ0utnoDhM++ql4duD3ZdLYSJFmC5Dvxhdc0UYovLXGebkiJ
         FXepK1PWNlPAYYleEm81ZYeXQ4rm/gKCndLpoVnGadcU5xLLkXgxxlwrjHlBZVwRpxK5
         k4fFBVixzTLgnY32h/xBB7yaXuwpIAVriX8DYnSJziaXNxvIcc7+uxlt1jyx8J3DyWuK
         yKVQJL26Mi2G3IJHL0HjIJvTlAfbvSK5vfPGIDz8m/vEBqqtA/tuY5DgQeXZys6sjF3q
         GQn8mmBWtk6VLFxp6zOeVifBYAsN7cWrP4wG5+XhFmsG3O1AxgFPGRW6660WS/F2zX8/
         LnKQ==
X-Gm-Message-State: ANhLgQ0c5o9KtpIyMLU8/6ri2noxB6bf4VqQdlvGmSI4+RBJ9BUDPWNS
        5jy/wM2OB7UWsTLyFS2NgWMemw==
X-Google-Smtp-Source: ADFU+vsIut+4VgAPXNEdqYtu7fgp8vaofntRkBnCOn19SV5Cowg0zCF8RTmsiSfgiudFb+3UDK6EfA==
X-Received: by 2002:a0d:e883:: with SMTP id r125mr134840ywe.304.1583439158961;
        Thu, 05 Mar 2020 12:12:38 -0800 (PST)
Received: from localhost ([2620:0:1013:11:1e1:4760:6ce4:fc64])
        by smtp.gmail.com with ESMTPSA id l191sm13067177ywb.12.2020.03.05.12.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 12:12:38 -0800 (PST)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     juston.li@intel.com, ramalingam.c@intel.com,
        ville.syrjala@linux.intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        daniel.vetter@ffwll.ch, Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v5 01/16] drm/i915: Fix sha_text population code
Date:   Thu,  5 Mar 2020 15:12:21 -0500
Message-Id: <20200305201236.152307-2-sean@poorly.run>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200305201236.152307-1-sean@poorly.run>
References: <20200305201236.152307-1-sean@poorly.run>
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
Link: https://patchwork.freedesktop.org/patch/msgid/20200218220242.107265-2-sean@poorly.run #v4

Changes in v2:
-None
Changes in v3:
-None
Changes in v4:
-Rebased on intel_de_write changes
Changes in v5:
-None
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 26 +++++++++++++++++------
 include/drm/drm_hdcp.h                    |  3 +++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index ee0f27ea2810d..defa8654e7ac5 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -338,8 +338,10 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 
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
@@ -437,7 +439,7 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 		/* Write 32 bits of text */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24 | bstatus[1] << 16;
+		sha_text |= bstatus[0] << 8 | bstatus[1];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
@@ -452,17 +454,29 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
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
index c6bab4986a658..fe58dbb46962a 100644
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

