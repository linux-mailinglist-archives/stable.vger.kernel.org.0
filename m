Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B4E3C4EE6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242418AbhGLHWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344791AbhGLHUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:20:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E84D0613D2;
        Mon, 12 Jul 2021 07:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074284;
        bh=QFMxR+186mchFWrSXA9thaaBEdEdiezx6en5O1R/D9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8IdplxPuz0c29EtS/aQ52QCjxqidMFBp6r9iJDegagoNFhyA4ZqCE79TVtWQASYR
         XeBsW1wmSGNVCF/uqTpAibnGc/SFMR644U3jH/0/CLgjDiWa7SyENQr7F3xBYW49Wm
         Av7vZmbdJPxCUepDQAGkp0kDF3IeRVWVtLDZIFKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 526/700] tty: nozomi: Fix a resource leak in an error handling function
Date:   Mon, 12 Jul 2021 08:10:09 +0200
Message-Id: <20210712061032.389563013@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 31a9a318255960d32ae183e95d0999daf2418608 ]

A 'request_irq()' call is not balanced by a corresponding 'free_irq()' in
the error handling path, as already done in the remove function.

Add it.

Fixes: 9842c38e9176 ("kfifo: fix warn_unused_result")
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/4f0d2b3038e82f081d370ccb0cade3ad88463fe7.1620580838.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/nozomi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 861e95043191..0b10c2da4364 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1433,6 +1433,7 @@ err_free_tty:
 		tty_unregister_device(ntty_driver, dc->index_start + i);
 		tty_port_destroy(&dc->port[i].port);
 	}
+	free_irq(pdev->irq, dc);
 err_free_kfifo:
 	for (i = 0; i < MAX_PORT; i++)
 		kfifo_free(&dc->port[i].fifo_ul);
-- 
2.30.2



