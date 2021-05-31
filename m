Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5016939603B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhEaOXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233856AbhEaOVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E96FB6148E;
        Mon, 31 May 2021 13:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468688;
        bh=fTYm83lxB6rhwV9QngRLik0+nwkWeMZ+EZtosISWU2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvuznHE68C8B8Mz38rrnF3BMRAkBRdrlILaj0klVx3x+bHhcJrJaU2Q7e/3VxcxdB
         xhEojjzkhhzSa44XsWkSM2hVgJWApoAtjy6LGxpUHbnOlNW9E2/rL+qeht/iH7pNQD
         hPy62+jRM+wSk6aw/6eGKhojg34WtvOOW30UWzTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 5.4 053/177] serial: tegra: Fix a mask operation that is always true
Date:   Mon, 31 May 2021 15:13:30 +0200
Message-Id: <20210531130649.757360994@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 3ddb4ce1e6e3bd112778ab93bbd9092f23a878ec upstream.

Currently the expression lsr | UART_LSR_TEMT is always true and
this seems suspect. I believe the intent was to mask lsr with UART_LSR_TEMT
to check that bit, so the expression should be using the & operator
instead. Fix this.

Fixes: b9c2470fb150 ("serial: tegra: flush the RX fifo on frame error")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210426105514.23268-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -332,7 +332,7 @@ static void tegra_uart_fifo_reset(struct
 
 	do {
 		lsr = tegra_uart_read(tup, UART_LSR);
-		if ((lsr | UART_LSR_TEMT) && !(lsr & UART_LSR_DR))
+		if ((lsr & UART_LSR_TEMT) && !(lsr & UART_LSR_DR))
 			break;
 		udelay(1);
 	} while (--tmout);


