Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703E451A81D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353719AbiEDRIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354435AbiEDRCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:02:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B724C79D;
        Wed,  4 May 2022 09:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 920B36187C;
        Wed,  4 May 2022 16:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B24C385BF;
        Wed,  4 May 2022 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683141;
        bh=PhRXsatzWHvqXGivsWYtvZ8yGMRSGmpPSv6ugCS06DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fingn4BT3pioKZTsqKGZcuFaqEJVR8BtJsOgd8QvzBeeuMvrucN9Ce8k/vHhl1UC/
         7wK6P1mwJ9rHS9oH+j83w2jqtt2ZUGdEs4p5KCp+b+EFZh6dgZcF/kob289eVUSVnl
         Rht+b7gniJKLGiGr7hymaoLePM6mHVRqmFTN6AIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.10 128/129] tty: n_gsm: fix software flow control handling
Date:   Wed,  4 May 2022 18:45:20 +0200
Message-Id: <20220504153031.816518089@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

commit f4f7d63287217ba25e5c80f5faae5e4f7118790e upstream.

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
---
 drivers/tty/n_gsm.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -232,6 +232,7 @@ struct gsm_mux {
 	int initiator;			/* Did we initiate connection */
 	bool dead;			/* Has the mux been shut down */
 	struct gsm_dlci *dlci[NUM_DLCI];
+	int old_c_iflag;		/* termios c_iflag value before attach */
 	bool constipated;		/* Asked by remote to shut up */
 
 	spinlock_t tx_lock;
@@ -1960,6 +1961,16 @@ static void gsm0_receive(struct gsm_mux
 
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
 		/* EOF is only valid in frame if we have got to the data state
 		   and received at least one byte (the FCS) */
@@ -2378,6 +2389,9 @@ static int gsmld_attach_gsm(struct tty_s
 	int ret, i;
 
 	gsm->tty = tty_kref_get(tty);
+	/* Turn off tty XON/XOFF handling to handle it explicitly. */
+	gsm->old_c_iflag = tty->termios.c_iflag;
+	tty->termios.c_iflag &= (IXON | IXOFF);
 	ret =  gsm_activate_mux(gsm);
 	if (ret != 0)
 		tty_kref_put(gsm->tty);
@@ -2418,6 +2432,8 @@ static void gsmld_detach_gsm(struct tty_
 	WARN_ON(tty != gsm->tty);
 	for (i = 1; i < NUM_DLCI; i++)
 		tty_unregister_device(gsm_tty_driver, base + i);
+	/* Restore tty XON/XOFF handling. */
+	gsm->tty->termios.c_iflag = gsm->old_c_iflag;
 	tty_kref_put(gsm->tty);
 	gsm->tty = NULL;
 }


