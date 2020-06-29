Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699C220DCB1
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgF2TZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732613AbgF2TZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FAF925392;
        Mon, 29 Jun 2020 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445260;
        bh=keHXIWG4WmeoqHIOPMk3MCnR5w3BYmgRSNYF33aViCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otacwNlmDV22nCPR9NA8HirD4jRyfkdCAyCz5G9M1OT9KEpEFYi0F605D1+hetDnr
         CTqWMRTUBefgJRZImCy+kINkBHykKoZRFcEz2c35pcgrHU+KrW0HStHHm2xJJbDyE2
         hZn5lY1jcF0/mAVqJQfExEfLIS39PXSCJoRgV7cM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 041/191] tty: n_gsm: Fix waking up upper tty layer when room available
Date:   Mon, 29 Jun 2020 11:37:37 -0400
Message-Id: <20200629154007.2495120-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index d5efacd27b15c..56716f5250303 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -681,7 +681,7 @@ static struct gsm_msg *gsm_data_alloc(struct gsm_mux *gsm, u8 addr, int len,
  *	FIXME: lock against link layer control transmissions
  */
 
-static void gsm_data_kick(struct gsm_mux *gsm)
+static void gsm_data_kick(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 {
 	struct gsm_msg *msg, *nmsg;
 	int len;
@@ -713,6 +713,24 @@ static void gsm_data_kick(struct gsm_mux *gsm)
 
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
 
@@ -764,7 +782,7 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 	/* Add to the actual output queue */
 	list_add_tail(&msg->list, &gsm->tx_list);
 	gsm->tx_bytes += msg->len;
-	gsm_data_kick(gsm);
+	gsm_data_kick(gsm, dlci);
 }
 
 /**
@@ -1225,7 +1243,7 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 		gsm_control_reply(gsm, CMD_FCON, NULL, 0);
 		/* Kick the link in case it is idling */
 		spin_lock_irqsave(&gsm->tx_lock, flags);
-		gsm_data_kick(gsm);
+		gsm_data_kick(gsm, NULL);
 		spin_unlock_irqrestore(&gsm->tx_lock, flags);
 		break;
 	case CMD_FCOFF:
@@ -2408,7 +2426,7 @@ static void gsmld_write_wakeup(struct tty_struct *tty)
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

