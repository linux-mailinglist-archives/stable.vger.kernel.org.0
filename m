Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEBE72B62
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 11:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfGXJaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 05:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:32874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfGXJaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 05:30:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2EA120651;
        Wed, 24 Jul 2019 09:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563960613;
        bh=OLsO9KPj67EElynhoyp9rMfM4E4/2pZmSbjpsE4eraU=;
        h=Subject:To:From:Date:From;
        b=LOZ4BharS0ahBNacO8sT72AmZFnE7SC5THQ3KSbpwl+VpFjDHVDOMVN2HVWwsm5FF
         QO8c8XcQKEW1vQboGu3hMVKw7cbxjO/ObkUx07nXF3gYD/ZI8dRgi+cThj8QLJs9qb
         cIBEIXyXPjAzJJ7la7e5bafmXzgqXXZQ4AmLjN/o=
Subject: patch "fpga-manager: altera-ps-spi: Fix build error" added to char-misc-linus
To:     yuehaibing@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, mdf@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jul 2019 11:30:10 +0200
Message-ID: <1563960610105237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    fpga-manager: altera-ps-spi: Fix build error

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3d139703d397f6281368047ba7ad1c8bf95aa8ab Mon Sep 17 00:00:00 2001
From: YueHaibing <yuehaibing@huawei.com>
Date: Mon, 8 Jul 2019 15:13:56 +0800
Subject: fpga-manager: altera-ps-spi: Fix build error

If BITREVERSE is m and FPGA_MGR_ALTERA_PS_SPI is y,
build fails:

drivers/fpga/altera-ps-spi.o: In function `altera_ps_write':
altera-ps-spi.c:(.text+0x4ec): undefined reference to `byte_rev_table'

Select BITREVERSE to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: fcfe18f885f6 ("fpga-manager: altera-ps-spi: use bitrev8x4")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
Link: https://lore.kernel.org/r/20190708071356.50928-1-yuehaibing@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 474f304ec109..cdd4f73b4869 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -40,6 +40,7 @@ config ALTERA_PR_IP_CORE_PLAT
 config FPGA_MGR_ALTERA_PS_SPI
 	tristate "Altera FPGA Passive Serial over SPI"
 	depends on SPI
+	select BITREVERSE
 	help
 	  FPGA manager driver support for Altera Arria/Cyclone/Stratix
 	  using the passive serial interface over SPI.
-- 
2.22.0


