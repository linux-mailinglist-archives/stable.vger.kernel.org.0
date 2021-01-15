Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EFB2F7B76
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbhAOMc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:32:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbhAOMcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851D423403;
        Fri, 15 Jan 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713901;
        bh=xLN9rYuyNDG9+P6Of6Xx9oVOeW5BxrDM7o0vEdrzRyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBT7a65ixGCIh00PwfpagpH4rX4DWBE7GWDdN66u7lESreSTPcvdhTS0O8X4lxYu2
         1qsvlRJTfSQF5NMbtwK96Yu1TXs6JVbMSm/XQDchYZBvHhNnFUSp1MMTYMPuwCvHRK
         a8qkk6AtLhmaA4JNzrYmA+A/e1EDpQIF62sRUD6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 21/28] block: rsxx: select CONFIG_CRC32
Date:   Fri, 15 Jan 2021 13:27:58 +0100
Message-Id: <20210115121957.810788328@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
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
@@ -477,6 +477,7 @@ config BLK_DEV_RBD
 config BLK_DEV_RSXX
 	tristate "IBM Flash Adapter 900GB Full Height PCIe Device Driver"
 	depends on PCI
+	select CRC32
 	help
 	  Device driver for IBM's high speed PCIe SSD
 	  storage device: Flash Adapter 900GB Full Height.


