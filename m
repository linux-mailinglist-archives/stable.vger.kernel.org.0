Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE67615A68
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiKBDat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiKBDaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B6B264AD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F289E61729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99810C433D6;
        Wed,  2 Nov 2022 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359819;
        bh=p+gswbO3Cw1i0MlIrLMMH+EZYyIZf1zRCz15aYfaa4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RD2/zoqpwIz4LV+rTzKou7BELr9VHwR6DVQEDNTfXUWnKZpLDO5Fzaa/dWoeKFTCT
         w1IG3uT9uQmqLMYh8XPAcqC5WtvirJEECDcZXSVRknX9uQQopdmN2lMPi397bbEdxq
         5gpFHGNT6mdinYho8LEFIGXmIMyZyeBBQ2gy2Dys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 4.19 39/78] drm/msm/dsi: fix memory corruption with too many bridges
Date:   Wed,  2 Nov 2022 03:34:24 +0100
Message-Id: <20221102022054.137812051@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 2e786eb2f9cebb07e317226b60054df510b60c65 upstream.

Add the missing sanity check on the bridge counter to avoid corrupting
data beyond the fixed-sized bridge array in case there are ever more
than eight bridges.

Fixes: a689554ba6ed ("drm/msm: Initial add DSI connector support")
Cc: stable@vger.kernel.org	# 4.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/502668/
Link: https://lore.kernel.org/r/20220913085320.8577-4-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/dsi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -200,6 +200,12 @@ int msm_dsi_modeset_init(struct msm_dsi
 		return -EINVAL;
 
 	priv = dev->dev_private;
+
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	msm_dsi->dev = dev;
 
 	ret = msm_dsi_host_modeset_init(msm_dsi->host, dev);


