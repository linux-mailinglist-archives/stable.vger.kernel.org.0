Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA3E1A0B54
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgDGKZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgDGKZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3232078A;
        Tue,  7 Apr 2020 10:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255127;
        bh=f7u6t0dNWjyMlScevwXX5sR0zzzxI9tSWctejazajBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxVde5hOT76mNtTnENEcRkQt1/jiD5oInfNH0UgHpks8W44ikzeJ4tJ+zxL68EHTw
         Z76fYPJ4wBY7wuPSnuQc1kS7biYW9dnPJjRG5KULB4dl3xlBjZ+r9tlRh4bIFYQHrt
         +v1bCKFIEgJSo/l8KRaEu0JgJS46la/CeX4aBkR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 41/46] tcp: fix TFO SYNACK undo to avoid double-timestamp-undo
Date:   Tue,  7 Apr 2020 12:22:12 +0200
Message-Id: <20200407101503.782719171@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

commit dad8cea7add96a353fa1898b5ccefbb72da66f29 upstream.

In a rare corner case the new logic for undo of SYNACK RTO could
result in triggering the warning in tcp_fastretrans_alert() that says:
        WARN_ON(tp->retrans_out != 0);

The warning looked like:

WARNING: CPU: 1 PID: 1 at net/ipv4/tcp_input.c:2818 tcp_ack+0x13e0/0x3270

The sequence that tickles this bug is:
 - Fast Open server receives TFO SYN with data, sends SYNACK
 - (client receives SYNACK and sends ACK, but ACK is lost)
 - server app sends some data packets
 - (N of the first data packets are lost)
 - server receives client ACK that has a TS ECR matching first SYNACK,
   and also SACKs suggesting the first N data packets were lost
    - server performs TS undo of SYNACK RTO, then immediately
      enters recovery
    - buggy behavior then performed a *second* undo that caused
      the connection to be in CA_Open with retrans_out != 0

Basically, the incoming ACK packet with SACK blocks causes us to first
undo the cwnd reduction from the SYNACK RTO, but then immediately
enters fast recovery, which then makes us eligible for undo again. And
then tcp_rcv_synrecv_state_fastopen() accidentally performs an undo
using a "mash-up" of state from two different loss recovery phases: it
uses the timestamp info from the ACK of the original SYNACK, and the
undo_marker from the fast recovery.

This fix refines the logic to only invoke the tcp_try_undo_loss()
inside tcp_rcv_synrecv_state_fastopen() if the connection is still in
CA_Loss.  If peer SACKs triggered fast recovery, then
tcp_rcv_synrecv_state_fastopen() can't safely undo.

Fixes: 794200d66273 ("tcp: undo cwnd on Fast Open spurious SYNACK retransmit")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_input.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6100,7 +6100,11 @@ static void tcp_rcv_synrecv_state_fastop
 {
 	struct request_sock *req;
 
-	tcp_try_undo_loss(sk, false);
+	/* If we are still handling the SYNACK RTO, see if timestamp ECR allows
+	 * undo. If peer SACKs triggered fast recovery, we can't undo here.
+	 */
+	if (inet_csk(sk)->icsk_ca_state == TCP_CA_Loss)
+		tcp_try_undo_loss(sk, false);
 
 	/* Reset rtx states to prevent spurious retransmits_timed_out() */
 	tcp_sk(sk)->retrans_stamp = 0;


