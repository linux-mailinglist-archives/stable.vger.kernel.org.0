Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB034ABD2C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380492AbiBGLjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386260AbiBGLeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:34:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F0C043181;
        Mon,  7 Feb 2022 03:34:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC6C7B8102E;
        Mon,  7 Feb 2022 11:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3913C004E1;
        Mon,  7 Feb 2022 11:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233650;
        bh=sRT0SUtVKDDdJobDZ2zVLyItWfN68H3/PvgmN5nr8u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAQX48k1KpaRE1imS8OK63hG2Fs2FQgVHrj599ZYMUKQ3C8yDmTK6wE4atbM+D1AG
         tZP+JKGGGF+thWWS0TG56Z8yWbfSVSfZApLCIOV67+BcrChMvh56152mRD/4FCbJq3
         1+oEOdiQVX82SAz7sF2gNyuO8vsV6W0UiUW2vr3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH 5.16 078/126] drm: mxsfb: Fix NULL pointer dereference
Date:   Mon,  7 Feb 2022 12:06:49 +0100
Message-Id: <20220207103806.805730351@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 622c9a3a7868e1eeca39c55305ca3ebec4742b64 upstream.

mxsfb should not ever dereference the NULL pointer which
drm_atomic_get_new_bridge_state is allowed to return.
Assume a fixed format instead.

Fixes: b776b0f00f24 ("drm: mxsfb: Use bus_format from the nearest bridge if present")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220202081755.145716-3-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_kms.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -361,7 +361,11 @@ static void mxsfb_crtc_atomic_enable(str
 		bridge_state =
 			drm_atomic_get_new_bridge_state(state,
 							mxsfb->bridge);
-		bus_format = bridge_state->input_bus_cfg.format;
+		if (!bridge_state)
+			bus_format = MEDIA_BUS_FMT_FIXED;
+		else
+			bus_format = bridge_state->input_bus_cfg.format;
+
 		if (bus_format == MEDIA_BUS_FMT_FIXED) {
 			dev_warn_once(drm->dev,
 				      "Bridge does not provide bus format, assuming MEDIA_BUS_FMT_RGB888_1X24.\n"


