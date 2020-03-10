Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B78217F7EE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgCJMnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbgCJMnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:43:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3636524698;
        Tue, 10 Mar 2020 12:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844212;
        bh=m2VMjPdP7Tghk64h+YiyaAAmIOugxKZ/W6szpaKD2Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNr16ZuoFShLfzvR91k5X/HVf1cuuuOKHevgS/cM/i4SijfaAOqhqLSMsIMJVsOha
         HKe0XypeJxpycFbIOwnFP13yJfglRrf5tW+JxeX1PDvUmZXF+NXEmy/1k2Uj+GsGkx
         RroaNGYeyNvsYSf2t4rGQs/P9bU4Is7oR33F5DC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        yangerkun <yangerkun@huawei.com>
Subject: [PATCH 4.4 72/72] crypto: algif_skcipher - use ZERO_OR_NULL_PTR in skcipher_recvmsg_async
Date:   Tue, 10 Mar 2020 13:39:25 +0100
Message-Id: <20200310123619.498408311@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

Nowdays, we trigger a oops:
...
kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#1] SMP KASAN
...
Call Trace:
 [<ffffffff81a26fb1>] skcipher_recvmsg_async+0x3f1/0x1400 x86/../crypto/algif_skcipher.c:543
 [<ffffffff81a28053>] skcipher_recvmsg+0x93/0x7f0 x86/../crypto/algif_skcipher.c:723
 [<ffffffff823e43a4>] sock_recvmsg_nosec x86/../net/socket.c:702 [inline]
 [<ffffffff823e43a4>] sock_recvmsg x86/../net/socket.c:710 [inline]
 [<ffffffff823e43a4>] sock_recvmsg+0x94/0xc0 x86/../net/socket.c:705
 [<ffffffff823e464b>] sock_read_iter+0x27b/0x3a0 x86/../net/socket.c:787
 [<ffffffff817f479b>] aio_run_iocb+0x21b/0x7a0 x86/../fs/aio.c:1520
 [<ffffffff817f57c9>] io_submit_one x86/../fs/aio.c:1630 [inline]
 [<ffffffff817f57c9>] do_io_submit+0x6b9/0x10b0 x86/../fs/aio.c:1688
 [<ffffffff817f902d>] SYSC_io_submit x86/../fs/aio.c:1713 [inline]
 [<ffffffff817f902d>] SyS_io_submit+0x2d/0x40 x86/../fs/aio.c:1710
 [<ffffffff828b33c3>] tracesys_phase2+0x90/0x95

In skcipher_recvmsg_async, we use '!sreq->tsg' to determine does we
calloc fail. However, kcalloc may return ZERO_SIZE_PTR, and with this,
the latter sg_init_table will trigger the bug. Fix it be use ZERO_OF_NULL_PTR.

This function was introduced with ' commit a596999b7ddf ("crypto:
algif - change algif_skcipher to be asynchronous")', and has been removed
with 'commit e870456d8e7c ("crypto: algif_skcipher - overhaul memory
management")'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algif_skcipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v1->v2:
update the commit message

--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -538,7 +538,7 @@ static int skcipher_recvmsg_async(struct
 	lock_sock(sk);
 	tx_nents = skcipher_all_sg_nents(ctx);
 	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
-	if (unlikely(!sreq->tsg))
+	if (unlikely(ZERO_OR_NULL_PTR(sreq->tsg)))
 		goto unlock;
 	sg_init_table(sreq->tsg, tx_nents);
 	memcpy(iv, ctx->iv, ivsize);


