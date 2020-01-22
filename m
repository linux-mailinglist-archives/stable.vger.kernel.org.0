Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E79144F1F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgAVJev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:34:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731020AbgAVJeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:34:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD94824672;
        Wed, 22 Jan 2020 09:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685690;
        bh=GHP79wfYN6K6OWB26k7NvWICP9pGrlRQYuRqgkbyFlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf3todjlomIpaHhkBUXchUPF/tNst7mmyGlqfKmbcNSd3xUknm7jGvEzn14QI+ahw
         X7jh4dBhlhd3Va8LbUjsq1rZ4/48AFHwW6XHyt/Jx9qZXydfIvgsHkJtftbGpqadqs
         t9z6JJQXC5we8ychhhoInsHcJGbEdyGgcGgklo+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mans Rullgard <mans@mansr.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 39/97] spi: atmel: fix handling of cs_change set on non-last xfer
Date:   Wed, 22 Jan 2020 10:28:43 +0100
Message-Id: <20200122092802.851983132@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

commit fed8d8c7a6dc2a76d7764842853d81c770b0788e upstream.

The driver does the wrong thing when cs_change is set on a non-last
xfer in a message.  When cs_change is set, the driver deactivates the
CS and leaves it off until a later xfer again has cs_change set whereas
it should be briefly toggling CS off and on again.

This patch brings the behaviour of the driver back in line with the
documentation and common sense.  The delay of 10 us is the same as is
used by the default spi_transfer_one_message() function in spi.c.
[gregory: rebased on for-5.5 from spi tree]
Fixes: 8090d6d1a415 ("spi: atmel: Refactor spi-atmel to use SPI framework queue")
Signed-off-by: Mans Rullgard <mans@mansr.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20191018153504.4249-1-gregory.clement@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-atmel.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -315,7 +315,6 @@ struct atmel_spi {
 	struct atmel_spi_dma	dma;
 
 	bool			keep_cs;
-	bool			cs_active;
 
 	u32			fifo_size;
 };
@@ -1404,11 +1403,9 @@ static int atmel_spi_one_transfer(struct
 				 &msg->transfers)) {
 			as->keep_cs = true;
 		} else {
-			as->cs_active = !as->cs_active;
-			if (as->cs_active)
-				cs_activate(as, msg->spi);
-			else
-				cs_deactivate(as, msg->spi);
+			cs_deactivate(as, msg->spi);
+			udelay(10);
+			cs_activate(as, msg->spi);
 		}
 	}
 
@@ -1431,7 +1428,6 @@ static int atmel_spi_transfer_one_messag
 	atmel_spi_lock(as);
 	cs_activate(as, spi);
 
-	as->cs_active = true;
 	as->keep_cs = false;
 
 	msg->status = 0;


