Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505365495B5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349430AbiFMMUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353582AbiFMMRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:17:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7EA5622A;
        Mon, 13 Jun 2022 04:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4306561418;
        Mon, 13 Jun 2022 11:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEE5C3411C;
        Mon, 13 Jun 2022 11:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118158;
        bh=2+sXTKepR/8b3NHPfAW945T66hNq49V6LWnAU9ieP1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6r74Qya5m33Zhxzo2xt3K8kcN1narDf4kyF0JnniR8OLaNPANoyTGNnmOhBhSYPw
         ZCa0YIUY6mQGK9HHZXaQy/ABVgm3LpQQd7uEki+Ppf47vIv79rIR6c092adKlcSs2w
         mL+G6gv1W3bXKYyAVGTHwRkCpeTpLM79iAM1A2uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 247/287] drm: imx: fix compiler warning with gcc-12
Date:   Mon, 13 Jun 2022 12:11:11 +0200
Message-Id: <20220613094931.504930806@linuxfoundation.org>
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
index ff34f9bb55a1..824c90dca730 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -71,7 +71,7 @@ static void ipu_crtc_disable_planes(struct ipu_crtc *ipu_crtc,
 	drm_atomic_crtc_state_for_each_plane(plane, old_crtc_state) {
 		if (plane == &ipu_crtc->plane[0]->base)
 			disable_full = true;
-		if (&ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
+		if (ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
 			disable_partial = true;
 	}
 
-- 
2.35.1



