Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB815947B7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242551AbiHOXRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiHOXOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104697C1A0;
        Mon, 15 Aug 2022 13:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0A5E6068D;
        Mon, 15 Aug 2022 20:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27E6C433C1;
        Mon, 15 Aug 2022 20:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593731;
        bh=c8TCoezreroQ22F4AADF+S+ZKsutgMUl6aGH1RvFDmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iyEEjTNi0GgDvcieeBOujnFAYyFhMMjP4ZELVWwiHypzf9Y+CKYljSX1fIO1YzQf
         E4aIc1pJ0f8a3KbsLDKK84bZkDtPiAiGLRw1EaH60QUgUXtZ2GYijBP2qqkjsLwoWp
         K+Fk7URAxYd9QvRXibwVmOqhQmm1fROMcwfrN7kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marek Vasut <marex@denx.de>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0308/1157] drm: bridge: DRM_FSL_LDB should depend on ARCH_MXC
Date:   Mon, 15 Aug 2022 19:54:24 +0200
Message-Id: <20220815180451.986008296@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a9ad5822366c5065e6a65fe5ff5090295ba98986 ]

The Freescale i.MX8MP LDB bridge is only present on Freescale i.MX8MP
SoCs.  Hence add a dependency on ARCH_MXC, to prevent asking the user
about this driver when configuring a kernel without i.MX SoC support.

Fixes: 463db5c2ed4aed01 ("drm: bridge: ldb: Implement simple Freescale i.MX8MP LDB bridge")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/449e08ca791a3ca308de5477c1bdc1f6eb1b34e7.1652104211.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 307b135da2f6..449b1b5a76ac 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -78,6 +78,7 @@ config DRM_DISPLAY_CONNECTOR
 config DRM_FSL_LDB
 	tristate "Freescale i.MX8MP LDB bridge"
 	depends on OF
+	depends on ARCH_MXC || COMPILE_TEST
 	select DRM_KMS_HELPER
 	select DRM_PANEL_BRIDGE
 	help
-- 
2.35.1



