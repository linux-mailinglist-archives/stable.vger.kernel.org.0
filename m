Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80E4594432
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244686AbiHOWUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350790AbiHOWSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6372865647;
        Mon, 15 Aug 2022 12:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3E9661089;
        Mon, 15 Aug 2022 19:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB87FC433D6;
        Mon, 15 Aug 2022 19:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592507;
        bh=R0wrMkXbfeQsqAlW1Rt+DoojY5n/s25qlPySHwrEnvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1vULcDZoBL3t7zzSpIVTZ99DYTsMaoEGg//xophnsMoEH2Su2uzJNpBQD948Vr5i
         Q/2SlkgSEIikv3YIbwHYNkC9Gb9/++k79FREok4xpub0wmmKBfiBq8pOGNd0o9dIz2
         hFTg8AZ81hUGk+90glt2DrqtTrU73yO/c2BI6nf0=
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
Subject: [PATCH 5.19 0122/1157] media: isl7998x: select V4L2_FWNODE to fix build error
Date:   Mon, 15 Aug 2022 19:51:18 +0200
Message-Id: <20220815180444.489804539@linuxfoundation.org>
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
 drivers/media/i2c/Kconfig |    1 +
 1 file changed, 1 insertion(+)

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


