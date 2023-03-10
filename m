Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DBF6B40DF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCJNrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjCJNrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:47:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C3428E65
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:46:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A100B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3EBC433EF;
        Fri, 10 Mar 2023 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456017;
        bh=PnFPcGnSqGG/kE3uz3cio9R00rJwc4VZbUG+/gwUNss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDWrelTdkeyhgYh7z0zlTuJBEiHf37M5SO9ijtGraBnCZ9PWmSuySvsKeoiP4DheU
         GtMEPgS5o/yfqzkDQcIiOyabNfE6VqT/UWDFVR3ywRHpMertADkxZSVslDIcptiE0u
         P4IIw8RBnNgiVnB9utMhE1QUnMoepym/ZZjgIylE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marek Vasut <marex@denx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/193] drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC
Date:   Fri, 10 Mar 2023 14:37:14 +0100
Message-Id: <20230310133712.732911632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7783cc67862f9166c901bfa0f80b717aa8d354dd ]

Freescale/NXP i.MX LCDIF and eLCDIF LCD controllers are only present on
Freescale/NXP i.MX SoCs.  Hence add a dependency on ARCH_MXS ||
ARCH_MXC, to prevent asking the user about this driver when configuring
a kernel without Freescale/NXP i.MX support.

Fixes: 45d59d704080cc0c ("drm: Add new driver for MXSFB controller")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/98e74779ca2bc575d91afff03369e86b080c01ac.1669046358.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index 3ed6849d63cba..1a2805c7a0eb7 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -7,6 +7,7 @@ config DRM_MXSFB
 	tristate "i.MX23/i.MX28/i.MX6SX MXSFB LCD controller"
 	depends on DRM && OF
 	depends on COMMON_CLK
+	depends on ARCH_MXS || ARCH_MXC || COMPILE_TEST
 	select DRM_MXS
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
-- 
2.39.2



