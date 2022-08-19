Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCDE59A247
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353148AbiHSQdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353699AbiHSQcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B90F205E5;
        Fri, 19 Aug 2022 09:06:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9773D61811;
        Fri, 19 Aug 2022 16:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821A0C433D6;
        Fri, 19 Aug 2022 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925191;
        bh=yM6Gm8/7p489BZuA7bw0SIeXTgB+Ge/M4R3DX6zqehQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQXKpSOLVQLzwkEA8/FOOwme1B41DlbYDB1s5TrlPGsL8GLD5WTwwsXTAKkmPyvg3
         KDRCBb6A6izu8g3/McIUuC14YwSu4+Jhkpp91RK83pVjn9O/7sCLaZY7dI2Gc3GSay
         au8xsYQYgzILNkheiLH/jxxKQ8vikciB7izcCcbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/545] tty: n_gsm: fix wrong queuing behavior in gsm_dlci_data_output()
Date:   Fri, 19 Aug 2022 17:42:33 +0200
Message-Id: <20220819153846.553765353@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 556fc8ac06513cced381588d6d58c184d95cc4fe ]

1) The function drains the fifo for the given user tty/DLCI without
considering 'TX_THRESH_HI' and different to gsm_dlci_data_output_framed(),
which moves only one packet from the user side to the internal transmission
queue. We can only handle one packet at a time here if we want to allow
DLCI priority handling in gsm_dlci_data_sweep() to avoid link starvation.
2) Furthermore, the additional header octet from convergence layer type 2
is not counted against MTU. It is part of the UI/UIH frame message which
needs to be limited to MTU. Hence, it is wrong not to consider this octet.
3) Finally, the waiting user tty is not informed about freed space in its
send queue.

Take at most one packet worth of data out of the DLCI fifo to fix 1).
Limit the max user data size per packet to MTU - 1 in case of convergence
layer type 2 to leave space for the control signal octet which is added in
the later part of the function. This fixes 2).
Add tty_port_tty_wakeup() to wake up the user tty if new write space has
been made available to fix 3).

Fixes: 268e526b935e ("tty/n_gsm: avoid fifo overflow in gsm_dlci_data_output")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701061652.39604-3-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 74 +++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c95f7d8314fc..cb8de8d61265 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -795,41 +795,51 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 {
 	struct gsm_msg *msg;
 	u8 *dp;
-	int len, total_size, size;
-	int h = dlci->adaption - 1;
+	int h, len, size;
 
-	total_size = 0;
-	while (1) {
-		len = kfifo_len(&dlci->fifo);
-		if (len == 0)
-			return total_size;
-
-		/* MTU/MRU count only the data bits */
-		if (len > gsm->mtu)
-			len = gsm->mtu;
-
-		size = len + h;
-
-		msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
-		/* FIXME: need a timer or something to kick this so it can't
-		   get stuck with no work outstanding and no buffer free */
-		if (msg == NULL)
-			return -ENOMEM;
-		dp = msg->data;
-		switch (dlci->adaption) {
-		case 1:	/* Unstructured */
-			break;
-		case 2:	/* Unstructed with modem bits.
-		Always one byte as we never send inline break data */
-			*dp++ = (gsm_encode_modem(dlci) << 1) | EA;
-			break;
-		}
-		WARN_ON(kfifo_out_locked(&dlci->fifo, dp , len, &dlci->lock) != len);
-		__gsm_data_queue(dlci, msg);
-		total_size += size;
+	/* for modem bits without break data */
+	h = ((dlci->adaption == 1) ? 0 : 1);
+
+	len = kfifo_len(&dlci->fifo);
+	if (len == 0)
+		return 0;
+
+	/* MTU/MRU count only the data bits but watch adaption mode */
+	if ((len + h) > gsm->mtu)
+		len = gsm->mtu - h;
+
+	size = len + h;
+
+	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
+	/* FIXME: need a timer or something to kick this so it can't
+	 * get stuck with no work outstanding and no buffer free
+	 */
+	if (!msg)
+		return -ENOMEM;
+	dp = msg->data;
+	switch (dlci->adaption) {
+	case 1: /* Unstructured */
+		break;
+	case 2: /* Unstructured with modem bits.
+		 * Always one byte as we never send inline break data
+		 */
+		*dp++ = (gsm_encode_modem(dlci) << 1) | EA;
+		break;
+	default:
+		pr_err("%s: unsupported adaption %d\n", __func__,
+		       dlci->adaption);
+		break;
 	}
+
+	WARN_ON(len != kfifo_out_locked(&dlci->fifo, dp, len,
+		&dlci->lock));
+
+	/* Notify upper layer about available send space. */
+	tty_port_tty_wakeup(&dlci->port);
+
+	__gsm_data_queue(dlci, msg);
 	/* Bytes of data we used up */
-	return total_size;
+	return size;
 }
 
 /**
-- 
2.35.1



