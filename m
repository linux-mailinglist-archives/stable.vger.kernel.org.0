Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85A047ACA4
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhLTOqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37912 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236561AbhLTOoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C12A461165;
        Mon, 20 Dec 2021 14:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FCDC36AE7;
        Mon, 20 Dec 2021 14:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011493;
        bh=0Ef9eswxrkBiSQY9W3YBAESSTC4iNG5GMsGY3/HzruU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKLsBkWId5PkRkPke/Meri0i1lnfjBka2SmJULRTwsKjTDhe3LBXDKtO7ZkZJMAAE
         FpvQGE/RtzIb2EFvrMLL/XoApX04Ce+OA4JTJVLAx7Qm0Ja7ne1OZG87uQJoF2unPT
         JbGjc6eGWJX1PNbtnkUEGrLMinW/BNBIX3l39Q7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/71] net/smc: Prevent smc_release() from long blocking
Date:   Mon, 20 Dec 2021 15:34:30 +0100
Message-Id: <20211220143027.060261271@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit 5c15b3123f65f8fbb1b445d9a7e8812e0e435df2 ]

In nginx/wrk benchmark, there's a hung problem with high probability
on case likes that: (client will last several minutes to exit)

server: smc_run nginx

client: smc_run wrk -c 10000 -t 1 http://server

Client hangs with the following backtrace:

0 [ffffa7ce8Of3bbf8] __schedule at ffffffff9f9eOd5f
1 [ffffa7ce8Of3bc88] schedule at ffffffff9f9eløe6
2 [ffffa7ce8Of3bcaO] schedule_timeout at ffffffff9f9e3f3c
3 [ffffa7ce8Of3bd2O] wait_for_common at ffffffff9f9el9de
4 [ffffa7ce8Of3bd8O] __flush_work at ffffffff9fOfeOl3
5 [ffffa7ce8øf3bdfO] smc_release at ffffffffcO697d24 [smc]
6 [ffffa7ce8Of3be2O] __sock_release at ffffffff9f8O2e2d
7 [ffffa7ce8Of3be4ø] sock_close at ffffffff9f8ø2ebl
8 [ffffa7ce8øf3be48] __fput at ffffffff9f334f93
9 [ffffa7ce8Of3be78] task_work_run at ffffffff9flOlff5
10 [ffffa7ce8Of3beaO] do_exit at ffffffff9fOe5Ol2
11 [ffffa7ce8Of3bflO] do_group_exit at ffffffff9fOe592a
12 [ffffa7ce8Of3bf38] __x64_sys_exit_group at ffffffff9fOe5994
13 [ffffa7ce8Of3bf4O] do_syscall_64 at ffffffff9f9d4373
14 [ffffa7ce8Of3bfsO] entry_SYSCALL_64_after_hwframe at ffffffff9fa0007c

This issue dues to flush_work(), which is used to wait for
smc_connect_work() to finish in smc_release(). Once lots of
smc_connect_work() was pending or all executing work dangling,
smc_release() has to block until one worker comes to free, which
is equivalent to wait another smc_connnect_work() to finish.

In order to fix this, There are two changes:

1. For those idle smc_connect_work(), cancel it from the workqueue; for
   executing smc_connect_work(), waiting for it to finish. For that
   purpose, replace flush_work() with cancel_work_sync().

2. Since smc_connect() hold a reference for passive closing, if
   smc_connect_work() has been cancelled, release the reference.

Fixes: 24ac3a08e658 ("net/smc: rebuild nonblocking connect")
Reported-by: Tony Lu <tonylu@linux.alibaba.com>
Tested-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Link: https://lore.kernel.org/r/1639571361-101128-1-git-send-email-alibuda@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index fa3b20e5f4608..06684ac346abd 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -183,7 +183,9 @@ static int smc_release(struct socket *sock)
 	/* cleanup for a dangling non-blocking connect */
 	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
 		tcp_abort(smc->clcsock->sk, ECONNABORTED);
-	flush_work(&smc->connect_work);
+
+	if (cancel_work_sync(&smc->connect_work))
+		sock_put(&smc->sk); /* sock_hold in smc_connect for passive closing */
 
 	if (sk->sk_state == SMC_LISTEN)
 		/* smc_close_non_accepted() is called and acquires
-- 
2.33.0



