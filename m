Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216666BB0F9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjCOMXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjCOMXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:23:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D5295BDA
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D444CB81E05
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4456CC433D2;
        Wed, 15 Mar 2023 12:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882919;
        bh=ZSAeDi9jv4/dJ1fKpjMwPNiK+6ZKz8auX2dYLS72S5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WomttnMZhYwP1zoU82k3QzU7wMd44I7VdFsrhu/2Ki/EuR2K8jXZPuRYv9j7pktgw
         aB1odyt9T9TFmxBCOSzlP1l5OR46kOvV9GVn+CDmIj4yQg+l969pdcvIT1N20bPRHT
         oxkzo27QEbryRZgmyL8IG28q0Wio9I010/F4601k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "D. Wythe" <alibuda@linux.alibaba.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/104] net/smc: fix fallback failed while sendmsg with fastopen
Date:   Wed, 15 Mar 2023 13:12:23 +0100
Message-Id: <20230315115734.165474456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit ce7ca794712f186da99719e8b4e97bd5ddbb04c3 ]

Before determining whether the msg has unsupported options, it has been
prematurely terminated by the wrong status check.

For the application, the general usages of MSG_FASTOPEN likes

fd = socket(...)
/* rather than connect */
sendto(fd, data, len, MSG_FASTOPEN)

Hence, We need to check the flag before state check, because the sock
state here is always SMC_INIT when applications tries MSG_FASTOPEN.
Once we found unsupported options, fallback it to TCP.

Fixes: ee9dfbef02d1 ("net/smc: handle sockopts forcing fallback")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>

v2 -> v1: Optimize code style
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 41cbc7c89c9d2..8ab84926816f6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1988,16 +1988,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = -EPIPE;
+	int rc;
 
 	smc = smc_sk(sk);
 	lock_sock(sk);
-	if ((sk->sk_state != SMC_ACTIVE) &&
-	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
-	    (sk->sk_state != SMC_INIT))
-		goto out;
 
+	/* SMC does not support connect with fastopen */
 	if (msg->msg_flags & MSG_FASTOPEN) {
+		/* not connected yet, fallback */
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
 			smc_switch_to_fallback(smc);
 			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
@@ -2005,6 +2003,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			rc = -EINVAL;
 			goto out;
 		}
+	} else if ((sk->sk_state != SMC_ACTIVE) &&
+		   (sk->sk_state != SMC_APPCLOSEWAIT1) &&
+		   (sk->sk_state != SMC_INIT)) {
+		rc = -EPIPE;
+		goto out;
 	}
 
 	if (smc->use_fallback)
-- 
2.39.2



