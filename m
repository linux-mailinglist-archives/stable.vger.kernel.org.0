Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB334C7656
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiB1SCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbiB1SBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:01:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346E29A4FA;
        Mon, 28 Feb 2022 09:45:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B453B815CB;
        Mon, 28 Feb 2022 17:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A928C340E7;
        Mon, 28 Feb 2022 17:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070341;
        bh=VyUfbnGaAd3kqjHNxWN381qVv/0zLvBAVIYkwePJkDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ui2IHsnLPxndPy/74yf59EDNuZhqYDHtAOjV+KLFSrWKyb36VQgWsQJ4DwB3ZBIvu
         MSidcRu7G73KdzEnvmuVnTxw1IoGSTouUfzA4LnehbiI1HxV0y12BFE/Dfq5g9WMjq
         3ZV2lTS/GflYXXBj+adJZNOCwZMTfxEZpBUHlEP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 5.16 074/164] drm/vc4: crtc: Fix runtime_pm reference counting
Date:   Mon, 28 Feb 2022 18:23:56 +0100
Message-Id: <20220228172406.772484072@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit 6764eb690e77ecded48587d6d4e346ba2e196546 upstream.

At boot on the BCM2711, if the HDMI controllers are running, the CRTC
driver will disable itself and its associated HDMI controller to work
around a hardware bug that would leave some pixels stuck in a FIFO.

In order to avoid that issue, we need to run some operations in lockstep
between the CRTC and HDMI controller, and we need to make sure the HDMI
controller will be powered properly.

However, since we haven't enabled it through KMS, the runtime_pm state
is off at this point so we need to make sure the device is powered
through pm_runtime_resume_and_get, and once the operations are complete,
we call pm_runtime_put.

However, the HDMI controller will do that itself in its
post_crtc_powerdown, which means we'll end up calling pm_runtime_put for
a single pm_runtime_get, throwing the reference counting off. Let's
remove the pm_runtime_put call in the CRTC code in order to have the
proper counting.

Fixes: bca10db67bda ("drm/vc4: crtc: Make sure the HDMI controller is powered when disabling")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220203102003.1114673-1-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -538,9 +538,11 @@ int vc4_crtc_disable_at_boot(struct drm_
 	if (ret)
 		return ret;
 
-	ret = pm_runtime_put(&vc4_hdmi->pdev->dev);
-	if (ret)
-		return ret;
+	/*
+	 * post_crtc_powerdown will have called pm_runtime_put, so we
+	 * don't need it here otherwise we'll get the reference counting
+	 * wrong.
+	 */
 
 	return 0;
 }


