Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660F9D25B4
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387497AbfJJIkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbfJJIkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B2F21A4C;
        Thu, 10 Oct 2019 08:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696821;
        bh=/XgYEavpy/3HYlm+L0OW095hxFwEFZ4l1yMxKgRX3EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnF/BVoUvbKn+ubGm8sDbwpfq9gaf0Xyc4KFD282Hot/BP4kXlk4Ea3wx72xpBGHi
         VuDBf9HsBFFOZ4MZ8jN/qoqcYLZP+s1pqgzF1coKNRxlvQdj5nyYM0wtnTyEwLUJZ0
         HGm1Sa8yz/PSfUOdCIJ5t2k3oN4gpsrQANGYkj00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilia Mirkin <imirkin@alum.mit.edu>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>,
        Adam Jackson <ajax@redhat.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: [PATCH 5.3 064/148] drm/atomic: Take the atomic toys away from X
Date:   Thu, 10 Oct 2019 10:35:25 +0200
Message-Id: <20191010083615.346318040@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 26b1d3b527e7bf3e24b814d617866ac5199ce68d upstream.

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

v3: Go with paranoid, insist that the X should be first (suggested by
Rob)

Cc: Ilia Mirkin <imirkin@alum.mit.edu>
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
Link: https://patchwork.freedesktop.org/patch/msgid/20190905185318.31363-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_ioctl.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -336,7 +336,12 @@ drm_setclientcap(struct drm_device *dev,
 	case DRM_CLIENT_CAP_ATOMIC:
 		if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
 			return -EOPNOTSUPP;
-		if (req->value > 1)
+		/* The modesetting DDX has a totally broken idea of atomic. */
+		if (current->comm[0] == 'X' && req->value == 1) {
+			pr_info("broken atomic modeset userspace detected, disabling atomic\n");
+			return -EOPNOTSUPP;
+		}
+		if (req->value > 2)
 			return -EINVAL;
 		file_priv->atomic = req->value;
 		file_priv->universal_planes = req->value;


