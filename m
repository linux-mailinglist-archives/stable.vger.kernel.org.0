Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3057653A873
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354579AbiFAOJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355826AbiFAOG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:06:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88675BA9A4;
        Wed,  1 Jun 2022 07:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4FDB6162F;
        Wed,  1 Jun 2022 13:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00388C385B8;
        Wed,  1 Jun 2022 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091990;
        bh=+Sg44/L0M+G9n0ENnHsUVMZlZ9N783aU8Lc2N6fwMW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uf1VhnmggQ1P1KmyoCECxYZ24jyWEBVyNh6ZsWLsjZQdfXSA1CzBTgO9XlJ1iG+Ji
         w0qR8zpG8ducBOAOSVliW6VZsJrnaJsclF3vzfnQd0GJw0v81+Xgu84RTDe9XShj1z
         nYq1g5QacKVL6jExESJRxPOFFg1nX1XRBxFNTA8GFmL7d291C781Okd2qUoZZd6hca
         XtXdtenLZoO16lH2484qUzDv//bBEiv74J6xo3GPdtg35YEMMq3VS5ynGRtLCEtGyU
         LsEGrJ78pikl2NCBUfMxB6iFh6rbb5NyZsVlZEfFmnqMOwPoz6kMRF5530pmsBsh2v
         wn7GtslBJjC3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 20/20] drm: fix EDID struct for old ARM OABI format
Date:   Wed,  1 Jun 2022 09:59:02 -0400
Message-Id: <20220601135902.2004823-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135902.2004823-1-sashal@kernel.org>
References: <20220601135902.2004823-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b9719418c3d2..f40a97417b68 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -116,7 +116,7 @@ struct detailed_data_monitor_range {
 			u8 supported_scalings;
 			u8 preferred_refresh;
 		} __attribute__((packed)) cvt;
-	} formula;
+	} __attribute__((packed)) formula;
 } __attribute__((packed));
 
 struct detailed_data_wpindex {
@@ -149,7 +149,7 @@ struct detailed_non_pixel {
 		struct detailed_data_wpindex color;
 		struct std_timing timings[6];
 		struct cvt_timing cvt[4];
-	} data;
+	} __attribute__((packed)) data;
 } __attribute__((packed));
 
 #define EDID_DETAIL_EST_TIMINGS 0xf7
@@ -167,7 +167,7 @@ struct detailed_timing {
 	union {
 		struct detailed_pixel_timing pixel_data;
 		struct detailed_non_pixel other_data;
-	} data;
+	} __attribute__((packed)) data;
 } __attribute__((packed));
 
 #define DRM_EDID_INPUT_SERRATION_VSYNC (1 << 0)
-- 
2.35.1

