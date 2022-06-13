Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF281548BFF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356052AbiFMLvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356054AbiFMLtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82161182C;
        Mon, 13 Jun 2022 03:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B65DF61376;
        Mon, 13 Jun 2022 10:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D47EC34114;
        Mon, 13 Jun 2022 10:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117621;
        bh=nJDxXZeW4dNZBJ3xKwI5D10rJwiQ5ZFbGJpcGhfvC24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1gv6zEsu01v93AP+6Xuw359zSniPzTaKpA9e6yEBDjyemalX55FybgFYlVKriSAl
         ul7nPnHKdnXm64VAUnW3vlMGiGKNl1aOJkuZMZatG+A4SHuAFmM9zndpSHXUJu4CbJ
         rOJquD5a8KKv99iii89FsWv5Jvg9+H+M9Bp79xTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/287] drm: fix EDID struct for old ARM OABI format
Date:   Mon, 13 Jun 2022 12:08:01 +0200
Message-Id: <20220613094925.597058510@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 47f15561b69e226bfc034e94ff6dbec51a4662af ]

When building the kernel for arm with the "-mabi=apcs-gnu" option, gcc
will force alignment of all structures and unions to a word boundary
(see also STRUCTURE_SIZE_BOUNDARY and the "-mstructure-size-boundary=XX"
option if you're a gcc person), even when the members of said structures
do not want or need said alignment.

This completely messes up the structure alignment of 'struct edid' on
those targets, because even though all the embedded structures are
marked with "__attribute__((packed))", the unions that contain them are
not.

This was exposed by commit f1e4c916f97f ("drm/edid: add EDID block count
and size helpers"), but the bug is pre-existing.  That commit just made
the structure layout problem cause a build failure due to the addition
of the

        BUILD_BUG_ON(sizeof(*edid) != EDID_LENGTH);

sanity check in drivers/gpu/drm/drm_edid.c:edid_block_data().

This legacy union alignment should probably not be used in the first
place, but we can fix the layout by adding the packed attribute to the
union entries even when each member is already packed and it shouldn't
matter in a sane build environment.

You can see this issue with a trivial test program:

  union {
	struct {
		char c[5];
	};
	struct {
		char d;
		unsigned e;
	} __attribute__((packed));
  } a = { "1234" };

where building this with a normal "gcc -S" will result in the expected
5-byte size of said union:

	.type	a, @object
	.size	a, 5

but with an ARM compiler and the old ABI:

    arm-linux-gnu-gcc -mabi=apcs-gnu -mfloat-abi=soft -S t.c

you get

	.type	a, %object
	.size	a, 8

instead, because even though each member of the union is packed, the
union itself still gets aligned.

This was reported by Sudip for the spear3xx_defconfig target.

Link: https://lore.kernel.org/lkml/YpCUzStDnSgQLNFN@debian/
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_edid.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index 53be104aab5c..8b9678bffe7b 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -115,7 +115,7 @@ struct detailed_data_monitor_range {
 			u8 supported_scalings;
 			u8 preferred_refresh;
 		} __attribute__((packed)) cvt;
-	} formula;
+	} __attribute__((packed)) formula;
 } __attribute__((packed));
 
 struct detailed_data_wpindex {
@@ -148,7 +148,7 @@ struct detailed_non_pixel {
 		struct detailed_data_wpindex color;
 		struct std_timing timings[6];
 		struct cvt_timing cvt[4];
-	} data;
+	} __attribute__((packed)) data;
 } __attribute__((packed));
 
 #define EDID_DETAIL_EST_TIMINGS 0xf7
@@ -166,7 +166,7 @@ struct detailed_timing {
 	union {
 		struct detailed_pixel_timing pixel_data;
 		struct detailed_non_pixel other_data;
-	} data;
+	} __attribute__((packed)) data;
 } __attribute__((packed));
 
 #define DRM_EDID_INPUT_SERRATION_VSYNC (1 << 0)
-- 
2.35.1



