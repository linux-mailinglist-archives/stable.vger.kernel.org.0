Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06DA304AB7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbhAZE6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730309AbhAYSty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBFAA20E65;
        Mon, 25 Jan 2021 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600553;
        bh=FgDsuDqPOLAV85tBpA9qWT8iY7nuihfOtKWxblpU5ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcgJKD30JaIAVLDrgEqwmfJGWJM/KDOaMM866uvFdFFV1yvJVrFiG4y3gOm3UFhbJ
         laILeAFQRljQ5C7GoIl0smWLjaK/qiofSHK/ILPY9SXy+D+9421NbX0Q4T3pQgH+MD
         /ArgsDYp7LKsgaq0+NbT+NhtcmLZBRI/plXMofEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.10 029/199] drm/syncobj: Fix use-after-free
Date:   Mon, 25 Jan 2021 19:37:31 +0100
Message-Id: <20210125183217.485039867@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit a37eef63bc9e16e06361b539e528058146af80ab upstream.

While reviewing Christian's annotation patch I noticed that we have a
user-after-free for the WAIT_FOR_SUBMIT case: We drop the syncobj
reference before we've completed the waiting.

Of course usually there's nothing bad happening here since userspace
keeps the reference, but we can't rely on userspace to play nice here!

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Fixes: bc9c80fe01a2 ("drm/syncobj: use the timeline point in drm_syncobj_find_fence v4")
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.2+
Link: https://patchwork.freedesktop.org/patch/msgid/20210119130318.615145-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_syncobj.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -388,19 +388,18 @@ int drm_syncobj_find_fence(struct drm_fi
 		return -ENOENT;
 
 	*fence = drm_syncobj_fence_get(syncobj);
-	drm_syncobj_put(syncobj);
 
 	if (*fence) {
 		ret = dma_fence_chain_find_seqno(fence, point);
 		if (!ret)
-			return 0;
+			goto out;
 		dma_fence_put(*fence);
 	} else {
 		ret = -EINVAL;
 	}
 
 	if (!(flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT))
-		return ret;
+		goto out;
 
 	memset(&wait, 0, sizeof(wait));
 	wait.task = current;
@@ -432,6 +431,9 @@ int drm_syncobj_find_fence(struct drm_fi
 	if (wait.node.next)
 		drm_syncobj_remove_wait(syncobj, &wait);
 
+out:
+	drm_syncobj_put(syncobj);
+
 	return ret;
 }
 EXPORT_SYMBOL(drm_syncobj_find_fence);


