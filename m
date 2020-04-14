Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29D1A8A98
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 21:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504595AbgDNTDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 15:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504613AbgDNTDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 15:03:02 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654C2C061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 12:03:02 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g74so14496844qke.13
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 12:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qx+9uJOtenCeFNWJQn8/GXTaoex2bmlkCDWgniXI+ZU=;
        b=Pym8bfR7Gg2SFIjtkrpH3i99R3yaBV/sVMg+GrDhN+1uEfZbZNShC7p/2YFGKedq7I
         cfVSa9ty6LwtX9FirYHQ1czwqckx5uEa91Il3Oc7kTWnYugekyTfLHuvS1gbShaLTkas
         CGQioOVtDTntWActVDzN9h765S622eX4COcqXqBuiqqTdFMc0oVMX7vAA/E2PV3RufTr
         0ncoaCkRpbRUco+DNRQKzd22xjYxf7up9dRfLSu31wUoHvUj/sORm63+CFoc/IqfGv+F
         i5cwTnK0J0CVePVcnB4prpkUe8knDAhXQ3z62UMCHLxpiYhMFU2BD5fBHq6Iju8PsBlI
         hFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qx+9uJOtenCeFNWJQn8/GXTaoex2bmlkCDWgniXI+ZU=;
        b=mbvi3z48oXdGyLwnrJJgsArM1ddy+FQZ2xXRz5C1iUPadG19WZnPbe/5T7XX8qHAOQ
         bzHiK/z9rnfUgd0xS88Ifotsx7U45IMvZ6+ACKgZasfDkuD4EV9m9GmW9n5hVjD/ZssV
         A4cDuzwHhgfS4RpOsuwIpaIxxgiDTz2KB4ZXfyees/NRjmBK4vhvklxpp455jaKlbGLX
         9qO7VpAnE/rXoRMmtcDRqVilMoWXvstQ+erW+1HjlL50Qg+SXCw4Ujo4wDLWKPxhWsVH
         eQBnxRew2yKGJRlGHSy12cwGt59BPe351fBnd8UgLuctnPqYZCOMLazdq5qYmSpTGVp/
         UF9A==
X-Gm-Message-State: AGi0PuaeusQLfNrfnSAos9pXNezFsPSojFWeBuVd5igy3jjxh6JyJgCi
        DP7gYV/y9rcQD8jVVddQPpkzkA==
X-Google-Smtp-Source: APiQypIo6NVa3ggkrGir9Av9BKxhR8YxgO3E79REfl10Nl4HP+r06ERk/mZOw3BERhNtE8IuJR7XJw==
X-Received: by 2002:a37:9e92:: with SMTP id h140mr22324127qke.24.1586890981611;
        Tue, 14 Apr 2020 12:03:01 -0700 (PDT)
Received: from localhost (mobile-166-170-55-13.mycingular.net. [166.170.55.13])
        by smtp.gmail.com with ESMTPSA id z18sm12048224qtz.77.2020.04.14.12.03.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2020 12:03:01 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org, ramalingam.c@intel.com
Cc:     intel-gfx@lists.freedesktop.org, Sean Paul <seanpaul@chromium.org>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH v2] drm: Fix HDCP failures when SRM fw is missing
Date:   Tue, 14 Apr 2020 15:02:55 -0400
Message-Id: <20200414190258.38873-1-sean@poorly.run>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414184835.2878-1-sean@poorly.run>
References: <20200414184835.2878-1-sean@poorly.run>
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
cannot be found. It also checks the return value from request_srm such
that we won't end up trying to parse the ksv list if there is an error
fetching it.

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

Changes in v2:
-Noticed a couple other things to clean up
---

Sorry for the quick rev, noticed a couple other loose ends that should
be cleaned up.

 drivers/gpu/drm/drm_hdcp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_hdcp.c b/drivers/gpu/drm/drm_hdcp.c
index 7f386adcf872..910108ccaae1 100644
--- a/drivers/gpu/drm/drm_hdcp.c
+++ b/drivers/gpu/drm/drm_hdcp.c
@@ -241,8 +241,12 @@ static int drm_hdcp_request_srm(struct drm_device *drm_dev,
 
 	ret = request_firmware_direct(&fw, (const char *)fw_name,
 				      drm_dev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		*revoked_ksv_cnt = 0;
+		*revoked_ksv_list = NULL;
+		ret = 0;
 		goto exit;
+	}
 
 	if (fw->size && fw->data)
 		ret = drm_hdcp_srm_update(fw->data, fw->size, revoked_ksv_list,
@@ -287,6 +291,8 @@ int drm_hdcp_check_ksvs_revoked(struct drm_device *drm_dev, u8 *ksvs,
 
 	ret = drm_hdcp_request_srm(drm_dev, &revoked_ksv_list,
 				   &revoked_ksv_cnt);
+	if (ret)
+		return ret;
 
 	/* revoked_ksv_cnt will be zero when above function failed */
 	for (i = 0; i < revoked_ksv_cnt; i++)
-- 
Sean Paul, Software Engineer, Google / Chromium OS

