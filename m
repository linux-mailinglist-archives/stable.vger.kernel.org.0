Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7272124769C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404181AbgHQTjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729757AbgHQP0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B481E23A69;
        Mon, 17 Aug 2020 15:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677966;
        bh=ZYPj2n3jUoY+wTP3dDHarfWLSbwuShn8ynurOvqVWv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=syh2bieLBy6o38vHlAXzmDDHRwVV1nG2npqNnzJ+cdEwu0pSi3Nknc0tR4G3HxAYz
         FRF5PtXbGyuE7JkRmIQbejWvwanDo4rRpFFw8bNnJq15oK34COsnYab1xH7Cfm2Apa
         I8/MCDu1PBnTgMGgELdWIhHZ9jxhjk8Q2/W/jbAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 172/464] media: cxusb-analog: fix V4L2 dependency
Date:   Mon, 17 Aug 2020 17:12:05 +0200
Message-Id: <20200817143842.057548641@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1a55caf010c46d4f2073f9e92e97ef65358c16bf ]

CONFIG_DVB_USB_CXUSB_ANALOG is a 'bool' symbol with a dependency on the
tristate CONFIG_VIDEO_V4L2, which means it can be enabled as =y even
when its dependency is =m. This leads to a link failure:

drivers/media/usb/dvb-usb/cxusb-analog.o: In function `cxusb_medion_analog_init':
cxusb-analog.c:(.text+0x92): undefined reference to `v4l2_subdev_call_wrappers'
drivers/media/usb/dvb-usb/cxusb-analog.o: In function `cxusb_medion_register_analog':
cxusb-analog.c:(.text+0x466): undefined reference to `v4l2_device_register'
cxusb-analog.c:(.text+0x4c3): undefined reference to `v4l2_i2c_new_subdev'
cxusb-analog.c:(.text+0x4fb): undefined reference to `v4l2_subdev_call_wrappers'
...

Change the dependency only disallow the analog portion of the driver
in that configuration.

Fixes: e478d4054054 ("media: cxusb: add analog mode support for Medion MD95700")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 15d29c91662f3..25ba03edcb5c6 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -151,6 +151,7 @@ config DVB_USB_CXUSB
 config DVB_USB_CXUSB_ANALOG
 	bool "Analog support for the Conexant USB2.0 hybrid reference design"
 	depends on DVB_USB_CXUSB && VIDEO_V4L2
+	depends on VIDEO_V4L2=y || VIDEO_V4L2=DVB_USB_CXUSB
 	select VIDEO_CX25840
 	select VIDEOBUF2_VMALLOC
 	help
-- 
2.25.1



