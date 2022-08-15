Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65254593D97
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbiHOURA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346689AbiHOUQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:16:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1584A80A;
        Mon, 15 Aug 2022 11:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DF72B8109E;
        Mon, 15 Aug 2022 18:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E74C433C1;
        Mon, 15 Aug 2022 18:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589979;
        bh=OGvH2oC8IkGBDkmF6vOdjgA5GjQ+KpwMMXs63Zo55zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02ZOSK1bmrmub7g6Z9o/enHFCEpmH31OG5ZM+iU+WCq4i7hEYnL56Qcxck9TgR7rz
         HOJsNrEI8qKWkQVPr3JPV9pPFs/bLJ8Ocq27PPU+NPGBnAz1ElmUH+kcrN2LwrUN6U
         pt6H9AJujVu3uuSwdtxiN+31F9uqzfBoi0kcDkO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Marek Vasut <marex@denx.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.18 0112/1095] media: isl7998x: select V4L2_FWNODE to fix build error
Date:   Mon, 15 Aug 2022 19:51:51 +0200
Message-Id: <20220815180434.217644852@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

commit 81e005842d0b8167c059553a1c29c36d8a7a9329 upstream.

Fix build error when VIDEO_ISL7998X=y and V4L2_FWNODE=m
by selecting V4L2_FWNODE.

microblaze-linux-ld: drivers/media/i2c/isl7998x.o: in function `isl7998x_probe':
(.text+0x8f4): undefined reference to `v4l2_fwnode_endpoint_parse'

Cc: stable@vger.kernel.org # 5.18 and above
Fixes: 51ef2be546e2 ("media: i2c: isl7998x: Add driver for Intersil ISL7998x")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 2b20aa6c37b1..c926e5d43820 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1178,6 +1178,7 @@ config VIDEO_ISL7998X
 	depends on OF_GPIO
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
+	select V4L2_FWNODE
 	help
 	  Support for Intersil ISL7998x analog to MIPI-CSI2 or
 	  BT.656 decoder.
-- 
2.37.1



