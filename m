Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5806A59446F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348580AbiHOWcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351255AbiHOW2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:28:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33866F563;
        Mon, 15 Aug 2022 12:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89038B80EAD;
        Mon, 15 Aug 2022 19:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E71C433C1;
        Mon, 15 Aug 2022 19:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592867;
        bh=Rtw4ue+iKL+T8cp7diolRRRhtkzE1UQULkLc8KNMEY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETeuLoTbzY7bM/aopX3x3dBLjpMr7EJ3BIA/rNvzTrF05OHBLBvE9kYA3c2j/v6oj
         J7+kmu4r2lfZpB9eabus78bvGvs0BAcmSCTHrdsGi6Ijna8/0FkxVb6yTOnSxLTsCN
         P0XIlaz3XzToX7MiDUIYOMDtFHtHVNzaiLCNd1pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0856/1095] tty: n_gsm: fix wrong queuing behavior in gsm_dlci_data_output()
Date:   Mon, 15 Aug 2022 20:04:15 +0200
Message-Id: <20220815180504.732286635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index e80713a9d204..658d8f6e3a7d 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -886,41 +886,51 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
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



