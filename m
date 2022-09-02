Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A715AAFCB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbiIBMoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237397AbiIBMnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FE5EA338;
        Fri,  2 Sep 2022 05:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 093B9B82AA1;
        Fri,  2 Sep 2022 12:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A08CC433D7;
        Fri,  2 Sep 2022 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121915;
        bh=YYZqNvYH974mWYE0XTAzE/Kt7rGuXw0ZNZXMqgHHd+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5uHo9Bqhbp45IsRBaY2GVjkh2CoEc+1o/YyLCCU3prLYlF5rFIs9mGMn9aLwMxIT
         dbb00imKDr0/l7j1oZCrlhSvim7l0o418xXSbo2K3xYiLCh2j/10m1EmHH/beu8Hw4
         mSFfzH3j5O8XUx1QurRP/gi0pxMP14lZsiKxAlpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Maxime Ripard <maxime@cerno.tech>,
        "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.15 05/73] drm/vc4: hdmi: Depends on CONFIG_PM
Date:   Fri,  2 Sep 2022 14:18:29 +0200
Message-Id: <20220902121404.619894185@linuxfoundation.org>
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

commit 72e2329e7c9bbe15e7a813670497ec9c6f919af3 upstream.

We already depend on runtime PM to get the power domains and clocks for
most of the devices supported by the vc4 driver, so let's just select it
to make sure it's there.

Link: https://lore.kernel.org/r/20220629123510.1915022-38-maxime@cerno.tech
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
(cherry picked from commit f1bc386b319e93e56453ae27e9e83817bb1f6f95)
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Cc: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/Kconfig    |    1 +
 drivers/gpu/drm/vc4/vc4_hdmi.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/Kconfig
+++ b/drivers/gpu/drm/vc4/Kconfig
@@ -5,6 +5,7 @@ config DRM_VC4
 	depends on DRM
 	depends on SND && SND_SOC
 	depends on COMMON_CLK
+	depends on PM
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2122,7 +2122,7 @@ static int vc5_hdmi_init_resources(struc
 	return 0;
 }
 
-static int __maybe_unused vc4_hdmi_runtime_suspend(struct device *dev)
+static int vc4_hdmi_runtime_suspend(struct device *dev)
 {
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
 


