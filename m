Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5639543A290
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhJYTuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238065AbhJYTr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:47:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 049F261214;
        Mon, 25 Oct 2021 19:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190849;
        bh=JemFNvA4/QXcof/Gj6LnAX7JPYug6cOblT0fkwSJ7MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPyJHUOpUb1fG3qNFHATEhBFDf5E4Yn3UNajLyzS/GT31hmzGDKhdCY9lM5Pn6NfE
         3MTyFKi/eaeTGGDqxQcItA6fCqRIp5jQoejA2XG1vb8Nh8uUO8J8aASGazOEhY0bgz
         4cJG8yqstLZjhhFQHjTDt050G6SsTDyhm3nKcOkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Sottas Guillaume (LMB)" <Guillaume.Sottas@liebherr.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.14 068/169] can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path
Date:   Mon, 25 Oct 2021 21:14:09 +0200
Message-Id: <20211025191026.106618535@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d674a8f123b4096d85955c7eaabec688f29724c9 upstream.

When the a large chunk of data send and the receiver does not send a
Flow Control frame back in time, the sendmsg() does not return a error
code, but the number of bytes sent corresponding to the size of the
packet.

If a timeout occurs the isotp_tx_timer_handler() is fired, sets
sk->sk_err and calls the sk->sk_error_report() function. It was
wrongly expected that the error would be propagated to user space in
every case. For isotp_sendmsg() blocking on wait_event_interruptible()
this is not the case.

This patch fixes the problem by checking if sk->sk_err is set and
returning the error to user space.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://github.com/hartkopp/can-isotp/issues/42
Link: https://github.com/hartkopp/can-isotp/pull/43
Link: https://lore.kernel.org/all/20210507091839.1366379-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Reported-by: Sottas Guillaume (LMB) <Guillaume.Sottas@liebherr.com>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -960,6 +960,9 @@ static int isotp_sendmsg(struct socket *
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
 		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+
+		if (sk->sk_err)
+			return -sk->sk_err;
 	}
 
 	return size;


