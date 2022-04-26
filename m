Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA51150F8E1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346361AbiDZJDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345636AbiDZJBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:01:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEE68C7FE;
        Tue, 26 Apr 2022 01:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30572B81CFE;
        Tue, 26 Apr 2022 08:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965B4C385AE;
        Tue, 26 Apr 2022 08:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962614;
        bh=SUAn3YB/j5PTGxSFVHNsRKIXtZlnRLSnEars9wTl8II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfL42/A6w/Ue/mF5GB7cZp/gZKolDpCK4F4VMovQUcplyoCSga1VQENwxGZE/s7zx
         Y4mnFf4piLAgfA7fNqPQaK9n9XA/L+wzQdvLN9knP99kklRt2jJIOkkmUzNqPsCNQn
         vtt+XkH4JAU3bMA352ZDCQlKlStut8cwnM7Zx6XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+6e29a053eb165bd50de5@syzkaller.appspotmail.com
Subject: [PATCH 5.17 032/146] net/smc: Fix sock leak when release after smc_shutdown()
Date:   Tue, 26 Apr 2022 10:20:27 +0200
Message-Id: <20220426081750.970138852@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

[ Upstream commit 1a74e99323746353bba11562a2f2d0aa8102f402 ]

Since commit e5d5aadcf3cd ("net/smc: fix sk_refcnt underflow on linkdown
and fallback"), for a fallback connection, __smc_release() does not call
sock_put() if its state is already SMC_CLOSED.

When calling smc_shutdown() after falling back, its state is set to
SMC_CLOSED but does not call sock_put(), so this patch calls it.

Reported-and-tested-by: syzbot+6e29a053eb165bd50de5@syzkaller.appspotmail.com
Fixes: e5d5aadcf3cd ("net/smc: fix sk_refcnt underflow on linkdown and fallback")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 303c5e56e4df..68cd110722a4 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2538,8 +2538,10 @@ static int smc_shutdown(struct socket *sock, int how)
 	if (smc->use_fallback) {
 		rc = kernel_sock_shutdown(smc->clcsock, how);
 		sk->sk_shutdown = smc->clcsock->sk->sk_shutdown;
-		if (sk->sk_shutdown == SHUTDOWN_MASK)
+		if (sk->sk_shutdown == SHUTDOWN_MASK) {
 			sk->sk_state = SMC_CLOSED;
+			sock_put(sk);
+		}
 		goto out;
 	}
 	switch (how) {
-- 
2.35.1



