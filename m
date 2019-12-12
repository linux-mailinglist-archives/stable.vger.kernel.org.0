Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAE411D69E
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 20:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbfLLTCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 14:02:38 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39569 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730449AbfLLTCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 14:02:37 -0500
Received: by mail-yb1-f195.google.com with SMTP id o22so884686ybg.6
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 11:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h0egt0JF3BBaO6WdEMgj9OmFassmcCaVwLOw/Q8+8Ig=;
        b=SHJUYkdQXFIy7lhSOlGEt4N5lRi54RBmiuC1/wvPLbJPQdGP4+0qs0kcR03YfyUDsV
         kvnNq6grLvRnzgt1X0VhyaF2celBuey0NkyLNxLW/7k2uYpp7HMiyvNgfyYnCev/VBwa
         trV6aCHWZhzQVVQXMmG/Ig+nQLmfjtnnlnJ0IU+a90Bfgv2eNcsh1w55Bp5JGFH+Chjr
         L4I2vM8/zrgZ5pqpNZGVy4OGuFvGRPEbN4HoCQc4yT/JbQ8+z9VVnnDQl8LrgpnWwELF
         pZX2tWycjVoOJnafgIyjS3kVHB+esUoA+m7jNBSK1IX5QJSA4l/IgVD+fSdOicdJf87u
         7fXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h0egt0JF3BBaO6WdEMgj9OmFassmcCaVwLOw/Q8+8Ig=;
        b=Rmi1wkeWuJYFtRNu6MVwR/2gJbBEST76uKEBz8MmG+dQYB61/RT8G5r7/YNmfSGMDp
         Zs73Vesru/SIn01aSCoavVPkN8OUO+ojIwNI/FtigMVoV6FSO163TJLhj5NMzIfehj7k
         TA+brsdHsH4NAVy7kCpGi885wL682Q/VuAv6dulkTSy8RE3OteqGlfBHe+9faHLP46DP
         hhdGl17O4EYUWP32XlxO3GNXQLj4y5yfN8I1i0vWmvQL+StDLj2Qn03WsGuKOXGF6UUo
         ZbDRdoKcnjMPAp2zYg+MbcoVcdA9/HUQ3B67/C8lAI6TbzDpSUr4VhFqZUNNVTYjYEDj
         zJCw==
X-Gm-Message-State: APjAAAWOu1wSQA15mc97BOgGErT0t3ovEodPlRc5uMM9M2Hg71Iu3hTW
        oMGq+7tW/TaV405PhpiTTb4daQ==
X-Google-Smtp-Source: APXvYqxTLrnFF6DesdMGBQCsHLYXvOIO4H7H7tXnoUlpTgcZRRHBNuvB3iFuGq/JTG5n86eh2+8xgg==
X-Received: by 2002:a25:6385:: with SMTP id x127mr5367068ybb.468.1576177356773;
        Thu, 12 Dec 2019 11:02:36 -0800 (PST)
Received: from localhost ([2620:0:1013:11:1e1:4760:6ce4:fc64])
        by smtp.gmail.com with ESMTPSA id k23sm538820ywk.17.2019.12.12.11.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 11:02:36 -0800 (PST)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     ramalingam.c@intel.com, ville.syrjala@linux.intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, daniel.vetter@ffwll.ch,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v2 02/12] drm/i915: Clear the repeater bit on HDCP disable
Date:   Thu, 12 Dec 2019 14:02:20 -0500
Message-Id: <20191212190230.188505-3-sean@poorly.run>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <20191212190230.188505-1-sean@poorly.run>
References: <20191212190230.188505-1-sean@poorly.run>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

On HDCP disable, clear the repeater bit. This ensures if we connect a
non-repeater sink after a repeater, the bit is in the state we expect.

Fixes: ee5e5e7a5e0f ("drm/i915: Add HDCP framework + base implementation")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Sean Paul <seanpaul@chromium.org>

Changes in v2:
-Added to the set
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index eaab9008feef..c4394c8e10eb 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -773,6 +773,7 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 	struct intel_digital_port *intel_dig_port = conn_to_dig_port(connector);
 	enum port port = intel_dig_port->base.port;
 	enum transcoder cpu_transcoder = hdcp->cpu_transcoder;
+	u32 repeater_ctl;
 	int ret;
 
 	DRM_DEBUG_KMS("[%s:%d] HDCP is being disabled...\n",
@@ -787,6 +788,10 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 		return -ETIMEDOUT;
 	}
 
+	repeater_ctl = intel_hdcp_get_repeater_ctl(dev_priv, cpu_transcoder,
+						   port);
+	I915_WRITE(HDCP_REP_CTL, I915_READ(HDCP_REP_CTL) & ~repeater_ctl);
+
 	ret = hdcp->shim->toggle_signalling(intel_dig_port, false);
 	if (ret) {
 		DRM_ERROR("Failed to disable HDCP signalling\n");
-- 
Sean Paul, Software Engineer, Google / Chromium OS

