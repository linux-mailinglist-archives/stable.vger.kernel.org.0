Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DC556FDEE
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiGKKC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbiGKKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:01:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F1965585;
        Mon, 11 Jul 2022 02:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B0B6B80DB7;
        Mon, 11 Jul 2022 09:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64872C34115;
        Mon, 11 Jul 2022 09:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531709;
        bh=xGYQNJJI17CuW0Ug1SdLR/e3i/hXLSrdy6sgfvRKxyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvilalJwYys9h/pVMPELRY2FsYUnCM9flXWguExRGIOhYuYH/kOcOYj3KSiR7Q5Oi
         04S/P+ISOMLTP/xiLCOEDS1snY5nQnhlcwYPMLkFLvn/Xo82pqsb8YguidhT3TyWpM
         J9KuKaPySvagG3A06DT11QuOM5WifF+5xenxgQdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.15 176/230] tty: n_gsm: fix encoding of command/response bit
Date:   Mon, 11 Jul 2022 11:07:12 +0200
Message-Id: <20220711090609.052703588@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -471,7 +471,7 @@ static void gsm_hex_dump_bytes(const cha
  *	gsm_print_packet	-	display a frame for debug
  *	@hdr: header to print before decode
  *	@addr: address EA from the frame
- *	@cr: C/R bit from the frame
+ *	@cr: C/R bit seen as initiator
  *	@control: control including PF bit
  *	@data: following data bytes
  *	@dlen: length of data
@@ -571,7 +571,7 @@ static int gsm_stuff_frame(const u8 *inp
  *	gsm_send	-	send a control frame
  *	@gsm: our GSM mux
  *	@addr: address for control frame
- *	@cr: command/response bit
+ *	@cr: command/response bit seen as initiator
  *	@control:  control byte including PF bit
  *
  *	Format up and transmit a control frame. These do not go via the
@@ -586,11 +586,15 @@ static void gsm_send(struct gsm_mux *gsm
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
@@ -600,7 +604,7 @@ static void gsm_send(struct gsm_mux *gsm
 	case 1:
 	case 2:
 		/* Control frame + packing (but not frame stuffing) in mode 1 */
-		ibuf[0] = (addr << 2) | (cr << 1) | EA;
+		ibuf[0] = (addr << 2) | (ocr << 1) | EA;
 		ibuf[1] = control;
 		ibuf[2] = 0xFF - gsm_fcs_add_block(INIT_FCS, ibuf, 2);
 		/* Stuffing may double the size worst case */
@@ -630,7 +634,7 @@ static void gsm_send(struct gsm_mux *gsm
 
 static inline void gsm_response(struct gsm_mux *gsm, int addr, int control)
 {
-	gsm_send(gsm, addr, 1, control);
+	gsm_send(gsm, addr, 0, control);
 }
 
 /**
@@ -1875,10 +1879,10 @@ static void gsm_queue(struct gsm_mux *gs
 		goto invalid;
 
 	cr = gsm->address & 1;		/* C/R bit */
+	cr ^= gsm->initiator ? 0 : 1;	/* Flip so 1 always means command */
 
 	gsm_print_packet("<--", address, cr, gsm->control, gsm->buf, gsm->len);
 
-	cr ^= 1 - gsm->initiator;	/* Flip so 1 always means command */
 	dlci = gsm->dlci[address];
 
 	switch (gsm->control) {


