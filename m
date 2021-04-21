Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FAE366BE1
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbhDUNIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240953AbhDUNHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 349296143B;
        Wed, 21 Apr 2021 13:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010391;
        bh=e1Z3u0mBPmPHq2ksxGNEsin/pClz7/3xdJ9lbP8s4FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJJK7g9q7+pt9X7eQOnNgC4ew7GVm021DqvAI6fEuO3xIbs+cEhhm3yEt7GJ4TZju
         mnJuoUpfIpQRYak/OtIUqBxU3wtieFmYZ8kgYdXKH7nUc43T9RFBnqhmjotvWjBs+A
         ymgMcNGRJTny21ys95KXdCO+tRd7CY7bOocoWWL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        Richard Genoud <richard.genoud@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 120/190] Revert "tty: atmel_serial: fix a potential NULL pointer dereference"
Date:   Wed, 21 Apr 2021 14:59:55 +0200
Message-Id: <20210421130105.1226686-121-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit c85be041065c0be8bc48eda4c45e0319caf1d0e5.

Commits from @umn.edu addresses have been found to be submitted in "bad
faith" to try to test the kernel community's ability to review "known
malicious" changes.  The result of these submissions can be found in a
paper published at the 42nd IEEE Symposium on Security and Privacy
entitled, "Open Source Insecurity: Stealthily Introducing
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
of Minnesota) and Kangjie Lu (University of Minnesota).

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Richard Genoud <richard.genoud@gmail.com>
Cc: stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a24e5c2b30bc..9786d8e5f04f 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1256,10 +1256,6 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 					 sg_dma_len(&atmel_port->sg_rx)/2,
 					 DMA_DEV_TO_MEM,
 					 DMA_PREP_INTERRUPT);
-	if (!desc) {
-		dev_err(port->dev, "Preparing DMA cyclic failed\n");
-		goto chan_err;
-	}
 	desc->callback = atmel_complete_rx_dma;
 	desc->callback_param = port;
 	atmel_port->desc_rx = desc;
-- 
2.31.1

