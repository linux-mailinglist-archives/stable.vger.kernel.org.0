Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C6D395D28
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhEaNmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232953AbhEaNj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:39:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3214A61370;
        Mon, 31 May 2021 13:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467645;
        bh=cFKdeZRAsalLgHDr88RrC/uO12YQi4x7nN+X157/FWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJwZ2Lkeu2cZ8M5/NfSRF4AQeToggDOuxBygj7Cea4g60e5378nNvRo5LfOC/L/6P
         ypq7MdRSImbkxS8vMXiyWLiJsZ4FABZg9H2x6YRvdtF8u5q9Nj1Z/YY4rhBid5c4JE
         CbnGegBNqr6PMU3kEXV3GMET1tFSF/+PCYtEiieM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linh Phung <linh.phung.jy@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4.14 26/79] serial: sh-sci: Fix off-by-one error in FIFO threshold register setting
Date:   Mon, 31 May 2021 15:14:11 +0200
Message-Id: <20210531130636.845790318@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 2ea2e019c190ee3973ef7bcaf829d8762e56e635 upstream.

The Receive FIFO Data Count Trigger field (RTRG[6:0]) in the Receive
FIFO Data Count Trigger Register (HSRTRGR) of HSCIF can only hold values
ranging from 0-127.  As the FIFO size is equal to 128 on HSCIF, the user
can write an out-of-range value, touching reserved bits.

Fix this by limiting the trigger value to the FIFO size minus one.
Reverse the order of the checks, to avoid rx_trig becoming zero if the
FIFO size is one.

Note that this change has no impact on other SCIF variants, as their
maximum supported trigger value is lower than the FIFO size anyway, and
the code below takes care of enforcing these limits.

Fixes: a380ed461f66d1b8 ("serial: sh-sci: implement FIFO threshold register setting")
Reported-by: Linh Phung <linh.phung.jy@renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/5eff320aef92ffb33d00e57979fd3603bbb4a70f.1620648218.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -994,10 +994,10 @@ static int scif_set_rtrg(struct uart_por
 {
 	unsigned int bits;
 
+	if (rx_trig >= port->fifosize)
+		rx_trig = port->fifosize - 1;
 	if (rx_trig < 1)
 		rx_trig = 1;
-	if (rx_trig >= port->fifosize)
-		rx_trig = port->fifosize;
 
 	/* HSCIF can be set to an arbitrary level. */
 	if (sci_getreg(port, HSRTRGR)->size) {


