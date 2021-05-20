Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC62238A0DE
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhETJ0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231667AbhETJ0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C99216121E;
        Thu, 20 May 2021 09:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502700;
        bh=sPSfakmgnesZ82Y93DUvN1QdtL+qmeXs8YleoAHn0nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeT0QUIpWhrKqingzBPsHcVBAP65OWHlsMjWGImgpH3kbHApzccHCTNqBwNNY5ADv
         spB1z13arB+vsdGTd10XF8NKVbMMlWtl6E92yd1OVeMxn0C1ZRzquGXvFNbCcwlwRV
         WVvm3mtVLaL9w824bC7nDdnT7+pupnDVdjG5ISQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 02/45] drm/i915/display: fix compiler warning about array overrun
Date:   Thu, 20 May 2021 11:21:50 +0200
Message-Id: <20210520092053.593776689@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit fec4d42724a1bf3dcba52307e55375fdb967b852 upstream.

intel_dp_check_mst_status() uses a 14-byte array to read the DPRX Event
Status Indicator data, but then passes that buffer at offset 10 off as
an argument to drm_dp_channel_eq_ok().

End result: there are only 4 bytes remaining of the buffer, yet
drm_dp_channel_eq_ok() wants a 6-byte buffer.  gcc-11 correctly warns
about this case:

  drivers/gpu/drm/i915/display/intel_dp.c: In function ‘intel_dp_check_mst_status’:
  drivers/gpu/drm/i915/display/intel_dp.c:3491:22: warning: ‘drm_dp_channel_eq_ok’ reading 6 bytes from a region of size 4 [-Wstringop-overread]
   3491 |                     !drm_dp_channel_eq_ok(&esi[10], intel_dp->lane_count)) {
        |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/i915/display/intel_dp.c:3491:22: note: referencing argument 1 of type ‘const u8 *’ {aka ‘const unsigned char *’}
  In file included from drivers/gpu/drm/i915/display/intel_dp.c:38:
  include/drm/drm_dp_helper.h:1466:6: note: in a call to function ‘drm_dp_channel_eq_ok’
   1466 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
        |      ^~~~~~~~~~~~~~~~~~~~
       6:14 elapsed

This commit just extends the original array by 2 zero-initialized bytes,
avoiding the warning.

There may be some underlying bug in here that caused this confusion, but
this is at least no worse than the existing situation that could use
random data off the stack.

Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4488,7 +4488,18 @@ intel_dp_check_mst_status(struct intel_d
 	drm_WARN_ON_ONCE(&i915->drm, intel_dp->active_mst_links < 0);
 
 	for (;;) {
-		u8 esi[DP_DPRX_ESI_LEN] = {};
+		/*
+		 * The +2 is because DP_DPRX_ESI_LEN is 14, but we then
+		 * pass in "esi+10" to drm_dp_channel_eq_ok(), which
+		 * takes a 6-byte array. So we actually need 16 bytes
+		 * here.
+		 *
+		 * Somebody who knows what the limits actually are
+		 * should check this, but for now this is at least
+		 * harmless and avoids a valid compiler warning about
+		 * using more of the array than we have allocated.
+		 */
+		u8 esi[DP_DPRX_ESI_LEN+2] = {};
 		bool handled;
 		int retry;
 


