Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813B114E2B8
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgA3Sxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730118AbgA3SlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:41:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE30F2082E;
        Thu, 30 Jan 2020 18:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409673;
        bh=byCXBGSQFZqwCBWUAMGSYw1vJeHlsfyIX9xMMhCO7R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRdsOXD/Rq7pXBYlJAcB9dqvV4fDFVLnPQmftuyLDVbdtaIamWqqrLg2WJmupBsme
         ROOOkOstJu7F1NhLRb5wBu25uOx2ENUMqlVFyidp6DWYEkkQmrJDqGEPu2ZadwcEd0
         p8do6Gt/MmchZtKpkTIpdHzPe9x1xxMRE9UvvyW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 45/56] rxrpc: Fix use-after-free in rxrpc_receive_data()
Date:   Thu, 30 Jan 2020 19:39:02 +0100
Message-Id: <20200130183617.195550238@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 122d74fac84204b9a98263636f6f9a3b2e665639 ]

The subpacket scanning loop in rxrpc_receive_data() references the
subpacket count in the private data part of the sk_buff in the loop
termination condition.  However, when the final subpacket is pasted into
the ring buffer, the function is no longer has a ref on the sk_buff and
should not be looking at sp->* any more.  This point is actually marked in
the code when skb is cleared (but sp is not - which is an error).

Fix this by caching sp->nr_subpackets in a local variable and using that
instead.

Also clear 'sp' to catch accesses after that point.

This can show up as an oops in rxrpc_get_skb() if sp->nr_subpackets gets
trashed by the sk_buff getting freed and reused in the meantime.

Fixes: e2de6c404898 ("rxrpc: Use info in skbuff instead of reparsing a jumbo packet")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -413,7 +413,7 @@ static void rxrpc_input_data(struct rxrp
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	enum rxrpc_call_state state;
-	unsigned int j;
+	unsigned int j, nr_subpackets;
 	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = 0;
 	rxrpc_seq_t seq0 = sp->hdr.seq, hard_ack;
 	bool immediate_ack = false, jumbo_bad = false;
@@ -457,7 +457,8 @@ static void rxrpc_input_data(struct rxrp
 	call->ackr_prev_seq = seq0;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
 
-	if (sp->nr_subpackets > 1) {
+	nr_subpackets = sp->nr_subpackets;
+	if (nr_subpackets > 1) {
 		if (call->nr_jumbo_bad > 3) {
 			ack = RXRPC_ACK_NOSPACE;
 			ack_serial = serial;
@@ -465,11 +466,11 @@ static void rxrpc_input_data(struct rxrp
 		}
 	}
 
-	for (j = 0; j < sp->nr_subpackets; j++) {
+	for (j = 0; j < nr_subpackets; j++) {
 		rxrpc_serial_t serial = sp->hdr.serial + j;
 		rxrpc_seq_t seq = seq0 + j;
 		unsigned int ix = seq & RXRPC_RXTX_BUFF_MASK;
-		bool terminal = (j == sp->nr_subpackets - 1);
+		bool terminal = (j == nr_subpackets - 1);
 		bool last = terminal && (sp->rx_flags & RXRPC_SKB_INCL_LAST);
 		u8 flags, annotation = j;
 
@@ -506,7 +507,7 @@ static void rxrpc_input_data(struct rxrp
 		}
 
 		if (call->rxtx_buffer[ix]) {
-			rxrpc_input_dup_data(call, seq, sp->nr_subpackets > 1,
+			rxrpc_input_dup_data(call, seq, nr_subpackets > 1,
 					     &jumbo_bad);
 			if (ack != RXRPC_ACK_DUPLICATE) {
 				ack = RXRPC_ACK_DUPLICATE;
@@ -564,6 +565,7 @@ static void rxrpc_input_data(struct rxrp
 			 * ring.
 			 */
 			skb = NULL;
+			sp = NULL;
 		}
 
 		if (last) {


