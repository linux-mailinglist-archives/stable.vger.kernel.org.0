Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2DE29BA4B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369014AbgJ0P7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804286AbgJ0PyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:54:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4349204EF;
        Tue, 27 Oct 2020 15:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814065;
        bh=cgFXcNkUbl2sjPVQZk+vIt47X5S+DfvakEwJZgqpaPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hjam3e8NB+IZlUptbmnYsrTLdXKR0BfRz+eQcfvOSukWdBsT7cuTTJZJyEMOMvhlw
         4hEeGOFuWDfk+5BmJkB4iraIs0Ak+Vl6LoqH8Ccv8odhgW0/H6VeJdLLs4wWfJZFy6
         uzTx0UhPsOglpOLMv11EAL6dsA928wexKCDQHacA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 5.9 751/757] tty: serial: fsl_lpuart: fix lpuart32_poll_get_char
Date:   Tue, 27 Oct 2020 14:56:41 +0100
Message-Id: <20201027135525.744370238@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

commit 29788ab1d2bf26c130de8f44f9553ee78a27e8d5 upstream.

The watermark is set to 1, so we need to input two chars to trigger RDRF
using the original logic. With the new logic, we could always get the
char when there is data in FIFO.

Suggested-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20200929095509.21680-1-peng.fan@nxp.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/fsl_lpuart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -680,7 +680,7 @@ static void lpuart32_poll_put_char(struc
 
 static int lpuart32_poll_get_char(struct uart_port *port)
 {
-	if (!(lpuart32_read(port, UARTSTAT) & UARTSTAT_RDRF))
+	if (!(lpuart32_read(port, UARTWATER) >> UARTWATER_RXCNT_OFF))
 		return NO_POLL_CHAR;
 
 	return lpuart32_read(port, UARTDATA);


