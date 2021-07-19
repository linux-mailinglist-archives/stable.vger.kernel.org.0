Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0F3CD97D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242628AbhGSOa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243966AbhGSO1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66DA56121F;
        Mon, 19 Jul 2021 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707267;
        bh=9vyj3TdfwwwPSTnZzoLHybhy5ls7b+6xKOjkPW72Wa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jYk3Pp1QSmccel/VqOonRa84ppPtmXw/WgjJqOQrYFJQuVUDr+bHxtRutezRiwed
         BjnB+IHVofaLoe7m78xC+2oRG/RGSDCjKiLGEoVC2XVCc6jDgIQ00VmMvVV7Z/t8ln
         zxruCnv8SlexqLb8AAkffrPsLvE3yItukP0WYs7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 092/245] tty: nozomi: Fix a resource leak in an error handling function
Date:   Mon, 19 Jul 2021 16:50:34 +0200
Message-Id: <20210719144943.390770345@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index d6fd0e802ef5..c4c37640bda3 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1479,6 +1479,7 @@ err_free_tty:
 		tty_unregister_device(ntty_driver, dc->index_start + i);
 		tty_port_destroy(&dc->port[i].port);
 	}
+	free_irq(pdev->irq, dc);
 err_free_kfifo:
 	for (i = 0; i < MAX_PORT; i++)
 		kfifo_free(&dc->port[i].fifo_ul);
-- 
2.30.2



