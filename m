Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCDE6895DC
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjBCKVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbjBCKVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:21:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5D393AFA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:20:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FCBE61EC0
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBEEC433D2;
        Fri,  3 Feb 2023 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419606;
        bh=JvCrWRmie9YuKDVYlWJjVi2HVwDz/MZLtyW+7Vh3JQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mv1jgdBrGwyud+A2pqnT7c3w9W6Xs+soofw+NGlK1wHhpiocVjRxsBOyzatgJD5/E
         Vi7RQn2GYsV5Dso3umlYJ1yzqxypD1UXK9GQptdJqdN8+U8+In5tjU1YniMUWZOFLG
         3h8W1Y4UapmR4T9VD2JPo9r3BvXgBWz034pNWeFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 59/80] drm/i915/display: fix compiler warning about array overrun
Date:   Fri,  3 Feb 2023 11:12:53 +0100
Message-Id: <20230203101017.739800407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 drivers/gpu/drm/i915/intel_dp.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -4116,7 +4116,18 @@ intel_dp_check_mst_status(struct intel_d
 	bool bret;
 
 	if (intel_dp->is_mst) {
-		u8 esi[DP_DPRX_ESI_LEN] = { 0 };
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
+		u8 esi[DP_DPRX_ESI_LEN+2] = { 0 };
 		int ret = 0;
 		int retry;
 		bool handled;


