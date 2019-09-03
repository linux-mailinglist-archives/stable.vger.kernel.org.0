Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92102A7324
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfICTG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:06:59 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44443 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfICTG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 15:06:59 -0400
Received: by mail-ed1-f67.google.com with SMTP id a21so19533888edt.11
        for <stable@vger.kernel.org>; Tue, 03 Sep 2019 12:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ckY/KAeiZDB3HVlWWtTrREXRk00i+gfuUAhn7BUyNQc=;
        b=HcguDoinyhyklB70paAwAOsIanu+sNgBF0yAcpJHLx3t0bOo4u5VOKazsy/uNHnGkF
         doqd6Nx3eF0PJTgC8nyUow73FANyqbLGFiYOEqQBnKilYlk1pFIV3s2QTt9gQSDMSHVP
         BQtkWGqNHAkmHQp0BRaOIFWbPz9NwimF7mA5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ckY/KAeiZDB3HVlWWtTrREXRk00i+gfuUAhn7BUyNQc=;
        b=ZVe0IWHTwu6S1lpe5ndqYL01yBge+hkcjGp+RJVKJr0xvxmROQQyoghZCUZYsvk5VB
         Vtkm4FeS1Dt1+YZjH2LoUOP7MBdGy+ZdLA2TPEY/V6daU2R7NW2Kbl4sHF6w+5Zoui/g
         5jTs1lbiVq0u8Jgz9NpXl5mf8KVCFE1+zgVim2cEp33hpQQLYdDLEsV4Xgt96BLGPdqP
         bX67q+nNuHyLEf7A4vbLdi2vPfOnE5/2hTiQ7ndTp0pkTgOV0HLA+iFbsU9YpnRDYrqc
         pebbz/OwrdM5rqlWqLkwZT/6u82aQYrB/Z1Gdv8K7HtZ/ENkBBoU3mpSkwhMcZEpuk7P
         7sSA==
X-Gm-Message-State: APjAAAUPlmVmqZ0Qn7zJj0hLrhrmgg/DtMtTlwYmay4vA2sB7LcCqVuI
        PBnZIl1sbRaWuBkmU70URXm9nw==
X-Google-Smtp-Source: APXvYqx1BOkLWrBFwYTyatQP2rtihPWcoLWBj195C0eN89jv+ZkAeI6xRXFztEdEdx+ijWV2lChkuQ==
X-Received: by 2002:a17:906:c802:: with SMTP id cx2mr29826265ejb.114.1567537617137;
        Tue, 03 Sep 2019 12:06:57 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id b12sm3655583edj.93.2019.09.03.12.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 12:06:56 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>,
        Adam Jackson <ajax@redhat.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 1/3] drm/atomic: Take the atomic toys away from X
Date:   Tue,  3 Sep 2019 21:06:40 +0200
Message-Id: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.23.0
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

References: https://gitlab.freedesktop.org/xorg/xserver/issues/629
References: https://gitlab.freedesktop.org/xorg/xserver/merge_requests/180
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Michel Dänzer <michel@daenzer.net>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Adam Jackson <ajax@redhat.com>
Cc: Sean Paul <sean@poorly.run>
Cc: David Airlie <airlied@linux.ie>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/drm_ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 2c120c58f72d..1cb7b4c3c87c 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -334,6 +334,9 @@ drm_setclientcap(struct drm_device *dev, void *data, struct drm_file *file_priv)
 		file_priv->universal_planes = req->value;
 		break;
 	case DRM_CLIENT_CAP_ATOMIC:
+		/* The modesetting DDX has a totally broken idea of atomic. */
+		if (strstr(current->comm, "X"))
+			return -EOPNOTSUPP;
 		if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
 			return -EOPNOTSUPP;
 		if (req->value > 1)
-- 
2.23.0

