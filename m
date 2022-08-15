Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B742E5939D4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbiHOT2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbiHOT1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:27:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08405B7BB;
        Mon, 15 Aug 2022 11:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E7BDB810A1;
        Mon, 15 Aug 2022 18:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B91C433D7;
        Mon, 15 Aug 2022 18:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589005;
        bh=zn8xdHTvk6cuJwKCSSmY3TtG/YeiFQm5hr60CWdFPHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7cYMpN7gBW0ieJ+1vFETmF9JwOv+FhGYTxFQZTmE4ahPzGbYcFxatlel9uaR4xdl
         EEspreW4e2B6VMsthf7bdAKqCCXdNuzHrkER5d1SZ+jIgbZPSmKaMN6iiQx9xqBh8a
         I8IbBxMt4MVUsYNTamfaWnaoKoUkB6MSNMlGoVSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 583/779] tty: n_gsm: fix user open not possible at responder until initiator open
Date:   Mon, 15 Aug 2022 20:03:47 +0200
Message-Id: <20220815180402.254233998@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit ac77f0077c3265197d378158c85a55eee6d21508 ]

After setting up the control channel on both sides the responder side may
want to open a virtual tty to listen on until the initiator starts an
application on a user channel. The current implementation allows the
open() but no other operation, like termios. These fail with EINVAL.
The responder sided application has no means to detect an open by the
initiator sided application this way. And the initiator sided applications
usually expect the responder sided application to listen on the user
channel upon open.
Set the user channel into half-open state on responder side once a user
application opens the virtual tty to allow IO operations on it.
Furthermore, keep the user channel constipated until the initiator side
opens it to give the responder sided application the chance to detect the
new connection and to avoid data loss if the responder sided application
starts sending before the user channel is open.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701061652.39604-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index f86c5ebfcf91..36d5afa25fbb 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1524,6 +1524,8 @@ static void gsm_dlci_close(struct gsm_dlci *dlci)
 	if (debug & 8)
 		pr_debug("DLCI %d goes closed.\n", dlci->addr);
 	dlci->state = DLCI_CLOSED;
+	/* Prevent us from sending data before the link is up again */
+	dlci->constipated = true;
 	if (dlci->addr != 0) {
 		tty_port_tty_hangup(&dlci->port, false);
 		spin_lock_irqsave(&dlci->lock, flags);
@@ -1553,6 +1555,7 @@ static void gsm_dlci_open(struct gsm_dlci *dlci)
 	del_timer(&dlci->t1);
 	/* This will let a tty open continue */
 	dlci->state = DLCI_OPEN;
+	dlci->constipated = false;
 	if (debug & 8)
 		pr_debug("DLCI %d goes open.\n", dlci->addr);
 	/* Send current modem state */
@@ -1633,6 +1636,25 @@ static void gsm_dlci_begin_open(struct gsm_dlci *dlci)
 	mod_timer(&dlci->t1, jiffies + gsm->t1 * HZ / 100);
 }
 
+/**
+ *	gsm_dlci_set_opening	-	change state to opening
+ *	@dlci: DLCI to open
+ *
+ *	Change internal state to wait for DLCI open from initiator side.
+ *	We set off timers and responses upon reception of an SABM.
+ */
+static void gsm_dlci_set_opening(struct gsm_dlci *dlci)
+{
+	switch (dlci->state) {
+	case DLCI_CLOSED:
+	case DLCI_CLOSING:
+		dlci->state = DLCI_OPENING;
+		break;
+	default:
+		break;
+	}
+}
+
 /**
  *	gsm_dlci_begin_close	-	start channel open procedure
  *	@dlci: DLCI to open
@@ -1776,10 +1798,13 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 	dlci->addr = addr;
 	dlci->adaption = gsm->adaption;
 	dlci->state = DLCI_CLOSED;
-	if (addr)
+	if (addr) {
 		dlci->data = gsm_dlci_data;
-	else
+		/* Prevent us from sending data before the link is up */
+		dlci->constipated = true;
+	} else {
 		dlci->data = gsm_dlci_command;
+	}
 	gsm->dlci[addr] = dlci;
 	return dlci;
 }
@@ -3226,6 +3251,8 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 	/* Start sending off SABM messages */
 	if (gsm->initiator)
 		gsm_dlci_begin_open(dlci);
+	else
+		gsm_dlci_set_opening(dlci);
 	/* And wait for virtual carrier */
 	return tty_port_block_til_ready(port, tty, filp);
 }
-- 
2.35.1



