Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427F84C7485
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbiB1Rp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239161AbiB1Rnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4601A88B0D;
        Mon, 28 Feb 2022 09:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10BE3614B9;
        Mon, 28 Feb 2022 17:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21505C340E7;
        Mon, 28 Feb 2022 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069748;
        bh=Aj8Bvvtsr7L/vKmvvYvbff75UEWBXBwwcFdt35525dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qv+Sq8kMAiEU2iW9NPCILsIAnggvXgy4Cr/xgdsN0S31HiH7odbt1kj6uCJ9+QqfW
         OwxZ9CybhMHwmh8XlMP7LCUKlxaq3zb+5tMWAAX0D67ZpErrqOI1QY0gwrscQ6v2hw
         nxpoUI9/NrV2+5tjyG/nWoNM256vDASToCbGzmPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.10 78/80] tty: n_gsm: fix deadlock in gsmtty_open()
Date:   Mon, 28 Feb 2022 18:24:59 +0100
Message-Id: <20220228172321.207530421@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
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

commit a2ab75b8e76e455af7867e3835fd9cdf386b508f upstream.

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
---
 drivers/tty/n_gsm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1426,6 +1426,9 @@ static void gsm_dlci_close(struct gsm_dl
 	if (dlci->addr != 0) {
 		tty_port_tty_hangup(&dlci->port, false);
 		kfifo_reset(&dlci->fifo);
+		/* Ensure that gsmtty_open() can return. */
+		tty_port_set_initialized(&dlci->port, 0);
+		wake_up_interruptible(&dlci->port.open_wait);
 	} else
 		dlci->gsm->dead = true;
 	wake_up(&dlci->gsm->event);


