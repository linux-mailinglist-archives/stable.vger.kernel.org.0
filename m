Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB44C6435
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 08:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiB1H7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 02:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiB1H7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 02:59:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26D62FFCC
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 23:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F06561119
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F45C340E7;
        Mon, 28 Feb 2022 07:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646035102;
        bh=BxtPDgDSi+le7oDWXGq6FSJg6H7LWuPa491c0FIMyq0=;
        h=Subject:To:Cc:From:Date:From;
        b=g5lFM0kcMNdn57i2ljrcKyOA2UVn7M6i1plLsNjoOTRN+j0ne5MMkuL1KbB1sPI3r
         +AhHGCc+jOjFAPOHaxTeTYuF7kkcXbWvrbqpNNaM/pK/6q8Ok20owJkewuUuA9NLK6
         T8svJvFQLDuHlL7GTzTfC1toGBy6Vbhr484uTCmQ=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix wrong modem processing in convergence layer" failed to apply to 4.14-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 08:58:14 +0100
Message-ID: <1646035094217176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 687f9ad43c52501f46164758e908a5dd181a87fc Mon Sep 17 00:00:00 2001
From: "daniel.starke@siemens.com" <daniel.starke@siemens.com>
Date: Thu, 17 Feb 2022 23:31:22 -0800
Subject: [PATCH] tty: n_gsm: fix wrong modem processing in convergence layer
 type 2

The function gsm_process_modem() exists to handle modem status bits of
incoming frames. This includes incoming MSC (modem status command) frames
and convergence layer type 2 data frames. The function, however, was only
designed to handle MSC frames as it expects the command length. Within
gsm_dlci_data() it is wrongly assumed that this is the same as the data
frame length. This is only true if the data frame contains only 1 byte of
payload.

This patch names the length parameter of gsm_process_modem() in a generic
manner to reflect its association. It also corrects all calls to the
function to handle the variable number of modem status octets correctly in
both cases.

Fixes: 7263287af93d ("tty: n_gsm: Fixed logic to decode break signal from modem status")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220218073123.2121-6-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index b4ddac0124b9..8ff5c0c61233 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1021,25 +1021,25 @@ static void gsm_control_reply(struct gsm_mux *gsm, int cmd, const u8 *data,
  *	@tty: virtual tty bound to the DLCI
  *	@dlci: DLCI to affect
  *	@modem: modem bits (full EA)
- *	@clen: command length
+ *	@slen: number of signal octets
  *
  *	Used when a modem control message or line state inline in adaption
  *	layer 2 is processed. Sort out the local modem state and throttles
  */
 
 static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
-							u32 modem, int clen)
+							u32 modem, int slen)
 {
 	int  mlines = 0;
 	u8 brk = 0;
 	int fc;
 
-	/* The modem status command can either contain one octet (v.24 signals)
-	   or two octets (v.24 signals + break signals). The length field will
-	   either be 2 or 3 respectively. This is specified in section
-	   5.4.6.3.7 of the  27.010 mux spec. */
+	/* The modem status command can either contain one octet (V.24 signals)
+	 * or two octets (V.24 signals + break signals). This is specified in
+	 * section 5.4.6.3.7 of the 07.10 mux spec.
+	 */
 
-	if (clen == 2)
+	if (slen == 1)
 		modem = modem & 0x7f;
 	else {
 		brk = modem & 0x7f;
@@ -1096,6 +1096,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
+	int slen;
 	const u8 *dp = data;
 	struct tty_struct *tty;
 
@@ -1115,6 +1116,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 		return;
 	dlci = gsm->dlci[addr];
 
+	slen = len;
 	while (gsm_read_ea(&modem, *dp++) == 0) {
 		len--;
 		if (len == 0)
@@ -1131,7 +1133,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 		modem |= (brk & 0x7f);
 	}
 	tty = tty_port_tty_get(&dlci->port);
-	gsm_process_modem(tty, dlci, modem, clen);
+	gsm_process_modem(tty, dlci, modem, slen);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
@@ -1597,6 +1599,7 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 	struct tty_struct *tty;
 	unsigned int modem = 0;
 	int len = clen;
+	int slen = 0;
 
 	if (debug & 16)
 		pr_debug("%d bytes for tty\n", len);
@@ -1609,12 +1612,14 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 	case 2:		/* Asynchronous serial with line state in each frame */
 		while (gsm_read_ea(&modem, *data++) == 0) {
 			len--;
+			slen++;
 			if (len == 0)
 				return;
 		}
+		slen++;
 		tty = tty_port_tty_get(port);
 		if (tty) {
-			gsm_process_modem(tty, dlci, modem, clen);
+			gsm_process_modem(tty, dlci, modem, slen);
 			tty_kref_put(tty);
 		}
 		fallthrough;

