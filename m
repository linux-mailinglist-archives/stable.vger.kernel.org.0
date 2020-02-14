Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E097215E571
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388519AbgBNQlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405101AbgBNQWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07BA3246B0;
        Fri, 14 Feb 2020 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697358;
        bh=nBg3B4SGh9ImBA80puCaQjptdsSOnQ4qH+lPv9TJtHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYQq+k9xUifjacSiM+WgG+99MoW7jhPeHwot5cGoNXawGyCXQwaUWeM3T2AHtu8Qg
         RE5BjTHVwPGWVWR/cxV5ZI1gKdh6pS1XPRNvSq9R9ixz2R15ghbJThVzlAMkWypZO3
         snyvI58iQxgVeNX1JqJmqtjM8EP1AQtsztKcINWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Engraf <david.engraf@sysgo.com>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 060/141] Revert "tty/serial: atmel: fix out of range clock divider handling"
Date:   Fri, 14 Feb 2020 11:20:00 -0500
Message-Id: <20200214162122.19794-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 6dbd54e4154dfe386b3333687de15be239576617 ]

This reverts commit 751d0017334db9c4d68a8909c59f662a6ecbcec6.

The wrong commit got added to the tty-next tree, the correct one is in
the tty-linus branch.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Engraf <david.engraf@sysgo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/atmel_serial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 325f9db2da86c..255be61b4073a 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2200,6 +2200,9 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 		mode |= ATMEL_US_USMODE_NORMAL;
 	}
 
+	/* set the mode, clock divisor, parity, stop bits and data size */
+	atmel_uart_writel(port, ATMEL_US_MR, mode);
+
 	/*
 	 * Set the baud rate:
 	 * Fractional baudrate allows to setup output frequency more
-- 
2.20.1

