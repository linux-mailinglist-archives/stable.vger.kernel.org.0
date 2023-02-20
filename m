Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DE069CE94
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbjBTOA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjBTOAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2397D1E9E3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9592DB80D49
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA02C433D2;
        Mon, 20 Feb 2023 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901595;
        bh=HRST84SWVS9PGipPeDRXh2QU9h3jwN4zpqXUouakz24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAXYmu5kP21iA7sYV7Z/ZL2brg0T6RnOd4hRHq3re9kn/aS3gvkbRNeTe7rPV1U11
         rtOkyzEML2GUzVTizihzCI6KbB/CfYEcfjvWHNP/pTP0sSzaDCfu321t6hF7W4yYvC
         tEooaLg7E1bz6KawRp/q77r0rVU2uC8/s+qY+EPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 6.1 078/118] drm/vc4: crtc: Increase setup cost in core clock calculation to handle extreme reduced blanking
Date:   Mon, 20 Feb 2023 14:36:34 +0100
Message-Id: <20230220133603.537090925@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dom Cobley <popcornmix@gmail.com>

commit 247a631f9c0ffb37ed0786a94cb4c5f2b6fc7ab1 upstream.

The formula that determines the core clock requirement based on pixel
clock and blanking has been determined experimentally to minimise the
clock while supporting all modes we've seen.

A new reduced blanking mode (4kp60 at 533MHz rather than the standard
594MHz) has been seen that doesn't produce a high enough clock and
results in "flip_done timed out" error.

Increase the setup cost in the formula to make this work. The result is
a reduced blanking mode increases by up to 7MHz while leaving the
standard timing
mode untouched

Link: https://github.com/raspberrypi/linux/issues/4446
Fixes: 16e101051f32 ("drm/vc4: Increase the core clock based on HVS load")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127145558.446123-1-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -711,7 +711,7 @@ static int vc4_crtc_atomic_check(struct
 		struct vc4_encoder *vc4_encoder = to_vc4_encoder(encoder);
 
 		if (vc4_encoder->type == VC4_ENCODER_TYPE_HDMI0) {
-			vc4_state->hvs_load = max(mode->clock * mode->hdisplay / mode->htotal + 1000,
+			vc4_state->hvs_load = max(mode->clock * mode->hdisplay / mode->htotal + 8000,
 						  mode->clock * 9 / 10) * 1000;
 		} else {
 			vc4_state->hvs_load = mode->clock * 1000;


