Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB36B2E14CD
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgLWCn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729832AbgLWCW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269E4225AA;
        Wed, 23 Dec 2020 02:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690136;
        bh=BbtAdIFgjwoHhKSVKJdvtiuvyo+q+gYt02aUQcUTrm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KW4vseZTOIReZFsNY1YcRGfFgdSVjSqSdenC0qqJN49QKxvEHsxb8iHiYV9SZh9cu
         uGFAvUi0Gh7vIsy2b478efrS34hcZ2fEoYv5kdnIp6iS0ekDEOiAWeHiFK7W2uaZQD
         8I6UTtC0EqjoN8dOX0pTYFUAx7HHzaYI4CKMNBcP+jl9ZBZsAauYjEPGs9iW+7MmRz
         j8jCXRIi4EyKvqs1KvpcBuqtZBoNbrboigOUZAKn8i8HmiO4f89q7MygOK3e1TQO4n
         7W14zKx1NZwzfAhzGobOKO9Tf0NCTYhGLbM1Tn9o6Xb4IiecXHjIwC3NyDYKeMz/Mx
         bH+pPx0IyPGIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mingrui Ren <jiladahe1997@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 59/87] tty/serial/imx: Enable TXEN bit in imx_poll_init().
Date:   Tue, 22 Dec 2020 21:20:35 -0500
Message-Id: <20201223022103.2792705-59-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mingrui Ren <jiladahe1997@gmail.com>

[ Upstream commit aef1b6a27970607721a618a0b990716ca8dbbf97 ]

As described in Documentation, poll_init() is called by kgdb to initialize
hardware which supports both poll_put_char() and poll_get_char().

It's necessary to enable TXEN bit, otherwise, it will cause hardware fault
and kernel panic when calling imx_poll_put_char().

Generally, if use /dev/ttymxc0 as kgdb console as well as system
console, ttymxc0 is initialized early by system console which does enable
TXEN bit.But when use /dev/ttymxc1 as kgbd console, ttymxc1 is only
initialized by imx_poll_init() cannot enable the TXEN bit, which will
cause kernel panic.

Signed-off-by: Mingrui Ren <jiladahe1997@gmail.com>
Link: https://lore.kernel.org/r/20201202072543.151-1-972931182@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 7a6e26b12bf64..f3626ee1b06a2 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1784,7 +1784,7 @@ static int imx_uart_poll_init(struct uart_port *port)
 	ucr1 |= UCR1_UARTEN;
 	ucr1 &= ~(UCR1_TXMPTYEN | UCR1_RTSDEN | UCR1_RRDYEN);
 
-	ucr2 |= UCR2_RXEN;
+	ucr2 |= UCR2_RXEN | UCR2_TXEN;
 	ucr2 &= ~UCR2_ATEN;
 
 	imx_uart_writel(sport, ucr1, UCR1);
-- 
2.27.0

