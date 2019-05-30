Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C862F20F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbfE3ESI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbfE3DPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:36 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACF3024559;
        Thu, 30 May 2019 03:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186135;
        bh=VXQLeDfoSz4hky/VbJ78p/pF58lpzAFNQGeTBEj+as0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlJFrOpZCJ7cb3pnMSOMBsexeQs8n5xZ+mCu40YdHe/qlGRuR3yDtB4vEWr0Y550a
         dpsyfHWPGB84cWUyX/SmkBs/Td64kqiG5jT44SMS9ywYG6qlfxTVjpTKU1kH5RAdbT
         ipKw2XczCxVjDwni/Cyq0RScwLg1g1N7PMcXeCyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 301/346] media: staging: davinci_vpfe: disallow building with COMPILE_TEST
Date:   Wed, 29 May 2019 20:06:14 -0700
Message-Id: <20190530030556.097103521@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 49dc762cffd8305a861ca649e82dc5533b3e3344 ]

The driver should really call dm365_isif_setup_pinmux() through a callback,
but uses a hack to include a davinci specific machine header file when
compile testing instead. This works almost everywhere, but not on the
ARM omap1 platform, which has another header named mach/mux.h. This
causes a build failure:

drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: implicit declaration of function 'davinci_cfg_reg' [-Werror,-Wimplicit-function-declaration]
        davinci_cfg_reg(DM365_VIN_CAM_WEN);
        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: this function declaration is not a prototype [-Werror,-Wstrict-prototypes]
drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:18: error: use of undeclared identifier 'DM365_VIN_CAM_WEN'
        davinci_cfg_reg(DM365_VIN_CAM_WEN);
                        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2029:18: error: use of undeclared identifier 'DM365_VIN_CAM_VD'
        davinci_cfg_reg(DM365_VIN_CAM_VD);
                        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2030:18: error: use of undeclared identifier 'DM365_VIN_CAM_HD'
        davinci_cfg_reg(DM365_VIN_CAM_HD);
                        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2031:18: error: use of undeclared identifier 'DM365_VIN_YIN4_7_EN'
        davinci_cfg_reg(DM365_VIN_YIN4_7_EN);
                        ^
drivers/staging/media/davinci_vpfe/dm365_isif.c:2032:18: error: use of undeclared identifier 'DM365_VIN_YIN0_3_EN'
        davinci_cfg_reg(DM365_VIN_YIN0_3_EN);
                        ^
7 errors generated.

Exclude omap1 from compile-testing, under the assumption that all others
still work.

Fixes: 4907c73deefe ("media: staging: davinci_vpfe: allow building with COMPILE_TEST")

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/davinci_vpfe/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index aea449a8dbf8a..76818cc48ddcb 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
 	depends on VIDEO_V4L2
-	depends on (ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF) || COMPILE_TEST
+	depends on (ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF) || (COMPILE_TEST && !ARCH_OMAP1)
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on VIDEO_DAVINCI_VPBE_DISPLAY
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.20.1



