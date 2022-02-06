Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2EE4AAF3A
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbiBFMqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:46:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3240AC06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:46:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C30B560F79
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B082C340E9;
        Sun,  6 Feb 2022 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644151582;
        bh=A6Oark0LKC+f7KTPEXURPk8+oVkcm6gJlEBueukWe0Y=;
        h=Subject:To:Cc:From:Date:From;
        b=yeL39WFOHc8lTKuhJ5Aql1UE8zE76u9uUHgHA1eRKDuBI2wqTX7Lg5UMhhWuqdbcF
         e+JU/x0eumNEZMmW+6QyB/txdF0rUI1jg8daAOxCc7V7qj2w6a95x4Xl+WDJqd6iHZ
         vCck7V9fqsIiH6XPwwx8WDf4z7fl+/l1mPpb6u80=
Subject: FAILED: patch "[PATCH] drm: mxsfb: Fix NULL pointer dereference" failed to apply to 5.15-stable tree
To:     alexander.stein@ew.tq-group.com, marex@denx.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:46:19 +0100
Message-ID: <1644151579070@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 622c9a3a7868e1eeca39c55305ca3ebec4742b64 Mon Sep 17 00:00:00 2001
From: Alexander Stein <alexander.stein@ew.tq-group.com>
Date: Wed, 2 Feb 2022 09:17:55 +0100
Subject: [PATCH] drm: mxsfb: Fix NULL pointer dereference

mxsfb should not ever dereference the NULL pointer which
drm_atomic_get_new_bridge_state is allowed to return.
Assume a fixed format instead.

Fixes: b776b0f00f24 ("drm: mxsfb: Use bus_format from the nearest bridge if present")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220202081755.145716-3-alexander.stein@ew.tq-group.com

diff --git a/drivers/gpu/drm/mxsfb/mxsfb_kms.c b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
index 0655582ae8ed..4cfb6c001679 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -361,7 +361,11 @@ static void mxsfb_crtc_atomic_enable(struct drm_crtc *crtc,
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

