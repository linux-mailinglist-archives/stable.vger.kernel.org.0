Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544475EEF47
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 09:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbiI2HjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 03:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiI2HjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 03:39:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4F11397DA;
        Thu, 29 Sep 2022 00:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=U/H6ER4Dmga5p7E3JSan/uaDdo40K/EZfBAvTEwfgfQ=; b=syp+BNk8rbhRWtP7Czw5/QckPH
        HYYkYHRdZSDhzX6fciHx/jozpHETEGqs7cplZGrSUVqQXgxvXiDmuDJ2OphFaW/AFf1kPc8MDexRQ
        +UPQV40zfWEfB8f0tUMxF+GeNsApmke5majbyk1C3IAz7E1l8R1D+2O5EI9MU/LUAxRBM7SvYgpf8
        lVjnHDVmlujTCRgogx0BIKjUYPhOPUvyfXKBhHC1yTuYKS00KphToxwEpLJYhyr/6D6Dxula8K0SU
        g0CeoeNyNWn+tGs7gOlNNI4GF9V2NIQ6niCEXlhk3hT/BavjMgW882HTiqHPep2FKNMF5pLVMIfIt
        wW5cIQ1oVdvBuEsmzwjbTqLoKe1Q2ptdnop1zBL5MMJwopvuCoDXLfamixnu2/Hh9wx8I8E1QKuex
        umrwtslYH+AexAH+vVftAsRyFeDF11EFB/da/im9deB2YN32OkE7D+ZG+rJ3EQlx3/9Y3Ke46UEDh
        ZzEQ7/Urc2IzpgLwaJJATv3d;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1odo8a-002L3g-PM; Thu, 29 Sep 2022 07:39:16 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org
Subject: [PATCH 1/1] io_uring/net: fix fast_iov assignment in io_setup_async_msg()
Date:   Thu, 29 Sep 2022 09:39:10 +0200
Message-Id: <b2e7be246e2fb173520862b0c7098e55767567a2.1664436949.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1664436949.git.metze@samba.org>
References: <cover.1664436949.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I hit a very bad problem during my tests of SENDMSG_ZC.
BUG(); in first_iovec_segment() triggered very easily.
The problem was io_setup_async_msg() in the partial retry case,
which seems to happen more often with _ZC.

iov_iter_iovec_advance() may change i->iov in order to have i->iov_offset
being only relative to the first element.

Which means kmsg->msg.msg_iter.iov is no longer the
same as kmsg->fast_iov.

But this would rewind the copy to be the start of
async_msg->fast_iov, which means the internal
state of sync_msg->msg.msg_iter is inconsitent.

I tested with 5 vectors with length like this 4, 0, 64, 20, 8388608
and got a short writes with:
- ret=2675244 min_ret=8388692 => remaining 5713448 sr->done_io=2675244
- ret=-EAGAIN => io_uring_poll_arm
- ret=4911225 min_ret=5713448 => remaining 802223  sr->done_io=7586469
- ret=-EAGAIN => io_uring_poll_arm
- ret=802223  min_ret=802223  => res=8388692

While this was easily triggered with SENDMSG_ZC (queued for 6.1),
it was a potential problem starting with 7ba89d2af17aa879dda30f5d5d3f152e587fc551
in 5.18 for IORING_OP_RECVMSG.
And also with 4c3c09439c08b03d9503df0ca4c7619c5842892e in 5.19
for IORING_OP_SENDMSG.

However 257e84a5377fbbc336ff563833a8712619acce56 introduced the critical
code into io_setup_async_msg() in 5.11.

Fixes: 7ba89d2af17aa ("io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly")
Fixes: 257e84a5377fb ("io_uring: refactor sendmsg/recvmsg iov managing")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 io_uring/net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 60e392f7f2dc..a81fccd38ae4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -165,8 +165,10 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	async_msg->msg.msg_name = &async_msg->addr;
 	/* if were using fast_iov, set it to the new one */
-	if (!async_msg->free_iov)
-		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
+	if (!kmsg->free_iov) {
+		size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
+		async_msg->msg.msg_iter.iov = &async_msg->fast_iov[fast_idx];
+	}
 
 	return -EAGAIN;
 }
-- 
2.34.1

