Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1433461F55
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380257AbhK2Sp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56130 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380020AbhK2Sn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 26B4FCE167D;
        Mon, 29 Nov 2021 18:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C921BC53FAD;
        Mon, 29 Nov 2021 18:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211236;
        bh=qjpZ9gF+zx05uMW+HrkiH+IG+c6WLISugR5rtJZ0vh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkP3LeverOWylH99tr6tTdOPSX1hU/HaPrDg6lJ8JGJ2Jc06eGPaUkSTtJMqW+duZ
         qjXgSJSw/5CSTpCwVpO3jKS3wzhilqBslimnnRC4VyjsZrqZezCIYcwL5Ar2Yamgpv
         XliMqVl85/N6Sa1rnDw3rG7lmIQ8sPssB7CNYAAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/179] net/smc: Dont call clcsock shutdown twice when smc shutdown
Date:   Mon, 29 Nov 2021 19:19:04 +0100
Message-Id: <20211129181723.886775718@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index 4f1fa1bcb0316..3d8219e3b0264 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2154,8 +2154,10 @@ static __poll_t smc_poll(struct file *file, struct socket *sock,
 static int smc_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
+	bool do_shutdown = true;
 	struct smc_sock *smc;
 	int rc = -EINVAL;
+	int old_state;
 	int rc1 = 0;
 
 	smc = smc_sk(sk);
@@ -2182,7 +2184,11 @@ static int smc_shutdown(struct socket *sock, int how)
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
@@ -2192,7 +2198,7 @@ static int smc_shutdown(struct socket *sock, int how)
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



