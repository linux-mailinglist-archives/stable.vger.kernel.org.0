Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3A2462432
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhK2WRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhK2WQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7922C08EDBE;
        Mon, 29 Nov 2021 10:22:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20011CE13DB;
        Mon, 29 Nov 2021 18:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBFFC53FAD;
        Mon, 29 Nov 2021 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210131;
        bh=RlEx3VwTJFT8EQqDGaOIqzQyTxcub74iAAR/V6Lxqyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LX9rj0WE+cX7bR/PqMiMGHOXVrKAEWzYn21VcuGcyPqBQyoVnxbz8Tyvp+01yWh/K
         UFtvEstGe141E0eY1/j9jyVI2XuY3HjlVGQlrU3/a48d3s3AZ61sywG+kaS51yerlG
         tRl9DI5RqwmV7xa3OIAcRUBfVAfjDC+75sszRVxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/69] net/smc: Dont call clcsock shutdown twice when smc shutdown
Date:   Mon, 29 Nov 2021 19:18:35 +0100
Message-Id: <20211129181705.378003720@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
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
index 9aab4ab8161bd..4c904ab29e0e6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1589,8 +1589,10 @@ static __poll_t smc_poll(struct file *file, struct socket *sock,
 static int smc_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
+	bool do_shutdown = true;
 	struct smc_sock *smc;
 	int rc = -EINVAL;
+	int old_state;
 	int rc1 = 0;
 
 	smc = smc_sk(sk);
@@ -1617,7 +1619,11 @@ static int smc_shutdown(struct socket *sock, int how)
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
@@ -1627,7 +1633,7 @@ static int smc_shutdown(struct socket *sock, int how)
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



