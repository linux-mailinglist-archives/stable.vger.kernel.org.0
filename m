Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759B04727A9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhLMKEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45284 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239898AbhLMJ7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:59:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C39E5B80EA0;
        Mon, 13 Dec 2021 09:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8299EC34604;
        Mon, 13 Dec 2021 09:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389537;
        bh=WzlMa0/3NYbjLw5fA/OjUm4ZUClzZdT8yljui0qPCD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTprtx+uKZbmURGB1lo5sn/C0rmRPUrkwIajR+K+gECePX8nJpE3rJuK+JwravxN7
         /n+YwFpxs3a/3urUvtv/x2HX792uOHkhm1ia0rS3vKUA3NPab6Fwgw9Wk73b4HiY38
         ejjDGn+rHe9RHwZHsx9EW2U34zpxO8gAD6P0/WaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 122/171] bpf, sockmap: Re-evaluate proto ops when psock is removed from sockmap
Date:   Mon, 13 Dec 2021 10:30:37 +0100
Message-Id: <20211213092949.164172809@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit c0d95d3380ee099d735e08618c0d599e72f6c8b0 upstream.

When a sock is added to a sock map we evaluate what proto op hooks need to
be used. However, when the program is removed from the sock map we have not
been evaluating if that changes the required program layout.

Before the patch listed in the 'fixes' tag this was not causing failures
because the base program set handles all cases. Specifically, the case with
a stream parser and the case with out a stream parser are both handled. With
the fix below we identified a race when running with a proto op that attempts
to read skbs off both the stream parser and the skb->receive_queue. Namely,
that a race existed where when the stream parser is empty checking the
skb->receive_queue from recvmsg at the precies moment when the parser is
paused and the receive_queue is not empty could result in skipping the stream
parser. This may break a RX policy depending on the parser to run.

The fix tag then loads a specific proto ops that resolved this race. But, we
missed removing that proto ops recv hook when the sock is removed from the
sockmap. The result is the stream parser is stopped so no more skbs will be
aggregated there, but the hook and BPF program continues to be attached on
the psock. User space will then get an EBUSY when trying to read the socket
because the recvmsg() handler is now waiting on a stopped stream parser.

To fix we rerun the proto ops init() function which will look at the new set
of progs attached to the psock and rest the proto ops hook to the correct
handlers. And in the above case where we remove the sock from the sock map
the RX prog will no longer be listed so the proto ops is removed.

Fixes: c5d2177a72a16 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211119181418.353932-3-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skmsg.c    |    5 +++++
 net/core/sock_map.c |    5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1124,6 +1124,8 @@ void sk_psock_start_strp(struct sock *sk
 
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 {
+	psock_set_prog(&psock->progs.stream_parser, NULL);
+
 	if (!psock->saved_data_ready)
 		return;
 
@@ -1212,6 +1214,9 @@ void sk_psock_start_verdict(struct sock
 
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
 {
+	psock_set_prog(&psock->progs.stream_verdict, NULL);
+	psock_set_prog(&psock->progs.skb_verdict, NULL);
+
 	if (!psock->saved_data_ready)
 		return;
 
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -167,8 +167,11 @@ static void sock_map_del_link(struct soc
 		write_lock_bh(&sk->sk_callback_lock);
 		if (strp_stop)
 			sk_psock_stop_strp(sk, psock);
-		else
+		if (verdict_stop)
 			sk_psock_stop_verdict(sk, psock);
+
+		if (psock->psock_update_sk_prot)
+			psock->psock_update_sk_prot(sk, psock, false);
 		write_unlock_bh(&sk->sk_callback_lock);
 	}
 }


