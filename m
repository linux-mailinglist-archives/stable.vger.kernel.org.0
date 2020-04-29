Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27B11BE7CB
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 21:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgD2TzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 15:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2TzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 15:55:08 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61B4C03C1AE
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 12:55:08 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id o10so3011211qtr.6
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 12:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/rJ+qpCTUQ4xRTDli+gllJdywxBhgBDyTSUd0fgyLX8=;
        b=Mx9NV3C62tZ1IgRPUSXfHNa9az0cgkSiXyFECZ6wjMtnIR4qBEBizHekS6UJHBfghU
         30cy8hGaAtaVUwiAWR+Fx2Dy+ETtzABCFUlxlCnP6W3CHmqLSQgAawEbbhKVmJu38kXE
         7GFv/I20oWJzhi5ubl52k7Y3o35BC2xJ0zohWproN8ymQ7651X4Dh5uBQ0Sbc95dB5e+
         eWzRkUlz/mUaSESBBLL//uJ4NuV7OZbAr9wkWLtw3KdGXrk2fsqDqaCkZy0uzeOK5Lo4
         UXaJ4re/CRSKnoNFeplw//F5b2BxlbLWt8PkcdjDW/ydSW6pUsi3X3+VIsRgGyELNpB6
         /AOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/rJ+qpCTUQ4xRTDli+gllJdywxBhgBDyTSUd0fgyLX8=;
        b=t8+mbPU3gPQUZYllpiyxkBQA630Dhl11TglhmEUOUhtmWSUYqDyFktHycDOxGRtRoD
         EmrMK75wAVa8uIveHlYrwofcr4kZ3bDpeK0kYSn0DmCNFtczq5y6UGRMLyJ/mMrhe2ol
         fMGLrDjFZJdEkRRkAGg1pDdAjYS6aAMZF3rWeFPHhbUre+PQv9N+9f6zKlMDHGB8Npci
         y2Hr5sTGrHnjjtglBnHoFBJI8uTLlfinAPAKrDK2pibkljvWbjJCgv4bO9+qWgUHbAqN
         OMVGaYtHQJRwGkjaYUedaFFcZRAFRt9m/0onW3oQfggLpQ8qrTdzE9CezSchao66sFfp
         bhBA==
X-Gm-Message-State: AGi0PuZj0R4tGoxiO4yteg1nDS95yD2aiLWuxy8H2ZhB+2CDZfUQ6if/
        LIbuoe8MHSsDyB8tvIajQY9SwQ==
X-Google-Smtp-Source: APiQypJ8HrNAecGaGJOfAjH5jMMQNuPSSpXp7GJV8WNQJHPCBikcxgu30+Gh/2jz7jfO6lMWuT0UKA==
X-Received: by 2002:ac8:1a26:: with SMTP id v35mr6440001qtj.332.1588190107918;
        Wed, 29 Apr 2020 12:55:07 -0700 (PDT)
Received: from localhost (mobile-166-170-55-34.mycingular.net. [166.170.55.34])
        by smtp.gmail.com with ESMTPSA id 28sm143805qkp.10.2020.04.29.12.55.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Apr 2020 12:55:07 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     juston.li@intel.com, ramalingam.c@intel.com,
        ville.syrjala@linux.intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        daniel.vetter@ffwll.ch, seanpaul@chromium.org,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v6 02/16] drm/i915: Clear the repeater bit on HDCP disable
Date:   Wed, 29 Apr 2020 15:54:48 -0400
Message-Id: <20200429195502.39919-3-sean@poorly.run>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429195502.39919-1-sean@poorly.run>
References: <20200429195502.39919-1-sean@poorly.run>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

On HDCP disable, clear the repeater bit. This ensures if we connect a
non-repeater sink after a repeater, the bit is in the state we expect.

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
Link: https://patchwork.freedesktop.org/patch/msgid/20191212190230.188505-3-sean@poorly.run #v2
Link: https://patchwork.freedesktop.org/patch/msgid/20200117193103.156821-3-sean@poorly.run #v3
Link: https://patchwork.freedesktop.org/patch/msgid/20200218220242.107265-3-sean@poorly.run #v4
Link: https://patchwork.freedesktop.org/patch/msgid/20200305201236.152307-3-sean@poorly.run #v5

Changes in v2:
-Added to the set
Changes in v3:
-None
  I had previously agreed that clearing the rep_ctl bits on enable would
  also be a good idea. However when I committed that idea to code, it
  didn't look right. So let's rely on enables and disables being paired
  and everything outside of that will be considered a bug
Changes in v4:
-s/I915_(READ|WRITE)/intel_de_(read|write)/
Changes in v5:
-None
Changes in v6:
-None
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 525658fd201f..20175a53643d 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -795,6 +795,7 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 	struct intel_hdcp *hdcp = &connector->hdcp;
 	enum port port = intel_dig_port->base.port;
 	enum transcoder cpu_transcoder = hdcp->cpu_transcoder;
+	u32 repeater_ctl;
 	int ret;
 
 	drm_dbg_kms(&dev_priv->drm, "[%s:%d] HDCP is being disabled...\n",
@@ -810,6 +811,11 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 		return -ETIMEDOUT;
 	}
 
+	repeater_ctl = intel_hdcp_get_repeater_ctl(dev_priv, cpu_transcoder,
+						   port);
+	intel_de_write(dev_priv, HDCP_REP_CTL,
+		       intel_de_read(dev_priv, HDCP_REP_CTL) & ~repeater_ctl);
+
 	ret = hdcp->shim->toggle_signalling(intel_dig_port, false);
 	if (ret) {
 		drm_err(&dev_priv->drm, "Failed to disable HDCP signalling\n");
-- 
Sean Paul, Software Engineer, Google / Chromium OS

