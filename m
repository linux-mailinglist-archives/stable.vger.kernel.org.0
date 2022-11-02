Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB6961582C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiKBCqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiKBCq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E616921241
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:46:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83ABE617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26916C433D6;
        Wed,  2 Nov 2022 02:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357187;
        bh=K1NkvBslfeRCCkEgZeuH/mC7y3nvYfH+KCxSoFvq0lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkSGGgOi3awrAfRjAVbar7hxSDZcIv0ChFhb9wFeM4wPbBKwTnr1lW0F4FFxaVEin
         htOFF1lbsxMF0ZSuB3oJpeV9Eg5LGeBMb9hGHjcKLXUu3YryWF/Qc1gI8ULgAhZ6Nk
         A/ivPreFip9CsUho62ZkGZv2T7cREkhixAam54TU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 120/240] media: sun6i-csi: Add a Kconfig dependency on RESET_CONTROLLER
Date:   Wed,  2 Nov 2022 03:31:35 +0100
Message-Id: <20221102022114.099414913@linuxfoundation.org>
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

[ Upstream commit 6a720df702db764e2b3bbdaaa217e9d344efcfb2 ]

The driver relies on the reset controller API to work, so add
RESET_CONTROLLER as one of its Kconfig dependencies.

Fixes: 5cc7522d8965 ("media: sun6i: Add support for Allwinner CSI V3s")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun6i-csi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/Kconfig b/drivers/media/platform/sunxi/sun6i-csi/Kconfig
index 0345901617d4..e5b6991ce7f0 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/Kconfig
+++ b/drivers/media/platform/sunxi/sun6i-csi/Kconfig
@@ -2,7 +2,7 @@
 config VIDEO_SUN6I_CSI
 	tristate "Allwinner V3s Camera Sensor Interface driver"
 	depends on V4L_PLATFORM_DRIVERS
-	depends on VIDEO_DEV && COMMON_CLK  && HAS_DMA
+	depends on VIDEO_DEV && COMMON_CLK && RESET_CONTROLLER && HAS_DMA
 	depends on ARCH_SUNXI || COMPILE_TEST
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.35.1



