Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92971551A1A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243335AbiFTMzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243251AbiFTMzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:55:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C3B19295;
        Mon, 20 Jun 2022 05:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9EC661449;
        Mon, 20 Jun 2022 12:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADECC3411B;
        Mon, 20 Jun 2022 12:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729668;
        bh=+0lnCICOakkc5xCVlYlg5vEMHIhXXyayy+UhRU2d+C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8qcUDgKWJpsZF/lk966RHTl6bmsZmq3AD5Y7xOmDNXmvuATvEjGgZi0B8oaDjmj1
         5dVxMXmUJi9XQNCPR7/FhoLu4GxkNgswPgBXA1+aJI2hSj/EpeY4N9eeKdZsZrWnjj
         TGJ1BJ1ylSmm3WNl436ejodlGlazP7I49mWIiQv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 037/141] ipv6: Fix signed integer overflow in __ip6_append_data
Date:   Mon, 20 Jun 2022 14:49:35 +0200
Message-Id: <20220620124730.632853573@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit f93431c86b631bbca5614c66f966bf3ddb3c2803 ]

Resurrect ubsan overflow checks and ubsan report this warning,
fix it by change the variable [length] type to size_t.

UBSAN: signed-integer-overflow in net/ipv6/ip6_output.c:1489:19
2147479552 + 8567 cannot be represented in type 'int'
CPU: 0 PID: 253 Comm: err Not tainted 5.16.0+ #1
Hardware name: linux,dummy-virt (DT)
Call trace:
  dump_backtrace+0x214/0x230
  show_stack+0x30/0x78
  dump_stack_lvl+0xf8/0x118
  dump_stack+0x18/0x30
  ubsan_epilogue+0x18/0x60
  handle_overflow+0xd0/0xf0
  __ubsan_handle_add_overflow+0x34/0x44
  __ip6_append_data.isra.48+0x1598/0x1688
  ip6_append_data+0x128/0x260
  udpv6_sendmsg+0x680/0xdd0
  inet6_sendmsg+0x54/0x90
  sock_sendmsg+0x70/0x88
  ____sys_sendmsg+0xe8/0x368
  ___sys_sendmsg+0x98/0xe0
  __sys_sendmmsg+0xf4/0x3b8
  __arm64_sys_sendmmsg+0x34/0x48
  invoke_syscall+0x64/0x160
  el0_svc_common.constprop.4+0x124/0x300
  do_el0_svc+0x44/0xc8
  el0_svc+0x3c/0x1e8
  el0t_64_sync_handler+0x88/0xb0
  el0t_64_sync+0x16c/0x170

Changes since v1:
-Change the variable [length] type to unsigned, as Eric Dumazet suggested.
Changes since v2:
-Don't change exthdrlen type in ip6_make_skb, as Paolo Abeni suggested.
Changes since v3:
-Don't change ulen type in udpv6_sendmsg and l2tp_ip6_sendmsg, as
Jakub Kicinski suggested.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/20220607120028.845916-1-wangyufen@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ipv6.h    | 4 ++--
 net/ipv6/ip6_output.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c..023435ce1606 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1019,7 +1019,7 @@ int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr);
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
-		    void *from, int length, int transhdrlen,
+		    void *from, size_t length, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 		    struct rt6_info *rt, unsigned int flags);
 
@@ -1035,7 +1035,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk, struct sk_buff_head *queue,
 struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     struct ipcm6_cookie *ipc6,
 			     struct rt6_info *rt, unsigned int flags,
 			     struct inet_cork_full *cork);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index fa63ef2bd99c..87067e0ddaa3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1428,7 +1428,7 @@ static int __ip6_append_data(struct sock *sk,
 			     struct page_frag *pfrag,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
@@ -1776,7 +1776,7 @@ static int __ip6_append_data(struct sock *sk,
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
-		    void *from, int length, int transhdrlen,
+		    void *from, size_t length, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 		    struct rt6_info *rt, unsigned int flags)
 {
@@ -1973,7 +1973,7 @@ EXPORT_SYMBOL_GPL(ip6_flush_pending_frames);
 struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     struct ipcm6_cookie *ipc6, struct rt6_info *rt,
 			     unsigned int flags, struct inet_cork_full *cork)
 {
-- 
2.35.1



