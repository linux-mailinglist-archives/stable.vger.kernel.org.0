Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AD959DEAF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352877AbiHWKJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352857AbiHWKGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F56863EF;
        Tue, 23 Aug 2022 01:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED960611DD;
        Tue, 23 Aug 2022 08:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67BEC433D7;
        Tue, 23 Aug 2022 08:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244800;
        bh=mfXabLGDY9gETB+b3ZUJCxSsB/UQoJhhDwkWQHOl0eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4vHnKrqr3HBCucTvpgRYOsETuwctNneXlzZ4BIhsB6SeIcUUXD1J2jjqgCYgBshZ
         B2bAHaLE6zccAG0AZMIwwKKVPXEBMzTIk76Rr6ejnXwYMJObjjEWoqtywLVvNSuMNT
         r9s6zkLqd5zPlWXlz0VbYkqOKTWtvXFjzFI/K/fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/244] drm/imx/dcss: get rid of HPD warning message
Date:   Tue, 23 Aug 2022 10:25:13 +0200
Message-Id: <20220823080104.340461036@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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



