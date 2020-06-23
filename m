Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D366205EDE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390514AbgFWU1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389259AbgFWU1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:27:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542F4206C3;
        Tue, 23 Jun 2020 20:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944020;
        bh=S8xASzlc6X5kEJwE/xMTaJIM5tWM4QHQVAJ6RWPkhKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2d3FHIcT5P+7Lt3xQySsLAGTCGM9286vtMl6OFkbwTdhCi/fiKCj+i43hYoIM6jR
         JFbP3VmvDtfXtk0S3/kifDdTX8xF9J+QQgchZmUlddk34jrDeb30LGRgbA3I9xZkwq
         qoZAOoYOBmbJF5gNz7/Qvl31zAgnZ2C1NIYQXeB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/314] tty: n_gsm: Fix waking up upper tty layer when room available
Date:   Tue, 23 Jun 2020 21:55:37 +0200
Message-Id: <20200623195345.633833669@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit 01dbb362f0a114fbce19c8abe4cd6f4710e934d5 ]

Warn the upper layer when n_gms is ready to receive data
again. Without this the associated virtual tty remains blocked
indefinitely.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20200512115323.1447922-4-gregory.clement@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index a5165f989fcf6..8a0d66a05af59 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -665,7 +665,7 @@ static struct gsm_msg *gsm_data_alloc(struct gsm_mux *gsm, u8 addr, int len,
  *	FIXME: lock against link layer control transmissions
  */
 
-static void gsm_data_kick(struct gsm_mux *gsm)
+static void gsm_data_kick(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 {
 	struct gsm_msg *msg, *nmsg;
 	int len;
@@ -697,6 +697,24 @@ static void gsm_data_kick(struct gsm_mux *gsm)
 
 		list_del(&msg->list);
 		kfree(msg);
+
+		if (dlci) {
+			tty_port_tty_wakeup(&dlci->port);
+		} else {
+			int i = 0;
+
+			for (i = 0; i < NUM_DLCI; i++) {
+				struct gsm_dlci *dlci;
+
+				dlci = gsm->dlci[i];
+				if (dlci == NULL) {
+					i++;
+					continue;
+				}
+
+				tty_port_tty_wakeup(&dlci->port);
+			}
+		}
 	}
 }
 
@@ -748,7 +766,7 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 	/* Add to the actual output queue */
 	list_add_tail(&msg->list, &gsm->tx_list);
 	gsm->tx_bytes += msg->len;
-	gsm_data_kick(gsm);
+	gsm_data_kick(gsm, dlci);
 }
 
 /**
@@ -1209,7 +1227,7 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 		gsm_control_reply(gsm, CMD_FCON, NULL, 0);
 		/* Kick the link in case it is idling */
 		spin_lock_irqsave(&gsm->tx_lock, flags);
-		gsm_data_kick(gsm);
+		gsm_data_kick(gsm, NULL);
 		spin_unlock_irqrestore(&gsm->tx_lock, flags);
 		break;
 	case CMD_FCOFF:
@@ -2519,7 +2537,7 @@ static void gsmld_write_wakeup(struct tty_struct *tty)
 	/* Queue poll */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	spin_lock_irqsave(&gsm->tx_lock, flags);
-	gsm_data_kick(gsm);
+	gsm_data_kick(gsm, NULL);
 	if (gsm->tx_bytes < TX_THRESH_LO) {
 		gsm_dlci_data_sweep(gsm);
 	}
-- 
2.25.1



