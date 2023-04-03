Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CCE6D4800
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbjDCOZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjDCOY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:24:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F86F2705
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A29761D89
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C324C433EF;
        Mon,  3 Apr 2023 14:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531894;
        bh=GRx8OFCj/oyLdpI+5+BeYoXvKPFeo0FAVL5ApPEYPEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOLz6pw4HZcpBuCQORqZZW04Q3bRMSEPRmR/TdbCsfO+v6XgrZNr0KhL7obsToe65
         WdP72f6Hewgw7f5kJMnYQzn4RV2hcQ65puu+r8I6Ad+g5SuCn4hbvssEm4g03mln3g
         W462tiJw/74zFSPqcSjqfUHVvI4mM4YXGQ/wd0UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxime Ripard <mripard@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/173] drm/sun4i: fix missing component unbind on bind errors
Date:   Mon,  3 Apr 2023 16:07:12 +0200
Message-Id: <20230403140414.861280918@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit c22f2ff8724b49dce2ae797e9fbf4bc0fa91112f ]

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Cc: stable@vger.kernel.org      # 4.7
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230306103242.4775-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index c5912fd537729..9c6ae8cfa0b2c 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -93,7 +93,7 @@ static int sun4i_drv_bind(struct device *dev)
 	/* drm_vblank_init calls kcalloc, which can fail */
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	drm->irq_enabled = true;
 
@@ -117,6 +117,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);
-- 
2.39.2



