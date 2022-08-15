Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA11593D75
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbiHOUC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345921AbiHOUA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:00:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ACB7A51D;
        Mon, 15 Aug 2022 11:53:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AD70B810A0;
        Mon, 15 Aug 2022 18:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DADC433D7;
        Mon, 15 Aug 2022 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589604;
        bh=gSo018KO7yciQS/cs61HZj9oE5g4mjzMJegIb32bSyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSAdD2kACO7rTuxfMGzgeUMwm5tWDrswNP342T4DPStdBeRTqG+4MiHrGpvN0zHdP
         8Pl1Ny13LGH70LboPFNpdjVqG+f4fNL1K10KPwBNN5lAQ7cOzrREERzgNGrSNLUyWb
         ZfsKlUnnr+dzpf+++5Tv8CC3yBInidhgvBjseoVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.15 771/779] drm/msm: Fix dirtyfb refcounting
Date:   Mon, 15 Aug 2022 20:06:55 +0200
Message-Id: <20220815180410.350724076@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

commit 9225b337072a10bf9b09df8bf281437488dd8a26 upstream.

refcount_t complains about 0->1 transitions, which isn't *quite* what we
wanted.  So use dirtyfb==1 to mean that the fb is not connected to any
output that requires dirtyfb flushing, so that we can keep the underflow
and overflow checking.

Fixes: 9e4dde28e9cd ("drm/msm: Avoid dirtyfb stalls on video mode displays (v2)")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20220304202146.845566-1-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_fb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/msm_fb.c
+++ b/drivers/gpu/drm/msm/msm_fb.c
@@ -37,7 +37,7 @@ static int msm_framebuffer_dirtyfb(struc
 	/* If this fb is not used on any display requiring pixel data to be
 	 * flushed, then skip dirtyfb
 	 */
-	if (refcount_read(&msm_fb->dirtyfb) == 0)
+	if (refcount_read(&msm_fb->dirtyfb) == 1)
 		return 0;
 
 	return drm_atomic_helper_dirtyfb(fb, file_priv, flags, color,
@@ -221,6 +221,8 @@ static struct drm_framebuffer *msm_frame
 		goto fail;
 	}
 
+	refcount_set(&msm_fb->dirtyfb, 1);
+
 	drm_dbg_state(dev, "create: FB ID: %d (%p)", fb->base.id, fb);
 
 	return fb;


