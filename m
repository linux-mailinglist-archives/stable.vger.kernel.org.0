Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191552A9966
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgKFQYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgKFQYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 11:24:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2032151B;
        Fri,  6 Nov 2020 16:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604679855;
        bh=J9VikEZ6Ix9TXTiNa7zJuDjUczwql0c/XfgHyBtrcoo=;
        h=Subject:To:From:Date:From;
        b=JqYpFSXZVEOi5bTvSwcZLSUygw+rAiCn7qnL73EmhQMG8yqKMQGVFSYRSzfGR9YBY
         sGpkWsFIogQwZ2gvcthJ7mZJvMqqrw+TGYTnShV3+sprbjcEW7cWjXI/Y4DlJGz3vo
         nfzQj9rlYrnTaIqAjsOkT2tW6E9RTAeIXTnv6YXw=
Subject: patch "serial: txx9: add missing platform_driver_unregister() on error in" added to tty-linus
To:     miaoqinglang@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 Nov 2020 17:25:02 +0100
Message-ID: <16046799024730@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: txx9: add missing platform_driver_unregister() on error in

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0c5fc92622ed5531ff324b20f014e9e3092f0187 Mon Sep 17 00:00:00 2001
From: Qinglang Miao <miaoqinglang@huawei.com>
Date: Tue, 3 Nov 2020 16:49:42 +0800
Subject: serial: txx9: add missing platform_driver_unregister() on error in
 serial_txx9_init

Add the missing platform_driver_unregister() before return
from serial_txx9_init in the error handling case when failed
to register serial_txx9_pci_driver with macro ENABLE_SERIAL_TXX9_PCI
defined.

Fixes: ab4382d27412 ("tty: move drivers/serial/ to drivers/tty/serial/")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201103084942.109076-1-miaoqinglang@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_txx9.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index b4d89e31730e..7a07e7272de1 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -1280,6 +1280,9 @@ static int __init serial_txx9_init(void)
 
 #ifdef ENABLE_SERIAL_TXX9_PCI
 	ret = pci_register_driver(&serial_txx9_pci_driver);
+	if (ret) {
+		platform_driver_unregister(&serial_txx9_plat_driver);
+	}
 #endif
 	if (ret == 0)
 		goto out;
-- 
2.29.2


