Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B206AF08D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjCGSb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjCGSbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:31:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CE790B68
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:24:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8574261550
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721F3C433EF;
        Tue,  7 Mar 2023 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213457;
        bh=GsLA4w0BvTbWxC+Ki2Sv7W4m/dgFu9wCanHWZ42ARVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hq7+5byuiWht2U6AsyNRxzXx4OK114O3nLE3y0f5sLtu71ZRquwZgawUDKHSktQgE
         Foan2SlsJB6PqD6B7E2lZRkkx2WqgyrdESFX3+KHJS63V7X5Jvl7/uvbZvl4++9aHW
         4EjF90gn0MbyaFDzjpWrBbmmJHP29LzWmleCONHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 513/885] media: platform: mtk-mdp3: fix Kconfig dependencies
Date:   Tue,  7 Mar 2023 17:57:27 +0100
Message-Id: <20230307170024.769304998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e3f7feb6d89311f369dd4ad903ea62e45328cdbe ]

The new mdp3 driver uses 'select' to force-enable a couple of drivers
it depends on. This is error-prone and likely to cause dependency
loops as well as warnings like:

WARNING: unmet direct dependencies detected for VIDEO_MEDIATEK_VPU
  Depends on [n]: MEDIA_SUPPORT [=m] && MEDIA_PLATFORM_SUPPORT [=y] && MEDIA_PLATFORM_DRIVERS [=y] && V4L_MEM2MEM_DRIVERS [=n] && VIDEO_DEV [=m] && (ARCH_MEDIATEK [=y] || COMPILE_TEST [=y])
  Selected by [m]:
  - VIDEO_MEDIATEK_MDP3 [=m] && MEDIA_SUPPORT [=m] && MEDIA_PLATFORM_SUPPORT [=y] && MEDIA_PLATFORM_DRIVERS [=y] && (MTK_IOMMU [=m] || COMPILE_TEST [=y]) && VIDEO_DEV [=m] && (ARCH_MEDIATEK [=y] || COMPILE_TEST [=y]) && HAS_DMA [=y] && REMOTEPROC [=y]

This specific warning was already addressed in a previous patch,
but there are similar unnecessary 'select' statements, so turn those
into 'depends on'. This also means the dependency on ARCH_MEDIATEK
is redundant and can be dropped.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Fixes: 9195a860ef0a ("media: platform: mtk-mdp3: remove unused VIDEO_MEDIATEK_VPU config")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/Kconfig | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp3/Kconfig b/drivers/media/platform/mediatek/mdp3/Kconfig
index 846e759a8f6a9..602329c447501 100644
--- a/drivers/media/platform/mediatek/mdp3/Kconfig
+++ b/drivers/media/platform/mediatek/mdp3/Kconfig
@@ -3,14 +3,13 @@ config VIDEO_MEDIATEK_MDP3
 	tristate "MediaTek MDP v3 driver"
 	depends on MTK_IOMMU || COMPILE_TEST
 	depends on VIDEO_DEV
-	depends on ARCH_MEDIATEK || COMPILE_TEST
 	depends on HAS_DMA
 	depends on REMOTEPROC
+	depends on MTK_MMSYS
+	depends on MTK_CMDQ
+	depends on MTK_SCP
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	select MTK_MMSYS
-	select MTK_CMDQ
-	select MTK_SCP
 	default n
 	help
 	    It is a v4l2 driver and present in MediaTek MT8183 SoC.
-- 
2.39.2



