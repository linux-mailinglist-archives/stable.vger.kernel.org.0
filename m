Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F960541331
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353561AbiFGT4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357507AbiFGTzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:55:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE33C8A052;
        Tue,  7 Jun 2022 11:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7647D60DDF;
        Tue,  7 Jun 2022 18:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4D1C3411C;
        Tue,  7 Jun 2022 18:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626215;
        bh=/dbWxOZHy2OewWmHqoNlkYSibashwQ7otUvCVbYc+WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ld3IMjjax5UbWYX4+h+94+7bNWGXLNNRCuHiJnQgS0nuipwG3nBWAHtRDjxdUqn3c
         FGVSu2BZUaoxyqmgG8Q0vFsyQD2KMHnPXXBF0M7pd13tq98t26HnABUArFYkSUOpEY
         xQOtbxels1DGQCKVmYWddqlj7tcmnU1wtfOCCMyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Brian Starkey <brian.starkey@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 258/772] drm: mali-dp: potential dereference of null pointer
Date:   Tue,  7 Jun 2022 18:57:30 +0200
Message-Id: <20220607164956.625088066@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 73c3ed7495c67b8fbdc31cf58e6ca8757df31a33 ]

The return value of kzalloc() needs to be checked.
To avoid use of null pointer '&state->base' in case of the
failure of alloc.

Fixes: 99665d072183 ("drm: mali-dp: add malidp_crtc_state struct")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Brian Starkey <brian.starkey@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211214100837.46912-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_crtc.c b/drivers/gpu/drm/arm/malidp_crtc.c
index 494075ddbef6..b5928b52e279 100644
--- a/drivers/gpu/drm/arm/malidp_crtc.c
+++ b/drivers/gpu/drm/arm/malidp_crtc.c
@@ -487,7 +487,10 @@ static void malidp_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		malidp_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static int malidp_crtc_enable_vblank(struct drm_crtc *crtc)
-- 
2.35.1



