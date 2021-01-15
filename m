Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55D82F7A72
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbhAOMtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732459AbhAOMgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B56023884;
        Fri, 15 Jan 2021 12:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714143;
        bh=waAsZ4MKkYqNu+lCbaMvO1fKdOJNoyQJSMdZT95USng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hu5+qlb4ypcybBfxdnZSyJLuT37Gk9CxPsbhKDVo7lPHVkb0xCRrytLEU0U6cAvcX
         y1oOqKQO/U+ISOedxQIqMxdmS0eHTxwog2Atl0SUyXoou9MXKdmdvT9bQ/ENDXj89e
         ehhTdZrXRwZjP6tXSaBYz26iI72gVjBaGSKkvuQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 49/62] block: rsxx: select CONFIG_CRC32
Date:   Fri, 15 Jan 2021 13:28:11 +0100
Message-Id: <20210115122000.760483504@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 36a106a4c1c100d55ba3d32a21ef748cfcd4fa99 upstream.

Without crc32, the driver fails to link:

arm-linux-gnueabi-ld: drivers/block/rsxx/config.o: in function `rsxx_load_config':
config.c:(.text+0x124): undefined reference to `crc32_le'

Fixes: 8722ff8cdbfa ("block: IBM RamSan 70/80 device driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -461,6 +461,7 @@ config BLK_DEV_RBD
 config BLK_DEV_RSXX
 	tristate "IBM Flash Adapter 900GB Full Height PCIe Device Driver"
 	depends on PCI
+	select CRC32
 	help
 	  Device driver for IBM's high speed PCIe SSD
 	  storage device: Flash Adapter 900GB Full Height.


