Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C3A6CC32F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjC1Ov7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbjC1Ovq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:51:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82590DBD1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:51:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32DEDB80976
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96834C433D2;
        Tue, 28 Mar 2023 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015085;
        bh=jSUNIjL8GeyeDz0d1ATeTeuULRx6zQ5sbGxW0nJ5JMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=of2kEPUq9ucpTue6M5tq62Fg5NWBov4PMBntdjQQRf+ud+OtWogfjKDlbvckomTt1
         gca8ebpvqiiaZxWM2TW6DTpLyoJxtvCTsf8v0ZG21yigNUHCo6UARvgpihC7UG3MyN
         hcugVImTmUi9p2u/b+y0dcACivz0DZ3u292VFiQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexandr Sapozhnikov <alsp705@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 133/240] drm/cirrus: NULL-check pipe->plane.state->fb in cirrus_pipe_update()
Date:   Tue, 28 Mar 2023 16:41:36 +0200
Message-Id: <20230328142625.315219310@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandr Sapozhnikov <alsp705@gmail.com>

[ Upstream commit 7245e629dcaaf308f1868aeffa218e9849c77893 ]

After having been compared to NULL value at cirrus.c:455, pointer
'pipe->plane.state->fb' is passed as 1st parameter in call to function
'cirrus_fb_blit_rect' at cirrus.c:461, where it is dereferenced at
cirrus.c:316.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

v2:
	* aligned commit message to line-length limits

Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230215171549.16305-1-alsp705@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/cirrus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/cirrus.c b/drivers/gpu/drm/tiny/cirrus.c
index 678c2ef1cae70..ffa7e61dd1835 100644
--- a/drivers/gpu/drm/tiny/cirrus.c
+++ b/drivers/gpu/drm/tiny/cirrus.c
@@ -455,7 +455,7 @@ static void cirrus_pipe_update(struct drm_simple_display_pipe *pipe,
 	if (state->fb && cirrus->cpp != cirrus_cpp(state->fb))
 		cirrus_mode_set(cirrus, &crtc->mode, state->fb);
 
-	if (drm_atomic_helper_damage_merged(old_state, state, &rect))
+	if (state->fb && drm_atomic_helper_damage_merged(old_state, state, &rect))
 		cirrus_fb_blit_rect(state->fb, &shadow_plane_state->data[0], &rect);
 }
 
-- 
2.39.2



