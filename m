Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E71157B0D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBJN1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728457AbgBJMgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:38 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF0482080C;
        Mon, 10 Feb 2020 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338198;
        bh=RFgo86AgtcQiK8ya9+btawEpmHzxa7nsZHx6nqzGrKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naJLGMemygtS3BqivfPkNYfzzemc3mwwZRB8pd+lehVqDkaKYpbnaItczKo/QoC/Y
         iHR/jrui/TGZyf8ro3JEVscy9pVQeEi59aeFzGokro0JTWJfIEFrq/qODeJFf0xjH/
         Bpm4j6LZZxH2SEb15+YaMFgx0B9XRwsKs3XdW/m8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.4 011/309] rxrpc: Fix insufficient receive notification generation
Date:   Mon, 10 Feb 2020 04:29:27 -0800
Message-Id: <20200210122407.130550741@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit f71dbf2fb28489a79bde0dca1c8adfb9cdb20a6b ]

In rxrpc_input_data(), rxrpc_notify_socket() is called if the base sequence
number of the packet is immediately following the hard-ack point at the end
of the function.  However, this isn't sufficient, since the recvmsg side
may have been advancing the window and then overrun the position in which
we're adding - at which point rx_hard_ack >= seq0 and no notification is
generated.

Fix this by always generating a notification at the end of the input
function.

Without this, a long call may stall, possibly indefinitely.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -599,10 +599,8 @@ ack:
 				  false, true,
 				  rxrpc_propose_ack_input_data);
 
-	if (seq0 == READ_ONCE(call->rx_hard_ack) + 1) {
-		trace_rxrpc_notify_socket(call->debug_id, serial);
-		rxrpc_notify_socket(call);
-	}
+	trace_rxrpc_notify_socket(call->debug_id, serial);
+	rxrpc_notify_socket(call);
 
 unlock:
 	spin_unlock(&call->input_lock);


