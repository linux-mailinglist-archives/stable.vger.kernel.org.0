Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F31E205684
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 17:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733007AbgFWP7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 11:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731616AbgFWP7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 11:59:19 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08B6C061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:59:18 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x62so12413775qtd.3
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hPXrMMByCWFAX4dr17N0gwG7cbpIr/xu4CnGBcMvPTM=;
        b=Fgg+4sE2s/DGUQkVwT/mKk6mYL71L7M/7zgdKJhLgu7nvVnkgVtTdaWz5+ASY7f1x9
         607Eru5F150hws5CKGIea3E7JRbJn4yRSJGVj2JEE/IYMWIfhl1dgCPHKydDxCQrxaTL
         nICXXMV1LlL1BePG+y+6naw0q1xXzjsTwGtHFfJFfQ/BatQJKztT4aN+bLk+uhLJUoVG
         c+trHzoKJJvmfq34qRILDd5iQ3koHUnGMf/5GYP8kh7svIcdySs6tMG21haWvFblb3z2
         HsaaafvaVkLO41DnA6Lyw7X11O1VpP3sIeV2Akivd8tVom3xkbNut0wVGF0WhQoRxSej
         OwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hPXrMMByCWFAX4dr17N0gwG7cbpIr/xu4CnGBcMvPTM=;
        b=Wji7Kjs9nf35Rduhdhrbj2yromO/aKcD6qr+CqtMj14OZoA44ydk/CYmSadlFbbPzw
         hKRJMNg0y7YkClHJaCZ6cNVCWGCk0UuAPjM2/g3L4c48mi1tNgDa2PgNgPTrapKqkx7J
         H1TSFH4IDObhKQlPgNaZ5tTSURbJj3E6BiOp/S+iHCKZc4uZbUO/qS9rMJwiXl+GDQuu
         NX8zII7ZrAdeHn6tGE2hhR/xj6TjrhPrjNjO6yurMwIQsNRY7qFDD0VntbCOFAEb1E0N
         kWIQCG3jaarZSusoaEa4K55nANjAghtlp5aSQg2/kndr9aiFsuYLXPQ251UBWys5gvoE
         fNrw==
X-Gm-Message-State: AOAM530gcRtYWo7knWHQoSv5OqjZ/G6b4+dI2LWk0/wh8/9kNyRd8Lq/
        GD7KFmMbqrfUaPx+wgCLHfmX9eeyJ/Y=
X-Google-Smtp-Source: ABdhPJwDzGXD4Tj1ITeOHNjbd9Q27WHo/tk3fXxGDgHKrDKa4BnYt7SYh3CT/GmucosBLRNiwhz5RA==
X-Received: by 2002:ac8:348f:: with SMTP id w15mr11961571qtb.79.1592927958145;
        Tue, 23 Jun 2020 08:59:18 -0700 (PDT)
Received: from localhost ([166.137.96.174])
        by smtp.gmail.com with ESMTPSA id u128sm915383qkc.84.2020.06.23.08.59.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2020 08:59:17 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     juston.li@intel.com, ramalingam.c@intel.com,
        ville.syrjala@linux.intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        daniel.vetter@ffwll.ch, Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v7 02/17] drm/i915: Clear the repeater bit on HDCP disable
Date:   Tue, 23 Jun 2020 11:58:52 -0400
Message-Id: <20200623155907.22961-3-sean@poorly.run>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623155907.22961-1-sean@poorly.run>
References: <20200623155907.22961-1-sean@poorly.run>
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
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index f26fee3b4624..9f530b2f3606 100644
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

