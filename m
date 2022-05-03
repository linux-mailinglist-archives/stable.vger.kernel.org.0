Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990C45185C5
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbiECNos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiECNop (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:44:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DFD1A819
        for <stable@vger.kernel.org>; Tue,  3 May 2022 06:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F3D2B81EC8
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7316C385A9;
        Tue,  3 May 2022 13:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651585270;
        bh=9kqDcOFHL8vDE2jbdVt+2eHh9OuOPLr18Uq3ra6a+NU=;
        h=Subject:To:Cc:From:Date:From;
        b=ICJbiHUMKRR8F79WBNJfDlaUJTlmY7on+015goHBp+vzsZF5qHemGZLsdOwoq2enJ
         3Fu9zZ4++7Lm5ijGiVA89Xp39GzzNJsmr02AHijhI79hsNULU094xHN/vUJH1vWHpM
         oxmWFvEFEd/resyx/5kNQ+nApEeXXCU+tOgOydYM=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix software flow control handling" failed to apply to 4.9-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 15:41:08 +0200
Message-ID: <165158526816122@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f4f7d63287217ba25e5c80f5faae5e4f7118790e Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Fri, 22 Apr 2022 00:10:25 -0700
Subject: [PATCH] tty: n_gsm: fix software flow control handling

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.4.8.1 states that XON/XOFF characters
shall be used instead of Fcon/Fcoff command in advanced option mode to
handle flow control. Chapter 5.4.8.2 describes how XON/XOFF characters
shall be handled. Basic option mode only used Fcon/Fcoff commands and no
XON/XOFF characters. These are treated as data bytes here.
The current implementation uses the gsm_mux field 'constipated' to handle
flow control from the remote peer and the gsm_dlci field 'constipated' to
handle flow control from each DLCI. The later is unrelated to this patch.
The gsm_mux field is correctly set for Fcon/Fcoff commands in
gsm_control_message(). However, the same is not true for XON/XOFF
characters in gsm1_receive().
Disable software flow control handling in the tty to allow explicit
handling by n_gsm.
Add the missing handling in advanced option mode for gsm_mux in
gsm1_receive() to comply with the standard.

This patch depends on the following commit:
Commit 8838b2af23ca ("tty: n_gsm: fix SW flow control encoding/handling")

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220422071025.5490-3-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 570f0b8b7576..8652308c187f 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -232,6 +232,7 @@ struct gsm_mux {
 	int initiator;			/* Did we initiate connection */
 	bool dead;			/* Has the mux been shut down */
 	struct gsm_dlci *dlci[NUM_DLCI];
+	int old_c_iflag;		/* termios c_iflag value before attach */
 	bool constipated;		/* Asked by remote to shut up */
 
 	spinlock_t tx_lock;
@@ -2022,6 +2023,16 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 
 static void gsm1_receive(struct gsm_mux *gsm, unsigned char c)
 {
+	/* handle XON/XOFF */
+	if ((c & ISO_IEC_646_MASK) == XON) {
+		gsm->constipated = true;
+		return;
+	} else if ((c & ISO_IEC_646_MASK) == XOFF) {
+		gsm->constipated = false;
+		/* Kick the link in case it is idling */
+		gsm_data_kick(gsm, NULL);
+		return;
+	}
 	if (c == GSM1_SOF) {
 		/* EOF is only valid in frame if we have got to the data state */
 		if (gsm->state == GSM_DATA) {
@@ -2449,6 +2460,9 @@ static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 	int ret, i;
 
 	gsm->tty = tty_kref_get(tty);
+	/* Turn off tty XON/XOFF handling to handle it explicitly. */
+	gsm->old_c_iflag = tty->termios.c_iflag;
+	tty->termios.c_iflag &= (IXON | IXOFF);
 	ret =  gsm_activate_mux(gsm);
 	if (ret != 0)
 		tty_kref_put(gsm->tty);
@@ -2489,6 +2503,8 @@ static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 	WARN_ON(tty != gsm->tty);
 	for (i = 1; i < NUM_DLCI; i++)
 		tty_unregister_device(gsm_tty_driver, base + i);
+	/* Restore tty XON/XOFF handling. */
+	gsm->tty->termios.c_iflag = gsm->old_c_iflag;
 	tty_kref_put(gsm->tty);
 	gsm->tty = NULL;
 }

