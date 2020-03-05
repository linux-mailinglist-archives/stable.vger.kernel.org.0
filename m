Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147B117A12D
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 09:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgCEIWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 03:22:50 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:38530 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbgCEIWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 03:22:50 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2A51EF1B93CA484CD08B;
        Thu,  5 Mar 2020 16:22:45 +0800 (CST)
Received: from fedora-aep.huawei.cmm (10.175.113.49) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 16:22:36 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>
CC:     <stable@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <yangerkun@huawei.com>
Subject: [PATCH 4.4.y] crypto: algif_skcipher - use ZERO_OR_NULL_PTR in skcipher_recvmsg_async
Date:   Thu, 5 Mar 2020 16:50:40 +0800
Message-ID: <20200305085040.21551-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.49]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nowdays, we trigger a oops:
...
kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000
...
 [<ffffffff8114ab47>] do_async_page_fault+0x37/0xb0 x86/../arch/x86/kernel/kvm.c:266
 [<ffffffff828b4a48>] async_page_fault+0x28/0x30 x86/../arch/x86/entry/entry_64.S:1043
 [<ffffffff81b47c2a>] iov_iter_zero+0x15a/0x850 x86/../lib/iov_iter.c:445
 [<ffffffff81e8ca2f>] read_iter_zero+0xcf/0x1b0 x86/../drivers/char/mem.c:708
 [<ffffffff816ea7c8>] do_iter_readv_writev x86/../fs/read_write.c:679 [inline]
 [<ffffffff816ea7c8>] do_readv_writev+0x448/0x8e0 x86/../fs/read_write.c:823
 [<ffffffff816eacdf>] vfs_readv+0x7f/0xb0 x86/../fs/read_write.c:849
 [<ffffffff816edac3>] SYSC_preadv x86/../fs/read_write.c:927 [inline]
 [<ffffffff816edac3>] SyS_preadv+0x193/0x240 x86/../fs/read_write.c:913
 [<ffffffff828b3261>] entry_SYSCALL_64_fastpath+0x1e/0x9a

In skcipher_recvmsg_async, we use '!sreq->tsg' to determine does we
calloc fail. However, kcalloc may return ZERO_SIZE_PTR, and with this,
the latter sg_init_table will trigger the bug. Fix it be use ZERO_OF_NULL_PTR.

This function was introduced with ' commit a596999b7ddf ("crypto:
algif - change algif_skcipher to be asynchronous")', and has been removed
with 'commit e870456d8e7c ("crypto: algif_skcipher - overhaul memory
management")'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index d12782dc9683..9bd4691cc5c5 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -538,7 +538,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	lock_sock(sk);
 	tx_nents = skcipher_all_sg_nents(ctx);
 	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
-	if (unlikely(!sreq->tsg))
+	if (unlikely(ZERO_OR_NULL_PTR(sreq->tsg)))
 		goto unlock;
 	sg_init_table(sreq->tsg, tx_nents);
 	memcpy(iv, ctx->iv, ivsize);
-- 
2.17.2

