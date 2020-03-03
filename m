Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F07178243
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbgCCSKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731976AbgCCRvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03AE020728;
        Tue,  3 Mar 2020 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257881;
        bh=m7OLOWwF4hX4DtMx03rja13wZd/rZ41dd7u6ifR3LeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKfLap2MlfCLWJ9V2C55gRL573P9VSnVwi0Qv4d5tbIwCbX7aG4p58wsLol3CBIM9
         gD6j8KROToUKIrzvwSUB5TttFa9YWaEgm94T9veJ24V8uQBDZ3Y2qCS+ii+bwNxOBH
         AW0aKZ6TNMghkeUXXRUE5zvytByfzTFX3JKUcoLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 136/176] tipc: fix successful connect() but timed out
Date:   Tue,  3 Mar 2020 18:43:20 +0100
Message-Id: <20200303174320.493470489@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

commit 5391a87751a164b3194864126f3b016038abc9fe upstream.

In commit 9546a0b7ce00 ("tipc: fix wrong connect() return code"), we
fixed the issue with the 'connect()' that returns zero even though the
connecting has failed by waiting for the connection to be 'ESTABLISHED'
really. However, the approach has one drawback in conjunction with our
'lightweight' connection setup mechanism that the following scenario
can happen:

          (server)                        (client)

   +- accept()|                      |             wait_for_conn()
   |          |                      |connect() -------+
   |          |<-------[SYN]---------|                 > sleeping
   |          |                      *CONNECTING       |
   |--------->*ESTABLISHED           |                 |
              |--------[ACK]-------->*ESTABLISHED      > wakeup()
        send()|--------[DATA]------->|\                > wakeup()
        send()|--------[DATA]------->| |               > wakeup()
          .   .          .           . |-> recvq       .
          .   .          .           . |               .
        send()|--------[DATA]------->|/                > wakeup()
       close()|--------[FIN]-------->*DISCONNECTING    |
              *DISCONNECTING         |                 |
              |                      ~~~~~~~~~~~~~~~~~~> schedule()
                                                       | wait again
                                                       .
                                                       .
                                                       | ETIMEDOUT

Upon the receipt of the server 'ACK', the client becomes 'ESTABLISHED'
and the 'wait_for_conn()' process is woken up but not run. Meanwhile,
the server starts to send a number of data following by a 'close()'
shortly without waiting any response from the client, which then forces
the client socket to be 'DISCONNECTING' immediately. When the wait
process is switched to be running, it continues to wait until the timer
expires because of the unexpected socket state. The client 'connect()'
will finally get ‘-ETIMEDOUT’ and force to release the socket whereas
there remains the messages in its receive queue.

Obviously the issue would not happen if the server had some delay prior
to its 'close()' (or the number of 'DATA' messages is large enough),
but any kind of delay would make the connection setup/shutdown "heavy".
We solve this by simply allowing the 'connect()' returns zero in this
particular case. The socket is already 'DISCONNECTING', so any further
write will get '-EPIPE' but the socket is still able to read the
messages existing in its receive queue.

Note: This solution doesn't break the previous one as it deals with a
different situation that the socket state is 'DISCONNECTING' but has no
error (i.e. sk->sk_err = 0).

Fixes: 9546a0b7ce00 ("tipc: fix wrong connect() return code")
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/socket.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2441,6 +2441,8 @@ static int tipc_wait_for_connect(struct
 			return -ETIMEDOUT;
 		if (signal_pending(current))
 			return sock_intr_errno(*timeo_p);
+		if (sk->sk_state == TIPC_DISCONNECTING)
+			break;
 
 		add_wait_queue(sk_sleep(sk), &wait);
 		done = sk_wait_event(sk, timeo_p, tipc_sk_connected(sk),


