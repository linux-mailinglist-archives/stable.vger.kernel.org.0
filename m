Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244B54546F2
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 14:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbhKQNMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 08:12:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhKQNMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 08:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4777660235;
        Wed, 17 Nov 2021 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637154555;
        bh=MdvA9ihSnzAr5+oZ4KZ2pHQg8cX0qEexAIYQOhjxdtM=;
        h=Subject:To:From:Date:From;
        b=FCRf8e1duQaLTZ/eh53QkdoAurxz/eccpn8kcp3JcvlS8aob2i66Kns9qEEakxZIz
         07MjVpmnGZhfzx86krKCYGkYEamzUJ6Y9qKmO5eJhDlrdrIQNFaBtkaRA2KfTmi2Vf
         10I3WGLeENEls8BgphMq3B1Ya7ElC7WjMoRSS8ZY=
Subject: patch "staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 14:09:05 +0100
Message-ID: <1637154545174104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b535917c51acc97fb0761b1edec85f1f3d02bda4 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 17 Nov 2021 10:20:16 +0300
Subject: staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()

The free_rtllib() function frees the "dev" pointer so there is use
after free on the next line.  Re-arrange things to avoid that.

Fixes: 66898177e7e5 ("staging: rtl8192e: Fix unload/reload problem")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211117072016.GA5237@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index d2e9df60e9ba..b9ce71848023 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2549,13 +2549,14 @@ static void _rtl92e_pci_disconnect(struct pci_dev *pdev)
 			free_irq(dev->irq, dev);
 			priv->irq = 0;
 		}
-		free_rtllib(dev);
 
 		if (dev->mem_start != 0) {
 			iounmap((void __iomem *)dev->mem_start);
 			release_mem_region(pci_resource_start(pdev, 1),
 					pci_resource_len(pdev, 1));
 		}
+
+		free_rtllib(dev);
 	}
 
 	pci_disable_device(pdev);
-- 
2.34.0


