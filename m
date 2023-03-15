Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C046BB2C6
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjCOMib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbjCOMiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:38:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1659AFDB
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B723B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895FDC433D2;
        Wed, 15 Mar 2023 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883836;
        bh=R63HPpZq8h7gdUMFQmD6fmDT7vOIDou4F1fXXxV7wgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/UKaqL0j5ZEjpF5g59KLi2p1Q5fu8M4/gQmzzgfDmD6gcOClI0gj2zfufChnVP/l
         dGO8D64FjxNQJ8OBlqJIy/WewU7dON6ji65CIVEn7voXxnSfKneIAwI8Sdk2jyd+32
         8E0KD2aFG08HhO69QQRd3DY9jF1UC86PNNnpJvQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+7699d9e5635c10253a27@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Rao Shoaib <rao.shoaib@oracle.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/143] af_unix: fix struct pid leaks in OOB support
Date:   Wed, 15 Mar 2023 13:13:16 +0100
Message-Id: <20230315115743.838907537@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2aab4b96900272885bc157f8b236abf1cdc02e08 ]

syzbot reported struct pid leak [1].

Issue is that queue_oob() calls maybe_add_creds() which potentially
holds a reference on a pid.

But skb->destructor is not set (either directly or by calling
unix_scm_to_skb())

This means that subsequent kfree_skb() or consume_skb() would leak
this reference.

In this fix, I chose to fully support scm even for the OOB message.

[1]
BUG: memory leak
unreferenced object 0xffff8881053e7f80 (size 128):
comm "syz-executor242", pid 5066, jiffies 4294946079 (age 13.220s)
hex dump (first 32 bytes):
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<ffffffff812ae26a>] alloc_pid+0x6a/0x560 kernel/pid.c:180
[<ffffffff812718df>] copy_process+0x169f/0x26c0 kernel/fork.c:2285
[<ffffffff81272b37>] kernel_clone+0xf7/0x610 kernel/fork.c:2684
[<ffffffff812730cc>] __do_sys_clone+0x7c/0xb0 kernel/fork.c:2825
[<ffffffff849ad699>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<ffffffff849ad699>] do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
[<ffffffff84a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: syzbot+7699d9e5635c10253a27@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Rao Shoaib <rao.shoaib@oracle.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230307164530.771896-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f0c2293f1d3b8..7d17601ceee79 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2104,7 +2104,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
+static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other,
+		     struct scm_cookie *scm, bool fds_sent)
 {
 	struct unix_sock *ousk = unix_sk(other);
 	struct sk_buff *skb;
@@ -2115,6 +2116,11 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	if (!skb)
 		return err;
 
+	err = unix_scm_to_skb(scm, skb, !fds_sent);
+	if (err < 0) {
+		kfree_skb(skb);
+		return err;
+	}
 	skb_put(skb, 1);
 	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
 
@@ -2242,7 +2248,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (msg->msg_flags & MSG_OOB) {
-		err = queue_oob(sock, msg, other);
+		err = queue_oob(sock, msg, other, &scm, fds_sent);
 		if (err)
 			goto out_err;
 		sent++;
-- 
2.39.2



