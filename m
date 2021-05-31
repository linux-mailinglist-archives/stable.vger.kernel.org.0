Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907F0395E51
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhEaN5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233285AbhEaNzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2E1B61437;
        Mon, 31 May 2021 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468043;
        bh=/RuQUyMIaJ9E9bQymBEYM3aoAaFljy1lzbmmttyFdb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ajk9vUco5eNXbEOvnQ3IKEj4XJ4TTnkNB7Ex1o6DOhzDe7G/UnG2WAzOxSz3lm5Jt
         grPeDNsC4PpOx5BsXuvEp9+AaBWqE21TYClO265GhS+2IiQ19fmDCUjHSUxA8C5TMC
         e92j5emcSub4JoWCAbxqBd58BajcQx1y03zFbxWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 5.10 078/252] serial: tegra: Fix a mask operation that is always true
Date:   Mon, 31 May 2021 15:12:23 +0200
Message-Id: <20210531130700.642018293@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -333,7 +333,7 @@ static void tegra_uart_fifo_reset(struct
 
 	do {
 		lsr = tegra_uart_read(tup, UART_LSR);
-		if ((lsr | UART_LSR_TEMT) && !(lsr & UART_LSR_DR))
+		if ((lsr & UART_LSR_TEMT) && !(lsr & UART_LSR_DR))
 			break;
 		udelay(1);
 	} while (--tmout);


