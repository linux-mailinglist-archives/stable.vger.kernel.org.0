Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F579248A1D
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 17:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgHRPkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 11:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgHRPjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 11:39:48 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCF1C061342
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 08:39:42 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 62so18625574qkj.7
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 08:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d1D5o/i++O2dx3r2jrsCjyH48f0K/OvhWUAjvxwi7TA=;
        b=fJExf3k/eUOryvMwUDNci2WzXlvZY1vgpRFMmadp0eQxHC5ayVluggEEZRAcgZ2L8d
         MQMVpVo2o3341cs9QtA8xN7YV1IvfKksh/jMzoKAoTpr7qU7r1Nieqsa3RDCzGTKj85j
         xFRSkPfDZAznDZ9OqEkC6VblHnyfSFvq6hxDkpJnfflbEZdy0/NFf+h353QJB8iKm9Vg
         yr5Uf/u1FNbwl98BV9hp3lRAQLB41agh3WEcUkp5p4Eur3q/WLXYjSwY3Yw0hRwJVE9f
         ImnP3KM3C3ubNNsP+BGf+383MHN7Pvc0gjZ0AnWf6Cq8MTOY1dE9hMkiO6Eor3gCAGKe
         igIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d1D5o/i++O2dx3r2jrsCjyH48f0K/OvhWUAjvxwi7TA=;
        b=JBsSHPajfJEwe/JpZrio2krT2BoPtqryow/pi3xCSXHkMzIeSL4bVQIq/Ki76mOY4j
         TTGHDRDdj7VoOW4wWZ2i2BtvT8jxINdGET87WHHblykCuBEjLsODLJG9cxW2jdmhCLxC
         j9DgvVWcum04OX1TnrcdmkS5P5L6ST1IYc/Z6nsHkxJMo4xxInbs7uVLY16upjmigaN8
         D7mPw3rOm8EH1V74LGKwOaXY44ksjDyKbYlv+ikEYClmaIZzFu+0q8xfTdQ2dyiQXjiY
         0e7oOM6B0OUNCjEfMATPfYf5kCAL7IOTzS/TNQSjVxv6gwFoOy+hyaV5znttW9sg4gFA
         atTQ==
X-Gm-Message-State: AOAM533YdOGdkYcWbWVFHTORchEsuR2TX14SArREZckDXqFEogjhS77s
        N/7mscvl/AcHL+nDUb9mqOPZ2w==
X-Google-Smtp-Source: ABdhPJwQ47iPDVkmbwQrOI2scwtQvNd3mCOXPsjUxsngNOuNliDEgljntmpvaIsz/h/ynurJrJH5gg==
X-Received: by 2002:a05:620a:16c8:: with SMTP id a8mr17926022qkn.81.1597765175049;
        Tue, 18 Aug 2020 08:39:35 -0700 (PDT)
Received: from localhost (mobile-166-170-57-144.mycingular.net. [166.170.57.144])
        by smtp.gmail.com with ESMTPSA id d26sm24891349qtc.51.2020.08.18.08.39.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Aug 2020 08:39:34 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        juston.li@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        anshuman.gupta@intel.com
Cc:     ville.syrjala@linux.intel.com, daniel.vetter@ffwll.ch,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ramalingam C <ramalingam.c@intel.com>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ramalingam C <ramalingm.c@intel.com>
Subject: [PATCH v8 02/17] drm/i915: Clear the repeater bit on HDCP disable
Date:   Tue, 18 Aug 2020 11:38:50 -0400
Message-Id: <20200818153910.27894-3-sean@poorly.run>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200818153910.27894-1-sean@poorly.run>
References: <20200818153910.27894-1-sean@poorly.run>
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
Link: https://patchwork.freedesktop.org/patch/msgid/20200429195502.39919-3-sean@poorly.run #v6
Link: https://patchwork.freedesktop.org/patch/msgid/20200623155907.22961-3-sean@poorly.run #v7

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
Changes in v7:
-None
Changes in v8:
-None
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 6189b7583277..1a0d49af2a08 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -795,6 +795,7 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 	struct intel_hdcp *hdcp = &connector->hdcp;
 	enum port port = dig_port->base.port;
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
 	ret = hdcp->shim->toggle_signalling(dig_port, false);
 	if (ret) {
 		drm_err(&dev_priv->drm, "Failed to disable HDCP signalling\n");
-- 
Sean Paul, Software Engineer, Google / Chromium OS

