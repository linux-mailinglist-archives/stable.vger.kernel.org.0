Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997F61BE7CA
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 21:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgD2TzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 15:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2TzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 15:55:07 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BB5C03C1AE
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 12:55:07 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x12so2984414qts.9
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 12:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3wtpqEVb8+q8983awF7FbZdCsxnwZkDeLDI1Rfuwxvw=;
        b=V83Fs/ch9+ZTN112svVqBnawZvI2MornbpCx+pSHP4ddkdsLiH6NYJIEYJwH1qXlvt
         TxXx3jhpsWkCZWx1SUs6PTIpEatBuP0k9UrvH3ZQKFV+loc7ATaWL+Ijce4MP3pd2jUZ
         0kbj5S8bDa8d9A+ImhTxM93fylQer9HdnJe3Ei+ZeVJLq6VfZcrKR4G6zVFVm79xJEuz
         L4ZnuBtmZKLbEnuaQyMnvJDFSwqMmYUqPsMj0TZrPdx/xtnMrVRCp2Kl/+naU2cpCDRY
         QDtwobzAi0aBVbxuz8FVnsIRwiPgJPOBObA/KKnwdfebO39d08XUvUgkBCtpTfBx4CPN
         N7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3wtpqEVb8+q8983awF7FbZdCsxnwZkDeLDI1Rfuwxvw=;
        b=GW/kEry8d9iMJhL8K6m96e8WrLAFPGfKCLBnKA9JIncUFMfJ66c5FxR1ooj67fkoL3
         ZyGysrlGPXP+nUqYRVq80x91PgNQjFRC+gPLuRFhhzWGhfcfTrdAKPS9jGSdyWllQ8hW
         E4dXJyV25xWqc8pEBmOjNK3Fz1hSxaFq4jFFXWbboHYCB/ITN5AFIsMoqzqkzsqwMzz6
         ofno3W2HwZK+gzXHKkYaMVd+B3aM/mM0KyxhPzZNHF4x002CK8Ev92iQqKsRoHL05IGo
         q1zLleqXA6eAOeZNEamb2v4k86Wmtg0EDS3OpIleBhiEmuGZBDxtf9aWtpAKHU7FW2DG
         TyqA==
X-Gm-Message-State: AGi0PuZzWliyJ+/SRe/Nc0/YKBUhcl2vct4k1zSgxb4/V5DIAMhrgMk5
        xiIRzoO/FHMDyqhZe2iE1FbT9A==
X-Google-Smtp-Source: APiQypKTp6bOGWIkgxwG0seaGlNFdIUqnV6oFciqJQcKLFVJCbeaMxAisSfqFpxjsxGRwpY4eXrKpw==
X-Received: by 2002:aed:2b43:: with SMTP id p61mr36066075qtd.298.1588190106111;
        Wed, 29 Apr 2020 12:55:06 -0700 (PDT)
Received: from localhost (mobile-166-170-55-34.mycingular.net. [166.170.55.34])
        by smtp.gmail.com with ESMTPSA id o33sm181770qtj.62.2020.04.29.12.55.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Apr 2020 12:55:05 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     juston.li@intel.com, ramalingam.c@intel.com,
        ville.syrjala@linux.intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        daniel.vetter@ffwll.ch, seanpaul@chromium.org,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v6 01/16] drm/i915: Fix sha_text population code
Date:   Wed, 29 Apr 2020 15:54:47 -0400
Message-Id: <20200429195502.39919-2-sean@poorly.run>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429195502.39919-1-sean@poorly.run>
References: <20200429195502.39919-1-sean@poorly.run>
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
Link: https://patchwork.freedesktop.org/patch/msgid/20200305201236.152307-2-sean@poorly.run #v5

Changes in v2:
-None
Changes in v3:
-None
Changes in v4:
-Rebased on intel_de_write changes
Changes in v5:
-None
Changes in v6:
-None
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 26 +++++++++++++++++------
 include/drm/drm_hdcp.h                    |  3 +++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 2cbc4619b4ce..525658fd201f 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -336,8 +336,10 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 
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
@@ -435,7 +437,7 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 		/* Write 32 bits of text */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24 | bstatus[1] << 16;
+		sha_text |= bstatus[0] << 8 | bstatus[1];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
@@ -450,17 +452,29 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
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
index c6bab4986a65..fe58dbb46962 100644
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

