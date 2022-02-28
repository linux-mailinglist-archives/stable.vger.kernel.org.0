Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92D64C6430
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 08:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiB1H6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 02:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbiB1H6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 02:58:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526902D1DB
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 23:58:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2189B80D84
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55401C340E7;
        Mon, 28 Feb 2022 07:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646035081;
        bh=xhMIE+O1yilKofqAifNCXGgOyOXuR7nZgO13U7sgAk4=;
        h=Subject:To:Cc:From:Date:From;
        b=0roskqIltXGOzcNQ8eVsJLIzHWRpgyK5plOYTvmfsqCL6gVs8wK6b9+crAOe+LPEX
         60LC/i4G7x1SJNcB5tawxgXx3jg3NL5wC362nrapDe0lm+XVUlNGBxxiLY363zPK94
         eZCzdJ3d6GLdPaJwkKfj7ExC+RG/P9NfjUfPHH/E=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix wrong tty control line for flow control" failed to apply to 4.14-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 08:57:46 +0100
Message-ID: <16460350665475@kroah.com>
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

From c19d93542a6081577e6da9bf5e887979c72e80c1 Mon Sep 17 00:00:00 2001
From: "daniel.starke@siemens.com" <daniel.starke@siemens.com>
Date: Thu, 17 Feb 2022 23:31:21 -0800
Subject: [PATCH] tty: n_gsm: fix wrong tty control line for flow control

tty flow control is handled via gsmtty_throttle() and gsmtty_unthrottle().
Both functions propagate the outgoing hardware flow control state to the
remote side via MSC (modem status command) frames. The local state is taken
from the RTS (ready to send) flag of the tty. However, RTS gets mapped to
DTR (data terminal ready), which is wrong.
This patch corrects this by mapping RTS to RTS.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220218073123.2121-5-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 79397a40a8f8..b4ddac0124b9 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -3243,9 +3243,9 @@ static void gsmtty_throttle(struct tty_struct *tty)
 	if (dlci->state == DLCI_CLOSED)
 		return;
 	if (C_CRTSCTS(tty))
-		dlci->modem_tx &= ~TIOCM_DTR;
+		dlci->modem_tx &= ~TIOCM_RTS;
 	dlci->throttled = true;
-	/* Send an MSC with DTR cleared */
+	/* Send an MSC with RTS cleared */
 	gsmtty_modem_update(dlci, 0);
 }
 
@@ -3255,9 +3255,9 @@ static void gsmtty_unthrottle(struct tty_struct *tty)
 	if (dlci->state == DLCI_CLOSED)
 		return;
 	if (C_CRTSCTS(tty))
-		dlci->modem_tx |= TIOCM_DTR;
+		dlci->modem_tx |= TIOCM_RTS;
 	dlci->throttled = false;
-	/* Send an MSC with DTR set */
+	/* Send an MSC with RTS set */
 	gsmtty_modem_update(dlci, 0);
 }
 

