Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A18540C0D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350237AbiFGSda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352487AbiFGSbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE461451EF;
        Tue,  7 Jun 2022 10:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 744AEB8236F;
        Tue,  7 Jun 2022 17:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC41FC34115;
        Tue,  7 Jun 2022 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624574;
        bh=Yw3em7e/qm90mPwzR65SCtyxpWled5hyZRsVpRxZV24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyfQvKrr+SsnETiDJDZ4iPiKqK77+CtzEcXOnzLi9I+vfPITCsu3wYyBwA63UY2qz
         80zpALfEon/iYDUHGuozFyec7a3xNbr74qdKgNwbBXRFBpWMhTqSTfEojoAgoJ74H3
         Jl8F61bJ8MDWdccy9crmXZBUMeP0ufdCe4h7BMLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 376/667] net/smc: postpone sk_refcnt increment in connect()
Date:   Tue,  7 Jun 2022 19:00:41 +0200
Message-Id: <20220607164946.026474084@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index fb801c249d92..2ddd7b34b4ce 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1283,9 +1283,9 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
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



