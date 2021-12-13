Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF654726F2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239022AbhLMJ4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:56:22 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44334 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238719AbhLMJyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ECEFDCE0EB8;
        Mon, 13 Dec 2021 09:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C294C34600;
        Mon, 13 Dec 2021 09:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389255;
        bh=6AyAfLu8T4t1lFRF/aXhp02WCJf+FIa/z1+ODifwKHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDU0BJT+jtD/Fg+dIacVMes03+KHPGXe1Fdf0/xi9+8Tew2TDRDT7FeYgMmW+IO/j
         7kZBNg3Ux1QCYSY3sGCeoRwNRyrQQj24vuj+2baAH5NTIEXMN8IwK0AS9mWSZ1SFAX
         CugyeS0q9zrsjtMlmucuuHyARVf6+7BdMPOTkCXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 037/171] bpf, sockmap: Attach map progs to psock early for feature probes
Date:   Mon, 13 Dec 2021 10:29:12 +0100
Message-Id: <20211213092946.312270068@linuxfoundation.org>
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

commit 38207a5e81230d6ffbdd51e5fa5681be5116dcae upstream.

When a TCP socket is added to a sock map we look at the programs attached
to the map to determine what proto op hooks need to be changed. Before
the patch in the 'fixes' tag there were only two categories -- the empty
set of programs or a TX policy. In any case the base set handled the
receive case.

After the fix we have an optimized program for receive that closes a small,
but possible, race on receive. This program is loaded only when the map the
psock is being added to includes a RX policy. Otherwise, the race is not
possible so we don't need to handle the race condition.

In order for the call to sk_psock_init() to correctly evaluate the above
conditions all progs need to be set in the psock before the call. However,
in the current code this is not the case. We end up evaluating the
requirements on the old prog state. If your psock is attached to multiple
maps -- for example a tx map and rx map -- then the second update would pull
in the correct maps. But, the other pattern with a single rx enabled map
the correct receive hooks are not used. The result is the race fixed by the
patch in the fixes tag below may still be seen in this case.

To fix we simply set all psock->progs before doing the call into
sock_map_init(). With this the init() call gets the full list of programs
and chooses the correct proto ops on the first iteration instead of
requiring the second update to pull them in. This fixes the race case when
only a single map is used.

Fixes: c5d2177a72a16 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211119181418.353932-2-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock_map.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -282,6 +282,12 @@ static int sock_map_link(struct bpf_map
 
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);
+	if (stream_parser)
+		psock_set_prog(&psock->progs.stream_parser, stream_parser);
+	if (stream_verdict)
+		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
+	if (skb_verdict)
+		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 
 	ret = sock_map_init_proto(sk, psock);
 	if (ret < 0)
@@ -292,14 +298,10 @@ static int sock_map_link(struct bpf_map
 		ret = sk_psock_init_strp(sk, psock);
 		if (ret)
 			goto out_unlock_drop;
-		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
-		psock_set_prog(&psock->progs.stream_parser, stream_parser);
 		sk_psock_start_strp(sk, psock);
 	} else if (!stream_parser && stream_verdict && !psock->saved_data_ready) {
-		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
 		sk_psock_start_verdict(sk,psock);
 	} else if (!stream_verdict && skb_verdict && !psock->saved_data_ready) {
-		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 		sk_psock_start_verdict(sk, psock);
 	}
 	write_unlock_bh(&sk->sk_callback_lock);


