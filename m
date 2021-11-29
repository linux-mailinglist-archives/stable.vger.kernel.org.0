Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D82462434
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhK2WRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhK2WQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90573C127122;
        Mon, 29 Nov 2021 10:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 144BFB815D4;
        Mon, 29 Nov 2021 18:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460BCC53FAD;
        Mon, 29 Nov 2021 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210119;
        bh=wSanE+iMEHuphLUNYwHm5x3TV4pyRoQG0kyKPZkFyU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWxAc03tGK8lTgRU9N2mQ7+mppRPVV3h0oshN2re4MCp58bpPO4rVz5yC7ZGUMz4P
         bRsWAjxlsH4vtLotV8dn1A/c5BpxJOqCjZ7uUcamGN8M/DZm9eJJXtZChhQFz4bFf2
         1oVz0pTjDL3A82VEKcANf6FATEuObyaE0dxhfBII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/69] net/smc: Ensure the active closing peer first closes clcsock
Date:   Mon, 29 Nov 2021 19:18:31 +0100
Message-Id: <20211129181705.257861830@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

[ Upstream commit 606a63c9783a32a45bd2ef0eee393711d75b3284 ]

The side that actively closed socket, it's clcsock doesn't enter
TIME_WAIT state, but the passive side does it. It should show the same
behavior as TCP sockets.

Consider this, when client actively closes the socket, the clcsock in
server enters TIME_WAIT state, which means the address is occupied and
won't be reused before TIME_WAIT dismissing. If we restarted server, the
service would be unavailable for a long time.

To solve this issue, shutdown the clcsock in [A], perform the TCP active
close progress first, before the passive closed side closing it. So that
the actively closed side enters TIME_WAIT, not the passive one.

Client                                            |  Server
close() // client actively close                  |
  smc_release()                                   |
      smc_close_active() // PEERCLOSEWAIT1        |
          smc_close_final() // abort or closed = 1|
              smc_cdc_get_slot_and_msg_send()     |
          [A]                                     |
                                                  |smc_cdc_msg_recv_action() // ACTIVE
                                                  |  queue_work(smc_close_wq, &conn->close_work)
                                                  |    smc_close_passive_work() // PROCESSABORT or APPCLOSEWAIT1
                                                  |      smc_close_passive_abort_received() // only in abort
                                                  |
                                                  |close() // server recv zero, close
                                                  |  smc_release() // PROCESSABORT or APPCLOSEWAIT1
                                                  |    smc_close_active()
                                                  |      smc_close_abort() or smc_close_final() // CLOSED
                                                  |        smc_cdc_get_slot_and_msg_send() // abort or closed = 1
smc_cdc_msg_recv_action()                         |    smc_clcsock_release()
  queue_work(smc_close_wq, &conn->close_work)     |      sock_release(tcp) // actively close clc, enter TIME_WAIT
    smc_close_passive_work() // PEERCLOSEWAIT1    |    smc_conn_free()
      smc_close_passive_abort_received() // CLOSED|
      smc_conn_free()                             |
      smc_clcsock_release()                       |
        sock_release(tcp) // passive close clc    |

Link: https://www.spinics.net/lists/netdev/msg780407.html
Fixes: b38d732477e4 ("smc: socket closing and linkgroup cleanup")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_close.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index ea2b87f294696..e25c023582f9e 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -202,6 +202,12 @@ int smc_close_active(struct smc_sock *smc)
 			if (rc)
 				break;
 			sk->sk_state = SMC_PEERCLOSEWAIT1;
+
+			/* actively shutdown clcsock before peer close it,
+			 * prevent peer from entering TIME_WAIT state.
+			 */
+			if (smc->clcsock && smc->clcsock->sk)
+				rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		} else {
 			/* peer event has changed the state */
 			goto again;
-- 
2.33.0



