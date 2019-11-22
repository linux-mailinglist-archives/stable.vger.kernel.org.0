Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781611063E1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfKVGNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729435AbfKVGNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE9342071B;
        Fri, 22 Nov 2019 06:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403218;
        bh=jzremZJt9uCCXqYmgSJYucLdl1Qtl9dFmP4sQefk5tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV2o5U8moDA+/lOoxmKGCrzFZNapG4SAPvnu73nwbwM8oo/WUl2/yqvnCyAQramt+
         JvxTI3lkW5ayNblsHH3CVUQ7qyEQAK63y+8YjUSYZZKwNLvLRMl6iqv4ez1XnE8tKk
         E3qwYU/q6aY9Q2ULa3AHfOaNHAYul966vSSChREU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shiyan <shc_work@mail.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 33/68] serial: max310x: Fix tx_empty() callback
Date:   Fri, 22 Nov 2019 01:12:26 -0500
Message-Id: <20191122061301.4947-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a66fb7afecc71..e13e95733fa3c 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -763,12 +763,9 @@ static void max310x_start_tx(struct uart_port *port)
 
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

