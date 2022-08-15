Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F92359471F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiHOXRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353515AbiHOXQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CE8AF484;
        Mon, 15 Aug 2022 13:03:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 314FAB80EA8;
        Mon, 15 Aug 2022 20:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9191DC433D6;
        Mon, 15 Aug 2022 20:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593805;
        bh=pQKLs5HCEFvdf9V0RQd4XUTM1KsvjMxn9EJ5z3G4Ec4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXiyYYI2kypqTSCY+G5ypnYWemnp/Q4u9sxY6q2UmuWFuuNWZQr8+obgKAgUt/ZnH
         F3dfvI6ILi/baBl0GCSNQkhmiCyUCezYKzFiok+H36e2pJyMnAbb11A0jCDIRYVDYr
         AZ8AynbbS+7TCnmk8qyr/7eCoUviqAWiqRCH2r0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0328/1157] drm/ssd130x: Only define a SPI device ID table when built as a module
Date:   Mon, 15 Aug 2022 19:54:44 +0200
Message-Id: <20220815180452.777804739@linuxfoundation.org>
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

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 01ece65132e2980ece4eca91105dfc9eed504881 ]

The kernel test robot reports a compile warning due the ssd130x_spi_table
variable being defined but not used. This happen when ssd130x-spi driver
is built-in instead of being built as a module, i.e:

  CC      drivers/gpu/drm/solomon/ssd130x-spi.o
  AR      drivers/base/firmware_loader/built-in.a
  AR      drivers/base/built-in.a
  CC      kernel/trace/trace.o
drivers/gpu/drm/solomon/ssd130x-spi.c:155:35: warning: ‘ssd130x_spi_table’ defined but not used [-Wunused-const-variable=]
  155 | static const struct spi_device_id ssd130x_spi_table[] = {
      |                                   ^~~~~~~~~~~~~~~~~

The driver shouldn't need a SPI device ID table and only have an OF device
ID table, but the former is needed to workaround an issue in the SPI core.
This always reports a MODALIAS of the form "spi:<device>" even for devices
registered through Device Trees.

But the table is only needed when the driver built as a module to populate
the .ko alias info. It's not needed when the driver is built-in the kernel.

Fixes: 74373977d2ca ("drm/solomon: Add SSD130x OLED displays SPI support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220530140246.742469-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x-spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/solomon/ssd130x-spi.c b/drivers/gpu/drm/solomon/ssd130x-spi.c
index 43722adab1f8..07802907e39a 100644
--- a/drivers/gpu/drm/solomon/ssd130x-spi.c
+++ b/drivers/gpu/drm/solomon/ssd130x-spi.c
@@ -143,6 +143,7 @@ static const struct of_device_id ssd130x_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ssd130x_of_match);
 
+#if IS_MODULE(CONFIG_DRM_SSD130X_SPI)
 /*
  * The SPI core always reports a MODALIAS uevent of the form "spi:<dev>", even
  * if the device was registered via OF. This means that the module will not be
@@ -160,6 +161,7 @@ static const struct spi_device_id ssd130x_spi_table[] = {
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(spi, ssd130x_spi_table);
+#endif
 
 static struct spi_driver ssd130x_spi_driver = {
 	.driver = {
-- 
2.35.1



