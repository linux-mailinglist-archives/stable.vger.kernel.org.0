Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8365A2D9E8A
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440558AbgLNSHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408611AbgLNRjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:19 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 091/105] drm/i915/display/dp: Compute the correct slice count for VDSC on DP
Date:   Mon, 14 Dec 2020 18:29:05 +0100
Message-Id: <20201214172559.665668176@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manasi Navare <manasi.d.navare@intel.com>

commit f6cbe49be65ed800863ac5ba695555057363f9c2 upstream.

This patch fixes the slice count computation algorithm
for calculating the slice count based on Peak pixel rate
and the max slice width allowed on the DSC engines.
We need to ensure slice count > min slice count req
as per DP spec based on peak pixel rate and that it is
greater than min slice count based on the max slice width
advertised by DPCD. So use max of these two.
In the prev patch we were using min of these 2 causing it
to violate the max slice width limitation causing a blank
screen on 8K@60.

Fixes: d9218c8f6cf4 ("drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Manasi Navare <manasi.d.navare@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201204205804.25225-1-manasi.d.navare@intel.com
(cherry picked from commit d371d6ea92ad2a47f42bbcaa786ee5f6069c9c14)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -597,7 +597,7 @@ static u8 intel_dp_dsc_get_slice_count(s
 		return 0;
 	}
 	/* Also take into account max slice width */
-	min_slice_count = min_t(u8, min_slice_count,
+	min_slice_count = max_t(u8, min_slice_count,
 				DIV_ROUND_UP(mode_hdisplay,
 					     max_slice_width));
 


