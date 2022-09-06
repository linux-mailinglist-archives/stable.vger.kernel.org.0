Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618AF5AEA58
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiIFNnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbiIFNmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:42:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF42FD12;
        Tue,  6 Sep 2022 06:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 162E060F89;
        Tue,  6 Sep 2022 13:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AE7C433C1;
        Tue,  6 Sep 2022 13:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471453;
        bh=ghzlkPVlHrxi+3FV1dWDne7Rov0mefsDfm/yE58ZcZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSrtZ/ifDxW55Q7+8FkTUYoGykGvhZf6q7M6F3M9xte9nqv5Gx/aoWipuS06GRpd1
         K6MP9eA4DaLTPDI4R4ExeRXTmr2XiviSIZRJigH6+ZTvE94xFW/dPft0KR7lupHx1R
         /8tn6IHC6RfXpPlQy2JgmJ1hyltaiHOJfX3hj5oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/107] skmsg: Fix wrong last sg check in sk_msg_recvmsg()
Date:   Tue,  6 Sep 2022 15:29:48 +0200
Message-Id: <20220906132822.041403187@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 583585e48d965338e73e1eb383768d16e0922d73 ]

Fix one kernel NULL pointer dereference as below:

[  224.462334] Call Trace:
[  224.462394]  __tcp_bpf_recvmsg+0xd3/0x380
[  224.462441]  ? sock_has_perm+0x78/0xa0
[  224.462463]  tcp_bpf_recvmsg+0x12e/0x220
[  224.462494]  inet_recvmsg+0x5b/0xd0
[  224.462534]  __sys_recvfrom+0xc8/0x130
[  224.462574]  ? syscall_trace_enter+0x1df/0x2e0
[  224.462606]  ? __do_page_fault+0x2de/0x500
[  224.462635]  __x64_sys_recvfrom+0x24/0x30
[  224.462660]  do_syscall_64+0x5d/0x1d0
[  224.462709]  entry_SYSCALL_64_after_hwframe+0x65/0xca

In commit 9974d37ea75f ("skmsg: Fix invalid last sg check in
sk_msg_recvmsg()"), we change last sg check to sg_is_last(),
but in sockmap redirection case (without stream_parser/stream_verdict/
skb_verdict), we did not mark the end of the scatterlist. Check the
sk_msg_alloc, sk_msg_page_add, and bpf_msg_push_data functions, they all
do not mark the end of sg. They are expected to use sg.end for end
judgment. So the judgment of '(i != msg_rx->sg.end)' is added back here.

Fixes: 9974d37ea75f ("skmsg: Fix invalid last sg check in sk_msg_recvmsg()")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20220809094915.150391-1-liujian56@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4ddcfac344984..054073c7cbb95 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -462,7 +462,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 
 			if (copied == len)
 				break;
-		} while (!sg_is_last(sge));
+		} while ((i != msg_rx->sg.end) && !sg_is_last(sge));
 
 		if (unlikely(peek)) {
 			msg_rx = sk_psock_next_msg(psock, msg_rx);
@@ -472,7 +472,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		}
 
 		msg_rx->sg.start = i;
-		if (!sge->length && sg_is_last(sge)) {
+		if (!sge->length && (i == msg_rx->sg.end || sg_is_last(sge))) {
 			msg_rx = sk_psock_dequeue_msg(psock);
 			kfree_sk_msg(msg_rx);
 		}
-- 
2.35.1



