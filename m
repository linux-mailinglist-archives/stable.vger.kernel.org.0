Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF678111D4A
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbfLCWv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729659AbfLCWvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A623820862;
        Tue,  3 Dec 2019 22:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413515;
        bh=El87W87gUKdjkEIOxGKkTeim2N3L71k5D8CTxcsCHFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0auZauZc34xdPUFmojM8iTQc9v8cBoUqGPTjalAD9CNRZx+Nh1K4S1AfJKcP1m4Ki
         XcUcKzcFSfk3gXQi7+UE8Q9WYPIBwZthCMRe46lkFn9/wrrWqyRGcKJHKd23FODvgi
         6p5qYx0VWQgk1baThxw8INjLDmxjUOQr1pf//uL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/321] serial: max310x: Fix tx_empty() callback
Date:   Tue,  3 Dec 2019 23:33:42 +0100
Message-Id: <20191203223435.260836210@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shiyan <shc_work@mail.ru>

[ Upstream commit a8da3c7873ea57acb8f9cea58c0af477522965aa ]

Function max310x_tx_empty() accesses the IRQSTS register, which is
cleared by IC when reading, so if there is an interrupt status, we
will lose it. This patch implement the transmitter check only by
the current FIFO level.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index bd3e6cf81af5c..0c35c3c5e3734 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -844,12 +844,9 @@ static void max310x_wq_proc(struct work_struct *ws)
 
 static unsigned int max310x_tx_empty(struct uart_port *port)
 {
-	unsigned int lvl, sts;
+	u8 lvl = max310x_port_read(port, MAX310X_TXFIFOLVL_REG);
 
-	lvl = max310x_port_read(port, MAX310X_TXFIFOLVL_REG);
-	sts = max310x_port_read(port, MAX310X_IRQSTS_REG);
-
-	return ((sts & MAX310X_IRQ_TXEMPTY_BIT) && !lvl) ? TIOCSER_TEMT : 0;
+	return lvl ? 0 : TIOCSER_TEMT;
 }
 
 static unsigned int max310x_get_mctrl(struct uart_port *port)
-- 
2.20.1



