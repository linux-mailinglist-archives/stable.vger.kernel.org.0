Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9131411AF
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 20:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgAQTbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 14:31:09 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39230 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgAQTbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 14:31:08 -0500
Received: by mail-yw1-f66.google.com with SMTP id h126so14842685ywc.6
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 11:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cE4plDgeOaA1EdeFDIGVj5csFXNHOxdShFqwh4J/5Fc=;
        b=WMXiEassOBYE9KIMY/hA/5Xm4kX4pFBtFP7Z/WC/qytrK3VWYV6QLb6qPBt85nU6pQ
         4aHo8J9IGB5Z9YW8ufzzu6RJ3j/NsQYm2ey9FWG6f1ynRtE9dbhQX3oUp7RAdSojRcyY
         f70uVgeKR/BJIzePGP8lT+0813UGeIqYy67Kj/EW49nA70AMFdwcCd4599UJrV65vr8m
         fA1b8luLcrRpZ6GvOF1x0ZswYtFRW0mPydDWrx42z2yij5f9NZvclMs2rDErAlsZj6zY
         ZusZHmQ+uzS1/Q1p/QlwBRRikMZCAwsG1auEnnd8p9+TqoTlodPrPQuhlICStQNIMtdn
         +1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cE4plDgeOaA1EdeFDIGVj5csFXNHOxdShFqwh4J/5Fc=;
        b=GQIQm3mro0K6AkcncsKQfQVyCY0AEvOOJU4JySUJr0Ps7o/PM2FWFyI5sNH68EO+wf
         D6pVf1aC+m1yEV9M5V25LBJau/rWOr0y/VS/KBRYoD3ZqdCTqR29rTu6tKcRIuv6ji8u
         41GS5GqF6tJZTdu4i4sQrH0TQrhZccm0oUbAqqx7JDz6ykexZd3UFsnbFhX8qSXU8tzP
         crW2G1ml/YncgMiin33Lbi6q4DGzcIw2wiXRVs2kM2592LeGhrv073wymgdebH1EKAkT
         xxY2WNuZ3R7SPZFD7eecEQ8p9fihdni8B7XS+5dEIVWWgMkGcm5KmOYkyaT4FEZjcmP3
         YGuQ==
X-Gm-Message-State: APjAAAUCcb9ACwwzBc8LGYG8gs5uMe3nyCGGYPbb11hd9eeEZ7nLnFsT
        ztGmc3+9bOVsF2GhgN+sTlxksg==
X-Google-Smtp-Source: APXvYqyckStytURl9B6tgOLARMKeyE9aLWO+1WYovvHBWnXcs94qq1uKa+LYIGFqlTUz76q5Qn6pxg==
X-Received: by 2002:a81:7a43:: with SMTP id v64mr30586336ywc.95.1579289467846;
        Fri, 17 Jan 2020 11:31:07 -0800 (PST)
Received: from localhost ([2620:0:1013:11:1e1:4760:6ce4:fc64])
        by smtp.gmail.com with ESMTPSA id m16sm11439344ywa.90.2020.01.17.11.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 11:31:07 -0800 (PST)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     ramalingam.c@intel.com, ville.syrjala@linux.intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, daniel.vetter@ffwll.ch,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v3 02/12] drm/i915: Clear the repeater bit on HDCP disable
Date:   Fri, 17 Jan 2020 14:30:53 -0500
Message-Id: <20200117193103.156821-3-sean@poorly.run>
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

Changes in v2:
-Added to the set
Changes in v3:
-None
  I had previously agreed that clearing the rep_ctl bits on enable would
  also be a good idea. However when I committed that idea to code, it
  didn't look right. So let's rely on enables and disables being paired
  and everything outside of that will be considered a bug
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

