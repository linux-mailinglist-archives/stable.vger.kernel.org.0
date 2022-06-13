Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241BB549456
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356064AbiFMLsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356017AbiFMLnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:43:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CBD46143;
        Mon, 13 Jun 2022 03:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE188B80D41;
        Mon, 13 Jun 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1570DC3411C;
        Mon, 13 Jun 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117413;
        bh=+Zu52xhLNEr3n86vyYiWyA+bk3Zs5E5WLkGRppu9zUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkXwwYhORDUEcuo6uSP8Vb8cUI1b26DuxGzQLW0RG2D8CYz4VX/zkEzs00pEKf+x2
         IUAINvcLsd9O64hvx1dv43APqIJBwFCnKdCxE2ruibP55LP2nKay7jQf4vi5A91Te7
         GcS/0ph44Pk0WFKktRopNVXqPMWw81178fTuOulI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 364/411] drm: imx: fix compiler warning with gcc-12
Date:   Mon, 13 Jun 2022 12:10:37 +0200
Message-Id: <20220613094939.604690419@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit 7aefd8b53815274f3ef398d370a3c9b27dd9f00c ]

Gcc-12 correctly warned about this code using a non-NULL pointer as a
truth value:

  drivers/gpu/drm/imx/ipuv3-crtc.c: In function ‘ipu_crtc_disable_planes’:
  drivers/gpu/drm/imx/ipuv3-crtc.c:72:21: error: the comparison will always evaluate as ‘true’ for the address of ‘plane’ will never be NULL [-Werror=address]
     72 |                 if (&ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
        |                     ^

due to the extraneous '&' address-of operator.

Philipp Zabel points out that The mistake had no adverse effect since
the following condition doesn't actually dereference the NULL pointer,
but the intent of the code was obviously to check for it, not to take
the address of the member.

Fixes: eb8c88808c83 ("drm/imx: add deferred plane disabling")
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 2256c9789fc2..f19264e91d4d 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -68,7 +68,7 @@ static void ipu_crtc_disable_planes(struct ipu_crtc *ipu_crtc,
 	drm_atomic_crtc_state_for_each_plane(plane, old_crtc_state) {
 		if (plane == &ipu_crtc->plane[0]->base)
 			disable_full = true;
-		if (&ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
+		if (ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
 			disable_partial = true;
 	}
 
-- 
2.35.1



