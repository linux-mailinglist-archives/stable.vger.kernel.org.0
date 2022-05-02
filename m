Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280A6517A90
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 01:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiEBXTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 19:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiEBXTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 19:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C162CCB9
        for <stable@vger.kernel.org>; Mon,  2 May 2022 16:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61479B81A65
        for <stable@vger.kernel.org>; Mon,  2 May 2022 23:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DE7C385AC;
        Mon,  2 May 2022 23:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651533360;
        bh=CBOVF7sonE8sYektshsCgol6fnxPhT8NFY5fGtDhyHc=;
        h=Subject:To:Cc:From:Date:From;
        b=Iad9XeCHg1nMtVFgnpqQJJ2b6ArbWrX8XHDgvqjg0V7+vw5aWbDWZqsb0gGW7cOPS
         6/1NV1DVCOS+Kl1lkggjQZx0V4O6zMW2Pncm4W0f2KhgMIFenvUIXLJ6mOpRYaTuZ2
         hbnRLoJkaFPRXyllgFFVQt5A3eSL20G779FR4JGI=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix mux cleanup after unregister tty device" failed to apply to 4.9-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 01:15:52 +0200
Message-ID: <165153335228185@kroah.com>
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

From 284260f278b706364fb4c88a7b56ba5298d5973c Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Thu, 14 Apr 2022 02:42:09 -0700
Subject: [PATCH] tty: n_gsm: fix mux cleanup after unregister tty device

Internally, we manage the alive state of the mux channels and mux itself
with the field member 'dead'. This makes it possible to notify the user
if the accessed underlying link is already gone. On the other hand,
however, removing the virtual ttys before terminating the channels may
result in peer messages being received without any internal target. Move
the mux cleanup procedure from gsmld_detach_gsm() to gsmld_close() to fix
this by keeping the virtual ttys open until the mux has been cleaned up.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-4-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index f546dfe03d29..de97a3810731 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2479,7 +2479,6 @@ static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 		for (i = 1; i < NUM_DLCI; i++)
 			tty_unregister_device(gsm_tty_driver, base + i);
 	}
-	gsm_cleanup_mux(gsm, false);
 	tty_kref_put(gsm->tty);
 	gsm->tty = NULL;
 }
@@ -2544,6 +2543,12 @@ static void gsmld_close(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm = tty->disc_data;
 
+	/* The ldisc locks and closes the port before calling our close. This
+	 * means we have no way to do a proper disconnect. We will not bother
+	 * to do one.
+	 */
+	gsm_cleanup_mux(gsm, false);
+
 	gsmld_detach_gsm(tty, gsm);
 
 	gsmld_flush_buffer(tty);

