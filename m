Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA251859C
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiECNkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiECNkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:40:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9E42613C
        for <stable@vger.kernel.org>; Tue,  3 May 2022 06:36:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3414FB81ECE
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD25CC385A4;
        Tue,  3 May 2022 13:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651584987;
        bh=2RLTlxOZGknr05P4BbG36D9G6XqqcgsVamlcEMheWqM=;
        h=Subject:To:Cc:From:Date:From;
        b=saEMc+6PDOKu8KgamuTjWjoaDLiUK4iGmJLCBC3gMbPE9FU/FAvAXsrta6wDAaGhi
         ukdmCzfcRyIgjOPw5ZU1dQG42mIAL9bmlL16YKLlTuhz7O+1S2RjR3xqcj8H3Rvn0d
         1FbelPyRvoEfqV77YMxTsYGOEmhxfJLs3592aDRE=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix wrong signal octets encoding in MSC" failed to apply to 5.4-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 15:36:26 +0200
Message-ID: <16515849867422@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 317f86af7f5d19f286ed2d181cbaef4a188c7f19 Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Thu, 14 Apr 2022 02:42:18 -0700
Subject: [PATCH] tty: n_gsm: fix wrong signal octets encoding in MSC

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. The value of the modem status command (MSC) frame
contains an address field, control signal and optional break signal octet.
The address field is encoded as described in chapter 5.2.1.2 with only one
octet (may be extended to more in future versions of the standard). Whereas
the control signal and break signal octet are always one byte each. This is
strange at first glance as it makes the EA bit redundant. However, the same
two octets are also encoded as header in convergence layer type 2 as
described in chapter 5.5.2. No header length field is given and the only
way to test if there is an optional break signal octet is via the EA flag
which extends the control signal octet with a break signal octet. Now it
becomes obvious how the EA bit for those two octets shall be encoded in the
MSC frame. The current implementation treats the signal octet different for
MSC frame and convergence layer type 2 header even though the standard
describes it for both in the same way.
Use the EA bit to encode the signal octets not only in the convergence
layer type 2 header but also in the MSC frame in the same way with either
1 or 2 bytes in case of an optional break signal. Adjust the receiving path
accordingly in gsm_control_modem().

Fixes: 3ac06b905655 ("tty: n_gsm: Fix for modems with brk in modem status control")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-13-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 903278145078..23418ee93156 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1094,7 +1094,6 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 {
 	unsigned int addr = 0;
 	unsigned int modem = 0;
-	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
 	int slen;
@@ -1124,17 +1123,8 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 			return;
 	}
 	len--;
-	if (len > 0) {
-		while (gsm_read_ea(&brk, *dp++) == 0) {
-			len--;
-			if (len == 0)
-				return;
-		}
-		modem <<= 7;
-		modem |= (brk & 0x7f);
-	}
 	tty = tty_port_tty_get(&dlci->port);
-	gsm_process_modem(tty, dlci, modem, slen);
+	gsm_process_modem(tty, dlci, modem, slen - len);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
@@ -2963,8 +2953,10 @@ static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk)
 	int len = 2;
 
 	modembits[0] = (dlci->addr << 2) | 2 | EA;  /* DLCI, Valid, EA */
-	modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
-	if (brk) {
+	if (!brk) {
+		modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
+	} else {
+		modembits[1] = gsm_encode_modem(dlci) << 1;
 		modembits[2] = (brk << 4) | 2 | EA; /* Length, Break, EA */
 		len++;
 	}

