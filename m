Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76623529121
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbiEPUKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351037AbiEPUB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A201F47559;
        Mon, 16 May 2022 12:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CB58B81613;
        Mon, 16 May 2022 19:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EB3C34100;
        Mon, 16 May 2022 19:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731022;
        bh=l9vK0Sdh9FgyGUOPCCX0OfhhDLvjeRSbXgox8Ua7K8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODrElaCuyQu9AEV1at5L/hGuAFwKMBsA9+qyGJuWfNYvlT6Lyv4j87Jb37w4mcDPq
         ggDjeSERFmAlM0x6oY1JXr3NHzz8GvjzSqAph1L5rxiC8sNON/n9BwsRaTs7P846dO
         qtWtd2FvrVvjGV8wywcUXXdnw0Tq/jYkiduJeC7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 078/114] tty: n_gsm: fix invalid gsmtty_write_room() result
Date:   Mon, 16 May 2022 21:36:52 +0200
Message-Id: <20220516193627.725542986@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

commit 9361ebfbb79fd1bc8594a487c01ad52cdaa391ea upstream.

gsmtty_write() does not prevent the user to use the full fifo size of 4096
bytes as allocated in gsm_dlci_alloc(). However, gsmtty_write_room() tries
to limit the return value by 'TX_SIZE' and returns a negative value if the
fifo has more than 'TX_SIZE' bytes stored. This is obviously wrong as
'TX_SIZE' is defined as 512.
Define 'TX_SIZE' to the fifo size and use it accordingly for allocation to
keep the current behavior. Return the correct remaining size of the fifo in
gsmtty_write_room() via kfifo_avail().

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220504081733.3494-3-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -137,6 +137,7 @@ struct gsm_dlci {
 	int retries;
 	/* Uplink tty if active */
 	struct tty_port port;	/* The tty bound to this DLCI if there is one */
+#define TX_SIZE		4096    /* Must be power of 2. */
 	struct kfifo fifo;	/* Queue fifo for the DLCI */
 	int adaption;		/* Adaption layer in use */
 	int prev_adaption;
@@ -1731,7 +1732,7 @@ static struct gsm_dlci *gsm_dlci_alloc(s
 		return NULL;
 	spin_lock_init(&dlci->lock);
 	mutex_init(&dlci->mutex);
-	if (kfifo_alloc(&dlci->fifo, 4096, GFP_KERNEL) < 0) {
+	if (kfifo_alloc(&dlci->fifo, TX_SIZE, GFP_KERNEL) < 0) {
 		kfree(dlci);
 		return NULL;
 	}
@@ -2976,8 +2977,6 @@ static struct tty_ldisc_ops tty_ldisc_pa
  *	Virtual tty side
  */
 
-#define TX_SIZE		512
-
 /**
  *	gsm_modem_upd_via_data	-	send modem bits via convergence layer
  *	@dlci: channel
@@ -3217,7 +3216,7 @@ static unsigned int gsmtty_write_room(st
 	struct gsm_dlci *dlci = tty->driver_data;
 	if (dlci->state == DLCI_CLOSED)
 		return 0;
-	return TX_SIZE - kfifo_len(&dlci->fifo);
+	return kfifo_avail(&dlci->fifo);
 }
 
 static unsigned int gsmtty_chars_in_buffer(struct tty_struct *tty)


