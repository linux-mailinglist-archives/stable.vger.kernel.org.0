Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDB66BB2A8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjCOMhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjCOMhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:37:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30936A0B18
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 808A5CE19BE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A05AC433D2;
        Wed, 15 Mar 2023 12:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883721;
        bh=4hA0UNGutR386XUrVPRimDEMLtXi6x/I/v+1rtJavXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuMhGk2cOHZF7i3Mwy9PDIzWzPU+V07dDASxkBT26F6nA8OABmK/kRNepXd5f7c8S
         lHcd6ceJ+iWQAwyr6Hzyzc5QFKdw/OrLtsgIhjV55bmusc7mGGHuP4OPxH2cIV1ff7
         1cyieO55OjwgHHtQNz13nBV4pD6VMCwynpvb7OAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "D. Wythe" <alibuda@linux.alibaba.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/143] net/smc: fix fallback failed while sendmsg with fastopen
Date:   Wed, 15 Mar 2023 13:13:12 +0100
Message-Id: <20230315115743.720832944@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index d9413d43b1045..e8018b0fb7676 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2644,16 +2644,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
 			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 			if (rc)
@@ -2662,6 +2660,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			rc = -EINVAL;
 			goto out;
 		}
+	} else if ((sk->sk_state != SMC_ACTIVE) &&
+		   (sk->sk_state != SMC_APPCLOSEWAIT1) &&
+		   (sk->sk_state != SMC_INIT)) {
+		rc = -EPIPE;
+		goto out;
 	}
 
 	if (smc->use_fallback) {
-- 
2.39.2



