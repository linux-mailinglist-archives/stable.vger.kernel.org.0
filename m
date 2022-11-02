Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAA461581E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiKBCpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiKBCpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:45:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD7320F6F
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DCA6601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14945C433C1;
        Wed,  2 Nov 2022 02:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357140;
        bh=l4t+YWaFDJ3YvxRDOssbbrv7f4zHdvbXQOL+NQ1GlSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjOcNDF92kR4mla8e+2xUmongWAig5ksqpEcdETKFJRXX/TE6F71/ygdJL9e2zpNN
         0lx3F9HxPBMEJy2wQojPYMqQ2I9AUOEB3Mo90IrzeoDnDPoms5aVf776RO09Qtdr3T
         tKOwVtvRpEskT0CJCAQahb2NN4L4/TprAcpWumq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        kernel test robot <lkp@intel.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 118/240] media: sun6i-mipi-csi2: Add a Kconfig dependency on RESET_CONTROLLER
Date:   Wed,  2 Nov 2022 03:31:33 +0100
Message-Id: <20221102022114.055013757@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit d0734dab5480325fd67548aa51ee126570d48574 ]

The driver relies on the reset controller API to work, so add
RESET_CONTROLLER as one of its Kconfig dependencies.

It also selects PHY_SUN6I_MIPI_DPHY, which depends on RESET_CONTROLLER.

Fixes: af54b4f4c17f ("media: sunxi: Add support for the A31 MIPI CSI-2 controller")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig b/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
index 4d072abdfb70..08852f63692b 100644
--- a/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
+++ b/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_SUN6I_MIPI_CSI2
 	tristate "Allwinner A31 MIPI CSI-2 Controller Driver"
 	depends on V4L_PLATFORM_DRIVERS && VIDEO_DEV
 	depends on ARCH_SUNXI || COMPILE_TEST
-	depends on PM && COMMON_CLK
+	depends on PM && COMMON_CLK && RESET_CONTROLLER
 	depends on PHY_SUN6I_MIPI_DPHY
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.35.1



