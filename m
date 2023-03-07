Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AADE6AE974
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjCGRYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjCGRYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:24:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F215D9B9BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:19:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E0A4B819B0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05CFC4339B;
        Tue,  7 Mar 2023 17:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209564;
        bh=4wcmjOK3au9c7YzgOC3bkT1t8nJpoFaFDjWP1hCHNd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L47y4j+KYbU8LnYFNSp8v4rLx78dyGttBEaD57W94DuFBL7+WWOvHb25kWefqeL4m
         GvJjw3MSMIfiOIEG0r4maEGEVVyq0kx5/m0NLS1u6vCdpUI/W9Lg/sD2jYu6jDjcOR
         7thko4Y4lQRaip/R8MR7MwUKCkjt732Ss+WwH21g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0228/1001] drm/nouveau/disp: Fix nvif_outp_acquire_dp() argument size
Date:   Tue,  7 Mar 2023 17:50:00 +0100
Message-Id: <20230307170031.764563907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 4076ea2419cf15bc1e1580f8b24ddf675fbdb02c ]

Both Coverity and GCC with -Wstringop-overflow noticed that
nvif_outp_acquire_dp() accidentally defined its second argument with 1
additional element:

drivers/gpu/drm/nouveau/dispnv50/disp.c: In function 'nv50_pior_atomic_enable':
drivers/gpu/drm/nouveau/dispnv50/disp.c:1813:17: error: 'nvif_outp_acquire_dp' accessing 16 bytes in a region of size 15 [-Werror=stringop-overflow=]
 1813 |                 nvif_outp_acquire_dp(&nv_encoder->outp, nv_encoder->dp.dpcd, 0, 0, false, false);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/nouveau/dispnv50/disp.c:1813:17: note: referencing argument 2 of type 'u8[16]' {aka 'unsigned char[16]'}
drivers/gpu/drm/nouveau/include/nvif/outp.h:24:5: note: in a call to function 'nvif_outp_acquire_dp'
   24 | int nvif_outp_acquire_dp(struct nvif_outp *, u8 dpcd[16],
      |     ^~~~~~~~~~~~~~~~~~~~

Avoid these warnings by defining the argument size using the matching
define (DP_RECEIVER_CAP_SIZE, 15) instead of having it be a literal
(and incorrect) value (16).

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527269 ("Memory - corruptions")
Addresses-Coverity-ID: 1527268 ("Memory - corruptions")
Link: https://lore.kernel.org/lkml/202211100848.FFBA2432@keescook/
Link: https://lore.kernel.org/lkml/202211100848.F4C2819BB@keescook/
Fixes: 813443721331 ("drm/nouveau/disp: move DP link config into acquire")
Reviewed-by: Lyude Paul <lyude@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221127183036.never.139-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/include/nvif/outp.h | 3 ++-
 drivers/gpu/drm/nouveau/nvif/outp.c         | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvif/outp.h b/drivers/gpu/drm/nouveau/include/nvif/outp.h
index 45daadec3c0c7..fa76a7b5e4b37 100644
--- a/drivers/gpu/drm/nouveau/include/nvif/outp.h
+++ b/drivers/gpu/drm/nouveau/include/nvif/outp.h
@@ -3,6 +3,7 @@
 #define __NVIF_OUTP_H__
 #include <nvif/object.h>
 #include <nvif/if0012.h>
+#include <drm/display/drm_dp.h>
 struct nvif_disp;
 
 struct nvif_outp {
@@ -21,7 +22,7 @@ int nvif_outp_acquire_rgb_crt(struct nvif_outp *);
 int nvif_outp_acquire_tmds(struct nvif_outp *, int head,
 			   bool hdmi, u8 max_ac_packet, u8 rekey, u8 scdc, bool hda);
 int nvif_outp_acquire_lvds(struct nvif_outp *, bool dual, bool bpc8);
-int nvif_outp_acquire_dp(struct nvif_outp *, u8 dpcd[16],
+int nvif_outp_acquire_dp(struct nvif_outp *outp, u8 dpcd[DP_RECEIVER_CAP_SIZE],
 			 int link_nr, int link_bw, bool hda, bool mst);
 void nvif_outp_release(struct nvif_outp *);
 int nvif_outp_infoframe(struct nvif_outp *, u8 type, struct nvif_outp_infoframe_v0 *, u32 size);
diff --git a/drivers/gpu/drm/nouveau/nvif/outp.c b/drivers/gpu/drm/nouveau/nvif/outp.c
index 7da39f1eae9fb..c24bc5eae3ecf 100644
--- a/drivers/gpu/drm/nouveau/nvif/outp.c
+++ b/drivers/gpu/drm/nouveau/nvif/outp.c
@@ -127,7 +127,7 @@ nvif_outp_acquire(struct nvif_outp *outp, u8 proto, struct nvif_outp_acquire_v0
 }
 
 int
-nvif_outp_acquire_dp(struct nvif_outp *outp, u8 dpcd[16],
+nvif_outp_acquire_dp(struct nvif_outp *outp, u8 dpcd[DP_RECEIVER_CAP_SIZE],
 		     int link_nr, int link_bw, bool hda, bool mst)
 {
 	struct nvif_outp_acquire_v0 args;
-- 
2.39.2



