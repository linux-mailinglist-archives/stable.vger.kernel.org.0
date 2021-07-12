Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EFD3C4ABD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240482AbhGLGxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240399AbhGLGvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 509786100C;
        Mon, 12 Jul 2021 06:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072509;
        bh=c3ahNNaxmnOffWKOAvZYaIt98Rj2XEPxARdHuPaEI20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R04aFtNmuuf9n23FJuP/1MdenccU/JT2U+H2PJpRbaFw8UmfKB05yB0odC/oRcANb
         +EBmiu5X8bG3cebhGbLymtxEfX1AcESQb3NoPsIurZ0gyRNJ8L+KzfAdLneZdxq/6M
         KDZWV8dZV/idFVxYUIFoK7Lrsk5Ck0WUVCW8Tb7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 478/593] tty: nozomi: Fix the error handling path of nozomi_card_init()
Date:   Mon, 12 Jul 2021 08:10:38 +0200
Message-Id: <20210712060943.029411126@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6ae7d0f5a92b9619f6e3c307ce56b2cefff3f0e9 ]

The error handling path is broken and we may un-register things that have
never been registered.

Update the loops index accordingly.

Fixes: 9842c38e9176 ("kfifo: fix warn_unused_result")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/e28c2e92c7475da25b03d022ea2d6dcf1ba807a2.1621968629.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/nozomi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 9a251a1b0d00..6890418a29a4 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1394,7 +1394,7 @@ static int nozomi_card_init(struct pci_dev *pdev,
 			NOZOMI_NAME, dc);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev, "can't request irq %d\n", pdev->irq);
-		goto err_free_kfifo;
+		goto err_free_all_kfifo;
 	}
 
 	DBG1("base_addr: %p", dc->base_addr);
@@ -1432,13 +1432,15 @@ static int nozomi_card_init(struct pci_dev *pdev,
 	return 0;
 
 err_free_tty:
-	for (i = 0; i < MAX_PORT; ++i) {
+	for (i--; i >= 0; i--) {
 		tty_unregister_device(ntty_driver, dc->index_start + i);
 		tty_port_destroy(&dc->port[i].port);
 	}
 	free_irq(pdev->irq, dc);
+err_free_all_kfifo:
+	i = MAX_PORT;
 err_free_kfifo:
-	for (i = 0; i < MAX_PORT; i++)
+	for (i--; i >= PORT_MDM; i--)
 		kfifo_free(&dc->port[i].fifo_ul);
 err_free_sbuf:
 	kfree(dc->send_buf);
-- 
2.30.2



