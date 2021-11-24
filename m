Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675E845BA43
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242233AbhKXMJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241239AbhKXMHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DAB161078;
        Wed, 24 Nov 2021 12:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755465;
        bh=c46/3NevnXrmshmvsd3mQpGvD90qnjezmLcAsN/GfGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlSt0xYUOQofDjc/0uT++aYGf9G/UYDbRKfgqaeuGZdxyB/94AcFYFRFEP3RueQGT
         ZJ+R23qaCwt/JpVh3l4WtAUQSeABJk0/pifkDgV+LkUyYDX0R9YsmcULvMya/IpCN/
         6eFiiuD4cAXvw1SPHElOJ+/R48FPcARhPeX3D+iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 106/162] llc: fix out-of-bound array index in llc_sk_dev_hash()
Date:   Wed, 24 Nov 2021 12:56:49 +0100
Message-Id: <20211124115701.762450033@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8ac9dfd58b138f7e82098a4e0a0d46858b12215b ]

Both ifindex and LLC_SK_DEV_HASH_ENTRIES are signed.

This means that (ifindex % LLC_SK_DEV_HASH_ENTRIES) is negative
if @ifindex is negative.

We could simply make LLC_SK_DEV_HASH_ENTRIES unsigned.

In this patch I chose to use hash_32() to get more entropy
from @ifindex, like llc_sk_laddr_hashfn().

UBSAN: array-index-out-of-bounds in ./include/net/llc.h:75:26
index -43 is out of range for type 'hlist_head [64]'
CPU: 1 PID: 20999 Comm: syz-executor.3 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:151
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:291
 llc_sk_dev_hash include/net/llc.h:75 [inline]
 llc_sap_add_socket+0x49c/0x520 net/llc/llc_conn.c:697
 llc_ui_bind+0x680/0xd70 net/llc/af_llc.c:404
 __sys_bind+0x1e9/0x250 net/socket.c:1693
 __do_sys_bind net/socket.c:1704 [inline]
 __se_sys_bind net/socket.c:1702 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1702
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa503407ae9

Fixes: 6d2e3ea28446 ("llc: use a device based hash table to speed up multicast delivery")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/llc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/llc.h b/include/net/llc.h
index 95e5ced4c1339..18dfd3e49a69f 100644
--- a/include/net/llc.h
+++ b/include/net/llc.h
@@ -72,7 +72,9 @@ struct llc_sap {
 static inline
 struct hlist_head *llc_sk_dev_hash(struct llc_sap *sap, int ifindex)
 {
-	return &sap->sk_dev_hash[ifindex % LLC_SK_DEV_HASH_ENTRIES];
+	u32 bucket = hash_32(ifindex, LLC_SK_DEV_HASH_BITS);
+
+	return &sap->sk_dev_hash[bucket];
 }
 
 static inline
-- 
2.33.0



