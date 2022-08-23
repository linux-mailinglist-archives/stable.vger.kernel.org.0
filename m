Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A5659D4E1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242425AbiHWJGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347967AbiHWJFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:05:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E52385ABB;
        Tue, 23 Aug 2022 01:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B99E6148F;
        Tue, 23 Aug 2022 08:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45250C433D6;
        Tue, 23 Aug 2022 08:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243325;
        bh=mfXabLGDY9gETB+b3ZUJCxSsB/UQoJhhDwkWQHOl0eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMb7UOJgHW5hnszlSjkSP1gty1Mu0OL2TtrHmA4xRi/qM6iGoq8X8/KwpSXL2Gz9V
         7JTkDbU94yQ+HzHTtBEz8vSkLzJ5APqeWASm21KXS4l/lJNn2mY21ThWDJsmq6Mi62
         QlH5eShxHLdbmi9UxxHwe6LSYYZ5nCGKOac0hHUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 242/365] drm/imx/dcss: get rid of HPD warning message
Date:   Tue, 23 Aug 2022 10:02:23 +0200
Message-Id: <20220823080128.356688743@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>

[ Upstream commit 30bdc36b8c776cd4fce5de2a96ff28b37f96942f ]

When DCSS + MIPI_DSI is used, and the last bridge in the chain supports
HPD, we can see a "Hot plug detection already enabled" warning stack
trace dump that's thrown when DCSS is initialized.

The problem appeared when HPD was enabled by default in the
bridge_connector initialization, which made the
drm_bridge_connector_enable_hpd() call, in DCSS init path, redundant.
So, let's remove that call.

Fixes: 09077bc311658 ("drm/bridge_connector: enable HPD by default if supported")
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220721120912.6639-1-laurentiu.palcu@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dcss/dcss-kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/dcss/dcss-kms.c b/drivers/gpu/drm/imx/dcss/dcss-kms.c
index 9b84df34a6a1..8cf3352d8858 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-kms.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-kms.c
@@ -142,8 +142,6 @@ struct dcss_kms_dev *dcss_kms_attach(struct dcss_dev *dcss)
 
 	drm_kms_helper_poll_init(drm);
 
-	drm_bridge_connector_enable_hpd(kms->connector);
-
 	ret = drm_dev_register(drm, 0);
 	if (ret)
 		goto cleanup_crtc;
-- 
2.35.1



