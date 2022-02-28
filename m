Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C0C4C642C
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 08:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiB1H6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 02:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiB1H63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 02:58:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2D121833
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 23:57:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36E49CE0B3C
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33969C340E7;
        Mon, 28 Feb 2022 07:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646035067;
        bh=t8wmtwP/358aESCQFLtpMzzu9h5HJsHLaiLPNij+ljc=;
        h=Subject:To:Cc:From:Date:From;
        b=F43rny9xYLtL7mv1Ub309UFkPpAYfmMmqtsib2Fx/raVCwOWbJzl0InN4HamxgJkv
         oe2IIZJdI5KEDWEeuhgy76zqztK7t3hUGv0jc8+wrwdFaNONhHszoSslM5fbkfqO2G
         C0IYvXYDVxcoo9QUTd7HppTk5U2F4TRA4Usxr7Hw=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix wrong tty control line for flow control" failed to apply to 5.4-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 08:57:45 +0100
Message-ID: <1646035065120106@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
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
 

