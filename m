Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C2F627E79
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbiKNMsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbiKNMsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:48:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF4F31E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:48:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B8F9BCE1000
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7E1C433C1;
        Mon, 14 Nov 2022 12:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430096;
        bh=qc0DSQGrBZGrdMpTi84cSLT4fEqwbRojsGFfx3fnx6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLYF/e+XnuyjRjDIqH0qX3zLg9l9e0ICl32cs6R1yeE6Xlc/kxTae291FsHlUwklt
         YXVvNrGfvE4w7fQS3t8odto0PkLW8AshW99+rnnBikd6zrWNj9O8qxzf2zCFFIVVfu
         4P5/NByqg9QMDB8rbInNtOp9CKpVnjoOk2f2PBk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lu Wei <luwei32@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/95] tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent
Date:   Mon, 14 Nov 2022 13:45:21 +0100
Message-Id: <20221114124443.651362178@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit 0c175da7b0378445f5ef53904247cfbfb87e0b78 ]

If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
of TCPOPT_SACK_PERM is called to enable sack after data is sent
and dupacks are received , it will trigger a warning in function
tcp_verify_left_out() as follows:

============================================
WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
tcp_timeout_mark_lost+0x154/0x160
tcp_enter_loss+0x2b/0x290
tcp_retransmit_timer+0x50b/0x640
tcp_write_timer_handler+0x1c8/0x340
tcp_write_timer+0xe5/0x140
call_timer_fn+0x3a/0x1b0
__run_timers.part.0+0x1bf/0x2d0
run_timer_softirq+0x43/0xb0
__do_softirq+0xfd/0x373
__irq_exit_rcu+0xf6/0x140

The warning is caused in the following steps:
1. a socket named socketA is created
2. socketA enters repair mode without build a connection
3. socketA calls connect() and its state is changed to TCP_ESTABLISHED
   directly
4. socketA leaves repair mode
5. socketA calls sendmsg() to send data, packets_out and sack_outs(dup
   ack receives) increase
6. socketA enters repair mode again
7. socketA calls setsockopt with TCPOPT_SACK_PERM to enable sack
8. retransmit timer expires, it calls tcp_timeout_mark_lost(), lost_out
   increases
9. sack_outs + lost_out > packets_out triggers since lost_out and
   sack_outs increase repeatly

In function tcp_timeout_mark_lost(), tp->sacked_out will be cleared if
Step7 not happen and the warning will not be triggered. As suggested by
Denis and Eric, TCP_REPAIR_OPTIONS should be prohibited if data was
already sent.

socket-tcp tests in CRIU has been tested as follows:
$ sudo ./test/zdtm.py run -t zdtm/static/socket-tcp*  --keep-going \
       --ignore-taint

socket-tcp* represent all socket-tcp tests in test/zdtm/static/.

Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
Signed-off-by: Lu Wei <luwei32@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a7127364253c..cc588bc2b11d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3291,7 +3291,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_REPAIR_OPTIONS:
 		if (!tp->repair)
 			err = -EINVAL;
-		else if (sk->sk_state == TCP_ESTABLISHED)
+		else if (sk->sk_state == TCP_ESTABLISHED && !tp->bytes_sent)
 			err = tcp_repair_options_est(sk, optval, optlen);
 		else
 			err = -EPERM;
-- 
2.35.1



