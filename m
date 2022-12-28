Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E12658131
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiL1QZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiL1QYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FD21A078
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44D2961576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57867C433EF;
        Wed, 28 Dec 2022 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244539;
        bh=UGrJQkGLYnITeM1Zh1Zc8PyDtNFRBhOBeZLvoF7bcVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNFgfrzhD2w21TXBcSpc8odySsLcDENEIg3rVF7JctDHOSldXDMZXUiS2AYLc6z5k
         xgsbrOGsBsH5yDIy8RC2+STXZJJ/A4RT4eyR6lMiM1/bzB7NeAqv5qXPaC7Hj2T3yL
         9+oT8q+L6ezC9pjN54PhnS+2tkI4JF/9mkxVyMYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0729/1073] fbdev: ssd1307fb: Drop optional dependency
Date:   Wed, 28 Dec 2022 15:38:37 +0100
Message-Id: <20221228144347.824351003@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 025e3b507a3a8e1ee96a3112bb67495c77d6cdb6 ]

Only a single out of three devices need a PWM, so from driver it's
optional. Moreover it's a single driver in the entire kernel that
currently selects PWM. Unfortunately this selection is a root cause
of the circular dependencies when we want to enable optional PWM
for some other drivers that select GPIOLIB.

Fixes: a2ed00da5047 ("drivers/video: add support for the Solomon SSD1307 OLED Controller")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index cfc55273dc5d..9497fe929162 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2217,7 +2217,6 @@ config FB_SSD1307
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
 	select FB_DEFERRED_IO
-	select PWM
 	select FB_BACKLIGHT
 	help
 	  This driver implements support for the Solomon SSD1307
-- 
2.35.1



