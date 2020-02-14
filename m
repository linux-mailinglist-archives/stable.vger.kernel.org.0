Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D747B15F31A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgBNPw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731097AbgBNPw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 908A124673;
        Fri, 14 Feb 2020 15:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695578;
        bh=TAJQ3d5LQOTkR0u/zgFlmI/5rfKu3+mGs9qTStlSToU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzyaXEH3IAhDDl/QxvQbW+vD4og5dNvrGRtvZe9JV+B6RSksJmxVbmW2UJoDLzs2+
         8iB+BI3zWWmcuOGN0g6cJI4xPXNrICQnxT+DHnKs1QA6G9ClVWGNCNFMd2DJEJi/4e
         MiH7PLp/BB/mV7DTA22+45XBCwm92oRoXWNPSR6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 188/542] tty: omap-serial: remove set but unused variable
Date:   Fri, 14 Feb 2020 10:43:00 -0500
Message-Id: <20200214154854.6746-188-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit e83c6587c47caa2278aa3bd603b5a85eddc4cec9 ]

Fix the following warning:
drivers/tty/serial/omap-serial.c: In function serial_omap_rlsi:
drivers/tty/serial/omap-serial.c:496:16: warning: variable ch set but not used [-Wunused-but-set-variable]

The character read is useless according to the table 23-246 of the omap4
TRM. So we can drop it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/1575617863-32484-1-git-send-email-wangxiongfeng2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/omap-serial.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 6420ae581a802..5f808d8dfcd5c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -493,10 +493,13 @@ static unsigned int check_modem_status(struct uart_omap_port *up)
 static void serial_omap_rlsi(struct uart_omap_port *up, unsigned int lsr)
 {
 	unsigned int flag;
-	unsigned char ch = 0;
 
+	/*
+	 * Read one data character out to avoid stalling the receiver according
+	 * to the table 23-246 of the omap4 TRM.
+	 */
 	if (likely(lsr & UART_LSR_DR))
-		ch = serial_in(up, UART_RX);
+		serial_in(up, UART_RX);
 
 	up->port.icount.rx++;
 	flag = TTY_NORMAL;
-- 
2.20.1

