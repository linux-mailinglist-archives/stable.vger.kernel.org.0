Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9DAAAB4
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 20:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388830AbfIESSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 14:18:43 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40428 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbfIESSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 14:18:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id v38so3598954edm.7
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 11:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=obFAoJjwX5LVICOlIHTt1Y/s9EsFMUSE1s849zGP32Q=;
        b=fCjtWKHVKfNPVHweI4Dr39tiJQOVJ5Csyxs7DuVOxRDIxrjpp2gtRtuxU0N4SsSRj2
         cX52YmzJXNLBuI2D5qMYuo7im9kxNTogPs6pUJAlilJzDMBFSPWDmOF6lG518UPHrTUi
         hY81BqfZm6U1jwMN/BEPNL6bmMMme8hJhthkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=obFAoJjwX5LVICOlIHTt1Y/s9EsFMUSE1s849zGP32Q=;
        b=GrpWVGDJYColR1C0AkxC1Okjn2WIDeN0ryd4PrnT2g3uLXEyyHZfakuYmHFN6Tu79Q
         5H8t8e0TfOUMD/D4wKkuMo9qpWOW7jbNkLTi/8mwX9bqeyHDLVCLvTZR7U3TizKHbbPg
         I3lm1IJoxynuyA22FKBr/3HUZ/OxqB+sjeOj0LlqOK/+Z8ElUDgul0E6+5wg0z8rYyaU
         Bk73Kqw5vnULiFtf7+EQQtzJc6W0S1BjAiipa0T8Dx0meght0TpB+YnIz3j5Aw/ZS/SF
         X8R+DqYjeK11l5WCHictwfVA0z6HGazdKYyjgQmecM6Yra/7vgvS9GtxRGYrJEBO/5N7
         mWLw==
X-Gm-Message-State: APjAAAVcj7jMlEO5p++0Jngma87/m4XQAT9Kg04cuZ843hsRtePq9g3W
        yTh3vA5M9JAHNrgEO7lPK1AUag==
X-Google-Smtp-Source: APXvYqyzaG6Yf4kQ2QY6XayOtQGL5hNQW9zxGYl73+F4ofPJ6wblCKH7JO8eJ2dauX6xy0MRG8TzBg==
X-Received: by 2002:aa7:d8c8:: with SMTP id k8mr5400533eds.8.1567707522004;
        Thu, 05 Sep 2019 11:18:42 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id v8sm305107ejk.29.2019.09.05.11.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 11:18:41 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>,
        Adam Jackson <ajax@redhat.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm/atomic: Take the atomic toys away from X
Date:   Thu,  5 Sep 2019 20:18:34 +0200
Message-Id: <20190905181834.6234-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
References: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The -modesetting ddx has a totally broken idea of how atomic works:
- doesn't disable old connectors, assuming they get auto-disable like
  with the legacy setcrtc
- assumes ASYNC_FLIP is wired through for the atomic ioctl
- not a single call to TEST_ONLY

Iow the implementation is a 1:1 translation of legacy ioctls to
atomic, which is a) broken b) pointless.

We already have bugs in both i915 and amdgpu-DC where this prevents us
from enabling neat features.

If anyone ever cares about atomic in X we can easily add a new atomic
level (req->value == 2) for X to get back the shiny toys.

Since these broken versions of -modesetting have been shipping,
there's really no other way to get out of this bind.

v2:
- add an informational dmesg output (Rob, Ajax)
- reorder after the DRIVER_ATOMIC check to avoid useless noise (Ilia)
- allow req->value > 2 so that X can do another attempt at atomic in
  the future

Cc: Ilia Mirkin <imirkin@alum.mit.edu>
References: https://gitlab.freedesktop.org/xorg/xserver/issues/629
References: https://gitlab.freedesktop.org/xorg/xserver/merge_requests/180
References: abbc0697d5fb ("drm/fb: revert the i915 Actually configure untiled displays from master")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com> (v1)
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com> (v1)
Cc: Michel Dänzer <michel@daenzer.net>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Adam Jackson <ajax@redhat.com>
Acked-by: Adam Jackson <ajax@redhat.com>
Cc: Sean Paul <sean@poorly.run>
Cc: David Airlie <airlied@linux.ie>
Cc: Rob Clark <robdclark@gmail.com>
Acked-by: Rob Clark <robdclark@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/drm_ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 2c120c58f72d..56aa8bbb3a8c 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -336,7 +336,12 @@ drm_setclientcap(struct drm_device *dev, void *data, struct drm_file *file_priv)
 	case DRM_CLIENT_CAP_ATOMIC:
 		if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
 			return -EOPNOTSUPP;
-		if (req->value > 1)
+		/* The modesetting DDX has a totally broken idea of atomic. */
+		if (strstr(current->comm, "X") && req->value == 1) {
+			pr_info("broken atomic modeset userspace detected, disabling atomic\n");
+			return -EOPNOTSUPP;
+		}
+		if (req->value > 2)
 			return -EINVAL;
 		file_priv->atomic = req->value;
 		file_priv->universal_planes = req->value;
-- 
2.23.0

