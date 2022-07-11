Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E1756FD4E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiGKJxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbiGKJxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:53:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66333ADD6F;
        Mon, 11 Jul 2022 02:25:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A63A161370;
        Mon, 11 Jul 2022 09:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D370C34115;
        Mon, 11 Jul 2022 09:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531530;
        bh=n1ERvqJYN6N8alN0J6PYp2laun7OTpOR51vvmkEW9No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zexDBKbcy94ydQn4i5TZxX5+GwLPacYnTjnVqxMhK0qjGxN18CzP2pMZ7EUJA1Fzq
         8QlV0pVBGmgU8X9ku/0BsyiA9WtbT9dcW3eez3LhzKZWMYErXP9YhVamXM0LCX2CcW
         8kOwYrM84EjqcfHTDfwgaFemrKejiRlCsTh9lywc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/230] tty: n_gsm: fix invalid use of MSC in advanced option
Date:   Mon, 11 Jul 2022 11:06:27 +0200
Message-Id: <20220711090607.781750032@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit c19ffe00fed6bb423d81406d2a7e5793074c7d83 ]

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.4.6.3.7 states that the Modem Status
Command (MSC) shall only be used if the basic option was chosen.
The current implementation uses MSC frames even if advanced option was
chosen to inform the peer about modem line state updates. A standard
conform peer may choose to discard these frames in advanced option mode.
Furthermore, gsmtty_modem_update() is not part of the 'tty_operations'
functions despite its name.
Rename gsmtty_modem_update() to gsm_modem_update() to clarify this. Split
its function into gsm_modem_upd_via_data() and gsm_modem_upd_via_msc()
depending on the encoding and adaption. Introduce gsm_dlci_modem_output()
as adaption of gsm_dlci_data_output() to encode and queue empty frames in
advanced option mode. Use it in gsm_modem_upd_via_data().
gsm_modem_upd_via_msc() is based on the initial gsmtty_modem_update()
function which used only MSC frames to update modem states.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220422071025.5490-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 125 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 117 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c52d5e0d5c6f..c8ca00fad8e4 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -371,7 +371,7 @@ static const u8 gsm_fcs8[256] = {
 #define GOOD_FCS	0xCF
 
 static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len);
-static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk);
+static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk);
 
 /**
  *	gsm_fcs_add	-	update FCS
@@ -928,6 +928,63 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	return size;
 }
 
+/**
+ *	gsm_dlci_modem_output	-	try and push modem status out of a DLCI
+ *	@gsm: mux
+ *	@dlci: the DLCI to pull modem status from
+ *	@brk: break signal
+ *
+ *	Push an empty frame in to the transmit queue to update the modem status
+ *	bits and to transmit an optional break.
+ *
+ *	Caller must hold the tx_lock of the mux.
+ */
+
+static int gsm_dlci_modem_output(struct gsm_mux *gsm, struct gsm_dlci *dlci,
+				 u8 brk)
+{
+	u8 *dp = NULL;
+	struct gsm_msg *msg;
+	int size;
+
+	/* for modem bits without break data */
+	if (dlci->adaption == 1) {
+		size = 0;
+	} else if (dlci->adaption == 2) {
+		size = 1;
+		if (brk > 0)
+			size++;
+	} else {
+		pr_err("%s: unsupported adaption %d\n", __func__,
+		       dlci->adaption);
+	}
+
+	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
+	if (!msg) {
+		pr_err("%s: gsm_data_alloc error", __func__);
+		return -ENOMEM;
+	}
+	dp = msg->data;
+	switch (dlci->adaption) {
+	case 1: /* Unstructured */
+		break;
+	case 2: /* Unstructured with modem bits. */
+		if (brk == 0) {
+			*dp++ = (gsm_encode_modem(dlci) << 1) | EA;
+		} else {
+			*dp++ = gsm_encode_modem(dlci) << 1;
+			*dp++ = (brk << 4) | 2 | EA; /* Length, Break, EA */
+		}
+		break;
+	default:
+		/* Handled above */
+		break;
+	}
+
+	__gsm_data_queue(dlci, msg);
+	return size;
+}
+
 /**
  *	gsm_dlci_data_sweep		-	look for data to send
  *	@gsm: the GSM mux
@@ -1492,7 +1549,7 @@ static void gsm_dlci_open(struct gsm_dlci *dlci)
 		pr_debug("DLCI %d goes open.\n", dlci->addr);
 	/* Send current modem state */
 	if (dlci->addr)
-		gsmtty_modem_update(dlci, 0);
+		gsm_modem_update(dlci, 0);
 	wake_up(&dlci->gsm->event);
 }
 
@@ -2977,12 +3034,43 @@ static struct tty_ldisc_ops tty_ldisc_packet = {
 
 #define TX_SIZE		512
 
-static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk)
+/**
+ *	gsm_modem_upd_via_data	-	send modem bits via convergence layer
+ *	@dlci: channel
+ *	@brk: break signal
+ *
+ *	Send an empty frame to signal mobile state changes and to transmit the
+ *	break signal for adaption 2.
+ */
+
+static void gsm_modem_upd_via_data(struct gsm_dlci *dlci, u8 brk)
+{
+	struct gsm_mux *gsm = dlci->gsm;
+	unsigned long flags;
+
+	if (dlci->state != DLCI_OPEN || dlci->adaption != 2)
+		return;
+
+	spin_lock_irqsave(&gsm->tx_lock, flags);
+	gsm_dlci_modem_output(gsm, dlci, brk);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
+}
+
+/**
+ *	gsm_modem_upd_via_msc	-	send modem bits via control frame
+ *	@dlci: channel
+ *	@brk: break signal
+ */
+
+static int gsm_modem_upd_via_msc(struct gsm_dlci *dlci, u8 brk)
 {
 	u8 modembits[3];
 	struct gsm_control *ctrl;
 	int len = 2;
 
+	if (dlci->gsm->encoding != 0)
+		return 0;
+
 	modembits[0] = (dlci->addr << 2) | 2 | EA;  /* DLCI, Valid, EA */
 	if (!brk) {
 		modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
@@ -2997,6 +3085,27 @@ static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk)
 	return gsm_control_wait(dlci->gsm, ctrl);
 }
 
+/**
+ *	gsm_modem_update	-	send modem status line state
+ *	@dlci: channel
+ *	@brk: break signal
+ */
+
+static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk)
+{
+	if (dlci->adaption == 2) {
+		/* Send convergence layer type 2 empty data frame. */
+		gsm_modem_upd_via_data(dlci, brk);
+		return 0;
+	} else if (dlci->gsm->encoding == 0) {
+		/* Send as MSC control message. */
+		return gsm_modem_upd_via_msc(dlci, brk);
+	}
+
+	/* Modem status lines are not supported. */
+	return -EPROTONOSUPPORT;
+}
+
 static int gsm_carrier_raised(struct tty_port *port)
 {
 	struct gsm_dlci *dlci = container_of(port, struct gsm_dlci, port);
@@ -3029,7 +3138,7 @@ static void gsm_dtr_rts(struct tty_port *port, int onoff)
 		modem_tx &= ~(TIOCM_DTR | TIOCM_RTS);
 	if (modem_tx != dlci->modem_tx) {
 		dlci->modem_tx = modem_tx;
-		gsmtty_modem_update(dlci, 0);
+		gsm_modem_update(dlci, 0);
 	}
 }
 
@@ -3218,7 +3327,7 @@ static int gsmtty_tiocmset(struct tty_struct *tty,
 
 	if (modem_tx != dlci->modem_tx) {
 		dlci->modem_tx = modem_tx;
-		return gsmtty_modem_update(dlci, 0);
+		return gsm_modem_update(dlci, 0);
 	}
 	return 0;
 }
@@ -3279,7 +3388,7 @@ static void gsmtty_throttle(struct tty_struct *tty)
 		dlci->modem_tx &= ~TIOCM_RTS;
 	dlci->throttled = true;
 	/* Send an MSC with RTS cleared */
-	gsmtty_modem_update(dlci, 0);
+	gsm_modem_update(dlci, 0);
 }
 
 static void gsmtty_unthrottle(struct tty_struct *tty)
@@ -3291,7 +3400,7 @@ static void gsmtty_unthrottle(struct tty_struct *tty)
 		dlci->modem_tx |= TIOCM_RTS;
 	dlci->throttled = false;
 	/* Send an MSC with RTS set */
-	gsmtty_modem_update(dlci, 0);
+	gsm_modem_update(dlci, 0);
 }
 
 static int gsmtty_break_ctl(struct tty_struct *tty, int state)
@@ -3309,7 +3418,7 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 		if (encode > 0x0F)
 			encode = 0x0F;	/* Best effort */
 	}
-	return gsmtty_modem_update(dlci, encode);
+	return gsm_modem_update(dlci, encode);
 }
 
 static void gsmtty_cleanup(struct tty_struct *tty)
-- 
2.35.1



