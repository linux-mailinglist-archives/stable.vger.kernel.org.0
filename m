Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440FB5AB186
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbiIBNgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237164AbiIBNfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48E72B273;
        Fri,  2 Sep 2022 06:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 436C8621D6;
        Fri,  2 Sep 2022 12:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4169CC433D7;
        Fri,  2 Sep 2022 12:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122087;
        bh=Tkld2hdUhq4Rk9Ykapn2qM+q61m0Rq78GrQiEInBD68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SY5pNXNMoT93dqK98Pw7wywaYCPIctvJXDAyw8bYLzJ9MjR2zPrKVlk0wRvjK/Un6
         WYiri5yENeZnAX8tMCFsWbmRlUjtd/rqp07Ot+ebpxVMiZB3EFSLE8lz28RTdXKC1Q
         6vZXY9hhaYAdrlSGVja9CmkslQKQli6stp6pHIlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Maxime Ripard <maxime@cerno.tech>,
        "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.19 01/72] drm/vc4: hdmi: Rework power up
Date:   Fri,  2 Sep 2022 14:18:37 +0200
Message-Id: <20220902121404.816237715@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -2992,17 +2992,15 @@ static int vc4_hdmi_bind(struct device *
 			vc4_hdmi->disable_4kp60 = true;
 	}
 
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
 
 	if ((of_device_is_compatible(dev->of_node, "brcm,bcm2711-hdmi0") ||
 	     of_device_is_compatible(dev->of_node, "brcm,bcm2711-hdmi1")) &&
@@ -3048,6 +3046,7 @@ err_destroy_conn:
 err_destroy_encoder:
 	drm_encoder_cleanup(encoder);
 	pm_runtime_put_sync(dev);
+err_disable_runtime_pm:
 	pm_runtime_disable(dev);
 err_put_ddc:
 	put_device(&vc4_hdmi->ddc->dev);


