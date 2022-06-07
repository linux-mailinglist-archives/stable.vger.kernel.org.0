Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54923540659
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347191AbiFGRem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348329AbiFGRbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB50E11803A;
        Tue,  7 Jun 2022 10:29:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEF4AB82285;
        Tue,  7 Jun 2022 17:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31679C385A5;
        Tue,  7 Jun 2022 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622991;
        bh=b++NisNEOYAJekWC1SOtCV27oqLTWJV7laUnxid2riI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZMYXYWtIjovskPA5qlxn7HH24XFnbcBJlyXTr8z6xB/fCIPFJb0LIvUJeqRC/4vZ
         HefzYFC6pzCm6sHntxCOio1ph9P4BOEDfEzQo3nz60ffqDPXnmLXYTVFgT/j0mglCw
         UDhGGWvnIdrJ9o6Lm/wiaXePHU/BAoFMqwufABo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/452] net/smc: postpone sk_refcnt increment in connect()
Date:   Tue,  7 Jun 2022 19:01:54 +0200
Message-Id: <20220607164916.215711033@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

[ Upstream commit 75c1edf23b95a9c66923d9269d8e86e4dbde151f ]

Same trigger condition as commit 86434744. When setsockopt runs
in parallel to a connect(), and switch the socket into fallback
mode. Then the sk_refcnt is incremented in smc_connect(), but
its state stay in SMC_INIT (NOT SMC_ACTIVE). This cause the
corresponding sk_refcnt decrement in __smc_release() will not be
performed.

Fixes: 86434744fedf ("net/smc: add fallback check to connect()")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 35db3260e8d5..5d7710dd9514 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1118,9 +1118,9 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 	if (rc && rc != -EINPROGRESS)
 		goto out;
 
-	sock_hold(&smc->sk); /* sock put in passive closing */
 	if (smc->use_fallback)
 		goto out;
+	sock_hold(&smc->sk); /* sock put in passive closing */
 	if (flags & O_NONBLOCK) {
 		if (queue_work(smc_hs_wq, &smc->connect_work))
 			smc->connect_nonblock = 1;
-- 
2.35.1



