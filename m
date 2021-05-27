Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C408392E25
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 14:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhE0Mll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 08:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234466AbhE0Mlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 08:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8159606A5;
        Thu, 27 May 2021 12:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622119205;
        bh=TK291+ludnub+vGqPh2D0ugOURZMx6DBFagYTtAw/o0=;
        h=Subject:To:From:Date:From;
        b=QViiYdGxAZz1S8QDf0/EdEPvZGHLrC/6c5a0/GozJ9Bb/I8a8CQF7NrQXUh2k4FAr
         PE0CWhiDiP286EeA9CuUwM+TIhuP/N995CrK0oNCeFq4nATxUMgd0w2YzA/Cndqsa/
         aCDWQc8A8In730FtLiaqpZOYek9by7J8Ry+e/MGw=
Subject: patch "ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe" added to char-misc-testing
To:     lyl2019@mail.ustc.edu.cn, gregkh@linuxfoundation.org,
        siglesias@igalia.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 May 2021 14:40:02 +0200
Message-ID: <16221192026638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 9272e5d0028d45a3b45b58c9255e6e0df53f7ad9 Mon Sep 17 00:00:00 2001
From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Date: Mon, 24 May 2021 02:32:05 -0700
Subject: ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe

In the out_err_bus_register error branch of tpci200_pci_probe,
tpci200->info->cfg_regs is freed by tpci200_uninstall()->
tpci200_unregister()->pci_iounmap(..,tpci200->info->cfg_regs)
in the first time.

But later, iounmap() is called to free tpci200->info->cfg_regs
again.

My patch sets tpci200->info->cfg_regs to NULL after tpci200_uninstall()
to avoid the double free.

Fixes: cea2f7cdff2af ("Staging: ipack/bridges/tpci200: Use the TPCI200 in big endian mode")
Cc: stable <stable@vger.kernel.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Link: https://lore.kernel.org/r/20210524093205.8333-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ipack/carriers/tpci200.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index ec71063fff76..e1822e87ec3d 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -596,8 +596,11 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 
 out_err_bus_register:
 	tpci200_uninstall(tpci200);
+	/* tpci200->info->cfg_regs is unmapped in tpci200_uninstall */
+	tpci200->info->cfg_regs = NULL;
 out_err_install:
-	iounmap(tpci200->info->cfg_regs);
+	if (tpci200->info->cfg_regs)
+		iounmap(tpci200->info->cfg_regs);
 out_err_ioremap:
 	pci_release_region(pdev, TPCI200_CFG_MEM_BAR);
 out_err_pci_request:
-- 
2.31.1


