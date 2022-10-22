Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7B360861C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiJVHpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiJVHnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:43:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA2A5DF20;
        Sat, 22 Oct 2022 00:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC04B82DF7;
        Sat, 22 Oct 2022 07:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7BAC433C1;
        Sat, 22 Oct 2022 07:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424318;
        bh=gMan5kpbovKahV/1vwN9rBg7BvTH6IpSR+9l0CZ8VNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2s5TM+pXfRjAfdsEwq4m11jtx8PH+gHLg0ONSgLeD3Om70jr+hjc+I19AyjPSYaaq
         bL5Zdsyf+RQkst57yrY6diDlqhtvyLwISjPO5DFWjcN/oIIW7QNcWqqMqbQZ8MeHiN
         8YBeQSaz3iTMGOGMmgp4VDgQXZyhxCLWPuRZz0ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Takashi Iwai <tiwai@suse.de>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.19 071/717] drm/udl: Restore display mode on resume
Date:   Sat, 22 Oct 2022 09:19:10 +0200
Message-Id: <20221022072427.764692624@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 6d6e732835db92e66c28dbcf258a7e3d3c71420d upstream.

Restore the display mode whne resuming from suspend. Currently, the
display remains dark.

On resume, the CRTC's mode does not change, but the 'active' flag
changes to 'true'. Taking this into account when considering a mode
switch restores the display mode.

The bug is reproducable by using Gnome with udl and observing the
adapter's suspend/resume behavior.

Actually, the whole check added in udl_simple_display_pipe_enable()
about the crtc_state->mode_changed was bogus.  We should drop the
whole check and always apply the mode change in this function.

[ tiwai -- Drop the mode_changed check entirely instead, per Daniel's
  suggestion ]

Fixes: 997d33c35618 ("drm/udl: Inline DPMS code into CRTC enable and disable functions")
Cc: <stable@vger.kernel.org>
Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220908095115.23396-2-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/udl/udl_modeset.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/udl/udl_modeset.c
+++ b/drivers/gpu/drm/udl/udl_modeset.c
@@ -382,9 +382,6 @@ udl_simple_display_pipe_enable(struct dr
 
 	udl_handle_damage(fb, &shadow_plane_state->data[0], 0, 0, fb->width, fb->height);
 
-	if (!crtc_state->mode_changed)
-		return;
-
 	/* enable display */
 	udl_crtc_write_mode_to_hw(crtc);
 }


