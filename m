Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DA83CA9B8
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241212AbhGOTIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242114AbhGOTHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:07:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 883A4613D0;
        Thu, 15 Jul 2021 19:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375818;
        bh=oDj4QzskaiCbEtmnzszlg04IE4Xh1gAq207OnqONIEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdcFFyw0ZOfN8Y3BfcFcgxWJS3rPTcyDcKnHL+KTgS6L/ofJPwsS8r0/niKs8bMO/
         6013VMJzU/P7SIhmY9a1DB5v27u5DZjRtx+A7FekIZo9CcCDMyIDN5o7t9gXu6U+20
         8ruc2UwfRU3GFTEN+c83R3Yn6R//r8etG+4Tsq5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH 5.12 212/242] ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe
Date:   Thu, 15 Jul 2021 20:39:34 +0200
Message-Id: <20210715182630.516082374@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

commit 9272e5d0028d45a3b45b58c9255e6e0df53f7ad9 upstream.

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
 drivers/ipack/carriers/tpci200.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -596,8 +596,11 @@ static int tpci200_pci_probe(struct pci_
 
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


