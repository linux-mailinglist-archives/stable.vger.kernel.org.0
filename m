Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E09E4125A6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354025AbhITSqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383436AbhITSoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C7E863358;
        Mon, 20 Sep 2021 17:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159174;
        bh=1hv/tJtozOoDLf0cxrTyIzGNXzwE9pY0zWKMoVJLTrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpnCJGe6dp7N+9ZdQ91ildbE9movmdgMRqJq49d+/VFVauF0PgZebBtMatSpUOoAN
         9zX61Je49mrOfDPxzun01FN/WI9Czp4smqja5KIoyt0Ns2E2DP5uNdsvp4LG8zAQRw
         4ehJ5pfBB99XjG9lVHSTC4Fve3l1hHgmuojMn7IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 111/168] flow: fix object-size-mismatch warning in flowi{4,6}_to_flowi_common()
Date:   Mon, 20 Sep 2021 18:44:09 +0200
Message-Id: <20210920163925.289817285@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit b9edbfe1adecfc48fd11061dce68afb03d6adbdc ]

Commit 3df98d79215ace13 ("lsm,selinux: pass flowi_common instead of flowi
to the LSM hooks") introduced flowi{4,6}_to_flowi_common() functions which
cause UBSAN warning when building with LLVM 11.0.1 on Ubuntu 21.04.

 ================================================================================
 UBSAN: object-size-mismatch in ./include/net/flow.h:197:33
 member access within address ffffc9000109fbd8 with insufficient space
 for an object of type 'struct flowi'
 CPU: 2 PID: 7410 Comm: systemd-resolve Not tainted 5.14.0 #51
 Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
 Call Trace:
  dump_stack_lvl+0x103/0x171
  ubsan_type_mismatch_common+0x1de/0x390
  __ubsan_handle_type_mismatch_v1+0x41/0x50
  udp_sendmsg+0xda2/0x1300
  ? ip_skb_dst_mtu+0x1f0/0x1f0
  ? sock_rps_record_flow+0xe/0x200
  ? inet_send_prepare+0x2d/0x90
  sock_sendmsg+0x49/0x80
  ____sys_sendmsg+0x269/0x370
  __sys_sendmsg+0x15e/0x1d0
  ? syscall_enter_from_user_mode+0xf0/0x1b0
  do_syscall_64+0x3d/0xb0
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f7081a50497
 Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 RSP: 002b:00007ffc153870f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f7081a50497
 RDX: 0000000000000000 RSI: 00007ffc15387140 RDI: 000000000000000c
 RBP: 00007ffc15387140 R08: 0000563f29a5e4fc R09: 000000000000cd28
 R10: 0000563f29a68a30 R11: 0000000000000246 R12: 000000000000000c
 R13: 0000000000000001 R14: 0000563f29a68a30 R15: 0000563f29a5e50c
 ================================================================================

I don't think we need to call flowi{4,6}_to_flowi() from these functions
because the first member of "struct flowi4" and "struct flowi6" is

  struct flowi_common __fl_common;

while the first member of "struct flowi" is

  union {
    struct flowi_common __fl_common;
    struct flowi4       ip4;
    struct flowi6       ip6;
    struct flowidn      dn;
  } u;

which should point to the same address without access to "struct flowi".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 6f5e70240071..58beb16a49b8 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -194,7 +194,7 @@ static inline struct flowi *flowi4_to_flowi(struct flowi4 *fl4)
 
 static inline struct flowi_common *flowi4_to_flowi_common(struct flowi4 *fl4)
 {
-	return &(flowi4_to_flowi(fl4)->u.__fl_common);
+	return &(fl4->__fl_common);
 }
 
 static inline struct flowi *flowi6_to_flowi(struct flowi6 *fl6)
@@ -204,7 +204,7 @@ static inline struct flowi *flowi6_to_flowi(struct flowi6 *fl6)
 
 static inline struct flowi_common *flowi6_to_flowi_common(struct flowi6 *fl6)
 {
-	return &(flowi6_to_flowi(fl6)->u.__fl_common);
+	return &(fl6->__fl_common);
 }
 
 static inline struct flowi *flowidn_to_flowi(struct flowidn *fldn)
-- 
2.30.2



