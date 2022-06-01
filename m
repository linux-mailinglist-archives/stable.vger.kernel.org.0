Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4973353A8BC
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354598AbiFAOLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354974AbiFAOKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:10:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078EA1276C;
        Wed,  1 Jun 2022 07:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5CF6B81AEB;
        Wed,  1 Jun 2022 14:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFE1C3411D;
        Wed,  1 Jun 2022 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092088;
        bh=Bf5QOHaJpiVUqhHBRSN35OBw5iZVamMzadF9hlHiv/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cpf7T/vUb1d4hvMoZxdKAUVcD5z+daL9PaQrq3n59KP52Ah0AVVs15A2Dc8HP95Qj
         MdhL3McM3oQQwWWLDXr/0EbPebL+fapUJzrBBylw0jUALOUZb9pti8ijOAFzz0y/vr
         LedDlpx4IjuH7bgxbMeUTGaxzHOi434cphgx2K/DHy+dAVh4pwnZtAc/1KmSndqYk4
         Tmz4jRLl6zS9mfANuEO2QiNEG/zG2Wqf1fsZ8vbHHJ1hoVx3pM/XQRm9+Bqr43Kyzr
         HUuXzSmWjVliSjceG2GTkb7R0+dh/h7WturgdyrQbMUr2T3K96LdIzK9wME7hxxbk9
         jQCTd7ao28YEg==
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
Subject: [PATCH AUTOSEL 4.9 11/11] drm: fix EDID struct for old ARM OABI format
Date:   Wed,  1 Jun 2022 10:01:00 -0400
Message-Id: <20220601140100.2005469-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601140100.2005469-1-sashal@kernel.org>
References: <20220601140100.2005469-1-sashal@kernel.org>
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
index c3a7d440bc11..514a02095983 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -114,7 +114,7 @@ struct detailed_data_monitor_range {
 			u8 supported_scalings;
 			u8 preferred_refresh;
 		} __attribute__((packed)) cvt;
-	} formula;
+	} __attribute__((packed)) formula;
 } __attribute__((packed));
 
 struct detailed_data_wpindex {
@@ -147,7 +147,7 @@ struct detailed_non_pixel {
 		struct detailed_data_wpindex color;
 		struct std_timing timings[6];
 		struct cvt_timing cvt[4];
-	} data;
+	} __attribute__((packed)) data;
 } __attribute__((packed));
 
 #define EDID_DETAIL_EST_TIMINGS 0xf7
@@ -165,7 +165,7 @@ struct detailed_timing {
 	union {
 		struct detailed_pixel_timing pixel_data;
 		struct detailed_non_pixel other_data;
-	} data;
+	} __attribute__((packed)) data;
 } __attribute__((packed));
 
 #define DRM_EDID_INPUT_SERRATION_VSYNC (1 << 0)
-- 
2.35.1

