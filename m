Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE144F2B08
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbiDEIgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238708AbiDEITT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE7A6D3AD;
        Tue,  5 Apr 2022 01:09:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 159EA60B06;
        Tue,  5 Apr 2022 08:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D931C385A2;
        Tue,  5 Apr 2022 08:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146160;
        bh=vZCYosMR3xAeEcqaIxxhaQzuSAuF9vWSVdw/VukUcbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0So8eeVsKQyiFH4OnMOYBHKsVC12LQ2ou22cSexmHZP8aWAD36KlaWTJ8q3uwEP3G
         e+sn4Bbex8Xp7gECpVWw42Otc9/jAiOmQVX0AAaSbhOT15j/ClMuksN2cBqQZobPYp
         9HyoeHVEeywQ9w0bwdkeH42N8+5QT6hcVcvwBNYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0663/1126] bpf, sockmap: Fix double uncharge the mem of sk_msg
Date:   Tue,  5 Apr 2022 09:23:30 +0200
Message-Id: <20220405070427.088369394@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 2486ab434b2c2a14e9237296db00b1e1b7ae3273 ]

If tcp_bpf_sendmsg is running during a tear down operation, psock may be
freed.

tcp_bpf_sendmsg()
 tcp_bpf_send_verdict()
  sk_msg_return()
  tcp_bpf_sendmsg_redir()
   unlikely(!psock))
     sk_msg_free()

The mem of msg has been uncharged in tcp_bpf_send_verdict() by
sk_msg_return(), and would be uncharged by sk_msg_free() again. When psock
is null, we can simply returning an error code, this would then trigger
the sk_msg_free_nocharge in the error path of __SK_REDIRECT and would have
the side effect of throwing an error up to user space. This would be a
slight change in behavior from user side but would look the same as an
error if the redirect on the socket threw an error.

This issue can cause the following info:
WARNING: CPU: 0 PID: 2136 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
Call Trace:
 <TASK>
 __sk_destruct+0x24/0x1f0
 sk_psock_destroy+0x19b/0x1c0
 process_one_work+0x1b3/0x3c0
 worker_thread+0x30/0x350
 ? process_one_work+0x3c0/0x3c0
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30
 </TASK>

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220304081145.2037182-5-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 304800c60427..1cdcb4df0eb7 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -138,10 +138,9 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 	struct sk_psock *psock = sk_psock_get(sk);
 	int ret;
 
-	if (unlikely(!psock)) {
-		sk_msg_free(sk, msg);
-		return 0;
-	}
+	if (unlikely(!psock))
+		return -EPIPE;
+
 	ret = ingress ? bpf_tcp_ingress(sk, psock, msg, bytes, flags) :
 			tcp_bpf_push_locked(sk, msg, bytes, flags, false);
 	sk_psock_put(sk, psock);
-- 
2.34.1



