Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8368388E4A
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfHJUx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:53:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53868 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-00053W-Sf; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003ZN-5G; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Richard Genoud" <richard.genoud@gmail.com>,
        "Kangjie Lu" <kjlu@umn.edu>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.191840651@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 024/157] tty: atmel_serial: fix a potential NULL
 pointer dereference
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kangjie Lu <kjlu@umn.edu>

commit c85be041065c0be8bc48eda4c45e0319caf1d0e5 upstream.

In case dmaengine_prep_dma_cyclic fails, the fix returns a proper
error code to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Fixes: 34df42f59a60 ("serial: at91: add rx dma support")
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/atmel_serial.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1045,6 +1045,10 @@ static int atmel_prepare_rx_dma(struct u
 				sg_dma_len(&atmel_port->sg_rx)/2,
 				DMA_DEV_TO_MEM,
 				DMA_PREP_INTERRUPT);
+	if (!desc) {
+		dev_err(port->dev, "Preparing DMA cyclic failed\n");
+		goto chan_err;
+	}
 	desc->callback = atmel_complete_rx_dma;
 	desc->callback_param = port;
 	atmel_port->desc_rx = desc;

