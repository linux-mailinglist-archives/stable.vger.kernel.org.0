Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A444C643A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 08:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiB1H7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 02:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbiB1H73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 02:59:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61E246B26
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 23:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8439FB80DD3
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE9AC340E7;
        Mon, 28 Feb 2022 07:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646035128;
        bh=Xyehr0/i3SQp1WHzokRsJnRY3ZM6dwdhX2R/e85EUeA=;
        h=Subject:To:Cc:From:Date:From;
        b=oUrlvhOYKI6aSgeELEoKutBROMCyxwshSC97mRvz3XSj4XlUib7JCj2hdtmY0Es+n
         pDnhgzGCnxvJJZ7tEbFf3JNmicdcXKZ0novpJLTUdhFzCI1wHS4swYKVq9mhCLeaTm
         MZaOczH61znJjJCllWcQySrmHeZtSHJ1Bu7hf0OU=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix deadlock in gsmtty_open()" failed to apply to 4.9-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 08:58:36 +0100
Message-ID: <16460351166124@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a2ab75b8e76e455af7867e3835fd9cdf386b508f Mon Sep 17 00:00:00 2001
From: "daniel.starke@siemens.com" <daniel.starke@siemens.com>
Date: Thu, 17 Feb 2022 23:31:23 -0800
Subject: [PATCH] tty: n_gsm: fix deadlock in gsmtty_open()

In the current implementation the user may open a virtual tty which then
could fail to establish the underlying DLCI. The function gsmtty_open()
gets stuck in tty_port_block_til_ready() while waiting for a carrier rise.
This happens if the remote side fails to acknowledge the link establishment
request in time or completely. At some point gsm_dlci_close() is called
to abort the link establishment attempt. The function tries to inform the
associated virtual tty by performing a hangup. But the blocking loop within
tty_port_block_til_ready() is not informed about this event.
The patch proposed here fixes this by resetting the initialization state of
the virtual tty to ensure the loop exits and triggering it to make
tty_port_block_til_ready() return.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220218073123.2121-7-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 8ff5c0c61233..fa92f727fdf8 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1457,6 +1457,9 @@ static void gsm_dlci_close(struct gsm_dlci *dlci)
 	if (dlci->addr != 0) {
 		tty_port_tty_hangup(&dlci->port, false);
 		kfifo_reset(&dlci->fifo);
+		/* Ensure that gsmtty_open() can return. */
+		tty_port_set_initialized(&dlci->port, 0);
+		wake_up_interruptible(&dlci->port.open_wait);
 	} else
 		dlci->gsm->dead = true;
 	/* Unregister gsmtty driver,report gsmtty dev remove uevent for user */

