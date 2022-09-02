Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2885AAFC6
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbiIBMoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbiIBMmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FC9DD765;
        Fri,  2 Sep 2022 05:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3F25621B1;
        Fri,  2 Sep 2022 12:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D72C433D6;
        Fri,  2 Sep 2022 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121912;
        bh=xSCL2GfrESDYTSmLQBmuhprtKU9fxNc2EuGxf2rpy8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqPqjwQAyLdJF+rN9a/G5WnHaKBf77GGpNOlpbcYNZE6tZQVS+9GDmNnZzIkfI8D8
         6u4frMmyxp8aWXvkHzXOBLphgMrkEbT/7tr1f7tIVLXZ/JHbRIrztPzDheetLT3OGK
         m6lqHYC05Icco4cDl34micd4XOiCczDJJ8jIOJFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Maxime Ripard <maxime@cerno.tech>,
        "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.15 04/73] drm/vc4: hdmi: Rework power up
Date:   Fri,  2 Sep 2022 14:18:28 +0200
Message-Id: <20220902121404.592194557@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

commit 258e483a4d5e97a6a8caa74381ddc1f395ac1c71 upstream.

The current code tries to handle the case where CONFIG_PM isn't selected
by first calling our runtime_resume implementation and then properly
report the power state to the runtime_pm core.

This allows to have a functionning device even if pm_runtime_get_*
functions are nops.

However, the device power state if CONFIG_PM is enabled is
RPM_SUSPENDED, and thus our vc4_hdmi_write() and vc4_hdmi_read() calls
in the runtime_pm hooks will now report a warning since the device might
not be properly powered.

Even more so, we need CONFIG_PM enabled since the previous RaspberryPi
have a power domain that needs to be powered up for the HDMI controller
to be usable.

The previous patch has created a dependency on CONFIG_PM, now we can
just assume it's there and only call pm_runtime_resume_and_get() to make
sure our device is powered in bind.

Link: https://lore.kernel.org/r/20220629123510.1915022-39-maxime@cerno.tech
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
(cherry picked from commit 53565c28e6af2cef6bbf438c34250135e3564459)
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Cc: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2219,17 +2219,15 @@ static int vc4_hdmi_bind(struct device *
 	if (ret)
 		goto err_put_ddc;
 
+	pm_runtime_enable(dev);
+
 	/*
-	 * We need to have the device powered up at this point to call
-	 * our reset hook and for the CEC init.
+	 *  We need to have the device powered up at this point to call
+	 *  our reset hook and for the CEC init.
 	 */
-	ret = vc4_hdmi_runtime_resume(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret)
-		goto err_put_ddc;
-
-	pm_runtime_get_noresume(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+		goto err_disable_runtime_pm;
 
 	if (vc4_hdmi->variant->reset)
 		vc4_hdmi->variant->reset(vc4_hdmi);
@@ -2278,6 +2276,7 @@ err_destroy_conn:
 err_destroy_encoder:
 	drm_encoder_cleanup(encoder);
 	pm_runtime_put_sync(dev);
+err_disable_runtime_pm:
 	pm_runtime_disable(dev);
 err_put_ddc:
 	put_device(&vc4_hdmi->ddc->dev);


