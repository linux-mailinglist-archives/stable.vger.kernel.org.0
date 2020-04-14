Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC01A8A20
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 20:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504386AbgDNSsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 14:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504372AbgDNSsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 14:48:38 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E299C061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 11:48:38 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g74so14439047qke.13
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 11:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=6yzQmC4w0ygPYVxz9suanugjLM83UH8h3lByA0VCiMA=;
        b=cAEi95OSVoYMxPUPRRQ8P7aBzCq8iAWXDDnkVEIltb6Csmr/PTAqZ8uUgHj9KUrqdV
         QJf2dsphTPAsP6WLs7/Rlxy9qC7eCJ5RPO+/dwa9TTw8JifcBXEZjNy0+J95RAPH5BNM
         2wDMugg/9uMxbui+zrvAKweLF+If5y7NjbwtMOXKMugA8qc9c1RAPh86Taz0u9RvZ4p4
         LavIgMLzqRn7WrqOohi0GNcBWVJYMTjy7CN1qdP05mLO9DK5OI147ZRffqFQ5rJrtoNM
         GOj1s6DlGKmKASYh0om8z0BP/PDGdWF9y6gZYVDCN7KhkNJEvlW7FrdLcUkl5yIVGT9J
         NAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6yzQmC4w0ygPYVxz9suanugjLM83UH8h3lByA0VCiMA=;
        b=XpYdMKCI+keBmIa/rThhcLtRs+5hwwLd8Tcdvh0PtWrkMc9Fyyy3uDAmjl3JD1ON4w
         CF4R0rBIqujZIeNbPV0qVlUnltIWzzJ2aZqgfC6C+b8JwYUbcG69mN5Zw7L081kFqW43
         O1P1V6tCBo176efTYAdYCvDxAlcSEycA5UJG5u8CiuFkYZsZVmWKZzMDD8Yi0nah/tlP
         HBGIcqZPQmhi4AJ8IAeEc+iu/e7iDWeLXPDuz1ypqd1J8HfIVAFRGsfZr9ZOXBnTGDMP
         ZHt/Tj1SSG1ry/mDqfk44QjLixJtusVw8DnyJS9HAqwuydf9VZWiNg3ttzlUM4MbQw0X
         /1ZA==
X-Gm-Message-State: AGi0PuYxt1ozaCTE//CwmKNzAaFrmHMLiX71Tvxk0jjhAkaXLoWpGlnw
        mPPgSliGKRjAjrHE0g20x3S8pw==
X-Google-Smtp-Source: APiQypKMY6bMG74EyHD+GoZ12sBeFRvtchEAfByEmex7yDdu4T+2CkMF22ApyxuG74lJ5sRXGajdyA==
X-Received: by 2002:ae9:ed56:: with SMTP id c83mr18610142qkg.244.1586890117683;
        Tue, 14 Apr 2020 11:48:37 -0700 (PDT)
Received: from localhost (mobile-166-170-55-13.mycingular.net. [166.170.55.13])
        by smtp.gmail.com with ESMTPSA id f1sm10522199qkl.91.2020.04.14.11.48.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2020 11:48:36 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, ramalingam.c@intel.com
Cc:     intel-gfx@lists.freedesktop.org, Sean Paul <seanpaul@chromium.org>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH] drm: Fix HDCP failures when SRM fw is missing
Date:   Tue, 14 Apr 2020 14:48:26 -0400
Message-Id: <20200414184835.2878-1-sean@poorly.run>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

The SRM cleanup in 79643fddd6eb2 ("drm/hdcp: optimizing the srm
handling") inadvertently altered the behavior of HDCP auth when
the SRM firmware is missing. Before that patch, missing SRM was
interpreted as the device having no revoked keys. With that patch,
if the SRM fw file is missing we reject _all_ keys.

This patch fixes that regression by returning success if the file
cannot be found.

Fixes: 79643fddd6eb ("drm/hdcp: optimizing the srm handling")
Cc: stable@vger.kernel.org
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Sean Paul <sean@poorly.run>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 drivers/gpu/drm/drm_hdcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_hdcp.c b/drivers/gpu/drm/drm_hdcp.c
index 7f386adcf872..3c36005d367b 100644
--- a/drivers/gpu/drm/drm_hdcp.c
+++ b/drivers/gpu/drm/drm_hdcp.c
@@ -241,8 +241,10 @@ static int drm_hdcp_request_srm(struct drm_device *drm_dev,
 
 	ret = request_firmware_direct(&fw, (const char *)fw_name,
 				      drm_dev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		ret = 0;
 		goto exit;
+	}
 
 	if (fw->size && fw->data)
 		ret = drm_hdcp_srm_update(fw->data, fw->size, revoked_ksv_list,
-- 
Sean Paul, Software Engineer, Google / Chromium OS

