Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1727B1EA8E1
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgFAR4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbgFAR4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C4220776;
        Mon,  1 Jun 2020 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034207;
        bh=dc9czzCLAvBGNJXwWXxQ6EERhg0N39WPZaP1WBZlugQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sx0aZs0Fsx+MyWASjB1g/i7m5HKiq98jCI4SSxjAvWxnOQvNGLdy0vZuwiB09Dtss
         MHKon7qotHht8u0cWwYRcUnYvsv6Roh9Wc2h+dwvw6R84XVmECjly+ismlneSIkJsX
         psv+wiRV6VwHzD0FrrW9b6q7L6/Ogw4yFtmAQ560=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Matt Roper <matthew.d.roper@intel.com>,
        Xuebing Chen <chenxb_99091@126.com>
Subject: [PATCH 4.4 40/48] drm/fb-helper: Use proper plane mask for fb cleanup
Date:   Mon,  1 Jun 2020 19:53:50 +0200
Message-Id: <20200601174003.543518078@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

commit 7118fd9bd975a9f3093239d4c0f4e15356b57fab upstream.

pan_display_atomic() calls drm_atomic_clean_old_fb() to sanitize the
legacy FB fields (plane->fb and plane->old_fb).  However it was building
the plane mask to pass to this function incorrectly (the bitwise OR was
using plane indices rather than plane masks).  The end result was that
sometimes the legacy pointers would become out of sync with the atomic
pointers.  If another operation tried to re-set the same FB onto the
plane, we might end up with the pointers back in sync, but improper
reference counts, which would eventually lead to system crashes when we
accessed a pointer to a prematurely-destroyed FB.

The cause here was a very subtle bug introduced in commit:

        commit 07d3bad6c1210bd21e85d084807ef4ee4ac43a78
        Author: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
        Date:   Wed Nov 11 11:29:11 2015 +0100

            drm/core: Fix old_fb handling in pan_display_atomic.

I found the crashes were most easily reproduced (on i915 at least) by
starting X and then VT switching to a VT that wasn't running a console
instance...the sequence of vt/fbcon entries that happen in that case
trigger a reference count mismatch and crash the system.

Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=93313
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Xuebing Chen <chenxb_99091@126.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1256,7 +1256,7 @@ retry:
 			goto fail;
 
 		plane = mode_set->crtc->primary;
-		plane_mask |= drm_plane_index(plane);
+		plane_mask |= (1 << drm_plane_index(plane));
 		plane->old_fb = plane->fb;
 	}
 


