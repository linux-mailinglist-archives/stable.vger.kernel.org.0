Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A7461E2B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhK2Sdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:33:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50560 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379241AbhK2SbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:31:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96DE9CE13DE;
        Mon, 29 Nov 2021 18:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4201DC53FC7;
        Mon, 29 Nov 2021 18:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210474;
        bh=x/0MrtdlagQ2qs8cVA9vKJN8qDo36XQg41fb8ncQYLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoriEFwyQ2cT0xU1Lk5KnDzNg29E4+WvuFMfxBQAc0UeBJ9R9T1PZwzPEkQeDp1z3
         kGfILXU8f+8PWnsFVdPKcQA1uTR1ZOCf+yj8OxiaLVdsWSmOPajlrgY+Kj9GIfCrX2
         NLc2r8zaSPDAVRMhg7NCQJI9pjjbtYioegNgRtnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 72/92] net/smc: Dont call clcsock shutdown twice when smc shutdown
Date:   Mon, 29 Nov 2021 19:18:41 +0100
Message-Id: <20211129181709.814623262@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index 6b0f09c5b195f..5e1493f8deba7 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1658,8 +1658,10 @@ static __poll_t smc_poll(struct file *file, struct socket *sock,
 static int smc_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
+	bool do_shutdown = true;
 	struct smc_sock *smc;
 	int rc = -EINVAL;
+	int old_state;
 	int rc1 = 0;
 
 	smc = smc_sk(sk);
@@ -1686,7 +1688,11 @@ static int smc_shutdown(struct socket *sock, int how)
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
@@ -1696,7 +1702,7 @@ static int smc_shutdown(struct socket *sock, int how)
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



