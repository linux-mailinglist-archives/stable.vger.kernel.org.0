Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD854149B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358262AbiFGUVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359401AbiFGUUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5371D1050;
        Tue,  7 Jun 2022 11:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4893160906;
        Tue,  7 Jun 2022 18:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FABC385A2;
        Tue,  7 Jun 2022 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626620;
        bh=Lfxl43SYiS2hNLUte9m9PUQz2mdOkxoDQulM4pzaME8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMEjaPt02rWd2lh26sQTLf4ksamSVNc6SViWy/YkgvTZ0XTbCxV+v49Jqg4BN92TP
         Rvui9Eo3JOpzfsVm/kPuWkp71661rPwiN2DcO9GI/aj75ECvsapkn2qJJkDHSh3StF
         NkncLqEmE1La0Tz9Q5LbgWVas18JgCENqc21oG0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 445/772] net/smc: postpone sk_refcnt increment in connect()
Date:   Tue,  7 Jun 2022 19:00:37 +0200
Message-Id: <20220607165002.115310983@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index fd9d9cfd0f3d..b9fe31834354 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1417,9 +1417,9 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
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



