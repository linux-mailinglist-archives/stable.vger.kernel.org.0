Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1886D3CDE53
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344780AbhGSPCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344700AbhGSO7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D25B60551;
        Mon, 19 Jul 2021 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709234;
        bh=0NGF+/Yk5kcNR1dfnZcL1k/x5L1AmX9YZ0m95ltl6fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=on3Oc2MiDenzsiIxZ8lZ0rDdaQSzBUgKPK4fxpr8dbr7IhuEUfU8nisC4r7JTiAsD
         W8O8yM01RCzHeyNJNnk7aOdfp+1R6kbrTO5XlsZDaouyhTi4zjGl7an9h7j0EEMoeb
         qW8X70+Aw7j0HELJAYNjHJvhfkJwjR4hM1r6hnaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH 4.19 303/421] ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe
Date:   Mon, 19 Jul 2021 16:51:54 +0200
Message-Id: <20210719144956.833048832@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -599,8 +599,11 @@ static int tpci200_pci_probe(struct pci_
 
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


