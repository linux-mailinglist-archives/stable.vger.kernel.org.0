Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97BC549368
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357706AbiFMMGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358744AbiFMMEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:04:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4A750032;
        Mon, 13 Jun 2022 03:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A49A261346;
        Mon, 13 Jun 2022 10:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E00C341C5;
        Mon, 13 Jun 2022 10:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117871;
        bh=2MiGSPVt5iRNA+MRCvEt8ZV/VW9I8RfZ6xa1RC7f6sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqfVkHhdzUDnp33pTMVLRxNbLej5DJ8az3twn3UkEXIy2JZRmxAZ9xQ1xvsRAnEq7
         KzjDfHlbwvK+63LAWYcoQaczZf42U4AAgzBHqBZdM7sVSimj2Qt3q1SREW0fcZx1M7
         9wfmHOxh5HGjUB9VLewYFAjA7e3YyeskvQZ7Nopw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Brian Norris <briannorris@chromium.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 4.19 162/287] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
Date:   Mon, 13 Jun 2022 12:09:46 +0200
Message-Id: <20220613094928.790591935@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

commit 8fb6c44fe8468f92ac7b8bbfcca4404a4e88645f upstream.

If the display is not enable()d, then we aren't holding a runtime PM
reference here. Thus, it's easy to accidentally cause a hang, if user
space is poking around at /dev/drm_dp_aux0 at the "wrong" time.

Let's get a runtime PM reference, and check that we "see" the panel.
Don't force any panel power-up, etc., because that can be intrusive, and
that's not what other drivers do (see
drivers/gpu/drm/bridge/ti-sn65dsi86.c and
drivers/gpu/drm/bridge/parade-ps8640.c.)

Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
Cc: <stable@vger.kernel.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220301181107.v4.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1514,8 +1514,19 @@ static ssize_t analogix_dpaux_transfer(s
 				       struct drm_dp_aux_msg *msg)
 {
 	struct analogix_dp_device *dp = to_dp(aux);
+	int ret;
 
-	return analogix_dp_transfer(dp, msg);
+	pm_runtime_get_sync(dp->dev);
+
+	ret = analogix_dp_detect_hpd(dp);
+	if (ret)
+		goto out;
+
+	ret = analogix_dp_transfer(dp, msg);
+out:
+	pm_runtime_put(dp->dev);
+
+	return ret;
 }
 
 struct analogix_dp_device *


