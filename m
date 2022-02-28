Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35C04C7704
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiB1SLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241075AbiB1SJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DC3654A5;
        Mon, 28 Feb 2022 09:49:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98BF7CE17C5;
        Mon, 28 Feb 2022 17:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E89C340E7;
        Mon, 28 Feb 2022 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070562;
        bh=bJSGxrSyQRTjpkVIFjYm5UpZ5rWG34BAus4iU+AtDNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqSs40a0gcx/PpD6Cp1ugZNqn32WkVYMUv1r6hhbWqDfrDL4nVSja8bWxePyoPwq6
         r1ldYHwJlqcLwIpw0y44UVDx55sIy/q4Du6CCJIkis/ZRjB3iojnvG2Yw/hxroeuOk
         Cmwnb8f7zkt7fw6UL4QgkyaR0M7t5jMT7h1OkoJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.16 155/164] tty: n_gsm: fix encoding of command/response bit
Date:   Mon, 28 Feb 2022 18:25:17 +0100
Message-Id: <20220228172413.797509155@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: daniel.starke@siemens.com <daniel.starke@siemens.com>

commit 57435c42400ec147a527b2313188b649e81e449e upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.2.1.2 describes the encoding of the
C/R (command/response) bit. Table 1 shows that the actual encoding of the
C/R bit is inverted if the associated frame is sent by the responder.

The referenced commit fixed here further broke the internal meaning of this
bit in the outgoing path by always setting the C/R bit regardless of the
frame type.

This patch fixes both by setting the C/R bit always consistently for
command (1) and response (0) frames and inverting it later for the
responder where necessary. The meaning of this bit in the debug output
is being preserved and shows the bit as if it was encoded by the initiator.
This reflects only the frame type rather than the encoded combination of
communication side and frame type.

Fixes: cc0f42122a7e ("tty: n_gsm: Modify CR,PF bit when config requester")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220218073123.2121-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -448,7 +448,7 @@ static u8 gsm_encode_modem(const struct
  *	gsm_print_packet	-	display a frame for debug
  *	@hdr: header to print before decode
  *	@addr: address EA from the frame
- *	@cr: C/R bit from the frame
+ *	@cr: C/R bit seen as initiator
  *	@control: control including PF bit
  *	@data: following data bytes
  *	@dlen: length of data
@@ -548,7 +548,7 @@ static int gsm_stuff_frame(const u8 *inp
  *	gsm_send	-	send a control frame
  *	@gsm: our GSM mux
  *	@addr: address for control frame
- *	@cr: command/response bit
+ *	@cr: command/response bit seen as initiator
  *	@control:  control byte including PF bit
  *
  *	Format up and transmit a control frame. These do not go via the
@@ -563,11 +563,15 @@ static void gsm_send(struct gsm_mux *gsm
 	int len;
 	u8 cbuf[10];
 	u8 ibuf[3];
+	int ocr;
+
+	/* toggle C/R coding if not initiator */
+	ocr = cr ^ (gsm->initiator ? 0 : 1);
 
 	switch (gsm->encoding) {
 	case 0:
 		cbuf[0] = GSM0_SOF;
-		cbuf[1] = (addr << 2) | (cr << 1) | EA;
+		cbuf[1] = (addr << 2) | (ocr << 1) | EA;
 		cbuf[2] = control;
 		cbuf[3] = EA;	/* Length of data = 0 */
 		cbuf[4] = 0xFF - gsm_fcs_add_block(INIT_FCS, cbuf + 1, 3);
@@ -577,7 +581,7 @@ static void gsm_send(struct gsm_mux *gsm
 	case 1:
 	case 2:
 		/* Control frame + packing (but not frame stuffing) in mode 1 */
-		ibuf[0] = (addr << 2) | (cr << 1) | EA;
+		ibuf[0] = (addr << 2) | (ocr << 1) | EA;
 		ibuf[1] = control;
 		ibuf[2] = 0xFF - gsm_fcs_add_block(INIT_FCS, ibuf, 2);
 		/* Stuffing may double the size worst case */
@@ -611,7 +615,7 @@ static void gsm_send(struct gsm_mux *gsm
 
 static inline void gsm_response(struct gsm_mux *gsm, int addr, int control)
 {
-	gsm_send(gsm, addr, 1, control);
+	gsm_send(gsm, addr, 0, control);
 }
 
 /**
@@ -1800,10 +1804,10 @@ static void gsm_queue(struct gsm_mux *gs
 		goto invalid;
 
 	cr = gsm->address & 1;		/* C/R bit */
+	cr ^= gsm->initiator ? 0 : 1;	/* Flip so 1 always means command */
 
 	gsm_print_packet("<--", address, cr, gsm->control, gsm->buf, gsm->len);
 
-	cr ^= 1 - gsm->initiator;	/* Flip so 1 always means command */
 	dlci = gsm->dlci[address];
 
 	switch (gsm->control) {


