Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D22E29B8C1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801865AbgJ0Pos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799925AbgJ0PeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F43F22264;
        Tue, 27 Oct 2020 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812848;
        bh=LOjcuGBJclT3lPR7rvlNiuRhVS2aSFtEgRiiyrMjcIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPyVoA2tA+sid14em+U+XRdU5ShCeOB9nP8nSJ+NrWdMtT2khiHsf6lYpQ/0ybEmx
         bZRBQ48Wrsj3s3L5o0aVdXejGLvHOA5huWZs/l5V3PsydvyaE736hA9HBG9QjKq1UB
         dS/DxE9ptxKaGcEQv6YIsY9uNln1sUOByNvkr3ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 352/757] serial: 8250: Discard RTS/DTS setting from clock update method
Date:   Tue, 27 Oct 2020 14:50:02 +0100
Message-Id: <20201027135507.084233919@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 7718453e36960dadb8dc46f2b514b309659e1270 ]

It has been a mistake to add the MCR register RTS/DTS fields setting in
the generic method of the UART reference clock update. There is no point
in asserting these lines at that procedure. Just discard the
serial8250_out_MCR() mathod invocation from there then.

Fixes: 868f3ee6e452 ("serial: 8250: Add 8250 port clock update method")
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20200923161950.6237-2-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index c71d647eb87a0..1259fb6b66b38 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2665,7 +2665,6 @@ void serial8250_update_uartclk(struct uart_port *port, unsigned int uartclk)
 
 	serial8250_set_divisor(port, baud, quot, frac);
 	serial_port_out(port, UART_LCR, up->lcr);
-	serial8250_out_MCR(up, UART_MCR_DTR | UART_MCR_RTS);
 
 	spin_unlock_irqrestore(&port->lock, flags);
 	serial8250_rpm_put(up);
-- 
2.25.1



