Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B173469ACF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346399AbhLFPLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41554 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347302AbhLFPIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:08:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A277AB81118;
        Mon,  6 Dec 2021 15:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B93C341C1;
        Mon,  6 Dec 2021 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803101;
        bh=EXKLhvfR9Ql7HrtC+mWWvLl6/hAlaJv4sBSH74F1lGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C51VzEA/8vrqL38XeYBvgecVJoop2XxinR/XeD9U04G9quKvZJa8HJCeKPQnKyUxa
         j8ZN7gBo8saocyieMWXh9FB9oMnWodeNWHedMjJiq2YSUDGWnmWamS+viOd1D10IFU
         eYXZi2k0XsH7nX2k4cEi9b1CwIUUSjyOfcUnL89Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/106] net/smc: Dont call clcsock shutdown twice when smc shutdown
Date:   Mon,  6 Dec 2021 15:55:36 +0100
Message-Id: <20211206145556.336450898@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

[ Upstream commit bacb6c1e47691cda4a95056c21b5487fb7199fcc ]

When applications call shutdown() with SHUT_RDWR in userspace,
smc_close_active() calls kernel_sock_shutdown(), and it is called
twice in smc_shutdown().

This fixes this by checking sk_state before do clcsock shutdown, and
avoids missing the application's call of smc_shutdown().

Link: https://lore.kernel.org/linux-s390/1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com/
Fixes: 606a63c9783a ("net/smc: Ensure the active closing peer first closes clcsock")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Link: https://lore.kernel.org/r/20211126024134.45693-1-tonylu@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8c71f0929fbb7..f2c907d52812b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1178,8 +1178,10 @@ static unsigned int smc_poll(struct file *file, struct socket *sock,
 static int smc_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
+	bool do_shutdown = true;
 	struct smc_sock *smc;
 	int rc = -EINVAL;
+	int old_state;
 	int rc1 = 0;
 
 	smc = smc_sk(sk);
@@ -1206,7 +1208,11 @@ static int smc_shutdown(struct socket *sock, int how)
 	}
 	switch (how) {
 	case SHUT_RDWR:		/* shutdown in both directions */
+		old_state = sk->sk_state;
 		rc = smc_close_active(smc);
+		if (old_state == SMC_ACTIVE &&
+		    sk->sk_state == SMC_PEERCLOSEWAIT1)
+			do_shutdown = false;
 		break;
 	case SHUT_WR:
 		rc = smc_close_shutdown_write(smc);
@@ -1216,7 +1222,7 @@ static int smc_shutdown(struct socket *sock, int how)
 		/* nothing more to do because peer is not involved */
 		break;
 	}
-	if (smc->clcsock)
+	if (do_shutdown && smc->clcsock)
 		rc1 = kernel_sock_shutdown(smc->clcsock, how);
 	/* map sock_shutdown_cmd constants to sk_shutdown value range */
 	sk->sk_shutdown |= how + 1;
-- 
2.33.0



